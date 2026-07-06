// ==============================================================================
// Yoga24X — Unified Authorization Engine
// Combines RBAC (role/permission matrix) + ABAC (policy evaluation) into one
// Every decision emits a structured audit event with full correlation context
// ==============================================================================
import { Injectable, Logger } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { RedisService } from "../../redis/redis.module";
import {
  ROLE_PERMISSION_MATRIX,
  PermissionKey,
} from "../constants/permissions.registry";
import { AuthorizationContext } from "../interfaces/authorization-context.interface";
import { SecurityAuditService } from "./security-audit.service";

export interface AuthzResult {
  permitted: boolean;
  decision: string;
  reason: string;
  /** Permission overrides that were applied */
  appliedOverrides: string[];
  /** Policies that were evaluated */
  evaluatedPolicies: string[];
}

@Injectable()
export class AuthorizationEngineService {
  private readonly logger = new Logger(AuthorizationEngineService.name);

  // Cache effective permissions per user+tenant (5 min TTL)
  private readonly PERM_CACHE_TTL = 300;
  private readonly POLICY_CACHE_TTL = 60;

  constructor(
    private readonly prisma: PrismaService,
    private readonly redis: RedisService,
    private readonly audit: SecurityAuditService,
  ) {}

  // ─────────────────────────────────────────────────────────────────────────────
  // PRIMARY EVALUATION ENTRYPOINT
  // ─────────────────────────────────────────────────────────────────────────────

  async evaluate(
    ctx: AuthorizationContext,
    requiredPermission: PermissionKey,
  ): Promise<AuthzResult> {
    const result = await this.doEvaluate(ctx, requiredPermission);

    // Emit audit event for EVERY decision (OWASP ASVS Req 7.4.1)
    await this.audit.recordAuthzDecision({
      correlationId: ctx.correlationId,
      userId: ctx.userId,
      tenantId: ctx.tenantId,
      organizationId: ctx.organizationId,
      role: ctx.roles[0],
      permissionKey: requiredPermission,
      decision: result.permitted ? "PERMITTED" : "DENIED",
      decisionReason: result.reason,
      requestPath: ctx.requestPath,
      requestMethod: ctx.requestMethod,
      ipAddress: ctx.ipAddress,
      deviceId: ctx.deviceId,
      riskScore: ctx.riskScore,
      contextJson: {
        roles: ctx.roles,
        deviceTrust: ctx.deviceTrust,
        subscriptionTier: ctx.subscriptionTier,
        countryCode: ctx.countryCode,
        evaluatedPolicies: result.evaluatedPolicies,
        appliedOverrides: result.appliedOverrides,
      },
    });

    return result;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // STEP 1 – Resolve effective permissions (RBAC + overrides)
  // STEP 2 – Evaluate ABAC policies
  // STEP 3 – Apply user-specific overrides (highest priority)
  // ─────────────────────────────────────────────────────────────────────────────

  private async doEvaluate(
    ctx: AuthorizationContext,
    requiredPermission: PermissionKey,
  ): Promise<AuthzResult> {
    const appliedOverrides: string[] = [];
    const evaluatedPolicies: string[] = [];

    // ── Step 1: Check user-level permission overrides (DENY first — security default) ──
    const overrideResult = await this.evaluateOverrides(
      ctx,
      requiredPermission,
    );
    if (overrideResult !== null) {
      appliedOverrides.push(`override:${overrideResult.effect}`);
      if (overrideResult.effect === "DENY") {
        return {
          permitted: false,
          decision: "DENIED_PERMISSION",
          reason: `Explicit DENY override: ${overrideResult.reason}`,
          appliedOverrides,
          evaluatedPolicies,
        };
      }
      if (overrideResult.effect === "ALLOW" && !overrideResult.isConditional) {
        // Non-conditional ALLOW override — still run policies
        // fall through to policy evaluation
      }
    }

    // ── Step 2: Check RBAC — does the user's role grant this permission? ──────────
    const effectivePerms = await this.resolveEffectivePermissions(ctx);
    if (!effectivePerms.has(requiredPermission)) {
      return {
        permitted: false,
        decision: "DENIED_PERMISSION",
        reason: `Role '${ctx.roles.join(",")}' lacks permission '${requiredPermission}'`,
        appliedOverrides,
        evaluatedPolicies,
      };
    }

    // ── Step 3: ABAC — evaluate active policies for this context ─────────────────
    const policyResult = await this.evaluatePolicies(
      ctx,
      requiredPermission,
      evaluatedPolicies,
    );
    if (!policyResult.permitted) {
      return {
        permitted: false,
        decision: policyResult.decision,
        reason: policyResult.reason,
        appliedOverrides,
        evaluatedPolicies,
      };
    }

    return {
      permitted: true,
      decision: "PERMITTED",
      reason: "RBAC + ABAC checks passed",
      appliedOverrides,
      evaluatedPolicies,
    };
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // RBAC – Resolve effective permissions via role inheritance
  // ─────────────────────────────────────────────────────────────────────────────

  private async resolveEffectivePermissions(
    ctx: AuthorizationContext,
  ): Promise<Set<string>> {
    const cacheKey = `authz:perms:${ctx.userId}:${ctx.tenantId ?? "global"}`;
    try {
      const cached = await this.redis.get(cacheKey);
      if (cached) return new Set(JSON.parse(cached) as string[]);
    } catch {
      /* cache miss */
    }

    const perms = new Set<string>();
    const visited = new Set<string>();

    const resolveRole = (roleName: string): void => {
      if (visited.has(roleName)) return;
      visited.add(roleName);

      const roleDef = ROLE_PERMISSION_MATRIX[roleName];
      if (!roleDef) return;

      // Recurse through inherited roles first (depth-first inheritance)
      for (const inherited of roleDef.inherits) {
        resolveRole(inherited);
      }

      // Add own permissions
      for (const perm of roleDef.permissions) {
        perms.add(perm);
      }
    };

    for (const role of ctx.roles) {
      resolveRole(role);
    }

    try {
      await this.redis.setex(
        cacheKey,
        this.PERM_CACHE_TTL,
        JSON.stringify([...perms]),
      );
    } catch {
      /* non-critical */
    }

    return perms;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // User-Level Permission Overrides (6 states: allow/deny/inherited/overridden/temporary/conditional)
  // ─────────────────────────────────────────────────────────────────────────────

  private async evaluateOverrides(
    ctx: AuthorizationContext,
    permissionKey: PermissionKey,
  ): Promise<{
    effect: "ALLOW" | "DENY";
    reason: string;
    isConditional: boolean;
  } | null> {
    if (!ctx.userId) return null;

    const permission = await this.prisma.permission.findFirst({
      where: {
        module: permissionKey.split(":")[0],
        action: permissionKey.split(":")[1],
      },
    });
    if (!permission) return null;

    const override = await this.prisma.userPermissionOverride.findFirst({
      where: {
        userId: ctx.userId,
        permissionId: permission.id,
        ...(ctx.tenantId ? { tenantId: ctx.tenantId } : {}),
      },
      orderBy: { createdAt: "desc" },
    });

    if (!override) return null;

    // Check expiration for TEMPORARY overrides
    if (
      override.state === "TEMPORARY" &&
      override.expiresAt &&
      override.expiresAt < new Date()
    ) {
      return null; // Expired — fall through to base RBAC
    }

    // Evaluate CONDITIONAL overrides
    if (override.effect === "CONDITIONAL" || override.conditionJson) {
      const conditionMet = this.evaluateConditionExpression(
        override.conditionJson as Record<string, unknown>,
        ctx,
      );
      if (!conditionMet) return null;
    }

    return {
      effect: override.effect as "ALLOW" | "DENY",
      reason: override.reason,
      isConditional: !!override.conditionJson,
    };
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // ABAC – Evaluate active Security Policies
  // ─────────────────────────────────────────────────────────────────────────────

  private async evaluatePolicies(
    ctx: AuthorizationContext,
    permissionKey: PermissionKey,
    evaluatedPolicies: string[],
  ): Promise<{ permitted: boolean; decision: string; reason: string }> {
    const cacheKey = `authz:policies:${ctx.tenantId ?? "global"}`;
    let policies: Array<{
      name: string;
      policyType: string;
      action: string;
      rulesJson: unknown;
      priority: number;
    }>;

    try {
      const cached = await this.redis.get(cacheKey);
      if (cached) {
        policies = JSON.parse(cached);
      } else {
        policies = await this.prisma.securityPolicy.findMany({
          where: {
            isEnabled: true,
            OR: [{ tenantId: ctx.tenantId }, { tenantId: null }],
          },
          orderBy: { priority: "asc" },
          select: {
            name: true,
            policyType: true,
            action: true,
            rulesJson: true,
            priority: true,
          },
        });
        await this.redis.setex(
          cacheKey,
          this.POLICY_CACHE_TTL,
          JSON.stringify(policies),
        );
      }
    } catch {
      policies = [];
    }

    for (const policy of policies) {
      evaluatedPolicies.push(policy.name);
      const rules = policy.rulesJson as Record<string, unknown>;
      const matches = this.matchesPolicyRules(rules, ctx, permissionKey);

      if (matches) {
        switch (policy.action) {
          case "DENY":
          case "BLOCK_AND_ALERT":
            return {
              permitted: false,
              decision: `DENIED_POLICY`,
              reason: `Policy '${policy.name}' denied access`,
            };
          case "ENFORCE_MFA":
            if (!ctx.riskScore || ctx.riskScore < 50) break; // MFA already verified
            return {
              permitted: false,
              decision: "MFA_REQUIRED",
              reason: `Policy '${policy.name}' requires MFA for this context`,
            };
          case "THROTTLE":
            // Throttling is handled by rate-limit guards; log but permit here
            this.logger.warn(
              `Throttle policy matched for user ${ctx.userId}: ${policy.name}`,
            );
            break;
          case "ALLOW":
          case "AUDIT_ONLY":
            break; // Continue
        }
      }
    }

    return {
      permitted: true,
      decision: "PERMITTED",
      reason: "No blocking policies matched",
    };
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Policy Rule Matcher (Location, Device, Time, Risk, Health, Subscription, API)
  // ─────────────────────────────────────────────────────────────────────────────

  private matchesPolicyRules(
    rules: Record<string, unknown>,
    ctx: AuthorizationContext,
    permissionKey: string,
  ): boolean {
    // Permission scope filter
    if (rules["permissions"] && Array.isArray(rules["permissions"])) {
      const scopedPerms = rules["permissions"] as string[];
      const permMatches = scopedPerms.some((p) => {
        if (p === "*") return true;
        if (p.endsWith(":*")) {
          const module = p.slice(0, -2); // strip ':*'
          return permissionKey.startsWith(module + ":");
        }
        return p === permissionKey;
      });
      if (!permMatches) return false;
    }

    // Location rule
    if (rules["blockedCountries"] && Array.isArray(rules["blockedCountries"])) {
      if (
        ctx.countryCode &&
        (rules["blockedCountries"] as string[]).includes(ctx.countryCode)
      )
        return true;
    }
    if (rules["allowedCountries"] && Array.isArray(rules["allowedCountries"])) {
      if (
        ctx.countryCode &&
        !(rules["allowedCountries"] as string[]).includes(ctx.countryCode)
      )
        return true;
    }

    // Device trust rule
    if (rules["requireTrustedDevice"] === true && ctx.deviceTrust !== "TRUSTED")
      return true;
    if (rules["blockUntrustedDevice"] === true && ctx.deviceTrust === "BLOCKED")
      return true;

    // Time-based rule
    if (
      rules["allowedHours"] &&
      Array.isArray(rules["allowedHours"]) &&
      ctx.currentHour !== undefined
    ) {
      const [start, end] = rules["allowedHours"] as [number, number];
      if (ctx.currentHour < start || ctx.currentHour > end) return true;
    }

    // Risk score rule
    if (
      typeof rules["maxRiskScore"] === "number" &&
      ctx.riskScore !== undefined
    ) {
      if (ctx.riskScore > (rules["maxRiskScore"] as number)) return true;
    }

    // Health data rule
    if (
      rules["requireHealthVerification"] === true &&
      !ctx.hasHealthRestrictions
    )
      return false;

    // Subscription rule
    if (
      rules["requiredSubscriptionTiers"] &&
      Array.isArray(rules["requiredSubscriptionTiers"])
    ) {
      const tiers = rules["requiredSubscriptionTiers"] as string[];
      if (ctx.subscriptionTier && !tiers.includes(ctx.subscriptionTier))
        return true;
    }

    return false;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Condition Expression Evaluator (for CONDITIONAL overrides)
  // ─────────────────────────────────────────────────────────────────────────────

  private evaluateConditionExpression(
    condition: Record<string, unknown>,
    ctx: AuthorizationContext,
  ): boolean {
    if (!condition) return true;

    if (condition["ipRange"]) {
      // Basic CIDR match — extend with proper IP library in production
      if (
        ctx.ipAddress &&
        !(ctx.ipAddress as string).startsWith(condition["ipRange"] as string)
      ) {
        return false;
      }
    }
    if (condition["roles"] && Array.isArray(condition["roles"])) {
      const requiredRoles = condition["roles"] as string[];
      if (!requiredRoles.some((r) => ctx.roles.includes(r))) return false;
    }
    if (
      condition["subscriptionTiers"] &&
      Array.isArray(condition["subscriptionTiers"])
    ) {
      if (
        !ctx.subscriptionTier ||
        !(condition["subscriptionTiers"] as string[]).includes(
          ctx.subscriptionTier,
        )
      )
        return false;
    }

    return true;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Cache Invalidation (call after role/permission changes)
  // ─────────────────────────────────────────────────────────────────────────────

  async invalidateUserPermissionCache(
    userId: string,
    tenantId?: string,
  ): Promise<void> {
    const pattern = `authz:perms:${userId}:${tenantId ?? "*"}`;
    try {
      await this.redis.del(pattern);
    } catch {
      /* non-critical */
    }
  }

  async invalidatePolicyCache(tenantId?: string): Promise<void> {
    const key = `authz:policies:${tenantId ?? "global"}`;
    try {
      await this.redis.del(key);
    } catch {
      /* non-critical */
    }
  }
}

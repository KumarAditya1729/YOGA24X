// ==============================================================================
// Yoga24X — Feature Flag Service
// Multi-scope: Global / Tenant / Organization / User
// Deterministic % rollout, kill switch, scheduled enable/disable
// ==============================================================================
import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';
import { RedisService } from '../../redis/redis.module';
import { createHash } from 'crypto';

export interface FlagEvaluationContext {
  userId?: string;
  tenantId?: string;
  organizationId?: string;
  roles?: string[];
}

export interface FlagEvaluationResult {
  key: string;
  enabled: boolean;
  source: 'kill_switch' | 'scheduled' | 'user' | 'org' | 'tenant' | 'global';
  configJson?: Record<string, unknown>;
}

const FLAG_CACHE_TTL = 60; // seconds
const FLAG_CACHE_PREFIX = 'feature_flag:';

@Injectable()
export class FeatureFlagService {
  private readonly logger = new Logger(FeatureFlagService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly redis: RedisService,
  ) {}

  // ─────────────────────────────────────────────────────────────────────────────
  // EVALUATE — resolves flag value for a given context (precedence-based)
  // Precedence: killSwitch → User-scope → Org-scope → Tenant-scope → Global
  // ─────────────────────────────────────────────────────────────────────────────

  async evaluate(key: string, ctx: FlagEvaluationContext): Promise<FlagEvaluationResult> {
    const cacheKey = `${FLAG_CACHE_PREFIX}${key}:${ctx.tenantId ?? 'g'}:${ctx.organizationId ?? 'g'}:${ctx.userId ?? 'g'}`;

    try {
      const cached = await this.redis.get(cacheKey);
      if (cached) return JSON.parse(cached) as FlagEvaluationResult;
    } catch { /* cache miss */ }

    // Resolve all matching flags ordered by scope (most specific first)
    const flags = await this.prisma.tenantFeatureFlag.findMany({
      where: {
        key,
        OR: [
          { scope: 'USER', userId: ctx.userId },
          { scope: 'ORGANIZATION', organizationId: ctx.organizationId },
          { scope: 'TENANT', tenantId: ctx.tenantId },
          { scope: 'GLOBAL', tenantId: null, organizationId: null, userId: null },
        ],
      },
      orderBy: [{ scope: 'asc' }], // USER < ORGANIZATION < TENANT < GLOBAL
    });

    // Also check legacy global FeatureFlag table
    const globalFlag = await this.prisma.featureFlag.findUnique({ where: { key } });

    let result: FlagEvaluationResult = { key, enabled: false, source: 'global' };

    // Evaluate global flag as base
    if (globalFlag) {
      result = {
        key,
        enabled: globalFlag.isEnabled,
        source: 'global',
      };
    }

    const now = new Date();

    // Evaluate scoped flags — most specific wins
    for (const flag of flags) {
      // Kill switch always wins
      if (flag.killSwitch) {
        result = { key, enabled: false, source: 'kill_switch' };
        break;
      }

      // Scheduled activation check
      if (flag.scheduledEnableAt && flag.scheduledEnableAt > now) {
        continue; // Not yet active
      }
      if (flag.scheduledDisableAt && flag.scheduledDisableAt <= now) {
        result = { key, enabled: false, source: 'scheduled', configJson: flag.configJson as Record<string, unknown> };
        continue;
      }

      // Role targeting
      if (flag.targetRolesJson && Array.isArray(flag.targetRolesJson)) {
        const targetRoles = flag.targetRolesJson as string[];
        if (ctx.roles && !ctx.roles.some((r) => targetRoles.includes(r))) {
          continue; // User's role not targeted
        }
      }

      // Percentage rollout (deterministic hash)
      if (flag.rolloutPercentage < 100) {
        const seed = flag.rolloutSeed ?? key;
        const hashInput = `${seed}:${ctx.userId ?? ctx.tenantId ?? 'anon'}`;
        const hash = createHash('sha256').update(hashInput).digest('hex');
        const bucket = parseInt(hash.substring(0, 8), 16) % 100;
        if (bucket >= flag.rolloutPercentage) {
          continue; // Not in rollout bucket
        }
      }

      const source = flag.scope === 'USER' ? 'user'
        : flag.scope === 'ORGANIZATION' ? 'org'
        : flag.scope === 'TENANT' ? 'tenant'
        : 'global';

      result = {
        key,
        enabled: flag.isEnabled,
        source,
        configJson: flag.configJson as Record<string, unknown>,
      };
    }

    try {
      await this.redis.setex(cacheKey, FLAG_CACHE_TTL, JSON.stringify(result));
    } catch { /* non-critical */ }

    return result;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // MANAGEMENT
  // ─────────────────────────────────────────────────────────────────────────────

  async createOrUpdate(data: {
    key: string;
    scope: string;
    tenantId?: string;
    organizationId?: string;
    userId?: string;
    isEnabled: boolean;
    rolloutPercentage?: number;
    rolloutSeed?: string;
    targetRolesJson?: string[];
    configJson?: Record<string, unknown>;
    scheduledEnableAt?: Date;
    scheduledDisableAt?: Date;
    description?: string;
    createdBy: string;
  }) {
    const existing = await this.prisma.tenantFeatureFlag.findFirst({
      where: {
        key: data.key,
        scope: data.scope as any,
        tenantId: data.tenantId ?? null,
        organizationId: data.organizationId ?? null,
        userId: data.userId ?? null,
      },
    });

    await this.invalidateFlagCache(data.key, data.tenantId, data.organizationId, data.userId);

    if (existing) {
      return this.prisma.tenantFeatureFlag.update({
        where: { id: existing.id },
        data: {
          isEnabled: data.isEnabled,
          rolloutPercentage: data.rolloutPercentage ?? 100,
          rolloutSeed: data.rolloutSeed,
          targetRolesJson: (data.targetRolesJson ?? []) as any,
          configJson: (data.configJson ?? {}) as any,
          scheduledEnableAt: data.scheduledEnableAt,
          scheduledDisableAt: data.scheduledDisableAt,
          description: data.description,
        },
      });
    }

    return this.prisma.tenantFeatureFlag.create({
      data: {
        key: data.key,
        scope: data.scope as any,
        tenantId: data.tenantId,
        organizationId: data.organizationId,
        userId: data.userId,
        isEnabled: data.isEnabled,
        rolloutPercentage: data.rolloutPercentage ?? 100,
        rolloutSeed: data.rolloutSeed,
        targetRolesJson: (data.targetRolesJson ?? []) as any,
        configJson: (data.configJson ?? {}) as any,
        scheduledEnableAt: data.scheduledEnableAt,
        scheduledDisableAt: data.scheduledDisableAt,
        description: data.description,
        createdBy: data.createdBy,
      },
    });
  }

  async triggerKillSwitch(key: string, tenantId?: string, activatedBy?: string): Promise<void> {
    this.logger.warn(`[KILL SWITCH ACTIVATED] Flag: ${key} | Tenant: ${tenantId} | By: ${activatedBy}`);
    await this.prisma.tenantFeatureFlag.updateMany({
      where: { key, ...(tenantId ? { tenantId } : {}) },
      data: { killSwitch: true, isEnabled: false },
    });
    await this.invalidateFlagCache(key, tenantId);
  }

  async releaseKillSwitch(key: string, tenantId?: string): Promise<void> {
    await this.prisma.tenantFeatureFlag.updateMany({
      where: { key, ...(tenantId ? { tenantId } : {}) },
      data: { killSwitch: false },
    });
    await this.invalidateFlagCache(key, tenantId);
  }

  async listFlags(tenantId?: string, scope?: string) {
    return this.prisma.tenantFeatureFlag.findMany({
      where: {
        ...(tenantId ? { tenantId } : {}),
        ...(scope ? { scope: scope as any } : {}),
      },
      orderBy: { key: 'asc' },
    });
  }

  private async invalidateFlagCache(
    key: string,
    tenantId?: string,
    organizationId?: string,
    userId?: string,
  ) {
    const pattern = `${FLAG_CACHE_PREFIX}${key}:*`;
    try {
      await this.redis.del(pattern);
    } catch { /* non-critical */ }
  }
}

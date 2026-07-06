// ==============================================================================
// Yoga24X — Unified Authorization Guard
// Runs on every protected route — builds AuthorizationContext and delegates
// to AuthorizationEngineService (RBAC + ABAC + audit in one call)
// ==============================================================================
import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
  Logger,
  UnauthorizedException,
} from "@nestjs/common";
import { Reflector } from "@nestjs/core";
import { randomUUID } from "crypto";
import { AuthorizationEngineService } from "../authorization/authorization-engine.service";
import { AuthorizationContext } from "../interfaces/authorization-context.interface";
import {
  PERMISSIONS_KEY,
  ROLES_KEY,
  PUBLIC_ROUTE_KEY,
  AUTHZ_CONTEXT_KEY,
} from "../decorators/authorization.decorators";
import { getTenantContextOptional } from "../tenant/tenant.context";
import { PermissionKey } from "../constants/permissions.registry";

@Injectable()
export class AuthorizationGuard implements CanActivate {
  private readonly logger = new Logger(AuthorizationGuard.name);

  constructor(
    private readonly reflector: Reflector,
    private readonly authzEngine: AuthorizationEngineService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    // 1. Allow public routes unconditionally
    const isPublic = this.reflector.getAllAndOverride<boolean>(
      PUBLIC_ROUTE_KEY,
      [context.getHandler(), context.getClass()],
    );
    if (isPublic) return true;

    const req = context.switchToHttp().getRequest();
    const user = req.user;

    if (!user) {
      throw new UnauthorizedException("Authentication required");
    }

    // 2. Build authorization context from request + tenant store
    const tenantCtx = getTenantContextOptional();
    const correlationId =
      (req.headers["x-correlation-id"] as string) ?? randomUUID();

    const authzCtx: AuthorizationContext = {
      userId: user.sub ?? user.id,
      tenantId: tenantCtx?.tenantId ?? user.tenantId,
      organizationId: req.headers["x-organization-id"] as string | undefined,
      roles: user.roles ?? [],
      permissions: [],
      deviceId: user.deviceId,
      ipAddress: req.ip ?? (req.headers["x-forwarded-for"] as string),
      deviceTrust: user.deviceTrust ?? "UNKNOWN",
      subscriptionTier: user.subscriptionTier ?? "FREE",
      riskScore: user.riskScore ?? 0,
      currentHour: new Date().getUTCHours(),
      countryCode: (req.headers["cf-ipcountry"] as string) ?? undefined,
      hasHealthRestrictions: user.hasHealthRestrictions ?? false,
      correlationId,
      requestPath: req.path,
      requestMethod: req.method,
    };

    // Attach to request for downstream use
    req[AUTHZ_CONTEXT_KEY] = authzCtx;
    req.correlationId = correlationId;

    // 3. Check required roles (coarse — role inclusion check)
    const requiredRoles = this.reflector.getAllAndOverride<string[]>(
      ROLES_KEY,
      [context.getHandler(), context.getClass()],
    );
    if (requiredRoles?.length) {
      const hasRole = requiredRoles.some((r) => authzCtx.roles.includes(r));
      if (!hasRole) {
        throw new ForbiddenException(
          `Required roles: ${requiredRoles.join(", ")}`,
        );
      }
    }

    // 4. Check required permissions via full engine (RBAC + ABAC + audit)
    const requiredPermissions = this.reflector.getAllAndOverride<
      PermissionKey[]
    >(PERMISSIONS_KEY, [context.getHandler(), context.getClass()]);

    if (requiredPermissions?.length) {
      for (const permission of requiredPermissions) {
        const result = await this.authzEngine.evaluate(authzCtx, permission);

        if (!result.permitted) {
          this.logger.warn(
            `Access denied | User: ${authzCtx.userId} | Permission: ${permission} | Reason: ${result.reason} | Correlation: ${correlationId}`,
          );
          if (result.decision === "MFA_REQUIRED") {
            throw new ForbiddenException({
              message: "MFA verification required",
              code: "MFA_REQUIRED",
            });
          }
          throw new ForbiddenException({
            message: `Access denied: ${result.reason}`,
            code: result.decision,
            correlationId,
          });
        }
      }
    }

    return true;
  }
}

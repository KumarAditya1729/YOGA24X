// ==============================================================================
// Yoga24X — Tenant Resolver Middleware
// Resolves active tenant from X-Tenant-ID header or Host slug
// Injects into AsyncLocalStorage — all downstream code gets isolation for free
// ==============================================================================
import {
  Injectable,
  NestMiddleware,
  UnauthorizedException,
  Logger,
} from "@nestjs/common";
import { Request, Response, NextFunction } from "express";
import { TenantService } from "./tenant.service";
import { tenantContextStorage } from "./tenant.context";

@Injectable()
export class TenantResolverMiddleware implements NestMiddleware {
  private readonly logger = new Logger(TenantResolverMiddleware.name);

  constructor(private readonly tenantService: TenantService) {}

  async use(req: Request, res: Response, next: NextFunction): Promise<void> {
    // Resolution priority: X-Tenant-ID header → Host slug → bypass (public routes)
    const tenantId = req.headers["x-tenant-id"] as string | undefined;
    const host = req.hostname;

    let tenantContext = null;

    if (tenantId) {
      tenantContext = await this.tenantService.resolveById(tenantId);
    } else if (host && host !== "localhost") {
      tenantContext = await this.tenantService.resolveByDomain(host);
    }

    if (!tenantContext) {
      // Public routes without tenant context are allowed through
      // Guards will enforce tenant requirements on protected routes
      return next();
    }

    if (
      tenantContext.status === "SUSPENDED" ||
      tenantContext.status === "CHURNED"
    ) {
      throw new UnauthorizedException(
        `Tenant '${tenantContext.tenantSlug}' is ${tenantContext.status.toLowerCase()}. Access denied.`,
      );
    }

    this.logger.debug(
      `Tenant resolved: ${tenantContext.tenantSlug} (${tenantContext.tenantId})`,
    );

    // Run the rest of the request pipeline inside the tenant context store
    tenantContextStorage.run(tenantContext, () => next());
  }
}

// ==============================================================================
// Yoga24X — Security Module
// Registers all RBAC+ABAC+Tenant+FeatureFlag+Policy services and middleware
// ==============================================================================
import {
  Module,
  MiddlewareConsumer,
  RequestMethod,
  Global,
} from "@nestjs/common";
import { PrismaModule } from "../prisma/prisma.module";
import { RedisModule } from "../redis/redis.module";

// Services
import { AuthorizationEngineService } from "./authorization/authorization-engine.service";
import { SecurityAuditService } from "./authorization/security-audit.service";
import { TenantService } from "./tenant/tenant.service";
import { TenantResolverMiddleware } from "./tenant/tenant-resolver.middleware";
import { FeatureFlagService } from "./feature-flags/feature-flags.service";
import { OrganizationService } from "./organization/organization.service";
import { SecurityPolicyService } from "./policies/security-policy.service";
import { RbacService } from "./rbac/rbac.service";

// Guards
import { AuthorizationGuard } from "./guards/authorization.guard";

// Controllers
import { RolesController } from "./controllers/roles.controller";
import {
  TenantsController,
  FeatureFlagsController,
  PoliciesController,
  OrganizationsController,
  SecurityAuditController,
} from "./controllers/security.controllers";

@Global()
@Module({
  imports: [PrismaModule, RedisModule],
  providers: [
    AuthorizationEngineService,
    SecurityAuditService,
    TenantService,
    FeatureFlagService,
    OrganizationService,
    SecurityPolicyService,
    RbacService,
    AuthorizationGuard,
  ],
  controllers: [
    RolesController,
    TenantsController,
    FeatureFlagsController,
    PoliciesController,
    OrganizationsController,
    SecurityAuditController,
  ],
  exports: [
    AuthorizationEngineService,
    SecurityAuditService,
    TenantService,
    FeatureFlagService,
    RbacService,
    AuthorizationGuard,
    SecurityPolicyService,
  ],
})
export class SecurityModule {
  configure(consumer: MiddlewareConsumer) {
    consumer
      .apply(TenantResolverMiddleware)
      .forRoutes({ path: "*", method: RequestMethod.ALL });
  }
}

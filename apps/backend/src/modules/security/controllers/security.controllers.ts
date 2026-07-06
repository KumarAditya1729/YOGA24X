// ==============================================================================
// Yoga24X — Tenant, Feature Flag, Policy, Organization & Audit Controllers
// ==============================================================================
import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  HttpCode,
  HttpStatus,
  ParseUUIDPipe,
} from "@nestjs/common";
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiQuery,
} from "@nestjs/swagger";
import { AuthorizationGuard } from "../guards/authorization.guard";
import { RequirePermissions } from "../decorators/authorization.decorators";
import { PERMISSIONS } from "../constants/permissions.registry";
import { TenantService } from "../tenant/tenant.service";
import { FeatureFlagService } from "../feature-flags/feature-flags.service";
import { SecurityPolicyService } from "../policies/security-policy.service";
import { OrganizationService } from "../organization/organization.service";
import { SecurityAuditService } from "../authorization/security-audit.service";

// ── Tenant Controller ────────────────────────────────────────────────────────

@ApiTags("Security — Tenants")
@ApiBearerAuth()
@UseGuards(AuthorizationGuard)
@Controller("api/v1/security/tenants")
export class TenantsController {
  constructor(private readonly tenantService: TenantService) {}

  @Get()
  @ApiOperation({ summary: "List all tenants" })
  @RequirePermissions(PERMISSIONS.TENANTS_READ)
  listAll(@Query("page") page = 1, @Query("limit") limit = 20) {
    return this.tenantService.listAll(+page, +limit);
  }

  @Get(":id")
  @ApiOperation({ summary: "Get tenant by ID" })
  @RequirePermissions(PERMISSIONS.TENANTS_READ)
  findById(@Param("id", ParseUUIDPipe) id: string) {
    return this.tenantService.findById(id);
  }

  @Post()
  @ApiOperation({ summary: "Create a new tenant" })
  @RequirePermissions(PERMISSIONS.TENANTS_MANAGE)
  @HttpCode(HttpStatus.CREATED)
  create(@Body() body: { name: string; slug: string; plan?: string }) {
    return this.tenantService.create(body);
  }

  @Put(":id/branding")
  @ApiOperation({ summary: "Update tenant branding configuration" })
  @RequirePermissions(PERMISSIONS.TENANTS_BRANDING)
  updateBranding(
    @Param("id", ParseUUIDPipe) id: string,
    @Body() brandingJson: Record<string, unknown>,
  ) {
    return this.tenantService.updateBranding(id, brandingJson);
  }

  @Put(":id/config")
  @ApiOperation({ summary: "Update tenant configuration" })
  @RequirePermissions(PERMISSIONS.TENANTS_CONFIG)
  updateConfig(
    @Param("id", ParseUUIDPipe) id: string,
    @Body() configJson: Record<string, unknown>,
  ) {
    return this.tenantService.updateConfig(id, configJson);
  }

  @Put(":id/suspend")
  @ApiOperation({ summary: "Suspend a tenant" })
  @RequirePermissions(PERMISSIONS.TENANTS_SUSPEND)
  suspend(@Param("id", ParseUUIDPipe) id: string) {
    return this.tenantService.suspend(id);
  }

  @Put(":id/activate")
  @ApiOperation({ summary: "Activate a suspended tenant" })
  @RequirePermissions(PERMISSIONS.TENANTS_MANAGE)
  activate(@Param("id", ParseUUIDPipe) id: string) {
    return this.tenantService.activate(id);
  }
}

// ── Feature Flag Controller ────────────────────────────────────────────────────

@ApiTags("Security — Feature Flags")
@ApiBearerAuth()
@UseGuards(AuthorizationGuard)
@Controller("api/v1/security/flags")
export class FeatureFlagsController {
  constructor(private readonly flagService: FeatureFlagService) {}

  @Get()
  @ApiOperation({ summary: "List feature flags" })
  @RequirePermissions(PERMISSIONS.FLAGS_READ)
  @ApiQuery({ name: "tenantId", required: false })
  @ApiQuery({ name: "scope", required: false })
  list(@Query("tenantId") tenantId?: string, @Query("scope") scope?: string) {
    return this.flagService.listFlags(tenantId, scope);
  }

  @Get("evaluate/:key")
  @ApiOperation({ summary: "Evaluate a feature flag for a context" })
  @RequirePermissions(PERMISSIONS.FLAGS_READ)
  evaluate(
    @Param("key") key: string,
    @Query("userId") userId?: string,
    @Query("tenantId") tenantId?: string,
    @Query("organizationId") organizationId?: string,
  ) {
    return this.flagService.evaluate(key, { userId, tenantId, organizationId });
  }

  @Post()
  @ApiOperation({ summary: "Create or update a feature flag" })
  @RequirePermissions(PERMISSIONS.FLAGS_MANAGE)
  @HttpCode(HttpStatus.CREATED)
  createOrUpdate(
    @Body()
    body: {
      key: string;
      scope: string;
      tenantId?: string;
      organizationId?: string;
      userId?: string;
      isEnabled: boolean;
      rolloutPercentage?: number;
      configJson?: Record<string, unknown>;
      scheduledEnableAt?: string;
      scheduledDisableAt?: string;
      description?: string;
      createdBy: string;
    },
  ) {
    return this.flagService.createOrUpdate({
      ...body,
      scheduledEnableAt: body.scheduledEnableAt
        ? new Date(body.scheduledEnableAt)
        : undefined,
      scheduledDisableAt: body.scheduledDisableAt
        ? new Date(body.scheduledDisableAt)
        : undefined,
    });
  }

  @Post(":key/kill-switch")
  @ApiOperation({ summary: "Activate emergency kill switch for a flag" })
  @RequirePermissions(PERMISSIONS.FLAGS_KILL_SWITCH)
  @HttpCode(HttpStatus.NO_CONTENT)
  killSwitch(
    @Param("key") key: string,
    @Body() body: { tenantId?: string; activatedBy: string },
  ) {
    return this.flagService.triggerKillSwitch(
      key,
      body.tenantId,
      body.activatedBy,
    );
  }

  @Delete(":key/kill-switch")
  @ApiOperation({ summary: "Release kill switch for a flag" })
  @RequirePermissions(PERMISSIONS.FLAGS_KILL_SWITCH)
  @HttpCode(HttpStatus.NO_CONTENT)
  releaseKillSwitch(
    @Param("key") key: string,
    @Query("tenantId") tenantId?: string,
  ) {
    return this.flagService.releaseKillSwitch(key, tenantId);
  }
}

// ── Security Policy Controller ────────────────────────────────────────────────

@ApiTags("Security — Policies")
@ApiBearerAuth()
@UseGuards(AuthorizationGuard)
@Controller("api/v1/security/policies")
export class PoliciesController {
  constructor(private readonly policyService: SecurityPolicyService) {}

  @Get()
  @ApiOperation({ summary: "Get active security policies" })
  @RequirePermissions(PERMISSIONS.SECURITY_POLICIES_MANAGE)
  getActive(@Query("tenantId") tenantId?: string) {
    return this.policyService.getActivePolicies(tenantId);
  }

  @Post()
  @ApiOperation({ summary: "Create a new security policy" })
  @RequirePermissions(PERMISSIONS.SECURITY_POLICIES_MANAGE)
  @HttpCode(HttpStatus.CREATED)
  create(
    @Body()
    body: {
      name: string;
      description?: string;
      policyType: string;
      action: string;
      rulesJson: Record<string, unknown>;
      priority?: number;
      tenantId?: string;
      organizationId?: string;
      createdBy: string;
    },
  ) {
    return this.policyService.createPolicy(body);
  }

  @Put(":id")
  @ApiOperation({ summary: "Update a security policy" })
  @RequirePermissions(PERMISSIONS.SECURITY_POLICIES_MANAGE)
  update(
    @Param("id", ParseUUIDPipe) id: string,
    @Body()
    body: {
      name?: string;
      rulesJson?: Record<string, unknown>;
      isEnabled?: boolean;
      priority?: number;
    },
  ) {
    return this.policyService.updatePolicy(id, body);
  }

  @Delete(":id")
  @ApiOperation({ summary: "Delete a security policy" })
  @RequirePermissions(PERMISSIONS.SECURITY_POLICIES_MANAGE)
  @HttpCode(HttpStatus.NO_CONTENT)
  delete(@Param("id", ParseUUIDPipe) id: string) {
    return this.policyService.deletePolicy(id);
  }
}

// ── Organization Controller ────────────────────────────────────────────────────

@ApiTags("Security — Organizations")
@ApiBearerAuth()
@UseGuards(AuthorizationGuard)
@Controller("api/v1/security/organizations")
export class OrganizationsController {
  constructor(private readonly orgService: OrganizationService) {}

  @Get()
  @ApiOperation({ summary: "List organizations for tenant" })
  @RequirePermissions(PERMISSIONS.ORGS_READ)
  list(
    @Query("tenantId") tenantId: string,
    @Query("page") page = 1,
    @Query("limit") limit = 20,
  ) {
    return this.orgService.findAllByTenant(tenantId, +page, +limit);
  }

  @Get(":id")
  @ApiOperation({ summary: "Get organization by ID" })
  @RequirePermissions(PERMISSIONS.ORGS_READ)
  findById(
    @Param("id", ParseUUIDPipe) id: string,
    @Query("tenantId") tenantId: string,
  ) {
    return this.orgService.findById(id, tenantId);
  }

  @Post()
  @ApiOperation({ summary: "Create organization" })
  @RequirePermissions(PERMISSIONS.ORGS_CREATE)
  @HttpCode(HttpStatus.CREATED)
  create(
    @Body()
    body: {
      name: string;
      type: string;
      ownerId: string;
      tenantId: string;
    },
  ) {
    return this.orgService.create(body);
  }

  @Post(":id/members")
  @ApiOperation({ summary: "Add member to organization" })
  @RequirePermissions(PERMISSIONS.ORGS_MANAGE_MEMBERS)
  addMember(
    @Param("id", ParseUUIDPipe) id: string,
    @Body() body: { userId: string; role: string; tenantId: string },
  ) {
    return this.orgService.addMember(id, body.userId, body.role, body.tenantId);
  }

  @Post("invitations")
  @ApiOperation({ summary: "Create secure organization invitation" })
  @RequirePermissions(PERMISSIONS.ORGS_INVITE)
  @HttpCode(HttpStatus.CREATED)
  createInvitation(
    @Body()
    body: {
      organizationId: string;
      email: string;
      role: string;
      teamId?: string;
      invitedBy: string;
      expiresInHours?: number;
    },
  ) {
    return this.orgService.createInvitation(body);
  }

  @Post("invitations/accept")
  @ApiOperation({ summary: "Accept organization invitation" })
  @HttpCode(HttpStatus.OK)
  acceptInvitation(@Body() body: { token: string; userId: string }) {
    return this.orgService.acceptInvitation(body.token, body.userId);
  }

  @Post(":id/transfer-ownership")
  @ApiOperation({ summary: "Initiate secure ownership transfer" })
  @RequirePermissions(PERMISSIONS.ORGS_TRANSFER_OWNERSHIP)
  @HttpCode(HttpStatus.ACCEPTED)
  initiateTransfer(
    @Param("id", ParseUUIDPipe) id: string,
    @Body()
    body: {
      fromUserId: string;
      toUserId: string;
      initiatedBy: string;
      tenantId: string;
    },
  ) {
    return this.orgService.initiateOwnershipTransfer({
      organizationId: id,
      ...body,
    });
  }

  @Post("transfer-ownership/confirm")
  @ApiOperation({ summary: "Confirm ownership transfer with token" })
  @HttpCode(HttpStatus.OK)
  confirmTransfer(@Body() body: { token: string; userId: string }) {
    return this.orgService.confirmOwnershipTransfer(body.token, body.userId);
  }
}

// ── Security Audit Controller ─────────────────────────────────────────────────

@ApiTags("Security — Audit & Events")
@ApiBearerAuth()
@UseGuards(AuthorizationGuard)
@Controller("api/v1/security/audit")
export class SecurityAuditController {
  constructor(private readonly auditService: SecurityAuditService) {}

  @Get("authz-logs")
  @ApiOperation({ summary: "Get authorization audit logs" })
  @RequirePermissions(PERMISSIONS.SECURITY_AUDIT_READ)
  getAuditLogs(
    @Query("userId") userId?: string,
    @Query("tenantId") tenantId?: string,
    @Query("decision") decision?: string,
    @Query("page") page = 1,
    @Query("limit") limit = 50,
  ) {
    return this.auditService.getAuditLogs({
      userId,
      tenantId,
      decision,
      page: +page,
      limit: +limit,
    });
  }

  @Get("security-events")
  @ApiOperation({ summary: "Get security event log" })
  @RequirePermissions(PERMISSIONS.SECURITY_EVENTS_READ)
  getSecurityEvents(
    @Query("tenantId") tenantId?: string,
    @Query("severity") severity?: string,
    @Query("eventType") eventType?: string,
    @Query("isAcknowledged") isAcknowledged?: string,
    @Query("page") page = 1,
    @Query("limit") limit = 50,
  ) {
    return this.auditService.getSecurityEvents({
      tenantId,
      severity,
      eventType,
      isAcknowledged:
        isAcknowledged !== undefined ? isAcknowledged === "true" : undefined,
      page: +page,
      limit: +limit,
    });
  }

  @Put("security-events/:id/acknowledge")
  @ApiOperation({ summary: "Acknowledge a security event" })
  @RequirePermissions(PERMISSIONS.SECURITY_EVENTS_ACK)
  acknowledge(
    @Param("id", ParseUUIDPipe) id: string,
    @Body() body: { acknowledgedBy: string },
  ) {
    return this.auditService.acknowledgeEvent(id, body.acknowledgedBy);
  }
}

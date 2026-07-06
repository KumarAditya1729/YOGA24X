// ==============================================================================
// Yoga24X — Security Module Controllers (Parts 11)
// Roles, Permissions, Policies, FeatureFlags, Tenants, Organizations, Audit
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
import {
  RequirePermissions,
  RequireRoles,
} from "../decorators/authorization.decorators";
import { PERMISSIONS } from "../constants/permissions.registry";
import { RbacService } from "../rbac/rbac.service";

@ApiTags("Security — RBAC & Roles")
@ApiBearerAuth()
@UseGuards(AuthorizationGuard)
@Controller("api/v1/security/roles")
export class RolesController {
  constructor(private readonly rbacService: RbacService) {}

  @Get("system")
  @ApiOperation({
    summary: "Get all system role definitions with permission matrix",
  })
  @RequirePermissions(PERMISSIONS.SECURITY_ROLES_MANAGE)
  getSystemRoles() {
    return this.rbacService.getSystemRoles();
  }

  @Get("registry")
  @ApiOperation({ summary: "Get complete permission registry" })
  @RequirePermissions(PERMISSIONS.SECURITY_ROLES_MANAGE)
  getPermissionRegistry() {
    return this.rbacService.getPermissionRegistry();
  }

  @Get("users/:userId")
  @ApiOperation({ summary: "Get all roles assigned to a user" })
  @RequirePermissions(PERMISSIONS.SECURITY_ROLES_MANAGE)
  getUserRoles(@Param("userId", ParseUUIDPipe) userId: string) {
    return this.rbacService.getUserRoles(userId);
  }

  @Post("users/:userId/assign")
  @ApiOperation({ summary: "Assign role to user" })
  @RequirePermissions(PERMISSIONS.SECURITY_ROLES_MANAGE)
  @HttpCode(HttpStatus.CREATED)
  assignRole(
    @Param("userId", ParseUUIDPipe) userId: string,
    @Body() body: { roleName: string; assignedBy: string },
  ) {
    return this.rbacService.assignRole(userId, body.roleName, body.assignedBy);
  }

  @Delete("users/:userId/revoke/:roleName")
  @ApiOperation({ summary: "Revoke role from user" })
  @RequirePermissions(PERMISSIONS.SECURITY_ROLES_MANAGE)
  @HttpCode(HttpStatus.NO_CONTENT)
  revokeRole(
    @Param("userId", ParseUUIDPipe) userId: string,
    @Param("roleName") roleName: string,
  ) {
    return this.rbacService.revokeRole(userId, roleName);
  }

  @Get("overrides/:userId")
  @ApiOperation({ summary: "Get permission overrides for a user" })
  @RequirePermissions(PERMISSIONS.SECURITY_PERMS_MANAGE)
  getUserOverrides(
    @Param("userId", ParseUUIDPipe) userId: string,
    @Query("tenantId") tenantId?: string,
  ) {
    return this.rbacService.getUserOverrides(userId, tenantId);
  }

  @Post("overrides")
  @ApiOperation({
    summary: "Grant permission override (allow/deny/temporary/conditional)",
  })
  @RequirePermissions(PERMISSIONS.SECURITY_PERMS_MANAGE)
  @HttpCode(HttpStatus.CREATED)
  grantOverride(
    @Body()
    body: {
      userId: string;
      permissionKey: string;
      effect: "ALLOW" | "DENY";
      state: "OVERRIDDEN" | "TEMPORARY";
      reason: string;
      grantedBy: string;
      tenantId?: string;
      organizationId?: string;
      expiresAt?: string;
      conditionJson?: Record<string, unknown>;
    },
  ) {
    return this.rbacService.grantOverride({
      ...body,
      expiresAt: body.expiresAt ? new Date(body.expiresAt) : undefined,
    });
  }

  @Delete("overrides/:id")
  @ApiOperation({ summary: "Revoke a permission override" })
  @RequirePermissions(PERMISSIONS.SECURITY_PERMS_MANAGE)
  @HttpCode(HttpStatus.NO_CONTENT)
  revokeOverride(
    @Param("id", ParseUUIDPipe) id: string,
    @Body() body: { userId: string },
  ) {
    return this.rbacService.revokeOverride(id, body.userId);
  }
}

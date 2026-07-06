// ==============================================================================
// Yoga24X — RBAC Service
// Manages roles and permission overrides for users
// ==============================================================================
import {
  Injectable,
  NotFoundException,
  ConflictException,
} from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { AuthorizationEngineService } from "../authorization/authorization-engine.service";
import {
  PERMISSIONS,
  ROLE_PERMISSION_MATRIX,
} from "../constants/permissions.registry";

@Injectable()
export class RbacService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly authzEngine: AuthorizationEngineService,
  ) {}

  // ── Role Management ────────────────────────────────────────────────────────

  async getSystemRoles() {
    return Object.values(ROLE_PERMISSION_MATRIX).map((r) => ({
      name: r.name,
      inherits: r.inherits,
      directPermissions: r.permissions,
      effectivePermissions: this.resolveInheritedPermissions(r.name),
    }));
  }

  async getUserRoles(userId: string) {
    const userRoles = await this.prisma.userRole.findMany({
      where: { userId },
      include: { role: true },
    });
    return userRoles.map((ur: { role: unknown }) => ur.role);
  }

  async assignRole(userId: string, roleName: string, assignedBy: string) {
    const role = await this.prisma.role.findUnique({
      where: { name: roleName },
    });
    if (!role) throw new NotFoundException(`Role '${roleName}' not found`);

    const existing = await this.prisma.userRole.findFirst({
      where: { userId, roleId: role.id },
    });
    if (existing) throw new ConflictException("User already has this role");

    const ur = await this.prisma.userRole.create({
      data: { userId, roleId: role.id, assignedBy },
    });

    await this.authzEngine.invalidateUserPermissionCache(userId);
    return ur;
  }

  async revokeRole(userId: string, roleName: string) {
    const role = await this.prisma.role.findUnique({
      where: { name: roleName },
    });
    if (!role) throw new NotFoundException(`Role '${roleName}' not found`);

    await this.prisma.userRole.deleteMany({
      where: { userId, roleId: role.id },
    });
    await this.authzEngine.invalidateUserPermissionCache(userId);
  }

  // ── Permission Override Management ─────────────────────────────────────────

  async grantOverride(data: {
    userId: string;
    permissionKey: string;
    effect: "ALLOW" | "DENY";
    state: "OVERRIDDEN" | "TEMPORARY";
    reason: string;
    grantedBy: string;
    tenantId?: string;
    organizationId?: string;
    expiresAt?: Date;
    conditionJson?: Record<string, unknown>;
  }) {
    const [module, action] = data.permissionKey.split(":");
    const permission = await this.prisma.permission.findFirst({
      where: { module, action },
    });
    if (!permission)
      throw new NotFoundException(
        `Permission '${data.permissionKey}' not found`,
      );

    const override = await this.prisma.userPermissionOverride.upsert({
      where: {
        uq_user_perm_override: {
          userId: data.userId,
          permissionId: permission.id,
          tenantId: data.tenantId ?? (null as any),
        },
      },
      update: {
        effect: data.effect as any,
        state: data.state as any,
        reason: data.reason,
        expiresAt: data.expiresAt,
        conditionJson: (data.conditionJson ?? null) as any,
        grantedBy: data.grantedBy,
      },
      create: {
        userId: data.userId,
        permissionId: permission.id,
        tenantId: data.tenantId,
        organizationId: data.organizationId,
        effect: data.effect as any,
        state: data.state as any,
        reason: data.reason,
        expiresAt: data.expiresAt,
        conditionJson: (data.conditionJson ?? null) as any,
        grantedBy: data.grantedBy,
      },
    });

    await this.authzEngine.invalidateUserPermissionCache(
      data.userId,
      data.tenantId,
    );
    return override;
  }

  async revokeOverride(overrideId: string, userId: string) {
    await this.prisma.userPermissionOverride.delete({
      where: { id: overrideId },
    });
    await this.authzEngine.invalidateUserPermissionCache(userId);
  }

  async getUserOverrides(userId: string, tenantId?: string) {
    return this.prisma.userPermissionOverride.findMany({
      where: { userId, ...(tenantId ? { tenantId } : {}) },
      orderBy: { createdAt: "desc" },
    });
  }

  // ── Permission Registry ────────────────────────────────────────────────────

  getPermissionRegistry() {
    return Object.entries(PERMISSIONS).map(([key, value]) => ({ key, value }));
  }

  private resolveInheritedPermissions(roleName: string): string[] {
    const perms = new Set<string>();
    const visited = new Set<string>();
    const resolve = (name: string) => {
      if (visited.has(name)) return;
      visited.add(name);
      const def = ROLE_PERMISSION_MATRIX[name];
      if (!def) return;
      def.inherits.forEach(resolve);
      def.permissions.forEach((p) => perms.add(p));
    };
    resolve(roleName);
    return [...perms];
  }
}

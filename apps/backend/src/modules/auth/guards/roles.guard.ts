// ==============================================================================
// Yoga24X AI Engineering OS — Roles Guard (RBAC Verification)
// ==============================================================================

import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
} from "@nestjs/common";
import { Reflector } from "@nestjs/core";
import { ROLES_KEY } from "../decorators/auth.decorators";
import { UserRoleName, JwtAccessPayload } from "@yoga24x/shared-types";

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.getAllAndOverride<UserRoleName[]>(
      ROLES_KEY,
      [context.getHandler(), context.getClass()],
    );

    if (!requiredRoles || requiredRoles.length === 0) {
      return true;
    }

    const { user }: { user: JwtAccessPayload } = context
      .switchToHttp()
      .getRequest();
    if (!user || !user.roles) {
      throw new ForbiddenException(
        "User roles missing from authentication context",
      );
    }

    // SUPER_ADMIN has universal access bypass
    if (user.roles.includes("SUPER_ADMIN")) {
      return true;
    }

    const hasRole = requiredRoles.some((role) => user.roles.includes(role));
    if (!hasRole) {
      throw new ForbiddenException(
        `Access denied: Requires one of the following roles: ${requiredRoles.join(", ")}`,
      );
    }

    return true;
  }
}

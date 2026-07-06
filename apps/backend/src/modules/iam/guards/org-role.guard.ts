// ==============================================================================
// Yoga24X AI Engineering OS — Organization Role Guard
// Verifies that a user has OWNER or ADMIN access to a target Organization
// ==============================================================================

import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
} from "@nestjs/common";
import { OrganizationRepository } from "../repositories/organization.repository";

@Injectable()
export class OrgRoleGuard implements CanActivate {
  constructor(private readonly orgRepo: OrganizationRepository) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const user = request.user;
    if (!user || !user.sub) {
      throw new ForbiddenException("Authentication required");
    }

    // Organization ID can come from params, body, or query
    const orgId =
      request.params.orgId ||
      request.body.organizationId ||
      request.query.orgId;
    if (!orgId) {
      throw new ForbiddenException("Organization ID is required");
    }

    const role = await this.orgRepo.getMemberRole(orgId, user.sub);
    if (!role || (role !== "OWNER" && role !== "ADMIN")) {
      throw new ForbiddenException(
        "You require OWNER or ADMIN role in this organization to perform this action",
      );
    }

    request.orgRole = role;
    return true;
  }
}

// ==============================================================================
// Yoga24X AI Engineering OS — Organization Service
// Handles Studio / Corporate Organization management, teams, branches, and invites
// ==============================================================================

import { Injectable, ForbiddenException } from "@nestjs/common";
import { OrganizationRepository } from "../repositories/organization.repository";
import {
  CreateOrganizationDto,
  InviteOrgMemberDto,
} from "@yoga24x/shared-types";

@Injectable()
export class OrganizationService {
  constructor(private readonly orgRepo: OrganizationRepository) {}

  async createOrganization(
    ownerId: string,
    dto: CreateOrganizationDto,
  ): Promise<any> {
    return this.orgRepo.createOrganization(ownerId, dto);
  }

  async getOrganizationDetails(orgId: string, userId: string): Promise<any> {
    // Verify member access
    const role = await this.orgRepo.getMemberRole(orgId, userId);
    if (!role) {
      throw new ForbiddenException(
        "You are not an active member of this organization",
      );
    }
    return this.orgRepo.getOrganizationDetails(orgId);
  }

  async getUserOrganizations(userId: string): Promise<any[]> {
    return this.orgRepo.getOrganizationsForUser(userId);
  }

  async inviteMember(
    orgId: string,
    inviterId: string,
    dto: InviteOrgMemberDto,
  ): Promise<any> {
    const role = await this.orgRepo.getMemberRole(orgId, inviterId);
    if (role !== "OWNER" && role !== "ADMIN") {
      throw new ForbiddenException(
        "Only organization owners and administrators can invite new members",
      );
    }
    return this.orgRepo.inviteMember(orgId, inviterId, dto);
  }

  async acceptInvitation(token: string, userId: string): Promise<any> {
    return this.orgRepo.acceptInvitation(token, userId);
  }

  async removeMember(
    orgId: string,
    removerId: string,
    targetUserId: string,
  ): Promise<void> {
    return this.orgRepo.removeMember(orgId, removerId, targetUserId);
  }

  async createTeam(
    orgId: string,
    userId: string,
    name: string,
    description?: string,
    leadUserId?: string,
  ): Promise<any> {
    const role = await this.orgRepo.getMemberRole(orgId, userId);
    if (role !== "OWNER" && role !== "ADMIN") {
      throw new ForbiddenException(
        "Only organization owners and administrators can create teams",
      );
    }
    return this.orgRepo.createTeam(orgId, name, description, leadUserId);
  }

  async createDepartment(
    orgId: string,
    userId: string,
    name: string,
    budgetCode?: string,
  ): Promise<any> {
    const role = await this.orgRepo.getMemberRole(orgId, userId);
    if (role !== "OWNER" && role !== "ADMIN") {
      throw new ForbiddenException(
        "Only organization owners and administrators can create departments",
      );
    }
    return this.orgRepo.createDepartment(orgId, name, budgetCode);
  }

  async createBranch(
    orgId: string,
    userId: string,
    name: string,
    address?: string,
    city?: string,
    managerUserId?: string,
  ): Promise<any> {
    const role = await this.orgRepo.getMemberRole(orgId, userId);
    if (role !== "OWNER" && role !== "ADMIN") {
      throw new ForbiddenException(
        "Only organization owners and administrators can create studio branches",
      );
    }
    return this.orgRepo.createBranch(orgId, name, address, city, managerUserId);
  }
}

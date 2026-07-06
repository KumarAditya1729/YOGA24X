// ==============================================================================
// Yoga24X AI Engineering OS — Organization Repository
// Handles Studios, Corporate Accounts, Teams, Departments, Branches, Members & Invites
// ==============================================================================

import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  ConflictException,
} from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import {
  CreateOrganizationDto,
  InviteOrgMemberDto,
  IAM_CONSTANTS,
} from "@yoga24x/shared-types";
import * as crypto from "crypto";

@Injectable()
export class OrganizationRepository {
  constructor(private readonly prisma: PrismaService) {}

  async createOrganization(
    ownerId: string,
    dto: CreateOrganizationDto,
  ): Promise<any> {
    return this.prisma.$transaction(async (tx: any) => {
      const org = await tx.organization.create({
        data: {
          name: dto.name,
          type: dto.type,
          ownerId,
          address: dto.address,
          city: dto.city,
          country: dto.country,
          status: "ACTIVE",
        },
      });

      // Automatically add owner as OWNER member in organization_members
      await tx.organizationMember.create({
        data: {
          organizationId: org.id,
          userId: ownerId,
          role: "OWNER",
          status: "ACTIVE",
        },
      });

      return org;
    });
  }

  async getOrganizationDetails(orgId: string): Promise<any> {
    const org = await this.prisma.organization.findUnique({
      where: { id: orgId },
      include: {
        owner: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            email: true,
            avatarUrl: true,
          },
        },
        teams: {
          include: {
            leadUser: { select: { id: true, firstName: true, lastName: true } },
          },
        },
        departments: true,
        branches: {
          include: {
            managerUser: {
              select: { id: true, firstName: true, lastName: true },
            },
          },
        },
        members: {
          include: {
            user: {
              select: {
                id: true,
                firstName: true,
                lastName: true,
                email: true,
                avatarUrl: true,
              },
            },
            team: true,
            department: true,
            branch: true,
          },
        },
        invitations: { where: { status: "PENDING" } },
      },
    });

    if (!org) {
      throw new NotFoundException(IAM_CONSTANTS.ERROR_CODES.ORG_NOT_FOUND);
    }
    return org;
  }

  async getOrganizationsForUser(userId: string): Promise<any[]> {
    return this.prisma.organizationMember.findMany({
      where: { userId, status: "ACTIVE" },
      include: {
        organization: true,
      },
    });
  }

  async getMemberRole(orgId: string, userId: string): Promise<string | null> {
    const member = await this.prisma.organizationMember.findUnique({
      where: { uq_org_member: { organizationId: orgId, userId } },
    });
    return member ? member.role : null;
  }

  async inviteMember(
    orgId: string,
    inviterId: string,
    dto: InviteOrgMemberDto,
  ): Promise<any> {
    // Check if user is already a member
    const existingUser = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });
    if (existingUser) {
      const existingMember = await this.prisma.organizationMember.findUnique({
        where: {
          uq_org_member: { organizationId: orgId, userId: existingUser.id },
        },
      });
      if (existingMember) {
        throw new ConflictException(
          "User is already a member of this organization",
        );
      }
    }

    const token = crypto.randomBytes(32).toString("hex");
    const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000); // 7 days TTL

    return this.prisma.organizationInvitation.create({
      data: {
        organizationId: orgId,
        email: dto.email,
        role: dto.role,
        teamId: dto.teamId,
        invitedBy: inviterId,
        token,
        status: "PENDING",
        expiresAt,
      },
    });
  }

  async acceptInvitation(token: string, userId: string): Promise<any> {
    return this.prisma.$transaction(async (tx: any) => {
      const invite = await tx.organizationInvitation.findUnique({
        where: { token },
      });

      if (
        !invite ||
        invite.status !== "PENDING" ||
        invite.expiresAt < new Date()
      ) {
        throw new ForbiddenException(
          "Invitation is invalid, expired, or already used",
        );
      }

      const member = await tx.organizationMember.create({
        data: {
          organizationId: invite.organizationId,
          userId,
          role: invite.role,
          teamId: invite.teamId,
          status: "ACTIVE",
        },
      });

      await tx.organizationInvitation.update({
        where: { id: invite.id },
        data: { status: "ACCEPTED" },
      });

      return member;
    });
  }

  async removeMember(
    orgId: string,
    removerId: string,
    targetUserId: string,
  ): Promise<void> {
    const removerRole = await this.getMemberRole(orgId, removerId);
    if (removerRole !== "OWNER" && removerRole !== "ADMIN") {
      throw new ForbiddenException(
        IAM_CONSTANTS.ERROR_CODES.UNAUTHORIZED_ORG_ACCESS,
      );
    }

    const targetRole = await this.getMemberRole(orgId, targetUserId);
    if (targetRole === "OWNER") {
      throw new ConflictException(
        IAM_CONSTANTS.ERROR_CODES.CANNOT_DELETE_ONLY_OWNER,
      );
    }

    await this.prisma.organizationMember.delete({
      where: { uq_org_member: { organizationId: orgId, userId: targetUserId } },
    });
  }

  async createTeam(
    orgId: string,
    name: string,
    description?: string,
    leadUserId?: string,
  ): Promise<any> {
    return this.prisma.organizationTeam.create({
      data: { organizationId: orgId, name, description, leadUserId },
    });
  }

  async createDepartment(
    orgId: string,
    name: string,
    budgetCode?: string,
  ): Promise<any> {
    return this.prisma.organizationDepartment.create({
      data: { organizationId: orgId, name, budgetCode },
    });
  }

  async createBranch(
    orgId: string,
    name: string,
    address?: string,
    city?: string,
    managerUserId?: string,
  ): Promise<any> {
    return this.prisma.organizationBranch.create({
      data: { organizationId: orgId, name, address, city, managerUserId },
    });
  }
}

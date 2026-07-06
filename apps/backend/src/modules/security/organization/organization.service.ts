// ==============================================================================
// Yoga24X — Organization Service
// Manages studio/corporate hierarchies, invitations, and ownership transfers
// All queries are automatically tenant-scoped via repository layer
// ==============================================================================
import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ConflictException,
  Logger,
} from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { randomBytes, createHash } from "crypto";
import { SecurityAuditService } from "../authorization/security-audit.service";

@Injectable()
export class OrganizationService {
  private readonly logger = new Logger(OrganizationService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: SecurityAuditService,
  ) {}

  // ─────────────────────────────────────────────────────────────────────────────
  // ORGANIZATION CRUD
  // ─────────────────────────────────────────────────────────────────────────────

  async create(data: {
    name: string;
    type: string;
    ownerId: string;
    tenantId: string;
    logoUrl?: string;
    address?: string;
    city?: string;
    country?: string;
  }) {
    return this.prisma.organization.create({ data });
  }

  async findById(id: string, tenantId: string) {
    const org = await this.prisma.organization.findFirst({
      where: { id, tenantId },
      include: {
        members: {
          include: {
            user: {
              select: {
                id: true,
                firstName: true,
                lastName: true,
                email: true,
              },
            },
          },
        },
        teams: true,
        departments: true,
        branches: true,
      },
    });
    if (!org)
      throw new NotFoundException(
        `Organization ${id} not found in tenant ${tenantId}`,
      );
    return org;
  }

  async findAllByTenant(tenantId: string, page = 1, limit = 20) {
    const skip = (page - 1) * limit;
    const [items, total] = await Promise.all([
      this.prisma.organization.findMany({
        where: { tenantId },
        skip,
        take: limit,
        orderBy: { createdAt: "desc" },
      }),
      this.prisma.organization.count({ where: { tenantId } }),
    ]);
    return { items, total, page, limit };
  }

  async update(
    id: string,
    tenantId: string,
    data: Partial<{
      name: string;
      logoUrl: string;
      address: string;
      city: string;
      status: string;
    }>,
  ) {
    await this.findById(id, tenantId);
    return this.prisma.organization.update({ where: { id }, data });
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // MEMBER MANAGEMENT
  // ─────────────────────────────────────────────────────────────────────────────

  async addMember(
    organizationId: string,
    userId: string,
    role: string,
    tenantId: string,
  ) {
    await this.findById(organizationId, tenantId);
    const existing = await this.prisma.organizationMember.findFirst({
      where: { organizationId, userId },
    });
    if (existing)
      throw new ConflictException(
        "User is already a member of this organization",
      );

    return this.prisma.organizationMember.create({
      data: { organizationId, userId, role, status: "ACTIVE" },
    });
  }

  async updateMemberRole(memberId: string, newRole: string) {
    return this.prisma.organizationMember.update({
      where: { id: memberId },
      data: { role: newRole },
    });
  }

  async removeMember(memberId: string) {
    return this.prisma.organizationMember.delete({ where: { id: memberId } });
  }

  async suspendMember(memberId: string) {
    return this.prisma.organizationMember.update({
      where: { id: memberId },
      data: { status: "SUSPENDED" },
    });
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // INVITATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  async createInvitation(data: {
    organizationId: string;
    email: string;
    role: string;
    teamId?: string;
    invitedBy: string;
    expiresInHours?: number;
  }) {
    const rawToken = randomBytes(32).toString("hex");
    const tokenHash = createHash("sha256").update(rawToken).digest("hex");
    const expiresAt = new Date();
    expiresAt.setHours(expiresAt.getHours() + (data.expiresInHours ?? 48));

    // Check for existing pending invitation
    const existing = await this.prisma.organizationInvitation.findFirst({
      where: {
        organizationId: data.organizationId,
        email: data.email,
        status: "PENDING",
      },
    });
    if (existing)
      throw new ConflictException(
        "A pending invitation already exists for this email",
      );

    const invitation = await this.prisma.organizationInvitation.create({
      data: {
        organizationId: data.organizationId,
        email: data.email,
        role: data.role,
        teamId: data.teamId,
        invitedBy: data.invitedBy,
        token: tokenHash,
        status: "PENDING",
        expiresAt,
      },
    });

    // Return raw token for email delivery (store only hash)
    return { ...invitation, plainToken: rawToken };
  }

  async acceptInvitation(plainToken: string, userId: string) {
    const tokenHash = createHash("sha256").update(plainToken).digest("hex");
    const invitation = await this.prisma.organizationInvitation.findFirst({
      where: { token: tokenHash, status: "PENDING" },
    });

    if (!invitation)
      throw new NotFoundException("Invalid or expired invitation token");
    if (invitation.expiresAt < new Date()) {
      await this.prisma.organizationInvitation.update({
        where: { id: invitation.id },
        data: { status: "EXPIRED" },
      });
      throw new BadRequestException("Invitation has expired");
    }

    await this.prisma.$transaction([
      this.prisma.organizationMember.create({
        data: {
          organizationId: invitation.organizationId,
          userId,
          role: invitation.role,
          teamId: invitation.teamId,
          status: "ACTIVE",
        },
      }),
      this.prisma.organizationInvitation.update({
        where: { id: invitation.id },
        data: { status: "ACCEPTED" },
      }),
    ]);

    return { organizationId: invitation.organizationId, role: invitation.role };
  }

  async revokeInvitation(invitationId: string) {
    return this.prisma.organizationInvitation.update({
      where: { id: invitationId },
      data: { status: "REVOKED" },
    });
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // OWNERSHIP TRANSFER
  // ─────────────────────────────────────────────────────────────────────────────

  async initiateOwnershipTransfer(data: {
    organizationId: string;
    tenantId: string;
    fromUserId: string;
    toUserId: string;
    initiatedBy: string;
  }) {
    await this.findById(data.organizationId, data.tenantId);

    const rawToken = randomBytes(32).toString("hex");
    const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000);

    const transfer = await this.prisma.ownershipTransferLog.create({
      data: {
        organizationId: data.organizationId,
        fromUserId: data.fromUserId,
        toUserId: data.toUserId,
        initiatedBy: data.initiatedBy,
        status: "PENDING",
        token: createHash("sha256").update(rawToken).digest("hex"),
        expiresAt,
      },
    });

    await this.audit.recordSecurityEvent({
      correlationId: randomBytes(16).toString("hex"),
      organizationId: data.organizationId,
      userId: data.initiatedBy,
      eventType: "OWNERSHIP_TRANSFER_INITIATED",
      severity: "HIGH",
      description: `Ownership transfer initiated from ${data.fromUserId} to ${data.toUserId}`,
    });

    return { ...transfer, plainToken: rawToken };
  }

  async confirmOwnershipTransfer(plainToken: string, confirmingUserId: string) {
    const tokenHash = createHash("sha256").update(plainToken).digest("hex");
    const transfer = await this.prisma.ownershipTransferLog.findFirst({
      where: { token: tokenHash, status: "PENDING" },
    });

    if (!transfer)
      throw new NotFoundException("Invalid or expired transfer token");
    if (transfer.expiresAt < new Date())
      throw new BadRequestException("Transfer token has expired");
    if (transfer.toUserId !== confirmingUserId)
      throw new BadRequestException("You are not the designated new owner");

    await this.prisma.$transaction([
      this.prisma.organization.update({
        where: { id: transfer.organizationId },
        data: { ownerId: transfer.toUserId },
      }),
      this.prisma.ownershipTransferLog.update({
        where: { id: transfer.id },
        data: { status: "ACCEPTED", completedAt: new Date() },
      }),
    ]);

    await this.audit.recordSecurityEvent({
      correlationId: randomBytes(16).toString("hex"),
      organizationId: transfer.organizationId,
      userId: confirmingUserId,
      eventType: "OWNERSHIP_TRANSFER_COMPLETED",
      severity: "HIGH",
      description: `Ownership transfer completed. New owner: ${confirmingUserId}`,
    });

    return {
      organizationId: transfer.organizationId,
      newOwnerId: transfer.toUserId,
    };
  }
}

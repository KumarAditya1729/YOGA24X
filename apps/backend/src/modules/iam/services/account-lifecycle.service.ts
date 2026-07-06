// ==============================================================================
// Yoga24X AI Engineering OS — Account Lifecycle Service
// Handles account suspension, activation, soft delete, and admin moderation
// ==============================================================================

import { Injectable, NotFoundException } from "@nestjs/common";
import { PrivacyRepository } from "../repositories/privacy.repository";
import { PrismaService } from "../../prisma/prisma.module";

@Injectable()
export class AccountLifecycleService {
  constructor(
    private readonly privacyRepo: PrivacyRepository,
    private readonly prisma: PrismaService,
  ) {}

  async suspendAccount(
    adminId: string,
    targetUserId: string,
    reason: string,
  ): Promise<any> {
    const user = await this.prisma.user.findUnique({
      where: { id: targetUserId },
    });
    if (!user) throw new NotFoundException("User not found");

    const suspended = await this.privacyRepo.suspendAccount(
      targetUserId,
      reason,
    );

    // Record audit log
    await this.prisma.auditLog.create({
      data: {
        actorId: adminId,
        action: "ACCOUNT_SUSPENDED",
        entityType: "User",
        entityId: targetUserId,
        ipAddress: "127.0.0.1",
        newValuesJson: { reason },
      },
    });

    return suspended;
  }

  async activateAccount(adminId: string, targetUserId: string): Promise<any> {
    const user = await this.prisma.user.findUnique({
      where: { id: targetUserId },
    });
    if (!user) throw new NotFoundException("User not found");

    const activated = await this.privacyRepo.activateAccount(targetUserId);

    await this.prisma.auditLog.create({
      data: {
        actorId: adminId,
        action: "ACCOUNT_ACTIVATED",
        entityType: "User",
        entityId: targetUserId,
        ipAddress: "127.0.0.1",
        newValuesJson: { status: "ACTIVE" },
      },
    });

    return activated;
  }

  async searchUsers(
    query?: string,
    role?: string,
    status?: string,
  ): Promise<any[]> {
    const where: any = {};
    if (query) {
      where.OR = [
        { email: { contains: query, mode: "insensitive" } },
        { firstName: { contains: query, mode: "insensitive" } },
        { lastName: { contains: query, mode: "insensitive" } },
        { phoneNumber: { contains: query } },
      ];
    }
    if (status) where.status = status as any;
    if (role) {
      where.userRoles = { some: { role: { name: role } } };
    }

    return this.prisma.user.findMany({
      where,
      select: {
        id: true,
        email: true,
        phoneNumber: true,
        firstName: true,
        lastName: true,
        avatarUrl: true,
        status: true,
        isEmailVerified: true,
        isPhoneVerified: true,
        profileCompletionPercentage: true,
        createdAt: true,
        userRoles: { include: { role: true } },
      },
      orderBy: { createdAt: "desc" },
      take: 100,
    });
  }
}

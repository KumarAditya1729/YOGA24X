// ==============================================================================
// Yoga24X AI Engineering OS — Privacy & Account Lifecycle Repository
// Handles consent, cookie/marketing/AI/health preferences, GDPR exports & deletion
// ==============================================================================

import { Injectable, NotFoundException } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import {
  UpdateConsentDto,
  ConsentType,
  IAM_CONSTANTS,
} from "@yoga24x/shared-types";

@Injectable()
export class PrivacyRepository {
  constructor(private readonly prisma: PrismaService) {}

  async getUserConsents(userId: string): Promise<any[]> {
    return this.prisma.userConsent.findMany({
      where: { userId },
      orderBy: { acceptedAt: "desc" },
    });
  }

  async updateConsent(
    userId: string,
    dto: UpdateConsentDto,
    ipAddress?: string,
    userAgent?: string,
  ): Promise<any> {
    if (dto.isAccepted) {
      return this.prisma.userConsent.create({
        data: {
          userId,
          consentType: dto.consentType,
          isAccepted: true,
          ipAddress,
          userAgent,
          acceptedAt: new Date(),
        },
      });
    } else {
      // Find active consent and revoke it
      const existing = await this.prisma.userConsent.findFirst({
        where: {
          userId,
          consentType: dto.consentType,
          isAccepted: true,
          revokedAt: null,
        },
      });
      if (existing) {
        return this.prisma.userConsent.update({
          where: { id: existing.id },
          data: { isAccepted: false, revokedAt: new Date() },
        });
      }
      return null;
    }
  }

  async createDataExportRequest(userId: string): Promise<any> {
    return this.prisma.dataExportRequest.create({
      data: {
        userId,
        status: "PROCESSING",
        requestedAt: new Date(),
      },
    });
  }

  async getDataExportRequests(userId: string): Promise<any[]> {
    return this.prisma.dataExportRequest.findMany({
      where: { userId },
      orderBy: { requestedAt: "desc" },
    });
  }

  async scheduleAccountDeletion(userId: string, reason?: string): Promise<any> {
    const scheduledFor = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000); // 30-day grace period

    return this.prisma.$transaction(async (tx: any) => {
      const request = await tx.accountDeletionRequest.create({
        data: {
          userId,
          reason,
          status: "SCHEDULED",
          scheduledFor,
        },
      });

      await tx.user.update({
        where: { id: userId },
        data: {
          isDeleted: true,
          deletedAt: new Date(),
          deletionScheduledAt: scheduledFor,
        },
      });

      return request;
    });
  }

  async cancelAccountDeletion(userId: string): Promise<any> {
    return this.prisma.$transaction(async (tx: any) => {
      await tx.accountDeletionRequest.updateMany({
        where: { userId, status: "SCHEDULED" },
        data: { status: "CANCELLED", completedAt: new Date() },
      });

      return tx.user.update({
        where: { id: userId },
        data: {
          isDeleted: false,
          deletedAt: null,
          deletionScheduledAt: null,
        },
      });
    });
  }

  async suspendAccount(userId: string, reason: string): Promise<any> {
    return this.prisma.user.update({
      where: { id: userId },
      data: {
        status: "SUSPENDED",
        suspendedAt: new Date(),
        suspensionReason: reason,
      },
    });
  }

  async activateAccount(userId: string): Promise<any> {
    return this.prisma.user.update({
      where: { id: userId },
      data: {
        status: "ACTIVE",
        suspendedAt: null,
        suspensionReason: null,
      },
    });
  }
}

// ==============================================================================
// Yoga24X — Teacher Admin Service
// Admin-only operations: feature, suspend, bulk list, stats recalculation
// ==============================================================================
import { Injectable, NotFoundException } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { TeacherProfileRepository } from "../repositories/teacher-profile.repository";
import { TeacherStatsRepository } from "../repositories/teacher-stats.repository";
import { EventEmitter2 } from "@nestjs/event-emitter";

@Injectable()
export class TeacherAdminService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly profileRepo: TeacherProfileRepository,
    private readonly statsRepo: TeacherStatsRepository,
    private readonly events: EventEmitter2,
  ) {}

  async featureTeacher(userId: string, isFeatured: boolean) {
    const profile = await this.prisma.teacherProfile.findUnique({
      where: { userId },
    });
    if (!profile) throw new NotFoundException("Teacher profile not found");

    return this.prisma.teacherProfile.update({
      where: { userId },
      data: {
        isFeatured,
        featuredAt: isFeatured ? new Date() : null,
      },
    });
  }

  async suspendTeacher(userId: string, reason: string) {
    return this.prisma.teacherProfile.update({
      where: { userId },
      data: { verificationStatus: "SUSPENDED" as any },
    });
  }

  async reinstateTeacher(userId: string) {
    return this.prisma.teacherProfile.update({
      where: { userId },
      data: { verificationStatus: "APPROVED" as any },
    });
  }

  async bulkRecalculateStats(userIds: string[]) {
    const results = await Promise.allSettled(
      userIds.map((id) => this.statsRepo.recalculate(id)),
    );
    const succeeded = results.filter((r) => r.status === "fulfilled").length;
    const failed = results.length - succeeded;
    return { succeeded, failed, total: results.length };
  }

  async getAdminDashboardMetrics() {
    const [total, approved, pending, underReview, flagged] = await Promise.all([
      this.prisma.teacherProfile.count(),
      this.prisma.teacherProfile.count({
        where: { verificationStatus: "APPROVED" },
      }),
      this.prisma.teacherVerification.count({ where: { status: "PENDING" } }),
      this.prisma.teacherVerification.count({
        where: { status: "UNDER_REVIEW" },
      }),
      this.prisma.teacherVerification.count({
        where: { aiFraudFlagged: true },
      }),
    ]);

    return {
      totalTeachers: total,
      approvedTeachers: approved,
      pendingVerifications: pending,
      underReviewVerifications: underReview,
      fraudFlaggedCount: flagged,
    };
  }

  async searchTeachers(search: string, page = 1, limit = 20) {
    const skip = (page - 1) * limit;
    const where = search
      ? {
          OR: [
            {
              user: {
                email: { contains: search, mode: "insensitive" as const },
              },
            },
            {
              user: {
                firstName: { contains: search, mode: "insensitive" as const },
              },
            },
            {
              user: {
                lastName: { contains: search, mode: "insensitive" as const },
              },
            },
            { headline: { contains: search, mode: "insensitive" as const } },
          ],
        }
      : {};

    const [data, total] = await Promise.all([
      this.prisma.teacherProfile.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: "desc" },
        include: {
          user: {
            select: {
              firstName: true,
              lastName: true,
              email: true,
              avatarUrl: true,
            },
          },
          stats: true,
          verification: {
            select: {
              status: true,
              aiFraudFlagged: true,
              lastSubmittedAt: true,
            },
          },
        },
      }),
      this.prisma.teacherProfile.count({ where }),
    ]);

    return { data, total, page, limit, totalPages: Math.ceil(total / limit) };
  }
}

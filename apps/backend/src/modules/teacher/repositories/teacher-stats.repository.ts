// ==============================================================================
// Yoga24X — Teacher Stats Repository
// Denormalized stat computation and persistence
// ==============================================================================
import { Injectable } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";

@Injectable()
export class TeacherStatsRepository {
  constructor(private readonly prisma: PrismaService) {}

  async getStats(userId: string) {
    return this.prisma.teacherStats.findUnique({ where: { userId } });
  }

  async incrementProfileView(userId: string) {
    return this.prisma.teacherStats.update({
      where: { userId },
      data: {
        profileViewsTotal: { increment: 1 },
        profileViewsThisMonth: { increment: 1 },
      },
    });
  }

  async recalculate(userId: string) {
    // Aggregate reviews
    const reviewAgg = await this.prisma.teacherReview.aggregate({
      where: { teacherUserId: userId, isHidden: false },
      _avg: {
        rating: true,
        communicationRating: true,
        knowledgeRating: true,
        punctualityRating: true,
      },
      _count: { id: true },
    });

    // Count certifications
    const certCount = await this.prisma.teacherCertification.count({
      where: { userId, isActive: true },
    });

    const avgRating = reviewAgg._avg.rating ?? 0;
    const totalReviews = reviewAgg._count.id;

    return this.prisma.teacherStats.upsert({
      where: { userId },
      create: {
        userId,
        averageRating: avgRating as any,
        totalReviews,
        lastCalculatedAt: new Date(),
      },
      update: {
        averageRating: avgRating as any,
        totalReviews,
        lastCalculatedAt: new Date(),
      },
    });
  }

  async updateFromBooking(userId: string, studentId: string) {
    // Increment class/student counters
    const uniqueStudents = await this.prisma.teacherReview.groupBy({
      by: ["studentUserId"],
      where: { teacherUserId: userId },
      _count: { studentUserId: true },
    });

    return this.prisma.teacherStats.update({
      where: { userId },
      data: {
        totalClasses: { increment: 1 },
        totalStudents: uniqueStudents.length,
      },
    });
  }

  async resetMonthlyStats() {
    // Called by a cron job at start of each month
    return this.prisma.teacherStats.updateMany({
      data: {
        profileViewsThisMonth: 0,
        thisMonthEarningsCents: 0,
      },
    });
  }

  async updateEarnings(userId: string, amountCents: number) {
    return this.prisma.teacherStats.update({
      where: { userId },
      data: {
        totalEarningsCents: { increment: amountCents },
        thisMonthEarningsCents: { increment: amountCents },
      },
    });
  }
}

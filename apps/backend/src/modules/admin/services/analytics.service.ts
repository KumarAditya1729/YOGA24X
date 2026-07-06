import { Injectable } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { SettlementStatus, MembershipStatus } from "@prisma/client";

@Injectable()
export class AnalyticsService {
  constructor(private readonly prisma: PrismaService) {}

  async getPlatformMetrics() {
    const totalUsers = await this.prisma.user.count();
    const activeSubscriptions = await this.prisma.membership.count({
      where: { status: MembershipStatus.ACTIVE },
    });
    const totalRevenue = await this.prisma.settlementBatch.aggregate({
      _sum: { totalCents: true },
      where: { status: SettlementStatus.SETTLED },
    });

    return {
      totalUsers,
      activeSubscriptions,
      totalRevenueInPaisa: totalRevenue._sum?.totalCents ?? 0,
    };
  }

  async getDailyActiveUsers(): Promise<number> {
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    return this.prisma.user.count({
      where: { updatedAt: { gte: yesterday }, isDeleted: false },
    });
  }

  async getMonthlyActiveUsers(): Promise<number> {
    const lastMonth = new Date();
    lastMonth.setMonth(lastMonth.getMonth() - 1);
    return this.prisma.user.count({
      where: { updatedAt: { gte: lastMonth }, isDeleted: false },
    });
  }

  async getChurnRate(): Promise<number> {
    const total = await this.prisma.membership.count();
    const cancelled = await this.prisma.membership.count({
      where: { status: MembershipStatus.CANCELLED },
    });
    return total > 0 ? Math.round((cancelled / total) * 100) : 0;
  }

  async getRetentionMetrics() {
    const total = await this.prisma.membership.count();
    const active = await this.prisma.membership.count({
      where: { status: MembershipStatus.ACTIVE },
    });
    const churnRate = await this.getChurnRate();
    return {
      total,
      active,
      retentionRate: total > 0 ? Math.round((active / total) * 100) : 0,
      churnRate,
    };
  }
}

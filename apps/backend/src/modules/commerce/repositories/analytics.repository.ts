import { Injectable } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { PaymentStatus } from "@prisma/client";

@Injectable()
export class AnalyticsRepository {
  constructor(private prisma: PrismaService) {}

  async getRevenueSummary(startDate: Date, endDate: Date) {
    const transactions = await this.prisma.paymentTransaction.findMany({
      where: {
        status: PaymentStatus.SUCCESS,
        createdAt: { gte: startDate, lte: endDate },
      },
    });

    const totalRevenueCents = transactions.reduce(
      (sum, t) => sum + t.amountCents,
      0,
    );
    const transactionCount = transactions.length;

    return { totalRevenueCents, transactionCount, startDate, endDate };
  }

  async getMRR() {
    const now = new Date();
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);

    const monthly = await this.prisma.paymentTransaction.aggregate({
      where: {
        status: PaymentStatus.SUCCESS,
        createdAt: { gte: startOfMonth },
      },
      _sum: { amountCents: true },
    });

    return { mrrCents: monthly._sum?.amountCents ?? 0 };
  }

  async getARR() {
    const { mrrCents } = await this.getMRR();
    return { arrCents: mrrCents * 12 };
  }

  async getActiveSubscriptions() {
    return this.prisma.userSubscription.count({ where: { status: "ACTIVE" } });
  }

  async getActiveMemberships() {
    return this.prisma.membership.count({ where: { status: "ACTIVE" } });
  }

  async getARPU() {
    const now = new Date();
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);

    const [revenue, users] = await Promise.all([
      this.prisma.paymentTransaction.aggregate({
        where: {
          status: PaymentStatus.SUCCESS,
          createdAt: { gte: startOfMonth },
        },
        _sum: { amountCents: true },
      }),
      this.prisma.paymentTransaction.findMany({
        where: {
          status: PaymentStatus.SUCCESS,
          createdAt: { gte: startOfMonth },
        },
        distinct: ["userId"],
        select: { userId: true },
      }),
    ]);

    const totalRevenue = revenue._sum?.amountCents ?? 0;
    const activeUsers = users.length;

    return {
      arpuCents: activeUsers > 0 ? Math.floor(totalRevenue / activeUsers) : 0,
      activeUsers,
    };
  }

  async getTeacherEarnings(teacherId: string, startDate: Date, endDate: Date) {
    return this.prisma.revenueShare.findMany({
      where: {
        recipientId: teacherId,
        shareType: "TEACHER",
        createdAt: { gte: startDate, lte: endDate },
      },
    });
  }

  async getConversionFunnel() {
    const [ordersCreated, ordersCompleted, subscriptions, memberships] =
      await Promise.all([
        this.prisma.paymentTransaction.count(),
        this.prisma.paymentTransaction.count({
          where: { status: PaymentStatus.SUCCESS },
        }),
        this.prisma.userSubscription.count({ where: { status: "ACTIVE" } }),
        this.prisma.membership.count({ where: { status: "ACTIVE" } }),
      ]);

    return {
      ordersCreated,
      ordersCompleted,
      conversionRate:
        ordersCreated > 0
          ? ((ordersCompleted / ordersCreated) * 100).toFixed(2)
          : "0",
      activeSubscriptions: subscriptions,
      activeMemberships: memberships,
    };
  }
}

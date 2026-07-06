import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';
import { CreateSubscriptionDto, CancelSubscriptionDto } from '../dto/commerce.dto';

@Injectable()
export class SubscriptionRepository {
  constructor(private prisma: PrismaService) {}

  async getPlans() {
    return this.prisma.subscriptionPlan.findMany({ where: { isActive: true } });
  }

  async createSubscription(userId: string, dto: CreateSubscriptionDto) {
    const plan = await this.prisma.subscriptionPlan.findUnique({ where: { id: dto.planId } });
    if (!plan) throw new NotFoundException('Subscription plan not found');

    const now = new Date();
    const periodEnd = new Date(now);

    if (plan.billingInterval === 'monthly') periodEnd.setMonth(periodEnd.getMonth() + 1);
    else if (plan.billingInterval === 'yearly') periodEnd.setFullYear(periodEnd.getFullYear() + 1);

    return this.prisma.userSubscription.create({
      data: {
        userId,
        planId: dto.planId,
        razorpaySubscriptionId: `sub_${Date.now()}`,
        status: 'ACTIVE',
        currentPeriodStart: now,
        currentPeriodEnd: periodEnd,
      },
    });
  }

  async getUserSubscription(userId: string) {
    return this.prisma.userSubscription.findFirst({
      where: { userId, status: 'ACTIVE' },
      include: { plan: true },
    });
  }

  async cancelSubscription(userId: string, subscriptionId: string, dto: CancelSubscriptionDto) {
    return this.prisma.userSubscription.update({
      where: { id: subscriptionId },
      data: {
        cancelAtPeriodEnd: dto.cancelAtPeriodEnd ?? true,
        status: dto.cancelAtPeriodEnd ? 'ACTIVE' : 'CANCELLED',
      },
    });
  }

  async renewSubscription(subscriptionId: string) {
    const sub = await this.prisma.userSubscription.findUnique({
      where: { id: subscriptionId },
      include: { plan: true },
    });
    if (!sub) throw new NotFoundException('Subscription not found');

    const newStart = sub.currentPeriodEnd;
    const newEnd = new Date(newStart);

    if (sub.plan.billingInterval === 'monthly') newEnd.setMonth(newEnd.getMonth() + 1);
    else if (sub.plan.billingInterval === 'yearly') newEnd.setFullYear(newEnd.getFullYear() + 1);

    return this.prisma.userSubscription.update({
      where: { id: subscriptionId },
      data: {
        currentPeriodStart: newStart,
        currentPeriodEnd: newEnd,
        status: 'ACTIVE',
      },
    });
  }
}

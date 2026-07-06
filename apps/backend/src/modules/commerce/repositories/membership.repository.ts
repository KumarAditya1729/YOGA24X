import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';
import { CreateMembershipPlanDto, PurchaseMembershipDto, FreezeMembershipDto } from '../dto/commerce.dto';

@Injectable()
export class MembershipRepository {
  constructor(private prisma: PrismaService) {}

  async createPlan(dto: CreateMembershipPlanDto) {
    return this.prisma.membershipPlan.create({
      data: {
        name: dto.name,
        membershipType: dto.membershipType,
        priceCents: dto.priceCents,
        durationDays: dto.durationDays,
        maxFreezeDays: dto.maxFreezeDays ?? 30,
      },
    });
  }

  async listPlans() {
    return this.prisma.membershipPlan.findMany({ where: { isActive: true } });
  }

  async purchaseMembership(userId: string, dto: PurchaseMembershipDto) {
    const plan = await this.prisma.membershipPlan.findUnique({ where: { id: dto.planId } });
    if (!plan) throw new NotFoundException('Membership plan not found');

    const startDate = new Date();
    const endDate = new Date(startDate.getTime() + plan.durationDays * 24 * 60 * 60 * 1000);

    return this.prisma.membership.create({
      data: {
        userId,
        planId: dto.planId,
        status: 'ACTIVE',
        startDate,
        endDate,
        autoRenew: dto.autoRenew ?? true,
      },
    });
  }

  async getActiveMembership(userId: string) {
    return this.prisma.membership.findFirst({
      where: { userId, status: 'ACTIVE' },
      include: { plan: true },
    });
  }

  async freezeMembership(userId: string, membershipId: string, dto: FreezeMembershipDto) {
    const membership = await this.prisma.membership.findUnique({ where: { id: membershipId } });
    if (!membership || membership.userId !== userId) throw new NotFoundException('Membership not found');

    const freezeStart = new Date(dto.freezeStartDate);
    const freezeEnd = new Date(dto.freezeEndDate);
    const freezeDays = Math.ceil((freezeEnd.getTime() - freezeStart.getTime()) / (1000 * 60 * 60 * 24));

    // Extend end date by freeze period
    const newEndDate = new Date(membership.endDate.getTime() + freezeDays * 24 * 60 * 60 * 1000);

    return this.prisma.membership.update({
      where: { id: membershipId },
      data: {
        status: 'FROZEN',
        freezeStartDate: freezeStart,
        freezeEndDate: freezeEnd,
        endDate: newEndDate,
      },
    });
  }

  async cancelMembership(userId: string, membershipId: string) {
    return this.prisma.membership.update({
      where: { id: membershipId },
      data: { status: 'CANCELLED' },
    });
  }
}

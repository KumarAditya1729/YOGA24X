import { Injectable } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { CreateRevenueShareRuleDto } from "../dto/commerce.dto";

@Injectable()
export class RevenueRepository {
  constructor(private prisma: PrismaService) {}

  async createRevenueShare(
    paymentTransactionId: string,
    dto: CreateRevenueShareRuleDto,
    amountCents: number,
  ) {
    return this.prisma.revenueShare.create({
      data: {
        paymentTransactionId,
        recipientId: dto.recipientId,
        shareType: dto.shareType,
        sharePercent: dto.sharePercent,
        amountCents,
      },
    });
  }

  async calculateAndDistributeRevenue(
    paymentTransactionId: string,
    grossAmountCents: number,
  ) {
    // Default platform commission: 20%, teacher: 70%, studio: 10%
    const platformShare = Math.floor(grossAmountCents * 0.2);
    const teacherShare = Math.floor(grossAmountCents * 0.7);
    const studioShare = grossAmountCents - platformShare - teacherShare;

    return { platformShare, teacherShare, studioShare, grossAmountCents };
  }

  async createSettlementBatch(recipientId: string, totalCents: number) {
    return this.prisma.settlementBatch.create({
      data: { recipientId, totalCents, currency: "INR", status: "PENDING" },
    });
  }

  async getRevenueSharesForRecipient(recipientId: string) {
    return this.prisma.revenueShare.findMany({
      where: { recipientId },
      orderBy: { createdAt: "desc" },
    });
  }

  async getPendingSettlements() {
    return this.prisma.settlementBatch.findMany({
      where: { status: "PENDING" },
      include: {
        recipient: {
          select: { id: true, email: true, firstName: true, lastName: true },
        },
      },
    });
  }

  async processSettlement(batchId: string, gatewayRef: string) {
    return this.prisma.settlementBatch.update({
      where: { id: batchId },
      data: { status: "SETTLED", settledAt: new Date(), gatewayRef },
    });
  }
}

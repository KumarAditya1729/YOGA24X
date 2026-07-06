import { Injectable } from "@nestjs/common";
import { RevenueRepository } from "../repositories/revenue.repository";
import { CreateRevenueShareRuleDto } from "../dto/commerce.dto";

@Injectable()
export class RevenueService {
  constructor(private readonly revenueRepo: RevenueRepository) {}

  createRevenueShare(
    paymentTransactionId: string,
    dto: CreateRevenueShareRuleDto,
    amountCents: number,
  ) {
    return this.revenueRepo.createRevenueShare(
      paymentTransactionId,
      dto,
      amountCents,
    );
  }
  distributeRevenue(paymentTransactionId: string, grossAmountCents: number) {
    return this.revenueRepo.calculateAndDistributeRevenue(
      paymentTransactionId,
      grossAmountCents,
    );
  }
  createSettlementBatch(recipientId: string, totalCents: number) {
    return this.revenueRepo.createSettlementBatch(recipientId, totalCents);
  }
  getSharesForRecipient(recipientId: string) {
    return this.revenueRepo.getRevenueSharesForRecipient(recipientId);
  }
  getPendingSettlements() {
    return this.revenueRepo.getPendingSettlements();
  }
  processSettlement(batchId: string, gatewayRef: string) {
    return this.revenueRepo.processSettlement(batchId, gatewayRef);
  }
}

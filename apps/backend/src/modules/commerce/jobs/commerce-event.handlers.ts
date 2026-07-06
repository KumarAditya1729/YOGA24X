import { Injectable, Logger } from "@nestjs/common";
import { OnEvent } from "@nestjs/event-emitter";
import { PrismaService } from "../../prisma/prisma.module";
import { WalletRepository } from "../repositories/wallet.repository";

@Injectable()
export class CommerceEventHandlers {
  private readonly logger = new Logger(CommerceEventHandlers.name);

  constructor(
    private prisma: PrismaService,
    private walletRepo: WalletRepository,
  ) {}

  @OnEvent("payment.completed")
  async handlePaymentCompleted(payload: {
    transactionId: string;
    userId: string;
  }) {
    this.logger.log(
      `Payment completed: ${payload.transactionId} for user ${payload.userId}`,
    );
    try {
      // Auto-generate invoice
      const existing = await this.prisma.invoice.findUnique({
        where: { paymentTransactionId: payload.transactionId },
      });
      if (!existing) {
        const invoiceNumber = `INV-${Date.now()}-${Math.floor(Math.random() * 10000)}`;
        await this.prisma.invoice.create({
          data: { paymentTransactionId: payload.transactionId, invoiceNumber },
        });
        this.logger.log(
          `Auto-created invoice for payment ${payload.transactionId}`,
        );
      }
    } catch (e) {
      this.logger.error(`Failed to auto-create invoice: ${e}`);
    }
  }

  @OnEvent("refund.approved")
  async handleRefundApproved(payload: {
    refundId: string;
    userId: string;
    amountCents: number;
    refundToWallet: boolean;
  }) {
    this.logger.log(
      `Refund approved: ${payload.refundId} for user ${payload.userId}`,
    );
    try {
      if (payload.refundToWallet) {
        await this.walletRepo.creditWallet(payload.userId, {
          amountCents: payload.amountCents,
          description: `Refund credit for refund ${payload.refundId}`,
          referenceId: payload.refundId,
        });
        await this.prisma.refund.update({
          where: { id: payload.refundId },
          data: { status: "COMPLETED" },
        });
        this.logger.log(`Credited wallet for refund ${payload.refundId}`);
      }
    } catch (e) {
      this.logger.error(`Failed to process wallet refund: ${e}`);
    }
  }

  @OnEvent("webhook.razorpay.payment.captured")
  async handleRazorpayPaymentCaptured(payload: any) {
    const paymentEntity = payload?.payload?.payment?.entity;
    if (!paymentEntity) return;
    this.logger.log(`Razorpay payment captured: ${paymentEntity.id}`);
  }

  @OnEvent("webhook.razorpay.subscription.charged")
  async handleSubscriptionCharged(payload: any) {
    const subId = payload?.payload?.subscription?.entity?.id;
    this.logger.log(`Razorpay subscription charged: ${subId}`);
  }
}

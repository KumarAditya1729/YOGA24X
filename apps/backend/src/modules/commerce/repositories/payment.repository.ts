import { Injectable, BadRequestException } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { EventEmitter2 } from "@nestjs/event-emitter";
import * as crypto from "crypto";
import {
  CreateOrderDto,
  VerifyPaymentDto,
  CreateOfflinePaymentDto,
} from "../dto/commerce.dto";
import { PaymentStatus } from "@prisma/client";

@Injectable()
export class PaymentRepository {
  constructor(
    private prisma: PrismaService,
    private eventEmitter: EventEmitter2,
  ) {}

  async createRazorpayOrder(userId: string, dto: CreateOrderDto) {
    // Idempotency check
    if (dto.idempotencyKey) {
      const existing = await this.prisma.idempotencyKey.findUnique({
        where: { key: dto.idempotencyKey },
      });
      if (existing) {
        return existing.responseBody;
      }
    }

    // Record the payment transaction (order created state)
    const transaction = await this.prisma.paymentTransaction.create({
      data: {
        userId,
        razorpayOrderId: `order_${crypto.randomBytes(8).toString("hex")}`,
        amountCents: dto.amountCents,
        currency: dto.currency || "INR",
        status: PaymentStatus.PENDING,
      },
    });

    // Store idempotency key
    if (dto.idempotencyKey) {
      await this.prisma.idempotencyKey.create({
        data: {
          key: dto.idempotencyKey,
          userId,
          responseBody: transaction as any,
          statusCode: 201,
          expiresAt: new Date(Date.now() + 24 * 60 * 60 * 1000),
        },
      });
    }

    return transaction;
  }

  async verifyAndCapturePayment(dto: VerifyPaymentDto) {
    const body = `${dto.razorpayOrderId}|${dto.razorpayPaymentId}`;
    const razorpayKeySecret = process.env.RAZORPAY_KEY_SECRET || "";
    const expectedSignature = crypto
      .createHmac("sha256", razorpayKeySecret)
      .update(body)
      .digest("hex");

    if (expectedSignature !== dto.razorpaySignature) {
      throw new BadRequestException("Invalid payment signature");
    }

    const transaction = await this.prisma.paymentTransaction.update({
      where: { razorpayOrderId: dto.razorpayOrderId },
      data: {
        razorpayPaymentId: dto.razorpayPaymentId,
        razorpaySignature: dto.razorpaySignature,
        status: PaymentStatus.SUCCESS,
      },
    });

    this.eventEmitter.emit("payment.completed", {
      transactionId: transaction.id,
      userId: transaction.userId,
    });
    return transaction;
  }

  async createOfflinePayment(dto: CreateOfflinePaymentDto) {
    return this.prisma.paymentTransaction.create({
      data: {
        userId: dto.userId,
        razorpayOrderId: `offline_${crypto.randomBytes(8).toString("hex")}`,
        amountCents: dto.amountCents,
        currency: "INR",
        status: PaymentStatus.SUCCESS,
        paymentMethod: dto.paymentMethod,
      },
    });
  }

  async handleWebhook(
    gateway: string,
    eventId: string,
    eventType: string,
    payload: any,
    signature?: string,
  ) {
    const existing = await this.prisma.paymentWebhookEvent.findUnique({
      where: { eventId },
    });
    if (existing?.processed) return { alreadyProcessed: true };

    const event = await this.prisma.paymentWebhookEvent.upsert({
      where: { eventId },
      create: { gateway, eventId, eventType, payload, signature },
      update: {},
    });

    this.eventEmitter.emit(`webhook.${gateway}.${eventType}`, payload);

    await this.prisma.paymentWebhookEvent.update({
      where: { id: event.id },
      data: { processed: true, processedAt: new Date() },
    });

    return { processed: true };
  }

  async getPaymentHistory(userId: string) {
    return this.prisma.paymentTransaction.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
      take: 50,
    });
  }
}

import { Injectable } from "@nestjs/common";
import { PaymentRepository } from "../repositories/payment.repository";
import {
  CreateOrderDto,
  VerifyPaymentDto,
  CreateOfflinePaymentDto,
} from "../dto/commerce.dto";

@Injectable()
export class PaymentService {
  constructor(private readonly paymentRepo: PaymentRepository) {}

  createOrder(userId: string, dto: CreateOrderDto) {
    return this.paymentRepo.createRazorpayOrder(userId, dto);
  }
  verifyPayment(dto: VerifyPaymentDto) {
    return this.paymentRepo.verifyAndCapturePayment(dto);
  }
  createOfflinePayment(dto: CreateOfflinePaymentDto) {
    return this.paymentRepo.createOfflinePayment(dto);
  }
  handleWebhook(
    gateway: string,
    eventId: string,
    eventType: string,
    payload: any,
    sig?: string,
  ) {
    return this.paymentRepo.handleWebhook(
      gateway,
      eventId,
      eventType,
      payload,
      sig,
    );
  }
  getHistory(userId: string) {
    return this.paymentRepo.getPaymentHistory(userId);
  }
}

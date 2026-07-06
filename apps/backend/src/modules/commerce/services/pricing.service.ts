import { Injectable } from "@nestjs/common";
import { PricingRepository } from "../repositories/pricing.repository";
import {
  CreateCouponDto,
  ApplyCouponDto,
  PurchaseGiftCardDto,
  RedeemGiftCardDto,
  CreatePricingRuleDto,
} from "../dto/commerce.dto";

@Injectable()
export class PricingService {
  constructor(private readonly pricingRepo: PricingRepository) {}

  createCoupon(dto: CreateCouponDto) {
    return this.pricingRepo.createCoupon(dto);
  }
  listCoupons() {
    return this.pricingRepo.listCoupons();
  }
  validateCoupon(userId: string, dto: ApplyCouponDto) {
    return this.pricingRepo.validateAndApplyCoupon(userId, dto);
  }
  redeemCoupon(
    couponId: string,
    userId: string,
    orderId: string | undefined,
    discountCents: number,
  ) {
    return this.pricingRepo.redeemCoupon(
      couponId,
      userId,
      orderId,
      discountCents,
    );
  }
  purchaseGiftCard(userId: string, dto: PurchaseGiftCardDto) {
    return this.pricingRepo.purchaseGiftCard(userId, dto);
  }
  redeemGiftCard(userId: string, dto: RedeemGiftCardDto) {
    return this.pricingRepo.redeemGiftCard(userId, dto);
  }
  createPricingRule(dto: CreatePricingRuleDto) {
    return this.pricingRepo.createPricingRule(dto);
  }
  getActivePricingRules() {
    return this.pricingRepo.getActivePricingRules();
  }
  calculatePrice(basePriceCents: number, userId?: string, couponCode?: string) {
    return this.pricingRepo.calculateFinalPrice(
      basePriceCents,
      userId,
      couponCode,
    );
  }
}

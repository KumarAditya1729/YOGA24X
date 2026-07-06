import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import {
  CreateCouponDto,
  ApplyCouponDto,
  PurchaseGiftCardDto,
  RedeemGiftCardDto,
  CreatePricingRuleDto,
} from "../dto/commerce.dto";
import * as crypto from "crypto";

@Injectable()
export class PricingRepository {
  constructor(private prisma: PrismaService) {}

  // ── Coupons ────────────────────────────────────────────────────────────────

  async createCoupon(dto: CreateCouponDto) {
    return this.prisma.coupon.create({
      data: {
        code: dto.code.toUpperCase(),
        couponType: dto.couponType,
        discountPercent: dto.discountPercent,
        discountCents: dto.discountCents,
        maxUsageCount: dto.maxUsageCount,
        perUserLimit: dto.perUserLimit ?? 1,
        minOrderCents: dto.minOrderCents,
        maxDiscountCents: dto.maxDiscountCents,
        startsAt: dto.startsAt ? new Date(dto.startsAt) : undefined,
        expiresAt: dto.expiresAt ? new Date(dto.expiresAt) : undefined,
      },
    });
  }

  async validateAndApplyCoupon(userId: string, dto: ApplyCouponDto) {
    const coupon = await this.prisma.coupon.findUnique({
      where: { code: dto.code.toUpperCase() },
    });

    if (!coupon || !coupon.isActive)
      throw new NotFoundException("Coupon not found or inactive");
    if (coupon.expiresAt && coupon.expiresAt < new Date())
      throw new BadRequestException("Coupon has expired");
    if (coupon.maxUsageCount && coupon.usageCount >= coupon.maxUsageCount)
      throw new BadRequestException("Coupon usage limit reached");
    if (coupon.minOrderCents && dto.orderAmountCents < coupon.minOrderCents)
      throw new BadRequestException(
        `Minimum order amount is ${coupon.minOrderCents / 100}`,
      );

    const userRedemptionCount = await this.prisma.couponRedemption.count({
      where: { couponId: coupon.id, userId },
    });
    if (userRedemptionCount >= coupon.perUserLimit)
      throw new BadRequestException("You have already used this coupon");

    let discountCents = 0;
    if (coupon.discountPercent) {
      discountCents = Math.floor(
        (dto.orderAmountCents * coupon.discountPercent) / 100,
      );
      if (coupon.maxDiscountCents)
        discountCents = Math.min(discountCents, coupon.maxDiscountCents);
    } else if (coupon.discountCents) {
      discountCents = coupon.discountCents;
    }

    return {
      coupon,
      discountCents,
      finalAmountCents: dto.orderAmountCents - discountCents,
    };
  }

  async redeemCoupon(
    couponId: string,
    userId: string,
    orderId: string | undefined,
    discountCents: number,
  ) {
    await this.prisma.$transaction([
      this.prisma.couponRedemption.create({
        data: { couponId, userId, orderId, discountCents },
      }),
      this.prisma.coupon.update({
        where: { id: couponId },
        data: { usageCount: { increment: 1 } },
      }),
    ]);
  }

  async listCoupons() {
    return this.prisma.coupon.findMany({ where: { isActive: true } });
  }

  // ── Gift Cards ─────────────────────────────────────────────────────────────

  async purchaseGiftCard(purchasedById: string, dto: PurchaseGiftCardDto) {
    const code = `GC-${crypto.randomBytes(6).toString("hex").toUpperCase()}`;
    return this.prisma.giftCard.create({
      data: {
        code,
        amountCents: dto.amountCents,
        issuedToId: dto.issuedToId,
        purchasedById,
        expiresAt: dto.expiresAt ? new Date(dto.expiresAt) : undefined,
      },
    });
  }

  async redeemGiftCard(userId: string, dto: RedeemGiftCardDto) {
    const card = await this.prisma.giftCard.findUnique({
      where: { code: dto.code.toUpperCase() },
    });
    if (!card) throw new NotFoundException("Gift card not found");
    if (card.status !== "ACTIVE")
      throw new BadRequestException("Gift card is not active");
    if (card.expiresAt && card.expiresAt < new Date())
      throw new BadRequestException("Gift card has expired");

    await this.prisma.$transaction([
      this.prisma.giftCard.update({
        where: { id: card.id },
        data: { status: "REDEEMED" },
      }),
      this.prisma.giftCardRedemption.create({
        data: { giftCardId: card.id, userId, amountCents: card.amountCents },
      }),
    ]);

    return { amountCents: card.amountCents, currency: card.currency };
  }

  // ── Pricing Rules ──────────────────────────────────────────────────────────

  async createPricingRule(dto: CreatePricingRuleDto) {
    return this.prisma.pricingRule.create({
      data: {
        name: dto.name,
        ruleType: dto.ruleType,
        discountPercent: dto.discountPercent,
        discountCents: dto.discountCents,
        priority: dto.priority ?? 0,
        startsAt: dto.startsAt ? new Date(dto.startsAt) : undefined,
        expiresAt: dto.expiresAt ? new Date(dto.expiresAt) : undefined,
      },
    });
  }

  async getActivePricingRules() {
    return this.prisma.pricingRule.findMany({
      where: {
        isActive: true,
        OR: [{ expiresAt: null }, { expiresAt: { gte: new Date() } }],
      },
      orderBy: { priority: "desc" },
    });
  }

  async calculateFinalPrice(
    basePriceCents: number,
    userId?: string,
    couponCode?: string,
  ): Promise<{ finalPriceCents: number; appliedDiscounts: any[] }> {
    const appliedDiscounts: any[] = [];
    let finalPrice = basePriceCents;

    // Apply pricing rules
    const rules = await this.getActivePricingRules();
    for (const rule of rules) {
      if (rule.discountPercent) {
        const discount = Math.floor((finalPrice * rule.discountPercent) / 100);
        finalPrice -= discount;
        appliedDiscounts.push({ type: rule.ruleType, discountCents: discount });
      } else if (rule.discountCents) {
        finalPrice -= rule.discountCents;
        appliedDiscounts.push({
          type: rule.ruleType,
          discountCents: rule.discountCents,
        });
      }
    }

    return { finalPriceCents: Math.max(finalPrice, 0), appliedDiscounts };
  }
}

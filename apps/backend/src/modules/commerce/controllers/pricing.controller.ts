import {
  Controller,
  Get,
  Post,
  Body,
  UseGuards,
  Request,
  Query,
} from "@nestjs/common";
import { ApiTags, ApiOperation, ApiBearerAuth } from "@nestjs/swagger";
import { JwtAuthGuard } from "../../auth/guards/jwt-auth.guard";
import { RequirePermissions } from "../../security/decorators/authorization.decorators";
import { PERMISSIONS } from "../../security/constants/permissions.registry";
import { PricingService } from "../services/pricing.service";
import {
  CreateCouponDto,
  ApplyCouponDto,
  PurchaseGiftCardDto,
  RedeemGiftCardDto,
  CreatePricingRuleDto,
} from "../dto/commerce.dto";

@ApiTags("Pricing & Promotions")
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller("api/v1/pricing")
export class PricingController {
  constructor(private readonly pricingService: PricingService) {}

  // ── Coupons ────────────────────────────────────────────────────────────────

  @Get("coupons")
  @RequirePermissions(PERMISSIONS.COUPON_READ)
  @ApiOperation({ summary: "List active coupons" })
  listCoupons() {
    return this.pricingService.listCoupons();
  }

  @Post("coupons")
  @RequirePermissions(PERMISSIONS.COUPON_MANAGE)
  @ApiOperation({ summary: "Create a coupon (Admin)" })
  createCoupon(@Body() dto: CreateCouponDto) {
    return this.pricingService.createCoupon(dto);
  }

  @Post("coupons/validate")
  @RequirePermissions(PERMISSIONS.COUPON_REDEEM)
  @ApiOperation({ summary: "Validate and apply a coupon to an order" })
  validateCoupon(@Request() req: any, @Body() dto: ApplyCouponDto) {
    return this.pricingService.validateCoupon(req.user.userId, dto);
  }

  // ── Gift Cards ─────────────────────────────────────────────────────────────

  @Post("gift-cards/purchase")
  @RequirePermissions(PERMISSIONS.GIFT_CARD_PURCHASE)
  @ApiOperation({ summary: "Purchase a gift card" })
  purchaseGiftCard(@Request() req: any, @Body() dto: PurchaseGiftCardDto) {
    return this.pricingService.purchaseGiftCard(req.user.userId, dto);
  }

  @Post("gift-cards/redeem")
  @RequirePermissions(PERMISSIONS.GIFT_CARD_READ)
  @ApiOperation({ summary: "Redeem a gift card to wallet" })
  redeemGiftCard(@Request() req: any, @Body() dto: RedeemGiftCardDto) {
    return this.pricingService.redeemGiftCard(req.user.userId, dto);
  }

  // ── Pricing Rules ──────────────────────────────────────────────────────────

  @Get("rules")
  @RequirePermissions(PERMISSIONS.PRICING_READ)
  @ApiOperation({ summary: "Get active pricing rules" })
  getRules() {
    return this.pricingService.getActivePricingRules();
  }

  @Post("rules")
  @RequirePermissions(PERMISSIONS.PRICING_MANAGE)
  @ApiOperation({ summary: "Create a pricing rule (Admin)" })
  createRule(@Body() dto: CreatePricingRuleDto) {
    return this.pricingService.createPricingRule(dto);
  }

  @Post("calculate")
  @RequirePermissions(PERMISSIONS.PRICING_READ)
  @ApiOperation({ summary: "Calculate final price after all discounts" })
  calculatePrice(
    @Request() req: any,
    @Body() body: { basePriceCents: number; couponCode?: string },
  ) {
    return this.pricingService.calculatePrice(
      body.basePriceCents,
      req.user.userId,
      body.couponCode,
    );
  }
}

import {
  IsString,
  IsInt,
  IsOptional,
  IsEnum,
  IsBoolean,
  IsArray,
  IsUUID,
  Min,
  IsDateString,
  IsNumber,
} from "class-validator";
import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import {
  MembershipType,
  CouponType,
  RefundReason,
  RevenueShareType,
  PricingRuleType,
} from "@prisma/client";

// ── Payment ──────────────────────────────────────────────────────────────────

export class CreateOrderDto {
  @ApiProperty()
  @IsInt()
  @Min(1)
  amountCents: number;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  currency?: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  idempotencyKey?: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  couponCode?: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  giftCardCode?: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  notes?: string;
}

export class VerifyPaymentDto {
  @ApiProperty()
  @IsString()
  razorpayOrderId: string;

  @ApiProperty()
  @IsString()
  razorpayPaymentId: string;

  @ApiProperty()
  @IsString()
  razorpaySignature: string;
}

export class CreateOfflinePaymentDto {
  @ApiProperty()
  @IsInt()
  @Min(1)
  amountCents: number;

  @ApiProperty()
  @IsString()
  paymentMethod: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  referenceNumber?: string;

  @ApiProperty()
  @IsUUID()
  userId: string;
}

// ── Wallet ────────────────────────────────────────────────────────────────────

export class WalletCreditDto {
  @ApiProperty()
  @IsInt()
  @Min(1)
  amountCents: number;

  @ApiProperty()
  @IsString()
  description: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  referenceId?: string;
}

export class WalletTransferDto {
  @ApiProperty()
  @IsUUID()
  recipientUserId: string;

  @ApiProperty()
  @IsInt()
  @Min(1)
  amountCents: number;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  description?: string;
}

// ── Membership ────────────────────────────────────────────────────────────────

export class CreateMembershipPlanDto {
  @ApiProperty()
  @IsString()
  name: string;

  @ApiProperty({ enum: MembershipType })
  @IsEnum(MembershipType)
  membershipType: MembershipType;

  @ApiProperty()
  @IsInt()
  @Min(1)
  priceCents: number;

  @ApiProperty()
  @IsInt()
  @Min(1)
  durationDays: number;

  @ApiPropertyOptional()
  @IsInt()
  @IsOptional()
  maxFreezeDays?: number;
}

export class PurchaseMembershipDto {
  @ApiProperty()
  @IsUUID()
  planId: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  couponCode?: string;

  @ApiPropertyOptional()
  @IsBoolean()
  @IsOptional()
  autoRenew?: boolean;
}

export class FreezeMembershipDto {
  @ApiProperty()
  @IsDateString()
  freezeStartDate: string;

  @ApiProperty()
  @IsDateString()
  freezeEndDate: string;
}

// ── Coupon ────────────────────────────────────────────────────────────────────

export class CreateCouponDto {
  @ApiProperty()
  @IsString()
  code: string;

  @ApiProperty({ enum: CouponType })
  @IsEnum(CouponType)
  couponType: CouponType;

  @ApiPropertyOptional()
  @IsInt()
  @IsOptional()
  discountPercent?: number;

  @ApiPropertyOptional()
  @IsInt()
  @IsOptional()
  discountCents?: number;

  @ApiPropertyOptional()
  @IsInt()
  @IsOptional()
  maxUsageCount?: number;

  @ApiPropertyOptional()
  @IsInt()
  @IsOptional()
  perUserLimit?: number;

  @ApiPropertyOptional()
  @IsInt()
  @IsOptional()
  minOrderCents?: number;

  @ApiPropertyOptional()
  @IsInt()
  @IsOptional()
  maxDiscountCents?: number;

  @ApiPropertyOptional()
  @IsDateString()
  @IsOptional()
  startsAt?: string;

  @ApiPropertyOptional()
  @IsDateString()
  @IsOptional()
  expiresAt?: string;
}

export class ApplyCouponDto {
  @ApiProperty()
  @IsString()
  code: string;

  @ApiProperty()
  @IsInt()
  @Min(1)
  orderAmountCents: number;
}

// ── Gift Card ─────────────────────────────────────────────────────────────────

export class PurchaseGiftCardDto {
  @ApiProperty()
  @IsInt()
  @Min(100)
  amountCents: number;

  @ApiPropertyOptional()
  @IsUUID()
  @IsOptional()
  issuedToId?: string;

  @ApiPropertyOptional()
  @IsDateString()
  @IsOptional()
  expiresAt?: string;
}

export class RedeemGiftCardDto {
  @ApiProperty()
  @IsString()
  code: string;
}

// ── Refund ────────────────────────────────────────────────────────────────────

export class RequestRefundDto {
  @ApiProperty()
  @IsUUID()
  paymentTransactionId: string;

  @ApiProperty()
  @IsInt()
  @Min(1)
  amountCents: number;

  @ApiProperty({ enum: RefundReason })
  @IsEnum(RefundReason)
  reason: RefundReason;

  @ApiPropertyOptional()
  @IsBoolean()
  @IsOptional()
  refundToWallet?: boolean;
}

export class ProcessRefundDto {
  @ApiProperty()
  @IsUUID()
  refundId: string;

  @ApiProperty({ enum: ["APPROVED", "REJECTED"] })
  @IsString()
  decision: "APPROVED" | "REJECTED";

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  adminNote?: string;
}

// ── Revenue Share ─────────────────────────────────────────────────────────────

export class CreateRevenueShareRuleDto {
  @ApiProperty()
  @IsUUID()
  recipientId: string;

  @ApiProperty({ enum: RevenueShareType })
  @IsEnum(RevenueShareType)
  shareType: RevenueShareType;

  @ApiProperty()
  @IsNumber()
  sharePercent: number;
}

// ── Pricing Rule ──────────────────────────────────────────────────────────────

export class CreatePricingRuleDto {
  @ApiProperty()
  @IsString()
  name: string;

  @ApiProperty({ enum: PricingRuleType })
  @IsEnum(PricingRuleType)
  ruleType: PricingRuleType;

  @ApiPropertyOptional()
  @IsInt()
  @IsOptional()
  discountPercent?: number;

  @ApiPropertyOptional()
  @IsInt()
  @IsOptional()
  discountCents?: number;

  @ApiPropertyOptional()
  @IsInt()
  @IsOptional()
  priority?: number;

  @ApiPropertyOptional()
  @IsDateString()
  @IsOptional()
  startsAt?: string;

  @ApiPropertyOptional()
  @IsDateString()
  @IsOptional()
  expiresAt?: string;
}

// ── Subscription ──────────────────────────────────────────────────────────────

export class CreateSubscriptionDto {
  @ApiProperty()
  @IsUUID()
  planId: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  couponCode?: string;
}

export class CancelSubscriptionDto {
  @ApiPropertyOptional()
  @IsBoolean()
  @IsOptional()
  cancelAtPeriodEnd?: boolean;
}

import {
  Controller,
  Get,
  Post,
  Body,
  UseGuards,
  Request,
  Headers,
} from "@nestjs/common";
import { ApiTags, ApiOperation, ApiBearerAuth } from "@nestjs/swagger";
import { JwtAuthGuard } from "../../auth/guards/jwt-auth.guard";
import { RequirePermissions } from "../../security/decorators/authorization.decorators";
import { PERMISSIONS } from "../../security/constants/permissions.registry";
import { PaymentService } from "../services/payment.service";
import {
  CreateOrderDto,
  VerifyPaymentDto,
  CreateOfflinePaymentDto,
} from "../dto/commerce.dto";

@ApiTags("Payments")
@ApiBearerAuth()
@Controller("api/v1/payments")
export class PaymentController {
  constructor(private readonly paymentService: PaymentService) {}

  @Post("orders")
  @UseGuards(JwtAuthGuard)
  @RequirePermissions(PERMISSIONS.PAYMENTS_INITIATE)
  @ApiOperation({ summary: "Create a Razorpay payment order" })
  createOrder(@Request() req: any, @Body() dto: CreateOrderDto) {
    return this.paymentService.createOrder(req.user.userId, dto);
  }

  @Post("verify")
  @UseGuards(JwtAuthGuard)
  @RequirePermissions(PERMISSIONS.PAYMENTS_INITIATE)
  @ApiOperation({ summary: "Verify and capture Razorpay payment" })
  verifyPayment(@Body() dto: VerifyPaymentDto) {
    return this.paymentService.verifyPayment(dto);
  }

  @Post("offline")
  @UseGuards(JwtAuthGuard)
  @RequirePermissions(PERMISSIONS.PAYMENT_MANAGE)
  @ApiOperation({ summary: "Record an offline / cash payment" })
  createOfflinePayment(@Body() dto: CreateOfflinePaymentDto) {
    return this.paymentService.createOfflinePayment(dto);
  }

  @Post("webhooks/razorpay")
  @ApiOperation({ summary: "Razorpay webhook receiver" })
  async razorpayWebhook(
    @Body() payload: any,
    @Headers("x-razorpay-signature") signature: string,
  ) {
    const eventId =
      payload?.payload?.payment?.entity?.id ?? `evt_${Date.now()}`;
    return this.paymentService.handleWebhook(
      "razorpay",
      eventId,
      payload?.event ?? "unknown",
      payload,
      signature,
    );
  }

  @Post("webhooks/stripe")
  @ApiOperation({ summary: "Stripe webhook receiver" })
  async stripeWebhook(
    @Body() payload: any,
    @Headers("stripe-signature") signature: string,
  ) {
    return this.paymentService.handleWebhook(
      "stripe",
      payload?.id ?? `evt_${Date.now()}`,
      payload?.type ?? "unknown",
      payload,
      signature,
    );
  }

  @Get("history")
  @UseGuards(JwtAuthGuard)
  @RequirePermissions(PERMISSIONS.PAYMENT_READ)
  @ApiOperation({ summary: "Get payment history for current user" })
  getHistory(@Request() req: any) {
    return this.paymentService.getHistory(req.user.userId);
  }
}

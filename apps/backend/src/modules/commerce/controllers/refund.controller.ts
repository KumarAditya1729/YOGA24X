import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  UseGuards,
  Request,
} from "@nestjs/common";
import { ApiTags, ApiOperation, ApiBearerAuth } from "@nestjs/swagger";
import { JwtAuthGuard } from "../../auth/guards/jwt-auth.guard";
import { RequirePermissions } from "../../security/decorators/authorization.decorators";
import { PERMISSIONS } from "../../security/constants/permissions.registry";
import { RefundService } from "../services/refund.service";
import { RequestRefundDto, ProcessRefundDto } from "../dto/commerce.dto";

@ApiTags("Refunds")
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller("refunds")
export class RefundController {
  constructor(private readonly refundService: RefundService) {}

  @Post("request")
  @RequirePermissions(PERMISSIONS.REFUND_REQUEST)
  @ApiOperation({ summary: "Request a refund for a payment" })
  requestRefund(@Request() req: any, @Body() dto: RequestRefundDto) {
    return this.refundService.requestRefund(req.user.userId, dto);
  }

  @Get("me")
  @RequirePermissions(PERMISSIONS.REFUND_READ)
  @ApiOperation({ summary: "Get refunds for current user" })
  getMyRefunds(@Request() req: any) {
    return this.refundService.getRefundsForUser(req.user.userId);
  }

  @Get("pending")
  @RequirePermissions(PERMISSIONS.REFUND_APPROVE)
  @ApiOperation({ summary: "Get all pending refunds (Admin)" })
  getPending() {
    return this.refundService.getPendingRefunds();
  }

  @Post("process")
  @RequirePermissions(PERMISSIONS.REFUND_APPROVE)
  @ApiOperation({ summary: "Approve or reject a refund (Admin)" })
  processRefund(@Request() req: any, @Body() dto: ProcessRefundDto) {
    return this.refundService.processRefund(req.user.userId, dto);
  }
}

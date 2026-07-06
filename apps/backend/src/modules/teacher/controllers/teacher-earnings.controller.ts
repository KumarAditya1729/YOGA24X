import { Controller, Get, Post, Body, UseGuards } from "@nestjs/common";
import { ApiTags, ApiOperation, ApiBearerAuth } from "@nestjs/swagger";
import { JwtAuthGuard } from "../../auth/guards/jwt-auth.guard";
import { RequirePermissions } from "../../security/decorators/authorization.decorators";
import { CurrentUser } from "../../auth/decorators/auth.decorators";
import { JwtAccessPayload as JwtPayload } from "@yoga24x/shared-types";
import { TeacherEarningsService } from "../services/teacher-earnings.service";
import { TEACHER_PERMISSIONS } from "../constants/teacher-permissions";
import { CreatePayoutRequestDto } from "../dto/teacher-operations.dto";

@ApiTags("Teacher Earnings (Operations)")
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller("teacher/operations/earnings")
export class TeacherEarningsController {
  constructor(private readonly earningsService: TeacherEarningsService) {}

  @Get("balance")
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_EARNINGS_READ)
  @ApiOperation({ summary: "Get wallet balance" })
  async getWalletBalance(@CurrentUser() user: JwtPayload) {
    return this.earningsService.getWalletBalance(user.sub);
  }

  @Get("payouts")
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_EARNINGS_READ)
  @ApiOperation({ summary: "Get payout requests" })
  async getPayouts(@CurrentUser() user: JwtPayload) {
    return this.earningsService.getPayouts(user.sub);
  }

  @Post("payouts")
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_EARNINGS_WRITE)
  @ApiOperation({ summary: "Request a payout" })
  async createPayout(
    @CurrentUser() user: JwtPayload,
    @Body() data: CreatePayoutRequestDto,
  ) {
    return this.earningsService.createPayout(user.sub, data);
  }
}

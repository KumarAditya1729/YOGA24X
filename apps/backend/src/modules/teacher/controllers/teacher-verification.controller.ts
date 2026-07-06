// ==============================================================================
// Yoga24X — Teacher Verification Controller
// REST API: KYC submission, status, admin review
// ==============================================================================
import {
  Controller,
  Get,
  Post,
  Put,
  Body,
  Param,
  Query,
  Req,
  HttpCode,
  HttpStatus,
} from "@nestjs/common";
import { ApiBearerAuth, ApiOperation, ApiTags } from "@nestjs/swagger";
import { TeacherVerificationService } from "../services/teacher-verification.service";
import {
  SubmitVerificationDto,
  ReviewVerificationDto,
} from "../dto/teacher.dto";

@ApiTags("Teachers — Verification")
@ApiBearerAuth()
@Controller("api/v1/teachers")
export class TeacherVerificationController {
  constructor(private readonly verifService: TeacherVerificationService) {}

  // ── Teacher-facing endpoints ─────────────────────────────────────────────────

  @Post("me/verification")
  @HttpCode(HttpStatus.ACCEPTED)
  @ApiOperation({ summary: "Submit KYC verification documents" })
  submitVerification(@Req() req: any, @Body() dto: SubmitVerificationDto) {
    return this.verifService.submitVerification(req.user.userId, dto);
  }

  @Get("me/verification")
  @ApiOperation({ summary: "Get own verification status and history" })
  getVerificationStatus(@Req() req: any) {
    return this.verifService.getVerificationStatus(req.user.userId);
  }

  // ── Admin endpoints ───────────────────────────────────────────────────────────

  @Get("admin/verifications")
  @ApiOperation({ summary: "[Admin] List pending verifications queue" })
  listPendingVerifications(
    @Query("page") page = "1",
    @Query("limit") limit = "20",
  ) {
    return this.verifService.listPending(parseInt(page), parseInt(limit));
  }

  @Put("admin/verifications/:userId/review")
  @ApiOperation({ summary: "[Admin] Approve or reject a verification" })
  reviewVerification(
    @Req() req: any,
    @Param("userId") userId: string,
    @Body() dto: ReviewVerificationDto,
  ) {
    return this.verifService.adminReview(userId, dto, req.user.userId);
  }

  @Put("admin/verifications/:userId/start-review")
  @ApiOperation({ summary: "[Admin] Mark a verification as UNDER_REVIEW" })
  startReview(@Req() req: any, @Param("userId") userId: string) {
    return this.verifService.startManualReview(userId, req.user.userId);
  }

  @Put("admin/verifications/:userId/flag-fraud")
  @ApiOperation({ summary: "[Admin] Flag verification as fraudulent" })
  flagFraud(
    @Param("userId") userId: string,
    @Body() body: { fraudScore: number; reason: string },
  ) {
    return this.verifService.flagFraud(userId, body.fraudScore, body.reason);
  }
}

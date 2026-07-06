// ==============================================================================
// Yoga24X AI Engineering OS — Verification Controller
// Endpoints for user document submissions and admin verification reviews
// ==============================================================================

import {
  Controller,
  Get,
  Post,
  Put,
  Body,
  Param,
  Query,
  Request,
} from "@nestjs/common";
import { VerificationService } from "../services/verification.service";
import {
  SubmitVerificationDto,
  ReviewVerificationDto,
} from "@yoga24x/shared-types";

@Controller("iam/verifications")
export class VerificationController {
  constructor(private readonly verificationService: VerificationService) {}

  @Post("submit")
  async submitVerification(
    @Request() req: any,
    @Body() dto: SubmitVerificationDto,
  ): Promise<any> {
    const userId = req.user?.sub || req.headers["x-user-id"];
    return this.verificationService.submitVerification(userId, dto);
  }

  @Get("me")
  async getMyVerifications(@Request() req: any): Promise<any[]> {
    const userId = req.user?.sub || req.headers["x-user-id"];
    return this.verificationService.getVerificationHistory(userId);
  }

  @Get("admin/queue")
  async getAdminQueue(
    @Query("status") status?: string,
    @Query("type") type?: string,
  ): Promise<any[]> {
    return this.verificationService.getAdminVerificationQueue(status, type);
  }

  @Put("admin/:id/review")
  async reviewVerification(
    @Request() req: any,
    @Param("id") id: string,
    @Body() dto: ReviewVerificationDto,
  ): Promise<any> {
    const reviewerId = req.user?.sub || req.headers["x-user-id"];
    return this.verificationService.reviewVerification(id, reviewerId, dto);
  }
}

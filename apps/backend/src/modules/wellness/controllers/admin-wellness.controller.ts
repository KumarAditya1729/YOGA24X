// ==============================================================================
// Yoga24X AI Engineering OS — Admin Wellness Controller
// REST APIs for Admin Health Viewer, Verification Queue, and Risk Dashboard
// ==============================================================================

import {
  Controller,
  Get,
  Param,
  UseGuards,
  UseInterceptors,
} from "@nestjs/common";
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from "@nestjs/swagger";
import { JwtAuthGuard } from "../../auth/guards/jwt-auth.guard";
import { OrgRoleGuard } from "../../iam/guards/org-role.guard";
import { PiiHealthMaskingInterceptor } from "../interceptors/pii-health-masking.interceptor";
import { AdminWellnessService } from "../services/admin-wellness.service";

@ApiTags("Admin - Wellness & Medical Verification")
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, OrgRoleGuard)
@UseInterceptors(PiiHealthMaskingInterceptor)
@Controller("admin/wellness")
export class AdminWellnessController {
  constructor(private readonly adminWellnessService: AdminWellnessService) {}

  @Get("risk-dashboard")
  @ApiOperation({
    summary: "Get enterprise wellness risk dashboard and critical alerts",
  })
  @ApiResponse({
    status: 200,
    description: "Risk dashboard retrieved successfully.",
  })
  async getRiskDashboard() {
    return this.adminWellnessService.getRiskDashboard();
  }

  @Get("analytics")
  @ApiOperation({
    summary: "Get enterprise wellness assessment analytics and score averages",
  })
  async getAssessmentAnalytics() {
    return this.adminWellnessService.getAssessmentAnalytics();
  }

  @Get("viewer/:userId")
  @ApiOperation({
    summary: "Admin health profile viewer with full medical safety flags",
  })
  async getHealthProfileViewer(@Param("userId") userId: string) {
    return this.adminWellnessService.getHealthProfileViewer(userId);
  }
}

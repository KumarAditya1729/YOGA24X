import {
  Controller,
  Get,
  UseGuards,
  Request,
  Query,
  Param,
} from "@nestjs/common";
import { ApiTags, ApiOperation, ApiBearerAuth } from "@nestjs/swagger";
import { JwtAuthGuard } from "../../auth/guards/jwt-auth.guard";
import { RequirePermissions } from "../../security/decorators/authorization.decorators";
import { PERMISSIONS } from "../../security/constants/permissions.registry";
import { CommerceAnalyticsService } from "../services/commerce-analytics.service";

@ApiTags("Commerce Analytics")
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller("analytics/commerce")
export class CommerceAnalyticsController {
  constructor(private readonly analyticsService: CommerceAnalyticsService) {}

  @Get("mrr")
  @RequirePermissions(PERMISSIONS.COMMERCE_ANALYTICS_READ)
  @ApiOperation({ summary: "Monthly Recurring Revenue" })
  getMRR() {
    return this.analyticsService.getMRR();
  }

  @Get("arr")
  @RequirePermissions(PERMISSIONS.COMMERCE_ANALYTICS_READ)
  @ApiOperation({ summary: "Annual Recurring Revenue" })
  getARR() {
    return this.analyticsService.getARR();
  }

  @Get("arpu")
  @RequirePermissions(PERMISSIONS.COMMERCE_ANALYTICS_READ)
  @ApiOperation({ summary: "Average Revenue Per User" })
  getARPU() {
    return this.analyticsService.getARPU();
  }

  @Get("funnel")
  @RequirePermissions(PERMISSIONS.COMMERCE_ANALYTICS_READ)
  @ApiOperation({ summary: "Conversion funnel analytics" })
  getConversionFunnel() {
    return this.analyticsService.getConversionFunnel();
  }

  @Get("subscriptions/active")
  @RequirePermissions(PERMISSIONS.COMMERCE_ANALYTICS_READ)
  @ApiOperation({ summary: "Count of active subscriptions" })
  getActiveSubscriptions() {
    return this.analyticsService.getActiveSubscriptions();
  }

  @Get("memberships/active")
  @RequirePermissions(PERMISSIONS.COMMERCE_ANALYTICS_READ)
  @ApiOperation({ summary: "Count of active memberships" })
  getActiveMemberships() {
    return this.analyticsService.getActiveMemberships();
  }

  @Get("revenue")
  @RequirePermissions(PERMISSIONS.COMMERCE_ANALYTICS_READ)
  @ApiOperation({ summary: "Revenue summary for date range" })
  getRevenueSummary(
    @Query("startDate") startDate: string,
    @Query("endDate") endDate: string,
  ) {
    const start = startDate
      ? new Date(startDate)
      : new Date(new Date().setDate(1));
    const end = endDate ? new Date(endDate) : new Date();
    return this.analyticsService.getRevenueSummary(start, end);
  }

  @Get("teachers/:teacherId/earnings")
  @RequirePermissions(PERMISSIONS.COMMERCE_ANALYTICS_READ)
  @ApiOperation({ summary: "Get earnings for a specific teacher" })
  getTeacherEarnings(
    @Param("teacherId") teacherId: string,
    @Query("startDate") startDate: string,
    @Query("endDate") endDate: string,
  ) {
    const start = startDate
      ? new Date(startDate)
      : new Date(new Date().setDate(1));
    const end = endDate ? new Date(endDate) : new Date();
    return this.analyticsService.getTeacherEarnings(teacherId, start, end);
  }
}

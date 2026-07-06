import { Controller, Get, UseGuards } from "@nestjs/common";
import { ApiTags, ApiOperation, ApiBearerAuth } from "@nestjs/swagger";
import { AuthorizationGuard } from "../../security/guards/authorization.guard";
import { RequirePermissions } from "../../security/decorators/authorization.decorators";
import { PERMISSIONS } from "../../security/constants/permissions.registry";
import { AnalyticsService } from "../services/analytics.service";

@ApiTags("Admin - Analytics")
@ApiBearerAuth()
@Controller("admin/analytics")
@UseGuards(AuthorizationGuard)
export class AnalyticsController {
  constructor(private readonly analyticsService: AnalyticsService) {}

  @Get("dau")
  @ApiOperation({ summary: "Daily Active Users" })
  @RequirePermissions(PERMISSIONS.ANALYTICS_READ)
  async dau() {
    const count = await this.analyticsService.getDailyActiveUsers();
    return { dau: count };
  }

  @Get("mau")
  @ApiOperation({ summary: "Monthly Active Users" })
  @RequirePermissions(PERMISSIONS.ANALYTICS_READ)
  async mau() {
    const count = await this.analyticsService.getMonthlyActiveUsers();
    return { mau: count };
  }

  @Get("churn")
  @ApiOperation({ summary: "Churn rate percentage" })
  @RequirePermissions(PERMISSIONS.ANALYTICS_READ)
  async churnRate() {
    const rate = await this.analyticsService.getChurnRate();
    return { churnRatePercent: rate };
  }

  @Get("overview")
  @ApiOperation({ summary: "Full analytics overview" })
  @RequirePermissions(PERMISSIONS.ANALYTICS_READ)
  async overview() {
    const [dau, mau, retention] = await Promise.all([
      this.analyticsService.getDailyActiveUsers(),
      this.analyticsService.getMonthlyActiveUsers(),
      this.analyticsService.getRetentionMetrics(),
    ]);
    return { dau, mau, ...retention };
  }
}

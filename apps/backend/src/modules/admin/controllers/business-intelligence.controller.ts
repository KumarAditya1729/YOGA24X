import { Controller, Get, UseGuards } from "@nestjs/common";
import { ApiTags, ApiOperation, ApiBearerAuth } from "@nestjs/swagger";
import { AuthorizationGuard } from "../../security/guards/authorization.guard";
import { RequirePermissions } from "../../security/decorators/authorization.decorators";
import { PERMISSIONS } from "../../security/constants/permissions.registry";
import { AnalyticsService } from "../services/analytics.service";
import { AiInsightsService } from "../services/ai-insights.service";

@ApiTags("Admin - Business Intelligence")
@ApiBearerAuth()
@Controller("admin/bi")
@UseGuards(AuthorizationGuard)
export class BusinessIntelligenceController {
  constructor(
    private readonly analyticsService: AnalyticsService,
    private readonly aiInsightsService: AiInsightsService,
  ) {}

  @Get("executive-summary")
  @ApiOperation({ summary: "Executive dashboard - platform KPIs" })
  @RequirePermissions(PERMISSIONS.ANALYTICS_READ)
  async executiveSummary() {
    return this.analyticsService.getPlatformMetrics();
  }

  @Get("retention")
  @ApiOperation({ summary: "Retention and churn metrics" })
  @RequirePermissions(PERMISSIONS.ANALYTICS_READ)
  async retentionDashboard() {
    return this.analyticsService.getRetentionMetrics();
  }

  @Get("ai-churn-prediction")
  @ApiOperation({ summary: "AI-powered churn prediction (Sovereign AI)" })
  @RequirePermissions(PERMISSIONS.ANALYTICS_READ)
  async aiChurnPrediction() {
    return this.aiInsightsService.generateChurnPrediction("global");
  }
}

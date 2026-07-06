import { Module } from "@nestjs/common";
import { PrismaModule } from "../prisma/prisma.module";
import { PrismaService } from "../prisma/prisma.module";
import { SecurityModule } from "../security/security.module";
import { AiModule } from "../ai/ai.module";

import { SuperAdminController } from "./controllers/super-admin.controller";
import { OrgAdminController } from "./controllers/org-admin.controller";
import { UserManagementController } from "./controllers/user-management.controller";
import { CmsController } from "./controllers/cms.controller";
import { CrmController } from "./controllers/crm.controller";
import { SupportController } from "./controllers/support.controller";
import { BusinessIntelligenceController } from "./controllers/business-intelligence.controller";
import { AnalyticsController } from "./controllers/analytics.controller";
import { NotificationController } from "./controllers/notification.controller";

import { SuperAdminService } from "./services/super-admin.service";
import { CmsService } from "./services/cms.service";
import { CrmService } from "./services/crm.service";
import { SupportService } from "./services/support.service";
import { AnalyticsService } from "./services/analytics.service";
import { AiInsightsService } from "./services/ai-insights.service";

@Module({
  imports: [PrismaModule, SecurityModule, AiModule],
  controllers: [
    SuperAdminController,
    OrgAdminController,
    UserManagementController,
    CmsController,
    CrmController,
    SupportController,
    BusinessIntelligenceController,
    AnalyticsController,
    NotificationController,
  ],
  providers: [
    SuperAdminService,
    CmsService,
    CrmService,
    SupportService,
    AnalyticsService,
    AiInsightsService,
    PrismaService,
  ],
  exports: [SuperAdminService, AnalyticsService],
})
export class AdminModule {}

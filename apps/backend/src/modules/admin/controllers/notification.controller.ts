import {
  Controller,
  Get,
  Post,
  Patch,
  Body,
  Param,
  UseGuards,
} from "@nestjs/common";
import { ApiTags, ApiOperation, ApiBearerAuth } from "@nestjs/swagger";
import { AuthorizationGuard } from "../../security/guards/authorization.guard";
import { RequirePermissions } from "../../security/decorators/authorization.decorators";
import { PERMISSIONS } from "../../security/constants/permissions.registry";
import { PrismaService } from "../../prisma/prisma.module";
import { CampaignStatus } from "@prisma/client";

@ApiTags("Admin - Notifications")
@ApiBearerAuth()
@Controller("admin/notifications")
@UseGuards(AuthorizationGuard)
export class NotificationController {
  constructor(private readonly prisma: PrismaService) {}

  @Get("campaigns")
  @ApiOperation({ summary: "List all notification campaigns" })
  @RequirePermissions(PERMISSIONS.ADMIN_SUPER)
  async getCampaigns() {
    return this.prisma.notificationCampaign.findMany({
      orderBy: { createdAt: "desc" },
    });
  }

  @Post("campaigns")
  @ApiOperation({ summary: "Create a notification campaign" })
  @RequirePermissions(PERMISSIONS.ADMIN_SUPER)
  async createCampaign(
    @Body()
    body: {
      title: string;
      message: string;
      targetSegment: string;
      scheduledAt?: string;
    },
  ) {
    return this.prisma.notificationCampaign.create({
      data: {
        title: body.title,
        message: body.message,
        targetSegment: body.targetSegment,
        status: CampaignStatus.DRAFT,
        scheduledAt: body.scheduledAt ? new Date(body.scheduledAt) : undefined,
      },
    });
  }

  @Patch("campaigns/:id/launch")
  @ApiOperation({ summary: "Launch a campaign" })
  @RequirePermissions(PERMISSIONS.ADMIN_SUPER)
  async launchCampaign(@Param("id") id: string) {
    return this.prisma.notificationCampaign.update({
      where: { id },
      data: { status: CampaignStatus.RUNNING },
    });
  }
}

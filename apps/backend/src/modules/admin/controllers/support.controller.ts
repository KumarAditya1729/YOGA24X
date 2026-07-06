import {
  Controller,
  Get,
  Post,
  Patch,
  Body,
  Param,
  Query,
  UseGuards,
} from "@nestjs/common";
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiQuery,
} from "@nestjs/swagger";
import { AuthorizationGuard } from "../../security/guards/authorization.guard";
import { RequirePermissions } from "../../security/decorators/authorization.decorators";
import { PERMISSIONS } from "../../security/constants/permissions.registry";
import { SupportService } from "../services/support.service";
import { TicketPriority, TicketStatus } from "@prisma/client";
import { PrismaService } from "../../prisma/prisma.module";

@ApiTags("Admin - Support")
@ApiBearerAuth()
@Controller("admin/support")
@UseGuards(AuthorizationGuard)
export class SupportController {
  constructor(
    private readonly supportService: SupportService,
    private readonly prisma: PrismaService,
  ) {}

  @Get("tickets")
  @ApiOperation({ summary: "Get all support tickets" })
  @ApiQuery({ name: "status", required: false, enum: TicketStatus })
  @ApiQuery({ name: "priority", required: false, enum: TicketPriority })
  @RequirePermissions(PERMISSIONS.SUPPORT_MANAGE)
  async getTickets(
    @Query("status") status?: TicketStatus,
    @Query("priority") priority?: TicketPriority,
  ) {
    return this.prisma.supportTicket.findMany({
      where: {
        ...(status ? { status } : {}),
        ...(priority ? { priority } : {}),
      },
      include: {
        user: {
          select: { id: true, email: true, firstName: true, lastName: true },
        },
        agent: { select: { id: true, email: true, firstName: true } },
        comments: { orderBy: { createdAt: "asc" } },
      },
      orderBy: { createdAt: "desc" },
    });
  }

  @Post("tickets")
  @ApiOperation({ summary: "Create a support ticket" })
  @RequirePermissions(PERMISSIONS.SUPPORT_MANAGE)
  async createTicket(
    @Body()
    body: {
      userId: string;
      subject: string;
      description: string;
      priority: TicketPriority;
    },
  ) {
    return this.supportService.createTicket(
      body.userId,
      body.subject,
      body.description,
      body.priority,
    );
  }

  @Patch("tickets/:id/assign")
  @ApiOperation({ summary: "Assign ticket to agent" })
  @RequirePermissions(PERMISSIONS.SUPPORT_MANAGE)
  async assignTicket(
    @Param("id") id: string,
    @Body() body: { agentId: string },
  ) {
    return this.supportService.assignTicket(id, body.agentId);
  }

  @Post("tickets/:id/comments")
  @ApiOperation({ summary: "Add a comment to a ticket" })
  @RequirePermissions(PERMISSIONS.SUPPORT_MANAGE)
  async addComment(
    @Param("id") id: string,
    @Body() body: { userId: string; content: string; isInternal?: boolean },
  ) {
    return this.supportService.addComment(
      id,
      body.userId,
      body.content,
      body.isInternal,
    );
  }

  @Patch("tickets/:id/status")
  @ApiOperation({ summary: "Update ticket status" })
  @RequirePermissions(PERMISSIONS.SUPPORT_MANAGE)
  async updateStatus(
    @Param("id") id: string,
    @Body() body: { status: TicketStatus },
  ) {
    return this.prisma.supportTicket.update({
      where: { id },
      data: { status: body.status },
    });
  }
}

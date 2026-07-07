// ==============================================================================
// Yoga24X AI Engineering OS — Scheduling Controller (Prompt 7)
// ==============================================================================

import {
  Controller,
  Get,
  Post,
  Param,
  Query,
  UseGuards,
  Body,
  Res,
  HttpStatus,
} from "@nestjs/common";
import { Response } from "express";
import { JwtAuthGuard } from "../../auth/guards/jwt-auth.guard";
import { RequirePermissions } from "../../security/decorators/authorization.decorators";
import { CurrentUser } from "../../auth/decorators/auth.decorators";
import { JwtAccessPayload as JwtPayload } from "@yoga24x/shared-types";
import { SchedulingService } from "../services/scheduling.service";
import { SCHEDULE_PERMISSIONS } from "../constants/booking-permissions";

@Controller("schedule")
@UseGuards(JwtAuthGuard)
export class SchedulingController {
  constructor(private readonly schedulingService: SchedulingService) {}

  @Get("teacher/:teacherUserId/slots")
  @RequirePermissions(SCHEDULE_PERMISSIONS.READ)
  async getAvailableSlots(
    @Param("teacherUserId") teacherUserId: string,
    @Query("from") from: string,
    @Query("to") to: string,
  ) {
    return this.schedulingService.getAvailableSlots(
      teacherUserId,
      new Date(from),
      new Date(to),
    );
  }

  @Get("teacher")
  @RequirePermissions(SCHEDULE_PERMISSIONS.READ)
  async getTeacherSchedule(
    @CurrentUser() user: JwtPayload,
    @Query("from") from: string,
    @Query("to") to: string,
  ) {
    return this.schedulingService.getTeacherSchedule(user.sub, from, to);
  }

  @Get("student/calendar")
  @RequirePermissions(SCHEDULE_PERMISSIONS.READ)
  async getStudentCalendar(
    @CurrentUser() user: JwtPayload,
    @Query("from") from: string,
    @Query("to") to: string,
  ) {
    return this.schedulingService.getStudentCalendar(user.sub, from, to);
  }

  @Post("conflict-check")
  @RequirePermissions(SCHEDULE_PERMISSIONS.WRITE)
  async checkConflicts(
    @CurrentUser() user: JwtPayload,
    @Body()
    body: { startTime: string; endTime: string; excludeSessionId?: string },
  ) {
    return this.schedulingService.checkConflicts(
      user.sub,
      new Date(body.startTime),
      new Date(body.endTime),
      body.excludeSessionId,
    );
  }

  @Get("session/:sessionId/ics")
  async exportIcs(@Param("sessionId") sessionId: string, @Res() res: Response) {
    // In production, fetch session from DB; using stub here for ICS export shape
    const icsContent = this.schedulingService.generateIcsContent({
      id: sessionId,
      title: "Yoga Session",
      startTime: new Date(),
      endTime: new Date(Date.now() + 3600000),
    });
    res.setHeader("Content-Type", "text/calendar");
    res.setHeader(
      "Content-Disposition",
      `attachment; filename=session-${sessionId}.ics`,
    );
    res.status(HttpStatus.OK).send(icsContent);
  }

  @Get("ai/optimize")
  @RequirePermissions(SCHEDULE_PERMISSIONS.WRITE)
  async getAIOptimized(
    @CurrentUser() user: JwtPayload,
    @Query() preferences: Record<string, unknown>,
  ) {
    return this.schedulingService.getAIOptimizedSchedule(user.sub, preferences);
  }
}

// ==============================================================================
// Yoga24X AI Engineering OS — Attendance Controller (Prompt 7)
// ==============================================================================

import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  UseGuards,
  Req,
  HttpCode,
  HttpStatus,
} from "@nestjs/common";
import { Request } from "express";
import { JwtAuthGuard } from "../../auth/guards/jwt-auth.guard";
import { RequirePermissions } from "../../security/decorators/authorization.decorators";
import { CurrentUser } from "../../auth/decorators/auth.decorators";
import { JwtAccessPayload as JwtPayload } from "@yoga24x/shared-types";
import { AttendanceService } from "../services/attendance.service";
import { ATTENDANCE_PERMISSIONS } from "../constants/booking-permissions";
import { CheckInDto } from "../dto/booking.dto";

@Controller("attendance")
@UseGuards(JwtAuthGuard)
export class AttendanceController {
  constructor(private readonly attendanceService: AttendanceService) {}

  @Post("check-in")
  @HttpCode(HttpStatus.OK)
  @RequirePermissions(ATTENDANCE_PERMISSIONS.WRITE)
  async checkIn(
    @CurrentUser() user: JwtPayload,
    @Body() dto: CheckInDto,
    @Req() req: Request,
  ) {
    const ip = req.ip ?? "0.0.0.0";
    return this.attendanceService.checkIn(user.sub, dto, ip);
  }

  @Post("check-in-token/:bookingId")
  @RequirePermissions(ATTENDANCE_PERMISSIONS.READ)
  async getCheckInToken(@Param("bookingId") bookingId: string) {
    return this.attendanceService.generateCheckInToken(bookingId);
  }

  @Post("manual/:bookingId")
  @RequirePermissions(ATTENDANCE_PERMISSIONS.WRITE)
  async markManual(
    @Param("bookingId") bookingId: string,
    @CurrentUser() user: JwtPayload,
  ) {
    return this.attendanceService.markManual(bookingId, user.sub);
  }

  @Post("complete/:bookingId")
  @RequirePermissions(ATTENDANCE_PERMISSIONS.WRITE)
  async completeSession(@Param("bookingId") bookingId: string) {
    return this.attendanceService.completeSession(bookingId);
  }

  @Get("session/:sessionId")
  @RequirePermissions(ATTENDANCE_PERMISSIONS.READ)
  async getSessionAttendance(@Param("sessionId") sessionId: string) {
    return this.attendanceService.getSessionAttendance(sessionId);
  }
}

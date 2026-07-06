// ==============================================================================
// Yoga24X AI Engineering OS — Attendance Service (Prompt 7)
// ==============================================================================

import { Injectable } from "@nestjs/common";
import { AttendanceRepository } from "../repositories/attendance.repository";
import { EventEmitter2 } from "@nestjs/event-emitter";
import { CheckInDto } from "../dto/booking.dto";

@Injectable()
export class AttendanceService {
  constructor(
    private readonly attendanceRepo: AttendanceRepository,
    private readonly events: EventEmitter2,
  ) {}

  async checkIn(userId: string, dto: CheckInDto, requestIp: string) {
    const attendance = await this.attendanceRepo.checkIn(
      userId,
      dto,
      requestIp,
    );
    this.events.emit("attendance.checked_in", {
      bookingId: dto.bookingId,
      userId,
      method: dto.method,
    });
    return attendance;
  }

  async markManual(bookingId: string, markedByUserId: string) {
    return this.attendanceRepo.markManualAttendance(bookingId, markedByUserId);
  }

  async completeSession(bookingId: string) {
    const result = await this.attendanceRepo.markSessionComplete(bookingId);
    this.events.emit("session.completed", { bookingId });
    return result;
  }

  async getSessionAttendance(sessionId: string) {
    return this.attendanceRepo.getAttendanceForSession(sessionId);
  }

  generateCheckInToken(bookingId: string) {
    return { token: this.attendanceRepo.generateCheckInToken(bookingId) };
  }
}

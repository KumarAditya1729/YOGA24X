// ==============================================================================
// Yoga24X AI Engineering OS — Scheduling Service (Prompt 7)
// ==============================================================================

import { Injectable, Logger, ConflictException } from "@nestjs/common";
import { SchedulingRepository } from "../repositories/scheduling.repository";

@Injectable()
export class SchedulingService {
  private readonly logger = new Logger(SchedulingService.name);

  constructor(private readonly schedulingRepo: SchedulingRepository) {}

  async checkConflicts(
    teacherUserId: string,
    startTime: Date,
    endTime: Date,
    excludeSessionId?: string,
  ) {
    const conflicts = await this.schedulingRepo.detectConflicts(
      teacherUserId,
      startTime,
      endTime,
      excludeSessionId,
    );
    if (conflicts.length > 0) {
      throw new ConflictException(
        `Scheduling conflict detected with ${conflicts.length} existing session(s).`,
      );
    }
    return { hasConflict: false };
  }

  async getAvailableSlots(teacherUserId: string, fromDate: Date, toDate: Date) {
    const sessions = await this.schedulingRepo.getAvailableSlots(
      teacherUserId,
      fromDate,
      toDate,
    );
    return sessions.map((s) => ({
      sessionId: s.id,
      title: s.title,
      startTime: s.startTime,
      endTime: s.endTime,
      maxParticipants: s.maxParticipants,
      availableSpots: s.maxParticipants - s.bookings.length,
      sessionType: s.sessionType,
    }));
  }

  async getTeacherSchedule(teacherUserId: string, from: string, to: string) {
    return this.schedulingRepo.getTeacherSchedule(
      teacherUserId,
      new Date(from),
      new Date(to),
    );
  }

  async getStudentCalendar(studentUserId: string, from: string, to: string) {
    return this.schedulingRepo.getStudentCalendar(
      studentUserId,
      new Date(from),
      new Date(to),
    );
  }

  /** AI Hook: Schedule Optimization (stub for future AI integration) */
  async getAIOptimizedSchedule(
    teacherUserId: string,
    preferences: Record<string, unknown>,
  ) {
    this.logger.log(
      `[AI Hook] Schedule optimization requested for teacher ${teacherUserId}`,
    );
    // TODO: Integrate with AI scheduling engine in Prompt 10
    return {
      suggestions: [],
      message: "AI schedule optimization not yet active.",
    };
  }

  /** AI Hook: Demand Forecasting (stub) */
  async getDemandForecast(teacherUserId: string, daysAhead: number) {
    this.logger.log(
      `[AI Hook] Demand forecast for teacher ${teacherUserId}, ${daysAhead} days`,
    );
    return { forecast: [], message: "AI demand forecast not yet active." };
  }

  /** Generate ICS export string for a session */
  generateIcsContent(session: {
    id: string;
    title: string;
    startTime: Date;
    endTime: Date;
    meetingUrl?: string | null;
  }): string {
    const formatDate = (d: Date) =>
      d.toISOString().replace(/[-:]/g, "").split(".")[0] + "Z";

    return [
      "BEGIN:VCALENDAR",
      "VERSION:2.0",
      "PRODID:-//Yoga24X//EN",
      "BEGIN:VEVENT",
      `UID:${session.id}@yoga24x`,
      `DTSTAMP:${formatDate(new Date())}`,
      `DTSTART:${formatDate(session.startTime)}`,
      `DTEND:${formatDate(session.endTime)}`,
      `SUMMARY:${session.title}`,
      session.meetingUrl ? `URL:${session.meetingUrl}` : "",
      "END:VEVENT",
      "END:VCALENDAR",
    ]
      .filter(Boolean)
      .join("\r\n");
  }
}

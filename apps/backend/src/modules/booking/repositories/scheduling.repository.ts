// ==============================================================================
// Yoga24X AI Engineering OS — Scheduling Repository (Prompt 7)
// ==============================================================================

import { Injectable, ConflictException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';

@Injectable()
export class SchedulingRepository {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Detect conflicts for a teacher within a given time window.
   * Returns any overlapping sessions for conflict reporting.
   */
  async detectConflicts(
    teacherUserId: string,
    startTime: Date,
    endTime: Date,
    excludeSessionId?: string,
  ) {
    return this.prisma.teacherSession.findMany({
      where: {
        teacherUserId,
        id: { not: excludeSessionId ?? '' },
        status: { notIn: ['CANCELLED', 'COMPLETED'] },
        AND: [
          { startTime: { lt: endTime } },
          { endTime: { gt: startTime } },
        ],
      },
    });
  }

  /**
   * Generate time slots from a teacher's availability windows,
   * filtered by capacity and existing bookings.
   */
  async getAvailableSlots(
    teacherUserId: string,
    fromDate: Date,
    toDate: Date,
  ) {
    return this.prisma.teacherSession.findMany({
      where: {
        teacherUserId,
        startTime: { gte: fromDate },
        endTime: { lte: toDate },
        status: { in: ['SCHEDULED'] },
      },
      include: {
        sessionType: true,
        bookings: { where: { status: { in: ['CONFIRMED', 'CHECKED_IN', 'STARTED'] } } },
      },
      orderBy: { startTime: 'asc' },
    });
  }

  /**
   * Get a teacher's upcoming schedule with all relevant bookings.
   */
  async getTeacherSchedule(teacherUserId: string, fromDate: Date, toDate: Date) {
    const sessions = await this.prisma.teacherSession.findMany({
      where: {
        teacherUserId,
        startTime: { gte: fromDate, lte: toDate },
      },
      include: {
        sessionType: true,
        bookings: {
          include: {
            student: { select: { id: true, firstName: true, lastName: true } },
            attendance: true,
          },
        },
      },
      orderBy: { startTime: 'asc' },
    });

    const events = await this.prisma.learningEvent.findMany({
      where: {
        instructorId: teacherUserId,
        scheduledStartAt: { gte: fromDate, lte: toDate },
      },
      include: { registrations: true },
      orderBy: { scheduledStartAt: 'asc' },
    });

    return { sessions, events };
  }

  /**
   * Get a student's unified calendar (bookings + enrollments).
   */
  async getStudentCalendar(studentUserId: string, fromDate: Date, toDate: Date) {
    const bookings = await this.prisma.teacherBooking.findMany({
      where: {
        studentUserId,
        status: { in: ['CONFIRMED', 'RESCHEDULED', 'CHECKED_IN', 'STARTED'] },
        session: { startTime: { gte: fromDate, lte: toDate } },
      },
      include: {
        session: { include: { teacher: { include: { user: { select: { firstName: true, lastName: true } } } }, sessionType: true } },
        attendance: true,
      },
      orderBy: { session: { startTime: 'asc' } },
    });

    const enrollments = await this.prisma.eventRegistration.findMany({
      where: {
        studentUserId,
        event: {
          scheduledStartAt: { gte: fromDate, lte: toDate },
        },
      },
      include: { event: true },
      orderBy: { event: { scheduledStartAt: 'asc' } },
    });

    return { bookings, enrollments };
  }
}

// ==============================================================================
// Yoga24X AI Engineering OS — Booking Repository (Prompt 7)
// ==============================================================================

import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';
import { BookingStatus, Prisma } from '@prisma/client';
import { CreateBookingDto, RescheduleBookingDto, CancelBookingDto, BookingQueryDto } from '../dto/booking.dto';

@Injectable()
export class BookingRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findById(id: string) {
    const booking = await this.prisma.teacherBooking.findUnique({
      where: { id },
      include: {
        session: { include: { sessionType: true, teacher: true } },
        student: { select: { id: true, email: true, firstName: true, lastName: true } },
        attendance: true,
        waitlistEntry: true,
      },
    });
    if (!booking) throw new NotFoundException(`Booking ${id} not found`);
    return booking;
  }

  async findForStudent(studentUserId: string, query: BookingQueryDto) {
    const where: Prisma.TeacherBookingWhereInput = {
      studentUserId,
      ...(query.status && { status: query.status }),
      ...(query.fromDate && { session: { startTime: { gte: new Date(query.fromDate) } } }),
      ...(query.toDate && { session: { startTime: { lte: new Date(query.toDate) } } }),
    };
    return this.prisma.teacherBooking.findMany({
      where,
      include: { session: { include: { teacher: true, sessionType: true } }, attendance: true },
      orderBy: { bookedAt: 'desc' },
      take: query.limit ?? 20,
      skip: query.offset ?? 0,
    });
  }

  async findForTeacher(teacherUserId: string, query: BookingQueryDto) {
    return this.prisma.teacherBooking.findMany({
      where: {
        session: { teacherUserId },
        ...(query.status && { status: query.status }),
      },
      include: { student: { select: { id: true, firstName: true, lastName: true, email: true } }, session: true, attendance: true },
      orderBy: { bookedAt: 'desc' },
      take: query.limit ?? 50,
      skip: query.offset ?? 0,
    });
  }

  async createBooking(studentUserId: string, dto: CreateBookingDto, tenantId: string) {
    // Conflict detection: check for existing confirmed booking at same time
    const session = await this.prisma.teacherSession.findUnique({
      where: { id: dto.sessionId },
      include: { bookings: { where: { status: { in: ['CONFIRMED', 'CHECKED_IN', 'STARTED'] } } } },
    });
    if (!session) throw new NotFoundException(`Session ${dto.sessionId} not found`);

    if (session.currentBookings >= session.maxParticipants) {
      throw new ConflictException('Session is fully booked. You may join the waitlist.');
    }

    // Check student double-booking
    const existingBooking = await this.prisma.teacherBooking.findFirst({
      where: {
        studentUserId,
        sessionId: dto.sessionId,
        status: { in: ['CONFIRMED', 'PENDING', 'CHECKED_IN'] },
      },
    });
    if (existingBooking) throw new ConflictException('You already have a booking for this session.');

    return this.prisma.$transaction(async (tx) => {
      const booking = await tx.teacherBooking.create({
        data: {
          sessionId: dto.sessionId,
          studentUserId,
          status: 'CONFIRMED',
          bookingNotes: dto.bookingNotes,
          expiresAt: new Date(Date.now() + 15 * 60 * 1000), // 15min hold
        },
      });
      await tx.teacherSession.update({
        where: { id: dto.sessionId },
        data: { currentBookings: { increment: 1 } },
      });
      return booking;
    });
  }

  async rescheduleBooking(userId: string, dto: RescheduleBookingDto) {
    const booking = await this.findById(dto.bookingId);
    if (booking.studentUserId !== userId) throw new ConflictException('Not your booking.');
    if (!['CONFIRMED', 'PENDING'].includes(booking.status)) {
      throw new ConflictException(`Cannot reschedule a booking with status ${booking.status}`);
    }

    return this.prisma.$transaction(async (tx) => {
      // Decrement old session
      await tx.teacherSession.update({
        where: { id: booking.sessionId },
        data: { currentBookings: { decrement: 1 } },
      });

      // Create new booking for new session
      const newBooking = await tx.teacherBooking.create({
        data: {
          sessionId: dto.newSessionId,
          studentUserId: userId,
          status: 'CONFIRMED',
          rescheduledFromId: dto.bookingId,
          bookingNotes: dto.reason,
        },
      });

      // Mark old as rescheduled
      await tx.teacherBooking.update({
        where: { id: dto.bookingId },
        data: { status: 'RESCHEDULED' },
      });

      // Increment new session
      await tx.teacherSession.update({
        where: { id: dto.newSessionId },
        data: { currentBookings: { increment: 1 } },
      });

      return newBooking;
    });
  }

  async cancelBooking(userId: string, dto: CancelBookingDto, role: string) {
    const booking = await this.findById(dto.bookingId);
    const isOwner = booking.studentUserId === userId;
    const isTeacher = booking.session.teacherUserId === userId;
    const isAdmin = role === 'SUPER_ADMIN' || role === 'PLATFORM_ADMIN';

    if (!isOwner && !isTeacher && !isAdmin) throw new ConflictException('Not authorized to cancel this booking.');
    if (['CANCELLED', 'COMPLETED', 'REFUNDED'].includes(booking.status)) {
      throw new ConflictException(`Cannot cancel a booking with status ${booking.status}`);
    }

    return this.prisma.$transaction(async (tx) => {
      const cancelled = await tx.teacherBooking.update({
        where: { id: dto.bookingId },
        data: {
          status: 'CANCELLED',
          cancelledAt: new Date(),
          cancellationReason: dto.reason,
        },
      });
      await tx.teacherSession.update({
        where: { id: booking.sessionId },
        data: { currentBookings: { decrement: 1 } },
      });
      return cancelled;
    });
  }
}

// ==============================================================================
// Yoga24X AI Engineering OS — Booking Service (Prompt 7)
// ==============================================================================

import { Injectable, Logger } from '@nestjs/common';
import { BookingRepository } from '../repositories/booking.repository';
import { WaitlistRepository } from '../repositories/waitlist.repository';
import { EventEmitter2 } from '@nestjs/event-emitter';
import {
  CreateBookingDto,
  RescheduleBookingDto,
  CancelBookingDto,
  BookingQueryDto,
} from '../dto/booking.dto';

@Injectable()
export class BookingService {
  private readonly logger = new Logger(BookingService.name);

  constructor(
    private readonly bookingRepo: BookingRepository,
    private readonly waitlistRepo: WaitlistRepository,
    private readonly events: EventEmitter2,
  ) {}

  async createBooking(userId: string, dto: CreateBookingDto, tenantId: string) {
    const booking = await this.bookingRepo.createBooking(userId, dto, tenantId);
    this.logger.log(`Booking created: ${booking.id} for user ${userId}`);
    this.events.emit('booking.created', { bookingId: booking.id, userId, tenantId });
    return booking;
  }

  async getStudentBookings(userId: string, query: BookingQueryDto) {
    return this.bookingRepo.findForStudent(userId, query);
  }

  async getTeacherBookings(teacherUserId: string, query: BookingQueryDto) {
    return this.bookingRepo.findForTeacher(teacherUserId, query);
  }

  async getBookingById(id: string) {
    return this.bookingRepo.findById(id);
  }

  async reschedule(userId: string, dto: RescheduleBookingDto) {
    const booking = await this.bookingRepo.rescheduleBooking(userId, dto);
    this.events.emit('booking.rescheduled', { bookingId: booking.id, userId });

    // Promote next on waitlist for the old session
    const oldBooking = await this.bookingRepo.findById(dto.bookingId);
    await this.waitlistRepo.promoteNext(oldBooking.sessionId);

    return booking;
  }

  async cancel(userId: string, dto: CancelBookingDto, role: string) {
    const booking = await this.bookingRepo.cancelBooking(userId, dto, role);
    this.events.emit('booking.cancelled', { bookingId: booking.id, userId, reason: dto.reason });

    // Promote next on waitlist when a slot opens
    await this.waitlistRepo.promoteNext(booking.sessionId);

    return booking;
  }
}

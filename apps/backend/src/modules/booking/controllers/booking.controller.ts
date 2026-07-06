// ==============================================================================
// Yoga24X AI Engineering OS — Booking Controller (Prompt 7)
// ==============================================================================

import {
  Controller, Get, Post, Delete, Body, Param, Query, UseGuards, Req, HttpCode, HttpStatus,
} from '@nestjs/common';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RequirePermissions } from '../../security/decorators/authorization.decorators';
import { CurrentUser } from '../../auth/decorators/auth.decorators';
import { JwtAccessPayload as JwtPayload } from '@yoga24x/shared-types';
import { BookingService } from '../services/booking.service';
import { BOOKING_PERMISSIONS } from '../constants/booking-permissions';
import {
  CreateBookingDto, RescheduleBookingDto, CancelBookingDto, BookingQueryDto,
} from '../dto/booking.dto';

@Controller('api/v1/bookings')
@UseGuards(JwtAuthGuard)
export class BookingController {
  constructor(private readonly bookingService: BookingService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @RequirePermissions(BOOKING_PERMISSIONS.WRITE)
  async createBooking(@CurrentUser() user: JwtPayload, @Body() dto: CreateBookingDto) {
    return this.bookingService.createBooking(user.sub, dto, user.tenantId ?? 'default');
  }

  @Get()
  @RequirePermissions(BOOKING_PERMISSIONS.READ)
  async getMyBookings(@CurrentUser() user: JwtPayload, @Query() query: BookingQueryDto) {
    return this.bookingService.getStudentBookings(user.sub, query);
  }

  @Get('teacher')
  @RequirePermissions(BOOKING_PERMISSIONS.READ)
  async getTeacherBookings(@CurrentUser() user: JwtPayload, @Query() query: BookingQueryDto) {
    return this.bookingService.getTeacherBookings(user.sub, query);
  }

  @Get(':id')
  @RequirePermissions(BOOKING_PERMISSIONS.READ)
  async getBooking(@Param('id') id: string) {
    return this.bookingService.getBookingById(id);
  }

  @Post('reschedule')
  @RequirePermissions(BOOKING_PERMISSIONS.RESCHEDULE)
  async rescheduleBooking(@CurrentUser() user: JwtPayload, @Body() dto: RescheduleBookingDto) {
    return this.bookingService.reschedule(user.sub, dto);
  }

  @Post('cancel')
  @RequirePermissions(BOOKING_PERMISSIONS.CANCEL)
  async cancelBooking(@CurrentUser() user: JwtPayload, @Body() dto: CancelBookingDto) {
    return this.bookingService.cancel(user.sub, dto, user.roles?.[0] ?? 'STUDENT');
  }
}

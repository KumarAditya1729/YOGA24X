// ==============================================================================
// Yoga24X AI Engineering OS — Booking DTOs (Prompt 7)
// ==============================================================================

import {
  IsString,
  IsOptional,
  IsEnum,
  IsUUID,
  IsInt,
  IsBoolean,
  IsDateString,
  IsLatitude,
  IsLongitude,
  Min,
  Max,
} from "class-validator";
import { BookingStatus } from "@prisma/client";

// ─── Create / Instant Booking ─────────────────────────────────────────────────
export class CreateBookingDto {
  @IsUUID()
  sessionId: string;

  @IsOptional()
  @IsString()
  bookingNotes?: string;
}

// ─── Approval-Based Booking ───────────────────────────────────────────────────
export class ApproveBookingDto {
  @IsUUID()
  bookingId: string;

  @IsEnum(BookingStatus)
  decision: "CONFIRMED" | "CANCELLED";

  @IsOptional()
  @IsString()
  reason?: string;
}

// ─── Reschedule ───────────────────────────────────────────────────────────────
export class RescheduleBookingDto {
  @IsUUID()
  bookingId: string;

  @IsUUID()
  newSessionId: string;

  @IsOptional()
  @IsString()
  reason?: string;
}

// ─── Cancel ───────────────────────────────────────────────────────────────────
export class CancelBookingDto {
  @IsUUID()
  bookingId: string;

  @IsString()
  reason: string;
}

// ─── Attendance / Check-In ────────────────────────────────────────────────────
export class CheckInDto {
  @IsUUID()
  bookingId: string;

  @IsString()
  method: "QR" | "OTP" | "GEO" | "MANUAL" | "REPLAY";

  @IsOptional()
  @IsString()
  token?: string; // QR or OTP token

  @IsOptional()
  @IsLatitude()
  geoLat?: number;

  @IsOptional()
  @IsLongitude()
  geoLng?: number;
}

// ─── Enrollment ───────────────────────────────────────────────────────────────
export class EnrollCourseDto {
  @IsUUID()
  courseId: string;
}

export class RegisterEventDto {
  @IsUUID()
  eventId: string;
}

// ─── Waitlist ─────────────────────────────────────────────────────────────────
export class JoinWaitlistDto {
  @IsOptional()
  @IsUUID()
  sessionId?: string;

  @IsOptional()
  @IsUUID()
  eventId?: string;
}

// ─── Calendar Sync ────────────────────────────────────────────────────────────
export class CalendarSyncDto {
  @IsString()
  provider: "GOOGLE" | "APPLE";

  @IsString()
  accessToken: string;

  @IsOptional()
  @IsString()
  refreshToken?: string;

  @IsOptional()
  @IsString()
  calendarId?: string;
}

// ─── Query Filters ────────────────────────────────────────────────────────────
export class BookingQueryDto {
  @IsOptional()
  @IsEnum(BookingStatus)
  status?: BookingStatus;

  @IsOptional()
  @IsDateString()
  fromDate?: string;

  @IsOptional()
  @IsDateString()
  toDate?: string;

  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number;

  @IsOptional()
  @IsInt()
  @Min(0)
  offset?: number;
}

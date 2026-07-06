import {
  IsString,
  IsOptional,
  IsInt,
  IsBoolean,
  IsArray,
  IsEnum,
  MaxLength,
  Min,
  Max,
  IsDateString,
  IsUUID,
  IsNumber,
} from "class-validator";
import { Type } from "class-transformer";
import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import { SessionFormat, PayoutStatus, BookingStatus } from "@prisma/client";

// ── Teacher Booking Rules ──────────────────────────────────────────────────────
export class UpdateTeacherBookingRuleDto {
  @ApiPropertyOptional()
  @IsInt()
  @Min(0)
  @IsOptional()
  advanceBookingDays?: number;
  @ApiPropertyOptional()
  @IsInt()
  @Min(0)
  @IsOptional()
  minimumNoticeHours?: number;
  @ApiPropertyOptional()
  @IsInt()
  @Min(0)
  @IsOptional()
  cancellationWindowHours?: number;
  @ApiPropertyOptional()
  @IsInt()
  @Min(0)
  @IsOptional()
  reschedulePolicyHours?: number;
  @ApiPropertyOptional()
  @IsInt()
  @Min(0)
  @IsOptional()
  bufferTimeMinutes?: number;
  @ApiPropertyOptional()
  @IsInt()
  @Min(1)
  @IsOptional()
  maxDailySessions?: number;
  @ApiPropertyOptional() @IsInt() @Min(1) @IsOptional() maxWeeklyHours?: number;
  @ApiPropertyOptional()
  @IsInt()
  @Min(0)
  @IsOptional()
  lateArrivalGraceMins?: number;
  @ApiPropertyOptional()
  @IsBoolean()
  @IsOptional()
  preventOverbooking?: boolean;
  @ApiPropertyOptional() @IsBoolean() @IsOptional() allowWaitlist?: boolean;
}

// ── Teacher Holidays ───────────────────────────────────────────────────────────
export class CreateTeacherHolidayDto {
  @ApiProperty({ example: "2026-12-25" }) @IsDateString() startDate!: string;
  @ApiProperty({ example: "2026-12-31" }) @IsDateString() endDate!: string;
  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  @MaxLength(255)
  reason?: string;
  @ApiPropertyOptional() @IsBoolean() @IsOptional() isEmergency?: boolean;
}

// ── Session Types & Pricing ────────────────────────────────────────────────────
export class CreateTeacherSessionTypeDto {
  @ApiProperty() @IsString() @MaxLength(255) title!: string;
  @ApiPropertyOptional() @IsString() @IsOptional() description?: string;
  @ApiProperty({ enum: SessionFormat })
  @IsEnum(SessionFormat)
  format!: SessionFormat;
  @ApiProperty({ example: 60 }) @IsInt() @Min(15) durationMinutes!: number;
  @ApiProperty({ example: 5000 }) @IsInt() @Min(0) basePriceCents!: number;
  @ApiPropertyOptional({ example: "USD" })
  @IsString()
  @MaxLength(3)
  @IsOptional()
  currency?: string;
  @ApiPropertyOptional({ example: 1 })
  @IsInt()
  @Min(1)
  @IsOptional()
  maxParticipants?: number;
  @ApiPropertyOptional() @IsBoolean() @IsOptional() isActive?: boolean;
  @ApiPropertyOptional() @IsBoolean() @IsOptional() isOnline?: boolean;
  @ApiPropertyOptional() @IsNumber() @IsOptional() taxRatePercent?: number;
}

export class UpdateTeacherSessionTypeDto {
  @ApiPropertyOptional()
  @IsString()
  @MaxLength(255)
  @IsOptional()
  title?: string;
  @ApiPropertyOptional() @IsString() @IsOptional() description?: string;
  @ApiPropertyOptional()
  @IsInt()
  @Min(15)
  @IsOptional()
  durationMinutes?: number;
  @ApiPropertyOptional() @IsInt() @Min(0) @IsOptional() basePriceCents?: number;
  @ApiPropertyOptional()
  @IsInt()
  @Min(1)
  @IsOptional()
  maxParticipants?: number;
  @ApiPropertyOptional() @IsBoolean() @IsOptional() isActive?: boolean;
  @ApiPropertyOptional() @IsBoolean() @IsOptional() isOnline?: boolean;
}

export class CreateTeacherPricingRuleDto {
  @ApiProperty() @IsString() @MaxLength(255) ruleName!: string;
  @ApiPropertyOptional() @IsNumber() @IsOptional() markupPercent?: number;
  @ApiPropertyOptional() @IsNumber() @IsOptional() discountPercent?: number;
  @ApiPropertyOptional() @IsBoolean() @IsOptional() isWeekend?: boolean;
  @ApiPropertyOptional() @IsBoolean() @IsOptional() isPeakHour?: boolean;
  @ApiPropertyOptional({ enum: SessionFormat, isArray: true })
  @IsArray()
  @IsEnum(SessionFormat, { each: true })
  @IsOptional()
  applicableFormats?: SessionFormat[];
}

// ── Scheduling & Bookings ──────────────────────────────────────────────────────
export class CreateTeacherSessionDto {
  @ApiProperty() @IsUUID() sessionTypeId!: string;
  @ApiProperty() @IsString() @MaxLength(255) title!: string;
  @ApiProperty() @IsDateString() startTime!: string;
  @ApiProperty() @IsDateString() endTime!: string;
  @ApiPropertyOptional()
  @IsInt()
  @Min(1)
  @IsOptional()
  maxParticipants?: number;
  @ApiPropertyOptional() @IsString() @IsOptional() meetingUrl?: string;
}

// ── Student Management (Roster) ────────────────────────────────────────────────
export class UpdateRosterDto {
  @ApiPropertyOptional() @IsBoolean() @IsOptional() isFavorite?: boolean;
  @ApiPropertyOptional() @IsBoolean() @IsOptional() isBlocked?: boolean;
}

export class CreateStudentNoteDto {
  @ApiProperty() @IsString() noteText!: string;
  @ApiPropertyOptional() @IsBoolean() @IsOptional() isPrivate?: boolean;
  @ApiPropertyOptional() @IsBoolean() @IsOptional() containsMedical?: boolean;
}

// ── Attendance ─────────────────────────────────────────────────────────────────
export class MarkAttendanceDto {
  @ApiProperty() @IsBoolean() attended!: boolean;
  @ApiPropertyOptional() @IsString() @IsOptional() notes?: string;
}

// ── Payouts ────────────────────────────────────────────────────────────────────
export class CreatePayoutRequestDto {
  @ApiProperty() @IsInt() @Min(1) amountCents!: number;
  @ApiPropertyOptional({ example: "USD" })
  @IsString()
  @MaxLength(3)
  @IsOptional()
  currency?: string;
  @ApiPropertyOptional()
  @IsString()
  @MaxLength(100)
  @IsOptional()
  bankAccountId?: string;
}

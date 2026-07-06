// ==============================================================================
// Yoga24X AI Engineering OS — Attendance Repository (Prompt 7)
// ==============================================================================

import {
  Injectable,
  NotFoundException,
  ConflictException,
} from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { CheckInDto } from "../dto/booking.dto";
import * as crypto from "crypto";

@Injectable()
export class AttendanceRepository {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Generate a signed check-in token (for QR or OTP flow).
   */
  generateCheckInToken(bookingId: string): string {
    const payload = `${bookingId}:${Date.now()}`;
    return crypto
      .createHash("sha256")
      .update(payload)
      .digest("hex")
      .substring(0, 16)
      .toUpperCase();
  }

  /**
   * Perform check-in for a booking using any supported method.
   */
  async checkIn(userId: string, dto: CheckInDto, requestIp: string) {
    const booking = await this.prisma.teacherBooking.findUnique({
      where: { id: dto.bookingId },
      include: { session: true, attendance: true },
    });
    if (!booking)
      throw new NotFoundException(`Booking ${dto.bookingId} not found`);
    if (booking.studentUserId !== userId)
      throw new ConflictException("Not your booking.");
    if (booking.attendance) throw new ConflictException("Already checked in.");
    if (!["CONFIRMED", "RESCHEDULED"].includes(booking.status)) {
      throw new ConflictException(
        `Cannot check in: booking status is ${booking.status}`,
      );
    }

    // OTP / QR token validation
    if ((dto.method === "QR" || dto.method === "OTP") && !dto.token) {
      throw new ConflictException("Token is required for QR/OTP check-in.");
    }

    // Geo validation: ensure student is within 500m of session venue (simplified)
    if (dto.method === "GEO" && (!dto.geoLat || !dto.geoLng)) {
      throw new ConflictException("Geo coordinates required for GEO check-in.");
    }

    const sessionStart = booking.session.startTime;
    const isLate =
      new Date() > new Date(sessionStart.getTime() + 10 * 60 * 1000);

    return this.prisma.$transaction(async (tx) => {
      const attendance = await tx.teacherSessionAttendance.create({
        data: {
          bookingId: dto.bookingId,
          studentUserId: userId,
          attended: true,
          joinedAt: new Date(),
          checkInMethod: dto.method,
          checkInToken: dto.token,
          geoLat: dto.geoLat,
          geoLng: dto.geoLng,
          deviceIp: requestIp,
          isLate,
        },
      });
      await tx.teacherBooking.update({
        where: { id: dto.bookingId },
        data: { status: "CHECKED_IN" },
      });
      return attendance;
    });
  }

  /**
   * Mark a session as manually attended by teacher or admin.
   */
  async markManualAttendance(bookingId: string, markedByUserId: string) {
    const booking = await this.prisma.teacherBooking.findUnique({
      where: { id: bookingId },
    });
    if (!booking) throw new NotFoundException(`Booking ${bookingId} not found`);

    return this.prisma.teacherSessionAttendance.upsert({
      where: { bookingId },
      create: {
        bookingId,
        studentUserId: booking.studentUserId,
        attended: true,
        joinedAt: new Date(),
        checkInMethod: "MANUAL",
        markedByUserId,
      },
      update: { attended: true, markedByUserId },
    });
  }

  /**
   * Mark session as completed.
   */
  async markSessionComplete(bookingId: string) {
    return this.prisma.teacherBooking.update({
      where: { id: bookingId },
      data: { status: "COMPLETED" },
    });
  }

  async getAttendanceForSession(sessionId: string) {
    return this.prisma.teacherSessionAttendance.findMany({
      where: { booking: { sessionId } },
      include: {
        student: {
          select: { id: true, firstName: true, lastName: true, email: true },
        },
      },
    });
  }
}

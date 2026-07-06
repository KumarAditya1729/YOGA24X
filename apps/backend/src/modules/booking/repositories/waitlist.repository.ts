// ==============================================================================
// Yoga24X AI Engineering OS — Waitlist Repository (Prompt 7)
// ==============================================================================

import {
  Injectable,
  ConflictException,
  NotFoundException,
} from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { JoinWaitlistDto } from "../dto/booking.dto";

@Injectable()
export class WaitlistRepository {
  constructor(private readonly prisma: PrismaService) {}

  async joinWaitlist(studentUserId: string, dto: JoinWaitlistDto) {
    if (!dto.sessionId && !dto.eventId) {
      throw new ConflictException(
        "Either sessionId or eventId must be provided.",
      );
    }

    const existing = await this.prisma.waitlistEntry.findFirst({
      where: {
        studentUserId,
        sessionId: dto.sessionId,
        eventId: dto.eventId,
        status: "PENDING",
      },
    });
    if (existing)
      throw new ConflictException("You are already on the waitlist.");

    // Determine priority (FIFO — last position + 1)
    const count = await this.prisma.waitlistEntry.count({
      where: {
        sessionId: dto.sessionId,
        eventId: dto.eventId,
        status: "PENDING",
      },
    });

    return this.prisma.waitlistEntry.create({
      data: {
        studentUserId,
        sessionId: dto.sessionId,
        eventId: dto.eventId,
        priority: count + 1,
        status: "PENDING",
        expiresAt: new Date(Date.now() + 24 * 60 * 60 * 1000), // 24h expiry
      },
    });
  }

  async leaveWaitlist(studentUserId: string, waitlistEntryId: string) {
    const entry = await this.prisma.waitlistEntry.findUnique({
      where: { id: waitlistEntryId },
    });
    if (!entry) throw new NotFoundException("Waitlist entry not found");
    if (entry.studentUserId !== studentUserId)
      throw new ConflictException("Not your entry.");

    return this.prisma.waitlistEntry.update({
      where: { id: waitlistEntryId },
      data: { status: "DECLINED" },
    });
  }

  /**
   * Auto-promote the highest-priority pending waitlist entry when a slot opens.
   */
  async promoteNext(sessionId?: string, eventId?: string) {
    const next = await this.prisma.waitlistEntry.findFirst({
      where: {
        sessionId,
        eventId,
        status: "PENDING",
        OR: [{ expiresAt: null }, { expiresAt: { gt: new Date() } }],
      },
      orderBy: { priority: "asc" },
    });

    if (!next) return null;

    return this.prisma.waitlistEntry.update({
      where: { id: next.id },
      data: { status: "PROMOTED", promotedAt: new Date() },
      include: {
        student: {
          select: { id: true, email: true, firstName: true, lastName: true },
        },
      },
    });
  }

  /**
   * Expire stale waitlist entries (called by scheduled job).
   */
  async expireStale() {
    return this.prisma.waitlistEntry.updateMany({
      where: {
        status: "PENDING",
        expiresAt: { lt: new Date() },
      },
      data: { status: "EXPIRED" },
    });
  }

  async getWaitlistForStudent(studentUserId: string) {
    return this.prisma.waitlistEntry.findMany({
      where: { studentUserId, status: "PENDING" },
      include: {
        session: { include: { sessionType: true } },
        event: true,
      },
      orderBy: { createdAt: "asc" },
    });
  }
}

import { Injectable, NotFoundException } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import {
  UpdateRosterDto,
  CreateStudentNoteDto,
  MarkAttendanceDto,
} from "../dto/teacher-operations.dto";

@Injectable()
export class TeacherStudentRepository {
  constructor(private readonly prisma: PrismaService) {}

  // ── Roster ───────────────────────────────────────────────────────────────────

  async getRoster(teacherUserId: string) {
    return this.prisma.teacherStudentRoster.findMany({
      where: { teacherUserId },
      include: {
        student: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            avatarUrl: true,
            email: true,
          },
        },
      },
      orderBy: { lastSessionAt: "desc" },
    });
  }

  async getRosterDetail(teacherUserId: string, studentUserId: string) {
    const roster = await this.prisma.teacherStudentRoster.findUnique({
      where: {
        uq_teacher_roster_teacher_student: { teacherUserId, studentUserId },
      },
      include: {
        student: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            avatarUrl: true,
            email: true,
          },
        },
        notes: { orderBy: { createdAt: "desc" } },
      },
    });
    if (!roster) throw new NotFoundException("Student not found in roster");
    return roster;
  }

  async updateRoster(
    teacherUserId: string,
    studentUserId: string,
    data: UpdateRosterDto,
  ) {
    return this.prisma.teacherStudentRoster.update({
      where: {
        uq_teacher_roster_teacher_student: { teacherUserId, studentUserId },
      },
      data,
    });
  }

  // ── Notes ────────────────────────────────────────────────────────────────────

  async createNote(
    teacherUserId: string,
    studentUserId: string,
    data: CreateStudentNoteDto,
  ) {
    const roster = await this.prisma.teacherStudentRoster.findUnique({
      where: {
        uq_teacher_roster_teacher_student: { teacherUserId, studentUserId },
      },
    });
    if (!roster) throw new NotFoundException("Student not found in roster");

    return this.prisma.teacherStudentNote.create({
      data: {
        rosterId: roster.id,
        noteText: data.noteText,
        isPrivate: data.isPrivate ?? true,
        containsMedical: data.containsMedical ?? false,
      },
    });
  }

  // ── Attendance ───────────────────────────────────────────────────────────────

  async markAttendance(
    teacherUserId: string,
    bookingId: string,
    data: MarkAttendanceDto,
  ) {
    const booking = await this.prisma.teacherBooking.findUnique({
      where: { id: bookingId },
      include: { session: true },
    });

    if (!booking || booking.session.teacherUserId !== teacherUserId) {
      throw new NotFoundException("Booking not found");
    }

    return this.prisma.teacherSessionAttendance.upsert({
      where: { bookingId },
      update: {
        attended: data.attended,
        notes: data.notes,
        joinedAt: data.attended ? new Date() : null,
      },
      create: {
        bookingId,
        studentUserId: booking.studentUserId,
        attended: data.attended,
        notes: data.notes,
        joinedAt: data.attended ? new Date() : null,
      },
    });
  }
}

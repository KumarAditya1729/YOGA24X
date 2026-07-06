// ==============================================================================
// Yoga24X AI Engineering OS — Enrollment Repository (Prompt 7)
// ==============================================================================

import { Injectable, ConflictException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';

@Injectable()
export class EnrollmentRepository {
  constructor(private readonly prisma: PrismaService) {}

  async enrollInCourse(userId: string, courseId: string) {
    const course = await this.prisma.course.findUnique({ where: { id: courseId } });
    if (!course) throw new NotFoundException(`Course ${courseId} not found`);
    if (course.visibility !== 'PUBLISHED') {
      throw new ConflictException('Course is not available for enrollment.');
    }

    const existing = await this.prisma.courseEnrollment.findFirst({
      where: { userId, courseId },
    });
    if (existing) throw new ConflictException('Already enrolled in this course.');

    return this.prisma.courseEnrollment.create({
      data: { userId, courseId },
    });
  }

  async getStudentEnrollments(userId: string) {
    return this.prisma.courseEnrollment.findMany({
      where: { userId },
      include: {
        course: {
          include: {
            instructor: {
              include: {
                user: { select: { firstName: true, lastName: true } },
              },
            },
          },
        },
      },
      orderBy: { enrolledAt: 'desc' },
    });
  }

  async registerForEvent(studentUserId: string, eventId: string) {
    const event = await this.prisma.learningEvent.findUnique({ where: { id: eventId } });
    if (!event) throw new NotFoundException(`Event ${eventId} not found`);

    const existing = await this.prisma.eventRegistration.findFirst({
      where: { studentUserId, eventId },
    });
    if (existing) throw new ConflictException('Already registered for this event.');

    const registrationCount = await this.prisma.eventRegistration.count({
      where: { eventId },
    });
    if (event.capacity > 0 && registrationCount >= event.capacity) {
      throw new ConflictException('Event is at full capacity. Join the waitlist.');
    }

    return this.prisma.eventRegistration.create({
      data: { studentUserId, eventId },
    });
  }

  async cancelEnrollment(userId: string, courseId: string) {
    const enrollment = await this.prisma.courseEnrollment.findFirst({
      where: { userId, courseId },
    });
    if (!enrollment) throw new NotFoundException('Enrollment not found.');
    return this.prisma.courseEnrollment.delete({ where: { id: enrollment.id } });
  }

  async getStudentEventRegistrations(studentUserId: string) {
    return this.prisma.eventRegistration.findMany({
      where: { studentUserId },
      include: {
        event: {
          include: {
            instructor: {
              include: {
                user: { select: { firstName: true, lastName: true } },
              },
            },
          },
        },
      },
      orderBy: { registeredAt: 'desc' },
    });
  }
}

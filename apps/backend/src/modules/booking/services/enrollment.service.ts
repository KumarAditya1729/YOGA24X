// ==============================================================================
// Yoga24X AI Engineering OS — Enrollment Service (Prompt 7)
// ==============================================================================

import { Injectable } from '@nestjs/common';
import { EnrollmentRepository } from '../repositories/enrollment.repository';
import { EventEmitter2 } from '@nestjs/event-emitter';

@Injectable()
export class EnrollmentService {
  constructor(
    private readonly enrollmentRepo: EnrollmentRepository,
    private readonly events: EventEmitter2,
  ) {}

  async enrollInCourse(userId: string, courseId: string) {
    const enrollment = await this.enrollmentRepo.enrollInCourse(userId, courseId);
    this.events.emit('enrollment.course_enrolled', { userId, courseId });
    return enrollment;
  }

  async cancelCourseEnrollment(userId: string, courseId: string) {
    return this.enrollmentRepo.cancelEnrollment(userId, courseId);
  }

  async registerForEvent(studentUserId: string, eventId: string) {
    const registration = await this.enrollmentRepo.registerForEvent(studentUserId, eventId);
    this.events.emit('enrollment.event_registered', { studentUserId, eventId });
    return registration;
  }

  async getMyEnrollments(userId: string) {
    return this.enrollmentRepo.getStudentEnrollments(userId);
  }

  async getMyEventRegistrations(studentUserId: string) {
    return this.enrollmentRepo.getStudentEventRegistrations(studentUserId);
  }
}

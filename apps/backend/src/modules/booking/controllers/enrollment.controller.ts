// ==============================================================================
// Yoga24X AI Engineering OS — Enrollment Controller (Prompt 7)
// ==============================================================================

import {
  Controller, Get, Post, Delete, Param, Body, UseGuards, HttpCode, HttpStatus,
} from '@nestjs/common';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RequirePermissions } from '../../security/decorators/authorization.decorators';
import { CurrentUser } from '../../auth/decorators/auth.decorators';
import { JwtAccessPayload as JwtPayload } from '@yoga24x/shared-types';
import { EnrollmentService } from '../services/enrollment.service';
import { ENROLLMENT_PERMISSIONS } from '../constants/booking-permissions';
import { EnrollCourseDto, RegisterEventDto } from '../dto/booking.dto';

@Controller('api/v1/enrollments')
@UseGuards(JwtAuthGuard)
export class EnrollmentController {
  constructor(private readonly enrollmentService: EnrollmentService) {}

  @Post('courses')
  @HttpCode(HttpStatus.CREATED)
  @RequirePermissions(ENROLLMENT_PERMISSIONS.WRITE)
  async enrollCourse(@CurrentUser() user: JwtPayload, @Body() dto: EnrollCourseDto) {
    return this.enrollmentService.enrollInCourse(user.sub, dto.courseId);
  }

  @Delete('courses/:courseId')
  @RequirePermissions(ENROLLMENT_PERMISSIONS.WRITE)
  async cancelCourseEnrollment(
    @CurrentUser() user: JwtPayload,
    @Param('courseId') courseId: string,
  ) {
    return this.enrollmentService.cancelCourseEnrollment(user.sub, courseId);
  }

  @Get('courses')
  @RequirePermissions(ENROLLMENT_PERMISSIONS.READ)
  async getMyCourses(@CurrentUser() user: JwtPayload) {
    return this.enrollmentService.getMyEnrollments(user.sub);
  }

  @Post('events')
  @HttpCode(HttpStatus.CREATED)
  @RequirePermissions(ENROLLMENT_PERMISSIONS.WRITE)
  async registerEvent(@CurrentUser() user: JwtPayload, @Body() dto: RegisterEventDto) {
    return this.enrollmentService.registerForEvent(user.sub, dto.eventId);
  }

  @Get('events')
  @RequirePermissions(ENROLLMENT_PERMISSIONS.READ)
  async getMyEvents(@CurrentUser() user: JwtPayload) {
    return this.enrollmentService.getMyEventRegistrations(user.sub);
  }
}

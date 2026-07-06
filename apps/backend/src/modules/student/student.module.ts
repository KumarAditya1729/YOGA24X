import { Module } from '@nestjs/common';

import { StudentController } from './controllers/student.controller';
import { StudentHealthController } from './controllers/student-health.controller';
import { StudentService } from './services/student.service';
import { StudentHealthService } from './services/student-health.service';
import { StudentDashboardService } from './services/student-dashboard.service';
import { StudentRepository } from './repositories/student.repository';
import { StudentHealthRepository } from './repositories/student-health.repository';
import { StudentAnalyticsRepository } from './repositories/student-analytics.repository';

@Module({
  controllers: [
    StudentController,
    StudentHealthController,
  ],
  providers: [
    StudentService,
    StudentHealthService,
    StudentDashboardService,
    StudentRepository,
    StudentHealthRepository,
    StudentAnalyticsRepository,
  ],
  exports: [
    StudentService,
    StudentHealthService,
  ],
})
export class StudentModule {}

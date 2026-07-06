// ==============================================================================
// Yoga24X AI Engineering OS — Wellness Module
// Encapsulates Health Identity, Assessments, Goals, and Medical Safety
// ==============================================================================

import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { IamModule } from '../iam/iam.module';

// Repositories
import { HealthProfileRepository } from './repositories/health-profile.repository';
import { WellnessAssessmentRepository } from './repositories/wellness-assessment.repository';
import { TimelineGoalRepository } from './repositories/timeline-goal.repository';
import { MedicalSafetyRepository } from './repositories/medical-safety.repository';

// Services
import { HealthProfileService } from './services/health-profile.service';
import { AssessmentService } from './services/assessment.service';
import { TimelineAndGoalService } from './services/timeline-goal.service';
import { MedicalSafetyService } from './services/medical-safety.service';
import { AdminWellnessService } from './services/admin-wellness.service';

// Interceptors
import { PiiHealthMaskingInterceptor } from './interceptors/pii-health-masking.interceptor';

// Controllers
import { HealthProfileController } from './controllers/health-profile.controller';
import { AssessmentController } from './controllers/assessment.controller';
import { TimelineGoalController } from './controllers/timeline-goal.controller';
import { MedicalSafetyController } from './controllers/medical-safety.controller';
import { AdminWellnessController } from './controllers/admin-wellness.controller';

@Module({
  imports: [PrismaModule, IamModule],
  controllers: [
    HealthProfileController,
    AssessmentController,
    TimelineGoalController,
    MedicalSafetyController,
    AdminWellnessController,
  ],
  providers: [
    HealthProfileRepository,
    WellnessAssessmentRepository,
    TimelineGoalRepository,
    MedicalSafetyRepository,
    HealthProfileService,
    AssessmentService,
    TimelineAndGoalService,
    MedicalSafetyService,
    AdminWellnessService,
    PiiHealthMaskingInterceptor,
  ],
  exports: [
    HealthProfileService,
    AssessmentService,
    TimelineAndGoalService,
    MedicalSafetyService,
    AdminWellnessService,
  ],
})
export class WellnessModule {}

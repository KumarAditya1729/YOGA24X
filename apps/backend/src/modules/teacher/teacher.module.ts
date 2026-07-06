// ==============================================================================
// Yoga24X — Teacher Module
// Encapsulates Teacher Identity, Certifications, Portfolio, Verification, Stats
// ==============================================================================
import { Module } from "@nestjs/common";
import { EventEmitterModule } from "@nestjs/event-emitter";
import { PrismaModule } from "../prisma/prisma.module";

// Repositories
import { TeacherProfileRepository } from "./repositories/teacher-profile.repository";
import { TeacherCertificationRepository } from "./repositories/teacher-certification.repository";
import { TeacherVerificationRepository } from "./repositories/teacher-verification.repository";
import { TeacherStatsRepository } from "./repositories/teacher-stats.repository";
import { TeacherAvailabilityRepository } from "./repositories/teacher-availability.repository";
import { TeacherSessionRepository } from "./repositories/teacher-session.repository";
import { TeacherStudentRepository } from "./repositories/teacher-student.repository";
import { TeacherEarningsRepository } from "./repositories/teacher-earnings.repository";

// Services
import { TeacherProfileService } from "./services/teacher-profile.service";
import { TeacherCertificationService } from "./services/teacher-certification.service";
import { TeacherPortfolioService } from "./services/teacher-portfolio.service";
import { TeacherVerificationService } from "./services/teacher-verification.service";
import { TeacherStatsService } from "./services/teacher-stats.service";
import { TeacherAdminService } from "./services/teacher-admin.service";
import { TeacherAvailabilityService } from "./services/teacher-availability.service";
import { TeacherSessionService } from "./services/teacher-session.service";
import { TeacherStudentService } from "./services/teacher-student.service";
import { TeacherEarningsService } from "./services/teacher-earnings.service";

// Controllers
import { TeacherProfileController } from "./controllers/teacher-profile.controller";
import { TeacherCertificationController } from "./controllers/teacher-certification.controller";
import { TeacherPortfolioController } from "./controllers/teacher-portfolio.controller";
import { TeacherVerificationController } from "./controllers/teacher-verification.controller";
import { TeacherAdminController } from "./controllers/teacher-admin.controller";
import { TeacherAvailabilityController } from "./controllers/teacher-availability.controller";
import { TeacherSessionController } from "./controllers/teacher-session.controller";
import { TeacherStudentController } from "./controllers/teacher-student.controller";
import { TeacherEarningsController } from "./controllers/teacher-earnings.controller";

@Module({
  imports: [PrismaModule],
  controllers: [
    TeacherProfileController,
    TeacherCertificationController,
    TeacherPortfolioController,
    TeacherVerificationController,
    TeacherAdminController,
    TeacherAvailabilityController,
    TeacherSessionController,
    TeacherStudentController,
    TeacherEarningsController,
  ],
  providers: [
    // Repositories
    TeacherProfileRepository,
    TeacherCertificationRepository,
    TeacherVerificationRepository,
    TeacherStatsRepository,
    TeacherAvailabilityRepository,
    TeacherSessionRepository,
    TeacherStudentRepository,
    TeacherEarningsRepository,
    // Services
    TeacherProfileService,
    TeacherCertificationService,
    TeacherPortfolioService,
    TeacherVerificationService,
    TeacherStatsService,
    TeacherAdminService,
    TeacherAvailabilityService,
    TeacherSessionService,
    TeacherStudentService,
    TeacherEarningsService,
  ],
  exports: [
    TeacherProfileService,
    TeacherCertificationService,
    TeacherPortfolioService,
    TeacherVerificationService,
    TeacherStatsService,
    TeacherAvailabilityService,
    TeacherSessionService,
    TeacherStudentService,
    TeacherEarningsService,
  ],
})
export class TeacherModule {}

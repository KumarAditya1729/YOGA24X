// ==============================================================================
// Yoga24X AI Engineering OS — Booking Module (Prompt 7)
// ==============================================================================

import { Module } from "@nestjs/common";
import { PrismaModule } from "../prisma/prisma.module";
import { SecurityModule } from "../security/security.module";

// Repositories
import { BookingRepository } from "./repositories/booking.repository";
import { SchedulingRepository } from "./repositories/scheduling.repository";
import { AttendanceRepository } from "./repositories/attendance.repository";
import { WaitlistRepository } from "./repositories/waitlist.repository";
import { EnrollmentRepository } from "./repositories/enrollment.repository";

// Services
import { BookingService } from "./services/booking.service";
import { SchedulingService } from "./services/scheduling.service";
import { AttendanceService } from "./services/attendance.service";
import { WaitlistService } from "./services/waitlist.service";
import { EnrollmentService } from "./services/enrollment.service";

// Controllers
import { BookingController } from "./controllers/booking.controller";
import { SchedulingController } from "./controllers/scheduling.controller";
import { AttendanceController } from "./controllers/attendance.controller";
import { WaitlistController } from "./controllers/waitlist.controller";
import { EnrollmentController } from "./controllers/enrollment.controller";

@Module({
  imports: [PrismaModule, SecurityModule],
  controllers: [
    BookingController,
    SchedulingController,
    AttendanceController,
    WaitlistController,
    EnrollmentController,
  ],
  providers: [
    // Repositories
    BookingRepository,
    SchedulingRepository,
    AttendanceRepository,
    WaitlistRepository,
    EnrollmentRepository,
    // Services
    BookingService,
    SchedulingService,
    AttendanceService,
    WaitlistService,
    EnrollmentService,
  ],
  exports: [
    BookingService,
    SchedulingService,
    EnrollmentService,
    AttendanceService,
  ],
})
export class BookingModule {}

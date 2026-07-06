import { Module } from "@nestjs/common";
import { PrismaModule } from "../prisma/prisma.module";
import { SecurityModule } from "../security/security.module";

import { CourseController } from "./controllers/course.controller";
import { LessonController } from "./controllers/lesson.controller";
import { EventController } from "./controllers/event.controller";
import { PublishingController } from "./controllers/publishing.controller";
import { StudentController } from "./controllers/student.controller";
import { AssessmentController } from "./controllers/assessment.controller";

import { CourseService } from "./services/course.service";
import { LessonService } from "./services/lesson.service";
import { EventService } from "./services/event.service";
import { PublishingService } from "./services/publishing.service";
import { StudentService } from "./services/student.service";

import { CourseRepository } from "./repositories/course.repository";
import { LessonRepository } from "./repositories/lesson.repository";
import { EventRepository } from "./repositories/event.repository";
import { PublishingRepository } from "./repositories/publishing.repository";
import { StudentRepository } from "./repositories/student.repository";

@Module({
  imports: [PrismaModule, SecurityModule],
  controllers: [
    CourseController,
    LessonController,
    EventController,
    PublishingController,
    StudentController,
    AssessmentController,
  ],
  providers: [
    CourseService,
    LessonService,
    EventService,
    PublishingService,
    StudentService,
    CourseRepository,
    LessonRepository,
    EventRepository,
    PublishingRepository,
    StudentRepository,
  ],
  exports: [CourseService, LessonService, EventService],
})
export class LearningModule {}

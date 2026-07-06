import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { EventEmitterModule } from "@nestjs/event-emitter";
import { ThrottlerModule, ThrottlerGuard } from "@nestjs/throttler";
import { APP_GUARD } from "@nestjs/core";
import { PrismaModule } from "./modules/prisma/prisma.module";
import { RedisModule } from "./modules/redis/redis.module";
import { AuthModule } from "./modules/auth/auth.module";
import { IamModule } from "./modules/iam/iam.module";
import { WellnessModule } from "./modules/wellness/wellness.module";
import { SecurityModule } from "./modules/security/security.module";
import { TeacherModule } from "./modules/teacher/teacher.module";
import { LearningModule } from "./modules/learning/learning.module";
import { BookingModule } from "./modules/booking/booking.module";
import { AuthController } from "./modules/auth/controllers/auth.controller";
import { SessionController } from "./modules/auth/controllers/session.controller";
import { AdminAuthController } from "./modules/auth/controllers/admin-auth.controller";
import { StudentModule } from "./modules/student/student.module";
import { SocialModule } from "./modules/social/social.module";
import { CommerceModule } from "./modules/commerce/commerce.module";
import { AiModule } from "./modules/ai/ai.module";
import { AdminModule } from "./modules/admin/admin.module";
import { HealthModule } from "./modules/health/health.module";

@Module({
  imports: [
    // ── Configuration ──────────────────────────────────────────────────────────
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: [".env.local", ".env"],
    }),

    // ── Rate Limiting (global) ─────────────────────────────────────────────────
    // 100 requests per 60s globally; per-route can override with @Throttle()
    ThrottlerModule.forRoot([
      {
        name: "short",
        ttl: 1000, // 1s window
        limit: 10, // 10 req/s burst
      },
      {
        name: "medium",
        ttl: 60000, // 60s window
        limit: 200, // 200 req/min
      },
    ]),

    // ── Core Infrastructure ────────────────────────────────────────────────────
    PrismaModule,
    RedisModule,
    EventEmitterModule.forRoot({
      wildcard: false,
      delimiter: ".",
      maxListeners: 20,
    }),

    // ── Observability ──────────────────────────────────────────────────────────
    HealthModule,

    // ── Business Modules ───────────────────────────────────────────────────────
    AuthModule,
    IamModule,
    WellnessModule,
    SecurityModule,
    TeacherModule,
    LearningModule,
    BookingModule,
    StudentModule,
    SocialModule,
    CommerceModule,
    AiModule,
    AdminModule,
  ],
  controllers: [AuthController, SessionController, AdminAuthController],
  providers: [
    // ── Global Rate Limiting Guard ─────────────────────────────────────────────
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
  ],
})
export class AppModule {}

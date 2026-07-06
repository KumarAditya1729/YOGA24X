// ==============================================================================
// Yoga24X — Health Module (Liveness & Readiness Probes)
// GET /api/v1/health  → liveness (is the process alive?)
// GET /api/v1/ready   → readiness (are all dependencies healthy?)
// ==============================================================================

import { Module } from '@nestjs/common';
import { TerminusModule } from '@nestjs/terminus';
import { HealthController } from './health.controller';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [TerminusModule, PrismaModule],
  controllers: [HealthController],
})
export class HealthModule {}

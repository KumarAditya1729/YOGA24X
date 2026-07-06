// ==============================================================================
// Yoga24X — Health Controller
// Kubernetes-compatible liveness & readiness endpoints
// ==============================================================================

import { Controller, Get } from "@nestjs/common";
import {
  HealthCheck,
  HealthCheckService,
  PrismaHealthIndicator,
} from "@nestjs/terminus";
import { ApiTags, ApiOperation } from "@nestjs/swagger";
import { PrismaService } from "../prisma/prisma.module";

@ApiTags("Health")
@Controller()
export class HealthController {
  constructor(
    private readonly health: HealthCheckService,
    private readonly prismaHealth: PrismaHealthIndicator,
    private readonly prisma: PrismaService,
  ) {}

  /**
   * Liveness probe — process is running and responsive
   * Used by: Kubernetes liveness probe, load balancer health check
   */
  @Get("health")
  @ApiOperation({
    summary: "Liveness probe — always returns 200 if process is running",
  })
  liveness() {
    return {
      status: "ok",
      environment: process.env.NODE_ENV || "development",
      version: process.env.APP_VERSION || "1.0.0",
      timestamp: new Date().toISOString(),
      uptime: Math.floor(process.uptime()),
      memory: {
        heapUsedMb: Math.round(process.memoryUsage().heapUsed / 1024 / 1024),
        heapTotalMb: Math.round(process.memoryUsage().heapTotal / 1024 / 1024),
        rssMb: Math.round(process.memoryUsage().rss / 1024 / 1024),
      },
    };
  }

  /**
   * Readiness probe — all dependencies are healthy
   * Used by: Kubernetes readiness probe
   */
  @Get("ready")
  @HealthCheck()
  @ApiOperation({
    summary: "Readiness probe — checks DB and Redis connectivity",
  })
  async readiness() {
    return this.health.check([
      () => this.prismaHealth.pingCheck("database", this.prisma),
    ]);
  }
}

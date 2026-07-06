// ==============================================================================
// Yoga24X — Security Audit Service
// Persists every authorization decision + security events to PostgreSQL
// Exposes metrics counters for observability
// ==============================================================================
import { Injectable, Logger } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { Counter, Registry } from "prom-client";

interface AuthzDecisionRecord {
  correlationId: string;
  userId?: string;
  tenantId?: string;
  organizationId?: string;
  role?: string;
  permissionKey?: string;
  policyType?: string;
  decision: string;
  decisionReason?: string;
  requestPath?: string;
  requestMethod?: string;
  ipAddress?: string;
  deviceId?: string;
  riskScore?: number;
  contextJson?: Record<string, unknown>;
}

interface SecurityEventRecord {
  correlationId: string;
  tenantId?: string;
  organizationId?: string;
  userId?: string;
  eventType: string;
  severity: "INFO" | "LOW" | "MEDIUM" | "HIGH" | "CRITICAL";
  description: string;
  metaJson?: Record<string, unknown>;
  ipAddress?: string;
  deviceId?: string;
  userAgent?: string;
}

@Injectable()
export class SecurityAuditService {
  private readonly logger = new Logger(SecurityAuditService.name);

  // Prometheus metrics
  private readonly authzDecisionCounter: Counter<string>;
  private readonly securityEventCounter: Counter<string>;

  constructor(private readonly prisma: PrismaService) {
    const register = new Registry();

    this.authzDecisionCounter = new Counter({
      name: "yoga24x_authz_decisions_total",
      help: "Total authorization decisions by outcome",
      labelNames: ["decision", "tenant_id"],
      registers: [register],
    });

    this.securityEventCounter = new Counter({
      name: "yoga24x_security_events_total",
      help: "Total security events by type and severity",
      labelNames: ["event_type", "severity"],
      registers: [register],
    });
  }

  async recordAuthzDecision(data: AuthzDecisionRecord): Promise<void> {
    try {
      await this.prisma.authorizationAuditLog.create({
        data: {
          correlationId: data.correlationId,
          userId: data.userId,
          tenantId: data.tenantId,
          organizationId: data.organizationId,
          role: data.role,
          permissionKey: data.permissionKey,
          policyType: data.policyType as any,
          decision: data.decision as any,
          decisionReason: data.decisionReason,
          requestPath: data.requestPath,
          requestMethod: data.requestMethod,
          ipAddress: data.ipAddress,
          deviceId: data.deviceId,
          riskScore: data.riskScore,
          contextJson: (data.contextJson ?? {}) as any,
        },
      });

      this.authzDecisionCounter.inc({
        decision: data.decision,
        tenant_id: data.tenantId ?? "global",
      });
    } catch (err) {
      // Non-blocking — log but don't fail the request
      this.logger.error("Failed to persist authz audit log", err);
    }
  }

  async recordSecurityEvent(data: SecurityEventRecord): Promise<void> {
    try {
      await this.prisma.securityEventLog.create({
        data: {
          correlationId: data.correlationId,
          tenantId: data.tenantId,
          organizationId: data.organizationId,
          userId: data.userId,
          eventType: data.eventType,
          severity: data.severity as any,
          description: data.description,
          metaJson: (data.metaJson ?? {}) as any,
          ipAddress: data.ipAddress,
          deviceId: data.deviceId,
          userAgent: data.userAgent,
        },
      });

      this.securityEventCounter.inc({
        event_type: data.eventType,
        severity: data.severity,
      });

      if (data.severity === "CRITICAL" || data.severity === "HIGH") {
        this.logger.error(
          `[SECURITY EVENT] ${data.eventType} | ${data.severity} | User: ${data.userId} | Tenant: ${data.tenantId}`,
        );
      }
    } catch (err) {
      this.logger.error("Failed to persist security event", err);
    }
  }

  async getAuditLogs(filters: {
    userId?: string;
    tenantId?: string;
    decision?: string;
    from?: Date;
    to?: Date;
    page?: number;
    limit?: number;
  }) {
    const {
      userId,
      tenantId,
      decision,
      from,
      to,
      page = 1,
      limit = 50,
    } = filters;
    const skip = (page - 1) * limit;

    const where: Record<string, unknown> = {};
    if (userId) where["userId"] = userId;
    if (tenantId) where["tenantId"] = tenantId;
    if (decision) where["decision"] = decision;
    if (from || to) {
      where["createdAt"] = {};
      if (from) (where["createdAt"] as Record<string, unknown>)["gte"] = from;
      if (to) (where["createdAt"] as Record<string, unknown>)["lte"] = to;
    }

    const [items, total] = await Promise.all([
      this.prisma.authorizationAuditLog.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: "desc" },
      }),
      this.prisma.authorizationAuditLog.count({ where }),
    ]);

    return { items, total, page, limit };
  }

  async getSecurityEvents(filters: {
    tenantId?: string;
    severity?: string;
    eventType?: string;
    isAcknowledged?: boolean;
    page?: number;
    limit?: number;
  }) {
    const {
      tenantId,
      severity,
      eventType,
      isAcknowledged,
      page = 1,
      limit = 50,
    } = filters;
    const skip = (page - 1) * limit;

    const where: Record<string, unknown> = {};
    if (tenantId) where["tenantId"] = tenantId;
    if (severity) where["severity"] = severity;
    if (eventType) where["eventType"] = eventType;
    if (isAcknowledged !== undefined) where["isAcknowledged"] = isAcknowledged;

    const [items, total] = await Promise.all([
      this.prisma.securityEventLog.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: "desc" },
      }),
      this.prisma.securityEventLog.count({ where }),
    ]);

    return { items, total, page, limit };
  }

  async acknowledgeEvent(eventId: string, acknowledgedBy: string) {
    return this.prisma.securityEventLog.update({
      where: { id: eventId },
      data: {
        isAcknowledged: true,
        acknowledgedBy,
        acknowledgedAt: new Date(),
      },
    });
  }
}

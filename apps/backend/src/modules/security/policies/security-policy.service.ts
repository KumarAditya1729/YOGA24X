// ==============================================================================
// Yoga24X — Security Policy Service
// Enforces password/OTP/device/session/API/upload/media/AI usage policies
// ==============================================================================
import { Injectable, BadRequestException } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { RedisService } from "../../redis/redis.module";

@Injectable()
export class SecurityPolicyService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly redis: RedisService,
  ) {}

  async getActivePolicies(tenantId?: string) {
    return this.prisma.securityPolicy.findMany({
      where: {
        isEnabled: true,
        OR: [{ tenantId: tenantId ?? null }, { tenantId: null }],
      },
      orderBy: { priority: "asc" },
    });
  }

  async createPolicy(data: {
    name: string;
    description?: string;
    policyType: string;
    action: string;
    rulesJson: Record<string, unknown>;
    priority?: number;
    tenantId?: string;
    organizationId?: string;
    appliesTo?: unknown[];
    createdBy: string;
  }) {
    return this.prisma.securityPolicy.create({
      data: {
        name: data.name,
        description: data.description,
        policyType: data.policyType as any,
        action: data.action as any,
        rulesJson: data.rulesJson as any,
        priority: data.priority ?? 100,
        tenantId: data.tenantId,
        organizationId: data.organizationId,
        appliesTo: (data.appliesTo ?? []) as any,
        createdBy: data.createdBy,
      },
    });
  }

  async updatePolicy(
    id: string,
    data: Partial<{
      name: string;
      rulesJson: Record<string, unknown>;
      isEnabled: boolean;
      priority: number;
    }>,
  ) {
    return this.prisma.securityPolicy.update({
      where: { id },
      data: data as any,
    });
  }

  async deletePolicy(id: string) {
    return this.prisma.securityPolicy.delete({ where: { id } });
  }

  // ── Password Policy Validation ─────────────────────────────────────────────

  validatePasswordComplexity(
    password: string,
    tenantConfig?: Record<string, unknown>,
  ): void {
    const minLength = (tenantConfig?.["passwordMinLength"] as number) ?? 8;
    const requireUppercase =
      (tenantConfig?.["passwordRequireUppercase"] as boolean) ?? true;
    const requireNumber =
      (tenantConfig?.["passwordRequireNumber"] as boolean) ?? true;
    const requireSpecial =
      (tenantConfig?.["passwordRequireSpecial"] as boolean) ?? true;

    if (password.length < minLength) {
      throw new BadRequestException(
        `Password must be at least ${minLength} characters`,
      );
    }
    if (requireUppercase && !/[A-Z]/.test(password)) {
      throw new BadRequestException(
        "Password must contain at least one uppercase letter",
      );
    }
    if (requireNumber && !/\d/.test(password)) {
      throw new BadRequestException(
        "Password must contain at least one number",
      );
    }
    if (
      requireSpecial &&
      !/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)
    ) {
      throw new BadRequestException(
        "Password must contain at least one special character",
      );
    }
  }

  // ── OTP Rate Limiting ─────────────────────────────────────────────────────

  async checkOtpRateLimit(
    identifier: string,
    tenantId?: string,
  ): Promise<void> {
    const key = `otp:ratelimit:${tenantId ?? "global"}:${identifier}`;
    const count = await this.redis.incr(key);
    if (count === 1) await this.redis.expire(key, 3600); // 1 hour window
    const maxAttempts = 5;
    if (count > maxAttempts) {
      throw new BadRequestException(
        "OTP rate limit exceeded. Try again in 1 hour.",
      );
    }
  }

  // ── Device Session Limits ─────────────────────────────────────────────────

  async checkDeviceSessionLimit(
    userId: string,
    tenantConfig?: Record<string, unknown>,
  ): Promise<void> {
    const maxSessions =
      (tenantConfig?.["maxConcurrentSessions"] as number) ?? 5;
    const activeSessions = await this.prisma.userSession.count({
      where: { userId, isActive: true },
    });
    if (activeSessions >= maxSessions) {
      throw new BadRequestException(
        `Maximum concurrent sessions (${maxSessions}) reached. Please sign out from another device.`,
      );
    }
  }

  // ── Upload Policy Validation ──────────────────────────────────────────────

  validateUpload(
    fileSizeBytes: number,
    mimeType: string,
    tenantConfig?: Record<string, unknown>,
  ): void {
    const maxSizeMB = (tenantConfig?.["maxUploadSizeMB"] as number) ?? 50;
    const allowedMimeTypes = (tenantConfig?.[
      "allowedMimeTypes"
    ] as string[]) ?? [
      "image/jpeg",
      "image/png",
      "image/webp",
      "video/mp4",
      "application/pdf",
    ];

    if (fileSizeBytes > maxSizeMB * 1024 * 1024) {
      throw new BadRequestException(
        `File size exceeds maximum allowed size of ${maxSizeMB}MB`,
      );
    }
    if (!allowedMimeTypes.includes(mimeType)) {
      throw new BadRequestException(`File type '${mimeType}' is not allowed`);
    }
  }
}

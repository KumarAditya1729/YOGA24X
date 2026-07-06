// ==============================================================================
// Yoga24X — Tenant Service
// Repository-level tenant data access — business services NEVER filter manually
// ==============================================================================
import { Injectable, NotFoundException, Logger } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { TenantContext } from "./tenant.context";
import { RedisService } from "../../redis/redis.module";

const TENANT_CACHE_TTL = 300; // 5 minutes
const TENANT_CACHE_PREFIX = "tenant:ctx:";

@Injectable()
export class TenantService {
  private readonly logger = new Logger(TenantService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly redis: RedisService,
  ) {}

  async resolveById(tenantId: string): Promise<TenantContext | null> {
    const cacheKey = `${TENANT_CACHE_PREFIX}id:${tenantId}`;
    return this.resolveWithCache(cacheKey, () =>
      this.prisma.tenant.findUnique({ where: { id: tenantId } }),
    );
  }

  async resolveByDomain(domain: string): Promise<TenantContext | null> {
    const cacheKey = `${TENANT_CACHE_PREFIX}domain:${domain}`;
    return this.resolveWithCache(cacheKey, () =>
      this.prisma.tenant.findFirst({
        where: {
          OR: [{ customDomain: domain }, { slug: domain.split(".")[0] }],
        },
      }),
    );
  }

  async resolveBySlug(slug: string): Promise<TenantContext | null> {
    const cacheKey = `${TENANT_CACHE_PREFIX}slug:${slug}`;
    return this.resolveWithCache(cacheKey, () =>
      this.prisma.tenant.findUnique({ where: { slug } }),
    );
  }

  async findById(tenantId: string) {
    const tenant = await this.prisma.tenant.findUnique({
      where: { id: tenantId },
    });
    if (!tenant) throw new NotFoundException(`Tenant ${tenantId} not found`);
    return tenant;
  }

  async create(data: {
    name: string;
    slug: string;
    plan?: string;
    brandingJson?: Record<string, unknown>;
    configJson?: Record<string, unknown>;
  }) {
    return this.prisma.tenant.create({
      data: {
        name: data.name,
        slug: data.slug,
        plan: data.plan ?? "FREE",
        brandingJson: (data.brandingJson ?? {}) as any,
        configJson: (data.configJson ?? {}) as any,
        status: "PROVISIONING",
      },
    });
  }

  async updateBranding(
    tenantId: string,
    brandingJson: Record<string, unknown>,
  ) {
    await this.invalidateCache(tenantId);
    return this.prisma.tenant.update({
      where: { id: tenantId },
      data: { brandingJson: brandingJson as any },
    });
  }

  async updateConfig(tenantId: string, configJson: Record<string, unknown>) {
    await this.invalidateCache(tenantId);
    return this.prisma.tenant.update({
      where: { id: tenantId },
      data: { configJson: configJson as any },
    });
  }

  async suspend(tenantId: string) {
    await this.invalidateCache(tenantId);
    return this.prisma.tenant.update({
      where: { id: tenantId },
      data: { status: "SUSPENDED" },
    });
  }

  async activate(tenantId: string) {
    await this.invalidateCache(tenantId);
    return this.prisma.tenant.update({
      where: { id: tenantId },
      data: { status: "ACTIVE" },
    });
  }

  async listAll(page = 1, limit = 20) {
    const skip = (page - 1) * limit;
    const [items, total] = await Promise.all([
      this.prisma.tenant.findMany({
        skip,
        take: limit,
        orderBy: { createdAt: "desc" },
      }),
      this.prisma.tenant.count(),
    ]);
    return { items, total, page, limit };
  }

  // ── Cache Helpers ─────────────────────────────────────────────────────────

  private async resolveWithCache(
    cacheKey: string,
    fetchFn: () => Promise<Record<string, unknown> | null>,
  ): Promise<TenantContext | null> {
    try {
      const cached = await this.redis.get(cacheKey);
      if (cached) return JSON.parse(cached) as TenantContext;
    } catch {
      this.logger.warn(`Redis cache miss for key: ${cacheKey}`);
    }

    const tenant = await fetchFn();
    if (!tenant) return null;

    const ctx: TenantContext = {
      tenantId: tenant["id"] as string,
      tenantSlug: tenant["slug"] as string,
      status: tenant["status"] as string,
      plan: tenant["plan"] as string,
      configJson: (tenant["configJson"] ?? {}) as Record<string, unknown>,
      brandingJson: (tenant["brandingJson"] ?? {}) as Record<string, unknown>,
      securityConfigJson: (tenant["securityConfigJson"] ?? {}) as Record<
        string,
        unknown
      >,
    };

    try {
      await this.redis.setex(cacheKey, TENANT_CACHE_TTL, JSON.stringify(ctx));
    } catch {
      this.logger.warn("Failed to cache tenant context in Redis");
    }

    return ctx;
  }

  private async invalidateCache(tenantId: string) {
    try {
      await this.redis.del(`${TENANT_CACHE_PREFIX}id:${tenantId}`);
    } catch {
      // Non-critical
    }
  }
}

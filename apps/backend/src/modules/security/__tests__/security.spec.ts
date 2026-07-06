// ==============================================================================
// Yoga24X — Backend Security Unit & Integration Tests
// Tests: RBAC inheritance, ABAC policy evaluation, tenant isolation,
//        feature flag rollout, audit logging
// ==============================================================================
import { Test, TestingModule } from '@nestjs/testing';
import { AuthorizationEngineService } from '../authorization/authorization-engine.service';
import { SecurityAuditService } from '../authorization/security-audit.service';
import { FeatureFlagService } from '../feature-flags/feature-flags.service';
import { RbacService } from '../rbac/rbac.service';
import { PrismaService } from '../../prisma/prisma.module';
import { RedisService } from '../../redis/redis.module';
import { PERMISSIONS } from '../constants/permissions.registry';
import { AuthorizationContext } from '../interfaces/authorization-context.interface';
import { randomUUID } from 'crypto';

// ── Mock factories ─────────────────────────────────────────────────────────────

const mockPrisma = {
  permission: { findFirst: jest.fn() },
  userPermissionOverride: { findFirst: jest.fn() },
  securityPolicy: { findMany: jest.fn().mockResolvedValue([]) },
  userRole: { findMany: jest.fn(), create: jest.fn(), deleteMany: jest.fn(), findFirst: jest.fn() },
  role: { findUnique: jest.fn() },
  authorizationAuditLog: { create: jest.fn().mockResolvedValue({}), findMany: jest.fn(), count: jest.fn() },
  securityEventLog: { create: jest.fn().mockResolvedValue({}), findMany: jest.fn(), count: jest.fn(), update: jest.fn() },
  tenantFeatureFlag: { findMany: jest.fn(), findFirst: jest.fn(), create: jest.fn(), update: jest.fn(), updateMany: jest.fn() },
  featureFlag: { findUnique: jest.fn() },
};

const mockRedis = {
  get: jest.fn().mockResolvedValue(null),
  setex: jest.fn().mockResolvedValue('OK'),
  del: jest.fn().mockResolvedValue(1),
  incr: jest.fn().mockResolvedValue(1),
  expire: jest.fn().mockResolvedValue(1),
};

function makeAuthzCtx(overrides: Partial<AuthorizationContext> = {}): AuthorizationContext {
  return {
    userId: randomUUID(),
    tenantId: randomUUID(),
    roles: ['STUDENT'],
    permissions: [],
    correlationId: randomUUID(),
    riskScore: 0,
    deviceTrust: 'TRUSTED',
    subscriptionTier: 'FREE',
    currentHour: 10,
    ...overrides,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// RBAC Tests
// ─────────────────────────────────────────────────────────────────────────────

describe('AuthorizationEngineService — RBAC', () => {
  let engine: AuthorizationEngineService;
  let audit: SecurityAuditService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthorizationEngineService,
        SecurityAuditService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: RedisService, useValue: mockRedis },
      ],
    })
      .overrideProvider(PrismaService).useValue(mockPrisma)
      .overrideProvider(RedisService).useValue(mockRedis)
      .compile();

    engine = module.get<AuthorizationEngineService>(AuthorizationEngineService);
    audit = module.get<SecurityAuditService>(SecurityAuditService);
    jest.clearAllMocks();
    mockPrisma.userPermissionOverride.findFirst.mockResolvedValue(null);
    mockPrisma.securityPolicy.findMany.mockResolvedValue([]);
  });

  it('STUDENT role should have courses:read permission (inherited from GUEST)', async () => {
    const ctx = makeAuthzCtx({ roles: ['STUDENT'] });
    const result = await engine.evaluate(ctx, PERMISSIONS.COURSES_READ);
    expect(result.permitted).toBe(true);
    expect(result.decision).toBe('PERMITTED');
  });

  it('STUDENT role should NOT have security:roles_manage permission', async () => {
    const ctx = makeAuthzCtx({ roles: ['STUDENT'] });
    const result = await engine.evaluate(ctx, PERMISSIONS.SECURITY_ROLES_MANAGE);
    expect(result.permitted).toBe(false);
    expect(result.decision).toBe('DENIED_PERMISSION');
  });

  it('SUPER_ADMIN inherits all PLATFORM_ADMIN permissions', async () => {
    const ctx = makeAuthzCtx({ roles: ['SUPER_ADMIN'] });
    const result = await engine.evaluate(ctx, PERMISSIONS.TENANTS_SUSPEND);
    expect(result.permitted).toBe(true);
  });

  it('TEACHER inherits STUDENT permissions (can enroll in courses)', async () => {
    const ctx = makeAuthzCtx({ roles: ['TEACHER'] });
    const result = await engine.evaluate(ctx, PERMISSIONS.COURSES_ENROLL);
    expect(result.permitted).toBe(true);
  });

  it('DOCTOR can access health:read_any but not courses:grade', async () => {
    const ctx = makeAuthzCtx({ roles: ['DOCTOR'] });
    const healthResult = await engine.evaluate(ctx, PERMISSIONS.HEALTH_READ_ANY);
    expect(healthResult.permitted).toBe(true);

    const gradeResult = await engine.evaluate(ctx, PERMISSIONS.COURSES_GRADE);
    expect(gradeResult.permitted).toBe(false);
  });

  it('Every evaluate() call produces an audit log entry', async () => {
    const auditSpy = jest.spyOn(audit, 'recordAuthzDecision');
    const ctx = makeAuthzCtx({ roles: ['STUDENT'] });
    await engine.evaluate(ctx, PERMISSIONS.COURSES_READ);
    expect(auditSpy).toHaveBeenCalledTimes(1);
    expect(auditSpy).toHaveBeenCalledWith(
      expect.objectContaining({
        correlationId: ctx.correlationId,
        userId: ctx.userId,
        tenantId: ctx.tenantId,
        decision: 'PERMITTED',
        permissionKey: PERMISSIONS.COURSES_READ,
      }),
    );
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// Permission Override Tests (6 states)
// ─────────────────────────────────────────────────────────────────────────────

describe('AuthorizationEngineService — Permission Overrides', () => {
  let engine: AuthorizationEngineService;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [
        AuthorizationEngineService,
        SecurityAuditService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: RedisService, useValue: mockRedis },
      ],
    }).compile();

    engine = module.get<AuthorizationEngineService>(AuthorizationEngineService);
    jest.clearAllMocks();
    mockPrisma.securityPolicy.findMany.mockResolvedValue([]);
  });

  it('DENY override blocks access even when role grants permission', async () => {
    mockPrisma.permission.findFirst.mockResolvedValue({ id: 'perm-uuid' });
    mockPrisma.userPermissionOverride.findFirst.mockResolvedValue({
      effect: 'DENY',
      state: 'OVERRIDDEN',
      reason: 'Suspended by admin',
      expiresAt: null,
      conditionJson: null,
    });

    const ctx = makeAuthzCtx({ roles: ['TEACHER'] });
    const result = await engine.evaluate(ctx, PERMISSIONS.COURSES_GRADE);
    expect(result.permitted).toBe(false);
    expect(result.decision).toBe('DENIED_PERMISSION');
    expect(result.appliedOverrides).toContain('override:DENY');
  });

  it('TEMPORARY override respects expiresAt — expired override does not apply', async () => {
    mockPrisma.permission.findFirst.mockResolvedValue({ id: 'perm-uuid' });
    mockPrisma.userPermissionOverride.findFirst.mockResolvedValue({
      effect: 'DENY',
      state: 'TEMPORARY',
      reason: 'Temporary suspension',
      expiresAt: new Date(Date.now() - 3600 * 1000), // expired 1 hour ago
      conditionJson: null,
    });

    const ctx = makeAuthzCtx({ roles: ['TEACHER'] });
    // Expired DENY override → should fall through to base RBAC (ALLOW for TEACHER)
    const result = await engine.evaluate(ctx, PERMISSIONS.COURSES_GRADE);
    expect(result.permitted).toBe(true);
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// ABAC Policy Engine Tests
// ─────────────────────────────────────────────────────────────────────────────

describe('AuthorizationEngineService — ABAC Policies', () => {
  let engine: AuthorizationEngineService;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [
        AuthorizationEngineService,
        SecurityAuditService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: RedisService, useValue: mockRedis },
      ],
    }).compile();

    engine = module.get<AuthorizationEngineService>(AuthorizationEngineService);
    jest.clearAllMocks();
    mockPrisma.userPermissionOverride.findFirst.mockResolvedValue(null);
  });

  it('LOCATION policy blocks access from blocked country', async () => {
    mockPrisma.securityPolicy.findMany.mockResolvedValue([{
      name: 'Block Sanctioned Countries',
      policyType: 'LOCATION',
      action: 'DENY',
      priority: 10,
      rulesJson: { blockedCountries: ['KP', 'IR', 'CU'], permissions: ['*'] },
    }]);

    const ctx = makeAuthzCtx({ roles: ['STUDENT'], countryCode: 'KP' });
    const result = await engine.evaluate(ctx, PERMISSIONS.COURSES_READ);
    expect(result.permitted).toBe(false);
    expect(result.decision).toBe('DENIED_POLICY');
  });

  it('RISK_SCORE policy enforces MFA for high-risk users', async () => {
    mockPrisma.securityPolicy.findMany.mockResolvedValue([{
      name: 'High Risk MFA Required',
      policyType: 'RISK_SCORE',
      action: 'ENFORCE_MFA',
      priority: 20,
      rulesJson: { maxRiskScore: 50, permissions: ['*'] },
    }]);

    const ctx = makeAuthzCtx({ roles: ['STUDENT'], riskScore: 75 });
    const result = await engine.evaluate(ctx, PERMISSIONS.COURSES_READ);
    expect(result.permitted).toBe(false);
    expect(result.decision).toBe('MFA_REQUIRED');
  });

  it('TIME_BASED policy denies access outside allowed hours', async () => {
    mockPrisma.securityPolicy.findMany.mockResolvedValue([{
      name: 'Business Hours Only',
      policyType: 'TIME_BASED',
      action: 'DENY',
      priority: 30,
      rulesJson: { allowedHours: [9, 18], permissions: ['security:*'] },
    }]);

    const ctx = makeAuthzCtx({
      roles: ['PLATFORM_ADMIN'],
      currentHour: 23, // Outside business hours
    });
    const result = await engine.evaluate(ctx, PERMISSIONS.SECURITY_AUDIT_READ);
    expect(result.permitted).toBe(false);
    expect(result.decision).toBe('DENIED_POLICY');
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// Feature Flag Tests
// ─────────────────────────────────────────────────────────────────────────────

describe('FeatureFlagService', () => {
  let flagService: FeatureFlagService;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [
        FeatureFlagService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: RedisService, useValue: mockRedis },
      ],
    }).compile();

    flagService = module.get<FeatureFlagService>(FeatureFlagService);
    jest.clearAllMocks();
    mockPrisma.featureFlag.findUnique.mockResolvedValue(null);
  });

  it('kill switch overrides enabled flag to disabled', async () => {
    mockPrisma.tenantFeatureFlag.findMany.mockResolvedValue([{
      key: 'ai_pose_coach',
      scope: 'TENANT',
      isEnabled: true,
      killSwitch: true, // Kill switch active
      rolloutPercentage: 100,
      targetRolesJson: null,
      scheduledEnableAt: null,
      scheduledDisableAt: null,
      configJson: null,
    }]);

    const result = await flagService.evaluate('ai_pose_coach', { tenantId: 'tenant-1' });
    expect(result.enabled).toBe(false);
    expect(result.source).toBe('kill_switch');
  });

  it('Scheduled disable disables flag after expiry date', async () => {
    const past = new Date(Date.now() - 3600 * 1000);
    mockPrisma.tenantFeatureFlag.findMany.mockResolvedValue([{
      key: 'beta_nutrition',
      scope: 'GLOBAL',
      isEnabled: true,
      killSwitch: false,
      rolloutPercentage: 100,
      targetRolesJson: null,
      scheduledEnableAt: null,
      scheduledDisableAt: past, // Already expired
      configJson: null,
    }]);

    const result = await flagService.evaluate('beta_nutrition', {});
    expect(result.enabled).toBe(false);
    expect(result.source).toBe('scheduled');
  });

  it('Percentage rollout produces deterministic consistent results for same user', async () => {
    mockPrisma.tenantFeatureFlag.findMany.mockResolvedValue([{
      key: 'new_dashboard',
      scope: 'TENANT',
      isEnabled: true,
      killSwitch: false,
      rolloutPercentage: 50,
      rolloutSeed: 'dashboard-v2',
      targetRolesJson: null,
      scheduledEnableAt: null,
      scheduledDisableAt: null,
      configJson: null,
    }]);

    const userId = 'user-fixed-uuid-123';
    const result1 = await flagService.evaluate('new_dashboard', { userId, tenantId: 't1' });
    // Reset cache to force re-evaluation
    mockRedis.get.mockResolvedValueOnce(null);
    const result2 = await flagService.evaluate('new_dashboard', { userId, tenantId: 't1' });
    expect(result1.enabled).toBe(result2.enabled); // Deterministic
  });
});

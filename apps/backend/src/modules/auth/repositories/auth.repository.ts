// ==============================================================================
// Yoga24X AI Engineering OS — Auth Repository (Prisma Data Access)
// ==============================================================================

import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';
import { User, UserIdentity, RefreshToken, UserSession, UserDevice, TrustedDevice, LoginHistory, OtpVerification, SecurityBlockedIp, AuditLog, Prisma, UserStatus } from '@prisma/client';
import { IdentityProviderType, UserRoleName } from '@yoga24x/shared-types';

@Injectable()
export class AuthRepository {
  constructor(private readonly prisma: PrismaService) {}

  // ============================================================================
  // User Queries & Mutations
  // ============================================================================

  async findUserById(id: string): Promise<any | null> {
    return this.prisma.user.findUnique({
      where: { id },
      include: {
        userRoles: { include: { role: true } },
        identities: true,
      },
    });
  }

  async findUserByEmail(email: string): Promise<any | null> {
    return this.prisma.user.findUnique({
      where: { email: email.toLowerCase() },
      include: {
        userRoles: { include: { role: true } },
        identities: true,
      },
    });
  }

  async findUserByPhone(phoneNumber: string): Promise<any | null> {
    return this.prisma.user.findUnique({
      where: { phoneNumber },
      include: {
        userRoles: { include: { role: true } },
        identities: true,
      },
    });
  }

  async findUserByIdentity(provider: string, providerId: string): Promise<any | null> {
    const identity = await this.prisma.userIdentity.findUnique({
      where: {
        uq_identities_provider_id: {
          provider: provider as any,
          providerId,
        },
      },
      include: {
        user: {
          include: {
            userRoles: { include: { role: true } },
            identities: true,
          },
        },
      },
    });
    return identity ? identity.user : null;
  }

  async createUser(data: {
    email: string;
    phoneNumber?: string;
    passwordHash?: string;
    firstName: string;
    lastName: string;
    status?: UserStatus;
    isEmailVerified?: boolean;
    isPhoneVerified?: boolean;
    roleName: UserRoleName;
    provider?: string;
    providerId?: string;
    profileDataJson?: any;
  }): Promise<User> {
    return this.prisma.$transaction(async (tx) => {
      // 1. Create User
      const user = await tx.user.create({
        data: {
          email: data.email.toLowerCase(),
          phoneNumber: data.phoneNumber || null,
          passwordHash: data.passwordHash || null,
          firstName: data.firstName,
          lastName: data.lastName,
          status: data.status || UserStatus.ACTIVE,
          isEmailVerified: data.isEmailVerified || false,
          isPhoneVerified: data.isPhoneVerified || false,
        },
      });

      // 2. Assign Role
      const role = await tx.role.findUnique({ where: { name: data.roleName } });
      if (role) {
        await tx.userRole.create({
          data: {
            userId: user.id,
            roleId: role.id,
          },
        });
      }

      // 3. Create Identity
      if (data.provider && data.providerId) {
        await tx.userIdentity.create({
          data: {
            userId: user.id,
            provider: data.provider as any,
            providerId: data.providerId,
            profileDataJson: data.profileDataJson || {},
          },
        });
      } else {
        await tx.userIdentity.create({
          data: {
            userId: user.id,
            provider: 'EMAIL',
            providerId: data.email.toLowerCase(),
          },
        });
        if (data.phoneNumber) {
          await tx.userIdentity.create({
            data: {
              userId: user.id,
              provider: 'PHONE',
              providerId: data.phoneNumber,
            },
          });
        }
      }

      // 4. Create StudentProfile & Wallet if STUDENT
      if (data.roleName === 'STUDENT') {
        await tx.studentProfile.create({
          data: {
            userId: user.id,
          },
        });
        await tx.wallet.create({
          data: {
            userId: user.id,
            balanceCents: 0,
            currency: 'INR',
          },
        });
      }

      // 5. Create InstructorProfile if TEACHER
      if (data.roleName === 'TEACHER') {
        await tx.instructorProfile.create({
          data: {
            userId: user.id,
            bio: 'Certified Instructor at Yoga24X.',
            yearsExperience: 1,
            specializations: ['Hatha'],
          },
        });
      }

      return user;
    });
  }

  async updateUserStatus(userId: string, status: UserStatus): Promise<User> {
    return this.prisma.user.update({
      where: { id: userId },
      data: { status },
    });
  }

  async updatePasswordHash(userId: string, passwordHash: string): Promise<User> {
    return this.prisma.user.update({
      where: { id: userId },
      data: { passwordHash },
    });
  }

  async markEmailVerified(userId: string): Promise<User> {
    return this.prisma.user.update({
      where: { id: userId },
      data: { isEmailVerified: true },
    });
  }

  async markPhoneVerified(userId: string): Promise<User> {
    return this.prisma.user.update({
      where: { id: userId },
      data: { isPhoneVerified: true },
    });
  }

  // ============================================================================
  // Refresh Token Queries
  // ============================================================================

  async createRefreshToken(data: {
    userId: string;
    tokenHash: string;
    familyId: string;
    expiresAt: Date;
  }): Promise<RefreshToken> {
    return this.prisma.refreshToken.create({
      data: {
        userId: data.userId,
        tokenHash: data.tokenHash,
        familyId: data.familyId,
        expiresAt: data.expiresAt,
        isRevoked: false,
      },
    });
  }

  async findRefreshTokenByHash(tokenHash: string): Promise<RefreshToken | null> {
    return this.prisma.refreshToken.findUnique({
      where: { tokenHash },
    });
  }

  async revokeRefreshTokenFamily(familyId: string): Promise<Prisma.BatchPayload> {
    return this.prisma.refreshToken.updateMany({
      where: { familyId },
      data: { isRevoked: true },
    });
  }

  async revokeAllUserRefreshTokens(userId: string): Promise<Prisma.BatchPayload> {
    return this.prisma.refreshToken.updateMany({
      where: { userId, isRevoked: false },
      data: { isRevoked: true },
    });
  }

  // ============================================================================
  // Session & Device Queries
  // ============================================================================

  async upsertDevice(data: {
    userId: string;
    deviceType: string;
    deviceFingerprint?: string;
    osVersion?: string;
    appVersion?: string;
    fcmToken?: string;
    ipAddress?: string;
  }): Promise<UserDevice> {
    // If fcmToken is provided, try to find by fcmToken, else find first by user and type
    if (data.fcmToken) {
      return this.prisma.userDevice.upsert({
        where: { fcmToken: data.fcmToken },
        update: {
          lastIp: data.ipAddress || null,
          osVersion: data.osVersion || null,
          appVersion: data.appVersion || null,
        },
        create: {
          userId: data.userId,
          deviceType: data.deviceType,
          fcmToken: data.fcmToken,
          osVersion: data.osVersion || null,
          appVersion: data.appVersion || null,
          lastIp: data.ipAddress || null,
        },
      });
    }

    const existing = await this.prisma.userDevice.findFirst({
      where: { userId: data.userId, deviceType: data.deviceType },
    });

    if (existing) {
      return this.prisma.userDevice.update({
        where: { id: existing.id },
        data: {
          lastIp: data.ipAddress || null,
          osVersion: data.osVersion || null,
          appVersion: data.appVersion || null,
        },
      });
    }

    return this.prisma.userDevice.create({
      data: {
        userId: data.userId,
        deviceType: data.deviceType,
        osVersion: data.osVersion || null,
        appVersion: data.appVersion || null,
        lastIp: data.ipAddress || null,
      },
    });
  }

  async createSession(data: {
    userId: string;
    deviceId?: string;
    ipAddress: string;
    userAgent: string;
  }): Promise<UserSession> {
    return this.prisma.userSession.create({
      data: {
        userId: data.userId,
        deviceId: data.deviceId || null,
        ipAddress: data.ipAddress,
        userAgent: data.userAgent,
        isActive: true,
      },
    });
  }

  async findActiveSessionById(sessionId: string): Promise<UserSession | null> {
    return this.prisma.userSession.findUnique({
      where: { id: sessionId },
    });
  }

  async revokeSession(sessionId: string): Promise<UserSession> {
    return this.prisma.userSession.update({
      where: { id: sessionId },
      data: { isActive: false },
    });
  }

  async revokeAllUserSessions(userId: string): Promise<Prisma.BatchPayload> {
    return this.prisma.userSession.updateMany({
      where: { userId, isActive: true },
      data: { isActive: false },
    });
  }

  async listActiveSessions(userId: string): Promise<any[]> {
    return this.prisma.userSession.findMany({
      where: { userId, isActive: true },
      orderBy: { lastActiveAt: 'desc' },
      include: { device: true },
    });
  }

  // ============================================================================
  // Trusted Devices & Biometric Queries
  // ============================================================================

  async findTrustedDeviceByFingerprint(fingerprint: string): Promise<TrustedDevice | null> {
    return this.prisma.trustedDevice.findUnique({
      where: { deviceFingerprint: fingerprint },
    });
  }

  async upsertTrustedDevice(data: {
    userId: string;
    deviceId?: string;
    deviceFingerprint: string;
    deviceName: string;
    publicKey?: string;
  }): Promise<TrustedDevice> {
    return this.prisma.trustedDevice.upsert({
      where: { deviceFingerprint: data.deviceFingerprint },
      update: {
        lastUsedAt: new Date(),
        isRevoked: false,
        publicKey: data.publicKey || undefined,
      },
      create: {
        userId: data.userId,
        deviceId: data.deviceId || null,
        deviceFingerprint: data.deviceFingerprint,
        deviceName: data.deviceName,
        publicKey: data.publicKey || null,
        isRevoked: false,
      },
    });
  }

  async revokeTrustedDevice(fingerprint: string): Promise<TrustedDevice> {
    return this.prisma.trustedDevice.update({
      where: { deviceFingerprint: fingerprint },
      data: { isRevoked: true },
    });
  }

  async listTrustedDevices(userId: string): Promise<TrustedDevice[]> {
    return this.prisma.trustedDevice.findMany({
      where: { userId, isRevoked: false },
      orderBy: { lastUsedAt: 'desc' },
    });
  }

  // ============================================================================
  // OTP Queries
  // ============================================================================

  async createOtpVerification(data: {
    identifier: string;
    otpHash: string;
    purpose: string;
    expiresAt: Date;
  }): Promise<OtpVerification> {
    return this.prisma.otpVerification.create({
      data: {
        identifier: data.identifier,
        otpHash: data.otpHash,
        purpose: data.purpose as any,
        expiresAt: data.expiresAt,
        attempts: 0,
        isUsed: false,
      },
    });
  }

  async findLatestValidOtp(identifier: string, purpose: string): Promise<OtpVerification | null> {
    return this.prisma.otpVerification.findFirst({
      where: {
        identifier,
        purpose: purpose as any,
        isUsed: false,
        expiresAt: { gt: new Date() },
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  async incrementOtpAttempts(id: string): Promise<OtpVerification> {
    return this.prisma.otpVerification.update({
      where: { id },
      data: { attempts: { increment: 1 } },
    });
  }

  async markOtpUsed(id: string): Promise<OtpVerification> {
    return this.prisma.otpVerification.update({
      where: { id },
      data: { isUsed: true },
    });
  }

  // ============================================================================
  // Security Audit & Login History
  // ============================================================================

  async createLoginHistory(data: {
    userId: string;
    loginStatus: string;
    ipAddress?: string;
    userAgent?: string;
    location?: string;
    deviceType?: string;
    riskScore: number;
    failureReason?: string;
  }): Promise<LoginHistory> {
    return this.prisma.loginHistory.create({
      data: {
        userId: data.userId,
        loginStatus: data.loginStatus as any,
        ipAddress: data.ipAddress || null,
        userAgent: data.userAgent || null,
        location: data.location || 'Unknown',
        deviceType: data.deviceType || 'WEB_BROWSER',
        riskScore: data.riskScore,
        failureReason: data.failureReason || null,
      },
    });
  }

  async listRecentLoginHistory(userId: string, limit = 20): Promise<LoginHistory[]> {
    return this.prisma.loginHistory.findMany({
      where: { userId },
      orderBy: { loginAt: 'desc' },
      take: limit,
    });
  }

  async createAuditLog(data: {
    actorId?: string;
    action: string;
    entityType: string;
    entityId: string;
    oldValuesJson?: any;
    newValuesJson?: any;
    ipAddress?: string;
  }): Promise<AuditLog> {
    return this.prisma.auditLog.create({
      data: {
        actorId: data.actorId || null,
        action: data.action,
        entityType: data.entityType,
        entityId: data.entityId,
        oldValuesJson: data.oldValuesJson || null,
        newValuesJson: data.newValuesJson || null,
        ipAddress: data.ipAddress || null,
      },
    });
  }

  async checkIpBlocked(ipAddress: string): Promise<SecurityBlockedIp | null> {
    return this.prisma.securityBlockedIp.findFirst({
      where: {
        ipAddress,
        OR: [{ expiresAt: null }, { expiresAt: { gt: new Date() } }],
      },
    });
  }
}

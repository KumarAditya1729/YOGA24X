// ==============================================================================
// Yoga24X AI Engineering OS — Token Service (RS256 JWT + Refresh Family Rotation)
// ==============================================================================

import { Injectable, UnauthorizedException, ForbiddenException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as crypto from 'crypto';
import { RedisService } from '../../redis/redis.module';
import { AuthRepository } from '../repositories/auth.repository';
import { AUTH_CONSTANTS, JwtAccessPayload, JwtRefreshPayload, UserRoleName } from '@yoga24x/shared-types';

@Injectable()
export class TokenService {
  constructor(
    private readonly jwtService: JwtService,
    private readonly redisService: RedisService,
    private readonly authRepository: AuthRepository,
  ) {}

  // ============================================================================
  // Generate Access Token (Short-Lived RS256 JWT)
  // ============================================================================

  async generateAccessToken(user: {
    id: string;
    email: string;
    roles: UserRoleName[];
    tenantId: string | null;
  }, sessionId: string, deviceId: string | null): Promise<{ accessToken: string; jti: string; expiresIn: number }> {
    const jti = crypto.randomUUID();
    const expiresIn = AUTH_CONSTANTS.ACCESS_TOKEN_TTL_SECONDS;

    const payload: JwtAccessPayload = {
      sub: user.id,
      email: user.email,
      roles: user.roles,
      tenantId: user.tenantId,
      sessionId,
      deviceId,
      jti,
      iat: Math.floor(Date.now() / 1000),
      exp: Math.floor(Date.now() / 1000) + expiresIn,
    };

    const accessToken = await this.jwtService.signAsync(payload);
    return { accessToken, jti, expiresIn };
  }

  // ============================================================================
  // Generate Refresh Token (Opaque SHA-256 Hashed + Family Rotation)
  // ============================================================================

  async generateRefreshToken(userId: string, sessionId: string, deviceId: string | null, familyId?: string): Promise<{ refreshToken: string; familyId: string; expiresAt: Date }> {
    const rawToken = crypto.randomBytes(40).toString('hex');
    const tokenHash = crypto.createHash('sha256').update(rawToken).digest('hex');
    const activeFamilyId = familyId || crypto.randomUUID();
    const ttlSeconds = AUTH_CONSTANTS.REFRESH_TOKEN_TTL_SECONDS;
    const expiresAt = new Date(Date.now() + ttlSeconds * 1000);

    // Store in PostgreSQL
    await this.authRepository.createRefreshToken({
      userId,
      tokenHash,
      familyId: activeFamilyId,
      expiresAt,
    });

    // Store active family in Redis for ultra-fast validation & theft detection
    await this.redisService.storeRefreshFamily(activeFamilyId, tokenHash, userId, ttlSeconds);

    // Create JWT wrapper around the opaque token for stateless verification of family & expiry
    const refreshPayload: JwtRefreshPayload = {
      sub: userId,
      familyId: activeFamilyId,
      tokenHash,
      sessionId,
      deviceId,
      iat: Math.floor(Date.now() / 1000),
      exp: Math.floor(Date.now() / 1000) + ttlSeconds,
    };

    const refreshToken = await this.jwtService.signAsync(refreshPayload, {
      secret: process.env.JWT_REFRESH_SECRET || 'yoga24x-enterprise-refresh-secret-key-2026',
    });

    return { refreshToken, familyId: activeFamilyId, expiresAt };
  }

  // ============================================================================
  // Refresh Token Rotation & Theft Detection Protocol
  // ============================================================================

  async rotateRefreshToken(refreshToken: string, deviceFingerprint: string, ipAddress: string): Promise<{
    user: any;
    accessToken: string;
    newRefreshToken: string;
    sessionId: string;
  }> {
    let payload: JwtRefreshPayload;
    try {
      payload = await this.jwtService.verifyAsync<JwtRefreshPayload>(refreshToken, {
        secret: process.env.JWT_REFRESH_SECRET || 'yoga24x-enterprise-refresh-secret-key-2026',
      });
    } catch (err) {
      throw new UnauthorizedException('Invalid or expired refresh token');
    }

    const { sub: userId, familyId, tokenHash, sessionId, deviceId } = payload;

    // 1. Check Redis for Token Family State
    const familyState = await this.redisService.getRefreshFamily(familyId);
    if (!familyState) {
      // Family not found in Redis (expired or revoked)
      throw new UnauthorizedException('Refresh token session expired');
    }

    // 2. THEFT DETECTION: If currentTokenHash in Redis does NOT match tokenHash presented
    if (familyState.currentTokenHash !== tokenHash || familyState.status === 'REVOKED') {
      console.error(`🚨 SECURITY ALERT: Refresh Token Reuse Theft Detected for User ${userId}, Family ${familyId}!`);
      
      // Revoke the entire token family immediately in Redis and DB
      await this.redisService.revokeRefreshFamily(familyId);
      await this.authRepository.revokeRefreshTokenFamily(familyId);
      
      // Revoke all active sessions for this user as a precautionary security measure
      await this.authRepository.revokeAllUserSessions(userId);

      // Log critical security event
      await this.authRepository.createAuditLog({
        actorId: userId,
        action: AUTH_CONSTANTS.AUDIT_ACTION_TOKEN_REUSE_DETECTED,
        entityType: 'RefreshTokenFamily',
        entityId: familyId,
        oldValuesJson: { presentedHash: tokenHash, expectedHash: familyState.currentTokenHash },
        newValuesJson: { status: 'REVOKED_ALL_SESSIONS' },
        ipAddress,
      });

      throw new ForbiddenException('Security violation: Token reuse detected. All sessions terminated.');
    }

    // 3. Verify User and Active Session in DB
    const user = await this.authRepository.findUserById(userId);
    if (!user || user.status !== 'ACTIVE') {
      throw new UnauthorizedException('User account inactive or suspended');
    }

    const session = await this.authRepository.findActiveSessionById(sessionId);
    if (!session || !session.isActive) {
      throw new UnauthorizedException('Session terminated');
    }

    // 4. Generate New Access Token and New Refresh Token (Family Rotation)
    const roles: UserRoleName[] = user.userRoles.map((ur: any) => ur.role.name as UserRoleName);
    const { accessToken } = await this.generateAccessToken(
      { id: user.id, email: user.email, roles, tenantId: user.tenantId },
      sessionId,
      deviceId,
    );

    const { refreshToken: newRefreshToken } = await this.generateRefreshToken(
      user.id,
      sessionId,
      deviceId,
      familyId, // Maintain same family ID for ongoing rotation tracking
    );

    // 5. Audit Log
    await this.authRepository.createAuditLog({
      actorId: user.id,
      action: AUTH_CONSTANTS.AUDIT_ACTION_TOKEN_REFRESH,
      entityType: 'UserSession',
      entityId: sessionId,
      ipAddress,
    });

    return {
      user: {
        id: user.id,
        email: user.email,
        phoneNumber: user.phoneNumber,
        firstName: user.firstName,
        lastName: user.lastName,
        avatarUrl: user.avatarUrl,
        roles,
        status: user.status,
        isEmailVerified: user.isEmailVerified,
        isPhoneVerified: user.isPhoneVerified,
        twoFactorEnabled: user.twoFactorEnabled,
        tenantId: user.tenantId,
      },
      accessToken,
      newRefreshToken,
      sessionId,
    };
  }

  // ============================================================================
  // Instant Token Revocation (JTI Blacklist & Refresh Revocations)
  // ============================================================================

  async revokeAccessToken(jti: string, ttlSeconds: number): Promise<void> {
    await this.redisService.blacklistJti(jti, ttlSeconds);
  }

  async isAccessTokenRevoked(jti: string): Promise<boolean> {
    return this.redisService.isJtiBlacklisted(jti);
  }
}

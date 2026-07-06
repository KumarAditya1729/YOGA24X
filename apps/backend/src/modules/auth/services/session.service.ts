// ==============================================================================
// Yoga24X AI Engineering OS — Session Service (Redis + DB Multi-Device Tracking)
// ==============================================================================

import { Injectable, NotFoundException } from "@nestjs/common";
import { RedisService } from "../../redis/redis.module";
import { AuthRepository } from "../repositories/auth.repository";
import { AUTH_CONSTANTS, DeviceInfo, SessionData } from "@yoga24x/shared-types";

@Injectable()
export class SessionService {
  constructor(
    private readonly redisService: RedisService,
    private readonly authRepository: AuthRepository,
  ) {}

  // ============================================================================
  // Create & Register User Session (Redis + DB)
  // ============================================================================

  async createSession(
    userId: string,
    deviceInfo: DeviceInfo,
    ipAddress: string,
    userAgent: string,
    location = "Unknown",
  ): Promise<{ sessionId: string; deviceId: string | null }> {
    // 1. Register or Update Device in PostgreSQL
    const device = await this.authRepository.upsertDevice({
      userId,
      deviceType: deviceInfo.deviceType,
      deviceFingerprint: deviceInfo.deviceFingerprint,
      osVersion: deviceInfo.osVersion,
      appVersion: deviceInfo.appVersion,
      fcmToken: deviceInfo.fcmToken,
      ipAddress,
    });

    // 2. Create Session Record in PostgreSQL
    const dbSession = await this.authRepository.createSession({
      userId,
      deviceId: device.id,
      ipAddress,
      userAgent,
    });

    // 3. Store Session State in Redis for Ultra-Fast Lookup & Multi-Device Control
    const sessionData: SessionData = {
      sessionId: dbSession.id,
      userId,
      deviceId: device.id,
      deviceFingerprint: deviceInfo.deviceFingerprint,
      ipAddress,
      userAgent,
      location,
      deviceType: deviceInfo.deviceType,
      isActive: true,
      createdAt: new Date().toISOString(),
      lastActiveAt: new Date().toISOString(),
    };

    const redisKey = `${AUTH_CONSTANTS.REDIS_KEY_SESSION_PREFIX}${dbSession.id}`;
    await this.redisService.set(
      redisKey,
      JSON.stringify(sessionData),
      AUTH_CONSTANTS.REFRESH_TOKEN_TTL_SECONDS,
    );

    return { sessionId: dbSession.id, deviceId: device.id };
  }

  // ============================================================================
  // Session Validation & Activity Touch
  // ============================================================================

  async getSession(sessionId: string): Promise<SessionData | null> {
    const redisKey = `${AUTH_CONSTANTS.REDIS_KEY_SESSION_PREFIX}${sessionId}`;
    const dataStr = await this.redisService.get(redisKey);
    if (dataStr) {
      return JSON.parse(dataStr) as SessionData;
    }

    // Fallback to PostgreSQL
    const dbSession =
      await this.authRepository.findActiveSessionById(sessionId);
    if (!dbSession || !dbSession.isActive) return null;

    const sessionData: SessionData = {
      sessionId: dbSession.id,
      userId: dbSession.userId,
      deviceId: dbSession.deviceId,
      deviceFingerprint: "unknown",
      ipAddress: dbSession.ipAddress || "unknown",
      userAgent: dbSession.userAgent || "unknown",
      location: "Unknown",
      deviceType: "WEB_BROWSER",
      isActive: true,
      createdAt: dbSession.createdAt.toISOString(),
      lastActiveAt: dbSession.lastActiveAt.toISOString(),
    };

    // Populate Redis cache
    await this.redisService.set(
      redisKey,
      JSON.stringify(sessionData),
      AUTH_CONSTANTS.REFRESH_TOKEN_TTL_SECONDS,
    );

    return sessionData;
  }

  async touchSessionActivity(sessionId: string): Promise<void> {
    const redisKey = `${AUTH_CONSTANTS.REDIS_KEY_SESSION_PREFIX}${sessionId}`;
    const dataStr = await this.redisService.get(redisKey);
    if (dataStr) {
      const data = JSON.parse(dataStr) as SessionData;
      data.lastActiveAt = new Date().toISOString();
      await this.redisService.set(
        redisKey,
        JSON.stringify(data),
        AUTH_CONSTANTS.REFRESH_TOKEN_TTL_SECONDS,
      );
    }
  }

  // ============================================================================
  // Logout & Revocation (Single Device vs All Devices)
  // ============================================================================

  async revokeSession(sessionId: string): Promise<void> {
    const redisKey = `${AUTH_CONSTANTS.REDIS_KEY_SESSION_PREFIX}${sessionId}`;
    await this.redisService.del(redisKey);
    await this.authRepository.revokeSession(sessionId);
  }

  async revokeAllUserSessions(userId: string): Promise<number> {
    // 1. Get all active sessions from DB
    const sessions = await this.authRepository.listActiveSessions(userId);

    // 2. Delete all session keys from Redis
    for (const s of sessions) {
      const redisKey = `${AUTH_CONSTANTS.REDIS_KEY_SESSION_PREFIX}${s.id}`;
      await this.redisService.del(redisKey);
    }

    // 3. Revoke all in DB and revoke all refresh tokens
    const res = await this.authRepository.revokeAllUserSessions(userId);
    await this.authRepository.revokeAllUserRefreshTokens(userId);

    return res.count;
  }

  // ============================================================================
  // Trusted Device Management (Biometric Passkeys)
  // ============================================================================

  async registerTrustedDevice(
    userId: string,
    deviceId: string | null,
    deviceFingerprint: string,
    deviceName: string,
    publicKey?: string,
  ): Promise<any> {
    return this.authRepository.upsertTrustedDevice({
      userId,
      deviceId: deviceId || undefined,
      deviceFingerprint,
      deviceName,
      publicKey,
    });
  }

  async listTrustedDevices(userId: string): Promise<any[]> {
    return this.authRepository.listTrustedDevices(userId);
  }

  async revokeTrustedDevice(fingerprint: string): Promise<any> {
    const device =
      await this.authRepository.findTrustedDeviceByFingerprint(fingerprint);
    if (!device) {
      throw new NotFoundException("Trusted device not found");
    }
    return this.authRepository.revokeTrustedDevice(fingerprint);
  }

  async isDeviceTrusted(deviceFingerprint: string): Promise<boolean> {
    const device =
      await this.authRepository.findTrustedDeviceByFingerprint(
        deviceFingerprint,
      );
    return !!(device && !device.isRevoked);
  }
}

// ==============================================================================
// Yoga24X AI Engineering OS — Risk Service (Risk-Based Login & Suspicious Detection)
// ==============================================================================

import { Injectable, ForbiddenException } from "@nestjs/common";
import { RedisService } from "../../redis/redis.module";
import { AuthRepository } from "../repositories/auth.repository";
import {
  AUTH_CONSTANTS,
  DeviceInfo,
  RiskEvaluationResult,
} from "@yoga24x/shared-types";

@Injectable()
export class RiskService {
  constructor(
    private readonly redisService: RedisService,
    private readonly authRepository: AuthRepository,
  ) {}

  // ============================================================================
  // Evaluate Login Risk Score (0-100) & Actionable Safeguards
  // ============================================================================

  async evaluateLoginRisk(
    userId: string,
    deviceInfo: DeviceInfo,
    ipAddress: string,
    location = "Unknown",
  ): Promise<RiskEvaluationResult> {
    let riskScore = 0;
    const factors: string[] = [];
    const safeDevice: DeviceInfo = deviceInfo || {
      deviceType: "WEB_BROWSER",
      deviceFingerprint: `web_${userId}_${Date.now()}`,
      deviceName: "Web Browser",
      osVersion: "Unknown",
      appVersion: "1.0.0",
    };

    // 1. Check if IP Address is explicitly blacklisted/blocked
    const blockedIp = await this.authRepository.checkIpBlocked(ipAddress);
    if (blockedIp) {
      throw new ForbiddenException(
        `Access denied from blocked IP address: ${ipAddress}. Reason: ${blockedIp.reason}`,
      );
    }

    // 2. FACTOR 1: Is this a completely new device fingerprint for this user? (+30 risk)
    const isTrusted = await this.authRepository.findTrustedDeviceByFingerprint(
      safeDevice.deviceFingerprint,
    );
    if (!isTrusted || isTrusted.userId !== userId || isTrusted.isRevoked) {
      riskScore += 30;
      factors.push("NEW_UNTRUSTED_DEVICE");
    }

    // 3. FACTOR 2: Check recent login history for unusual location or IP change (+25 risk)
    const recentLogins = await this.authRepository.listRecentLoginHistory(
      userId,
      5,
    );
    if (recentLogins.length > 0) {
      const lastLogin = recentLogins[0];
      if (lastLogin.ipAddress && lastLogin.ipAddress !== ipAddress) {
        riskScore += 20;
        factors.push("IP_ADDRESS_CHANGE");
      }
      if (
        lastLogin.location &&
        lastLogin.location !== location &&
        location !== "Unknown"
      ) {
        riskScore += 25;
        factors.push("GEOGRAPHIC_LOCATION_JUMP");
      }
    }

    // 4. FACTOR 3: Check IP velocity / burst failed logins in Redis (+40 risk)
    const failedLoginsKey = `${AUTH_CONSTANTS.REDIS_KEY_FAILED_LOGINS_PREFIX}${ipAddress}`;
    const failedCountStr = await this.redisService.get(failedLoginsKey);
    const failedCount = failedCountStr ? parseInt(failedCountStr, 10) : 0;
    if (failedCount > 2) {
      riskScore += 40;
      factors.push("HIGH_FAILED_LOGIN_VELOCITY_FROM_IP");
    }

    // 5. FACTOR 4: Check if account was recently locked or targeted by brute force (+35 risk)
    const userLockKey = `${AUTH_CONSTANTS.REDIS_KEY_ACCOUNT_LOCK_PREFIX}${userId}`;
    const wasRecentlyLocked = await this.redisService.exists(userLockKey);
    if (wasRecentlyLocked) {
      riskScore += 35;
      factors.push("RECENT_BRUTE_FORCE_TARGET");
    }

    // Cap score at 100
    riskScore = Math.min(riskScore, 100);

    // Determine Risk Level & Actions
    let riskLevel: "LOW" | "MEDIUM" | "HIGH" | "CRITICAL" = "LOW";
    let requireMfa = false;
    let blockLogin = false;

    if (riskScore >= AUTH_CONSTANTS.RISK_SCORE_BLOCK_THRESHOLD) {
      riskLevel = "CRITICAL";
      blockLogin = true;
      requireMfa = true;
    } else if (riskScore >= AUTH_CONSTANTS.RISK_SCORE_HIGH_THRESHOLD) {
      riskLevel = "HIGH";
      requireMfa = true;
    } else if (riskScore >= AUTH_CONSTANTS.RISK_SCORE_MEDIUM_THRESHOLD) {
      riskLevel = "MEDIUM";
      requireMfa = true;
    }

    // Record evaluation in Redis for monitoring
    const evalKey = `${AUTH_CONSTANTS.REDIS_KEY_RISK_SCORE_PREFIX}${userId}:${Date.now()}`;
    await this.redisService.set(
      evalKey,
      JSON.stringify({ riskScore, riskLevel, factors, ipAddress }),
      3600,
    );

    return {
      riskScore,
      riskLevel,
      factors,
      requireMfa,
      blockLogin,
    };
  }

  // ============================================================================
  // Log Suspicious Activity & Emit CloudEvents
  // ============================================================================

  async logLoginAttempt(
    userId: string,
    status: "SUCCESS" | "FAILED" | "BLOCKED" | "SUSPICIOUS",
    ipAddress: string,
    userAgent: string,
    location: string,
    deviceType: string,
    riskScore: number,
    failureReason?: string,
  ): Promise<void> {
    // 1. Persist to PostgreSQL LoginHistory
    await this.authRepository.createLoginHistory({
      userId,
      loginStatus: status,
      ipAddress,
      userAgent,
      location,
      deviceType: deviceType || "WEB_BROWSER",
      riskScore,
      failureReason,
    });

    // 2. If FAILED or BLOCKED, increment IP velocity counter in Redis
    if (
      status === "FAILED" ||
      status === "BLOCKED" ||
      status === "SUSPICIOUS"
    ) {
      const failedLoginsKey = `${AUTH_CONSTANTS.REDIS_KEY_FAILED_LOGINS_PREFIX}${ipAddress}`;
      const countStr = await this.redisService.get(failedLoginsKey);
      const count = (countStr ? parseInt(countStr, 10) : 0) + 1;
      await this.redisService.set(failedLoginsKey, count.toString(), 1800); // 30 min window

      // Emit security audit log
      await this.authRepository.createAuditLog({
        actorId: userId,
        action:
          status === "SUSPICIOUS"
            ? AUTH_CONSTANTS.AUDIT_ACTION_SUSPICIOUS_LOGIN_DETECTED
            : AUTH_CONSTANTS.AUDIT_ACTION_LOGIN_FAILED,
        entityType: "UserAccount",
        entityId: userId,
        newValuesJson: { status, riskScore, failureReason, ipAddress },
        ipAddress,
      });
    } else if (status === "SUCCESS") {
      // Clear failed login counter on success
      const failedLoginsKey = `${AUTH_CONSTANTS.REDIS_KEY_FAILED_LOGINS_PREFIX}${ipAddress}`;
      await this.redisService.del(failedLoginsKey);

      await this.authRepository.createAuditLog({
        actorId: userId,
        action: AUTH_CONSTANTS.AUDIT_ACTION_LOGIN_SUCCESS,
        entityType: "UserAccount",
        entityId: userId,
        newValuesJson: { riskScore, ipAddress },
        ipAddress,
      });
    }
  }
}

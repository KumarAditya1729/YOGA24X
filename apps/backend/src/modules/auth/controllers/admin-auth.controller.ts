// ==============================================================================
// Yoga24X AI Engineering OS — Admin Auth Controller (Security Monitoring & Controls)
// ==============================================================================

import {
  Controller,
  Get,
  Post,
  Delete,
  Param,
  Body,
  Query,
  UseGuards,
  HttpCode,
  HttpStatus,
  NotFoundException,
} from "@nestjs/common";
import { JwtAuthGuard } from "../guards/jwt-auth.guard";
import { RolesGuard } from "../guards/roles.guard";
import { Roles } from "../decorators/auth.decorators";
import { AuthRepository } from "../repositories/auth.repository";
import { SessionService } from "../services/session.service";
import { RedisService } from "../../redis/redis.module";
import { AUTH_CONSTANTS } from "@yoga24x/shared-types";

@Controller("api/v1/admin/security")
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles("SUPER_ADMIN", "ADMIN")
export class AdminAuthController {
  constructor(
    private readonly authRepository: AuthRepository,
    private readonly sessionService: SessionService,
    private readonly redisService: RedisService,
  ) {}

  // ============================================================================
  // Inspect User Login History (Audit & Risk Monitoring)
  // ============================================================================

  @Get("logins/:userId")
  @HttpCode(HttpStatus.OK)
  async getUserLoginHistory(
    @Param("userId") userId: string,
    @Query("limit") limitStr = "30",
  ) {
    const limit = parseInt(limitStr, 10) || 30;
    const history = await this.authRepository.listRecentLoginHistory(
      userId,
      limit,
    );
    return { success: true, data: history };
  }

  // ============================================================================
  // List User Active Sessions
  // ============================================================================

  @Get("sessions/:userId")
  @HttpCode(HttpStatus.OK)
  async getUserSessions(@Param("userId") userId: string) {
    const sessions = await this.authRepository.listActiveSessions(userId);
    return { success: true, data: sessions };
  }

  // ============================================================================
  // Force Logout User from All Devices
  // ============================================================================

  @Post("users/:userId/logout-all")
  @HttpCode(HttpStatus.OK)
  async forceLogoutUser(@Param("userId") userId: string) {
    const count = await this.sessionService.revokeAllUserSessions(userId);
    return {
      success: true,
      message: `Terminated ${count} active session(s) for user ${userId}`,
    };
  }

  // ============================================================================
  // Disable / Suspend Account
  // ============================================================================

  @Post("users/:userId/status")
  @HttpCode(HttpStatus.OK)
  async updateUserStatus(
    @Param("userId") userId: string,
    @Body("status") status: "ACTIVE" | "SUSPENDED" | "BANNED" | "DELETED",
  ) {
    const user = await this.authRepository.updateUserStatus(
      userId,
      status as any,
    );
    if (status !== "ACTIVE") {
      await this.sessionService.revokeAllUserSessions(userId);
    }
    return {
      success: true,
      message: `User status updated to ${status}`,
      data: user,
    };
  }

  // ============================================================================
  // Unlock Brute-Force Locked Account
  // ============================================================================

  @Post("users/:userId/unlock")
  @HttpCode(HttpStatus.OK)
  async unlockAccount(@Param("userId") userId: string) {
    const user = await this.authRepository.findUserById(userId);
    if (!user) throw new NotFoundException("User not found");

    const lockKeyId = `${AUTH_CONSTANTS.REDIS_KEY_ACCOUNT_LOCK_PREFIX}${userId}`;
    const lockKeyEmail = `${AUTH_CONSTANTS.REDIS_KEY_ACCOUNT_LOCK_PREFIX}${user.email}`;
    const lockKeyPhone = user.phoneNumber
      ? `${AUTH_CONSTANTS.REDIS_KEY_ACCOUNT_LOCK_PREFIX}${user.phoneNumber}`
      : null;

    await this.redisService.del(lockKeyId);
    await this.redisService.del(lockKeyEmail);
    if (lockKeyPhone) await this.redisService.del(lockKeyPhone);

    // Clear failed attempt counters
    const attemptsKeyEmail = `${AUTH_CONSTANTS.REDIS_KEY_OTP_ATTEMPTS_PREFIX}${user.email}`;
    await this.redisService.del(attemptsKeyEmail);

    return {
      success: true,
      message: `Account unlocked successfully for ${user.email}`,
    };
  }
}

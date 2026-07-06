// ==============================================================================
// Yoga24X AI Engineering OS — Session Controller (Multi-Device & Passkeys)
// ==============================================================================

import { Controller, Get, Post, Delete, Param, Body, UseGuards, HttpCode, HttpStatus } from '@nestjs/common';
import { SessionService } from '../services/session.service';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { CurrentUser } from '../decorators/auth.decorators';
import { JwtAccessPayload } from '@yoga24x/shared-types';
import { AuthRepository } from '../repositories/auth.repository';

@Controller('api/v1/sessions')
@UseGuards(JwtAuthGuard)
export class SessionController {
  constructor(
    private readonly sessionService: SessionService,
    private readonly authRepository: AuthRepository,
  ) {}

  // ============================================================================
  // List All Active Sessions for Current User
  // ============================================================================

  @Get()
  @HttpCode(HttpStatus.OK)
  async listMySessions(@CurrentUser() user: JwtAccessPayload) {
    const sessions = await this.authRepository.listActiveSessions(user.sub);
    return {
      success: true,
      data: sessions.map((s) => ({
        sessionId: s.id,
        deviceType: s.device?.deviceType || 'UNKNOWN',
        osVersion: s.device?.osVersion || 'N/A',
        appVersion: s.device?.appVersion || 'N/A',
        ipAddress: s.ipAddress,
        userAgent: s.userAgent,
        createdAt: s.createdAt,
        lastActiveAt: s.lastActiveAt,
        isCurrentSession: s.id === user.sessionId,
      })),
    };
  }

  // ============================================================================
  // Revoke Specific Session by ID
  // ============================================================================

  @Delete(':sessionId')
  @HttpCode(HttpStatus.OK)
  async revokeSession(@CurrentUser() user: JwtAccessPayload, @Param('sessionId') sessionId: string) {
    await this.sessionService.revokeSession(sessionId);
    return { success: true, message: `Session ${sessionId} terminated successfully` };
  }

  // ============================================================================
  // Revoke All Other Sessions except Current
  // ============================================================================

  @Delete('revoke/others')
  @HttpCode(HttpStatus.OK)
  async revokeAllOtherSessions(@CurrentUser() user: JwtAccessPayload) {
    const sessions = await this.authRepository.listActiveSessions(user.sub);
    let count = 0;
    for (const s of sessions) {
      if (s.id !== user.sessionId) {
        await this.sessionService.revokeSession(s.id);
        count++;
      }
    }
    return { success: true, message: `Terminated ${count} other active session(s)` };
  }

  // ============================================================================
  // Trusted Devices (Biometric Passkeys)
  // ============================================================================

  @Get('devices/trusted')
  @HttpCode(HttpStatus.OK)
  async listTrustedDevices(@CurrentUser() user: JwtAccessPayload) {
    const devices = await this.sessionService.listTrustedDevices(user.sub);
    return { success: true, data: devices };
  }

  @Post('devices/trusted')
  @HttpCode(HttpStatus.CREATED)
  async registerTrustedDevice(
    @CurrentUser() user: JwtAccessPayload,
    @Body() body: { deviceFingerprint: string; deviceName: string; publicKey?: string },
  ) {
    const device = await this.sessionService.registerTrustedDevice(
      user.sub,
      user.deviceId,
      body.deviceFingerprint,
      body.deviceName,
      body.publicKey,
    );
    return { success: true, data: device };
  }

  @Delete('devices/trusted/:fingerprint')
  @HttpCode(HttpStatus.OK)
  async revokeTrustedDevice(@Param('fingerprint') fingerprint: string) {
    await this.sessionService.revokeTrustedDevice(fingerprint);
    return { success: true, message: 'Trusted biometric device revoked' };
  }
}

// ==============================================================================
// Yoga24X AI Engineering OS — Master Authentication Service
// ==============================================================================

import { Injectable, UnauthorizedException, ForbiddenException, BadRequestException, NotFoundException } from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import * as crypto from 'crypto';
import { AuthRepository } from '../repositories/auth.repository';
import { TokenService } from './token.service';
import { OtpService } from './otp.service';
import { OAuthService } from './oauth.service';
import { SessionService } from './session.service';
import { RiskService } from './risk.service';
import { RedisService } from '../../redis/redis.module';
import {
  AUTH_CONSTANTS,
  AuthResponse,
  DeviceInfo,
  LoginDto,
  RegisterDto,
  GoogleLoginDto,
  AppleLoginDto,
  BiometricLoginDto,
  ResetPasswordDto,
  UserRoleName,
} from '@yoga24x/shared-types';

@Injectable()
export class AuthService {
  constructor(
    private readonly authRepository: AuthRepository,
    private readonly tokenService: TokenService,
    private readonly otpService: OtpService,
    private readonly oauthService: OAuthService,
    private readonly sessionService: SessionService,
    private readonly riskService: RiskService,
    private readonly redisService: RedisService,
  ) {}

  // ============================================================================
  // Standard Password Login (Email or Phone) + Risk Evaluation
  // ============================================================================

  async loginWithPassword(dto: LoginDto, ipAddress: string, userAgent: string): Promise<AuthResponse> {
    const cleanId = dto.emailOrPhone.trim().toLowerCase();

    // 1. Check Rate Limiter (Max 10 login attempts per 5 minutes per IP/ID)
    const rateLimit = await this.redisService.checkRateLimit(`login:${cleanId}`, 10, 300);
    if (!rateLimit.allowed) {
      throw new ForbiddenException(`Too many login attempts. Please wait ${rateLimit.resetInSeconds} seconds.`);
    }

    // 2. Find User by Email or Phone
    let user = await this.authRepository.findUserByEmail(cleanId);
    if (!user) {
      user = await this.authRepository.findUserByPhone(cleanId);
    }

    if (!user || !user.passwordHash) {
      await this.riskService.logLoginAttempt('00000000-0000-0000-0000-000000000000', 'FAILED', ipAddress, userAgent, 'Unknown', dto.deviceInfo.deviceType, 50, 'Account not found');
      throw new UnauthorizedException('Invalid email/phone or password');
    }

    if (user.status !== 'ACTIVE') {
      await this.riskService.logLoginAttempt(user.id, 'BLOCKED', ipAddress, userAgent, 'Unknown', dto.deviceInfo.deviceType, 90, `Account status: ${user.status}`);
      throw new ForbiddenException(`Account is ${user.status.toLowerCase()}. Please contact support.`);
    }

    // 3. Verify Password via Bcrypt/SHA-512
    let isPasswordMatch = false;
    if (user.passwordHash.includes(':')) {
      // PBKDF2 seed format
      const [salt, hash] = user.passwordHash.split(':');
      const verifyHash = crypto.pbkdf2Sync(dto.password, salt, 100000, 64, 'sha512').toString('hex');
      isPasswordMatch = hash === verifyHash;
    } else {
      isPasswordMatch = await bcrypt.compare(dto.password, user.passwordHash);
    }

    if (!isPasswordMatch) {
      await this.riskService.logLoginAttempt(user.id, 'FAILED', ipAddress, userAgent, 'Unknown', dto.deviceInfo.deviceType, 60, 'Invalid password');
      throw new UnauthorizedException('Invalid email/phone or password');
    }

    // 4. Evaluate Risk Score
    const risk = await this.riskService.evaluateLoginRisk(user.id, dto.deviceInfo, ipAddress);
    if (risk.blockLogin) {
      await this.riskService.logLoginAttempt(user.id, 'BLOCKED', ipAddress, userAgent, 'Unknown', dto.deviceInfo.deviceType, risk.riskScore, 'Critical risk score blocked');
      throw new ForbiddenException('Login blocked due to suspicious activity. Please verify your identity via email recovery.');
    }

    // 5. If Two Factor Enabled or High Risk -> Trigger 2FA Challenge
    if (user.twoFactorEnabled || risk.requireMfa) {
      // Dispatch 2FA OTP
      await this.otpService.generateAndSendOtp(user.email, 'TWO_FACTOR', 'EMAIL');
      await this.riskService.logLoginAttempt(user.id, 'SUSPICIOUS', ipAddress, userAgent, 'Unknown', dto.deviceInfo.deviceType, risk.riskScore, '2FA MFA required');
      
      throw new ForbiddenException({
        statusCode: 403,
        error: 'MFA_REQUIRED',
        message: 'Two-factor authentication required. An OTP has been dispatched to your verified email.',
        userId: user.id,
        riskScore: risk.riskScore,
      } as any);
    }

    // 6. Complete Login Orchestration
    return this.completeLoginOrchestration(user, dto.deviceInfo, ipAddress, userAgent, risk.riskScore, risk.riskLevel);
  }

  // ============================================================================
  // Passwordless OTP Login / 2FA Completion
  // ============================================================================

  async loginWithOtp(identifier: string, otpCode: string, purpose: string, deviceInfo: DeviceInfo, ipAddress: string, userAgent: string): Promise<AuthResponse> {
    const cleanId = identifier.trim().toLowerCase();

    // 1. Verify OTP via OtpService
    await this.otpService.verifyOtp(cleanId, otpCode, purpose);

    // 2. Find User
    let user = await this.authRepository.findUserByEmail(cleanId);
    if (!user) {
      user = await this.authRepository.findUserByPhone(cleanId);
    }

    if (!user || user.status !== 'ACTIVE') {
      throw new UnauthorizedException('User account not found or inactive');
    }

    // 3. Mark identifier verified if purpose was login or phone_verify
    if (!user.isEmailVerified && cleanId.includes('@')) {
      user = await this.authRepository.markEmailVerified(user.id);
    } else if (!user.isPhoneVerified && !cleanId.includes('@')) {
      user = await this.authRepository.markPhoneVerified(user.id);
    }

    const risk = await this.riskService.evaluateLoginRisk(user.id, deviceInfo, ipAddress);
    return this.completeLoginOrchestration(user, deviceInfo, ipAddress, userAgent, risk.riskScore, risk.riskLevel);
  }

  // ============================================================================
  // OAuth Login (Google / Apple)
  // ============================================================================

  async loginWithGoogle(dto: GoogleLoginDto, ipAddress: string, userAgent: string): Promise<AuthResponse> {
    const { user } = await this.oauthService.verifyGoogleIdToken(dto.idToken, dto.role);
    const risk = await this.riskService.evaluateLoginRisk(user.id, dto.deviceInfo, ipAddress);
    return this.completeLoginOrchestration(user, dto.deviceInfo, ipAddress, userAgent, risk.riskScore, risk.riskLevel);
  }

  async loginWithApple(dto: AppleLoginDto, ipAddress: string, userAgent: string): Promise<AuthResponse> {
    const { user } = await this.oauthService.verifyAppleIdentityToken(dto.identityToken, dto.authorizationCode, dto.firstName, dto.lastName, dto.role);
    const risk = await this.riskService.evaluateLoginRisk(user.id, dto.deviceInfo, ipAddress);
    return this.completeLoginOrchestration(user, dto.deviceInfo, ipAddress, userAgent, risk.riskScore, risk.riskLevel);
  }

  // ============================================================================
  // Biometric Passkey Login
  // ============================================================================

  async loginWithBiometric(dto: BiometricLoginDto, ipAddress: string, userAgent: string): Promise<AuthResponse> {
    // 1. Verify device is trusted in PostgreSQL
    const trustedDevice = await this.authRepository.findTrustedDeviceByFingerprint(dto.deviceFingerprint);
    if (!trustedDevice || trustedDevice.isRevoked || trustedDevice.userId !== dto.userId) {
      throw new UnauthorizedException('Biometric passkey device is not registered or revoked');
    }

    // 2. Verify Cryptographic Challenge Signature (WebAuthn / Passkey signature check simulation)
    const expectedChallenge = crypto.createHash('sha256').update(`${dto.userId}:${dto.deviceFingerprint}`).digest('hex');
    if (!dto.cryptographicSignature || dto.cryptographicSignature.length < 20) {
      throw new UnauthorizedException('Invalid biometric passkey cryptographic signature');
    }

    // 3. Find User
    const user = await this.authRepository.findUserById(dto.userId);
    if (!user || user.status !== 'ACTIVE') {
      throw new UnauthorizedException('User account inactive');
    }

    // Update last used timestamp
    await this.authRepository.upsertTrustedDevice({
      userId: user.id,
      deviceFingerprint: dto.deviceFingerprint,
      deviceName: trustedDevice.deviceName,
    });

    const risk = await this.riskService.evaluateLoginRisk(user.id, dto.deviceInfo, ipAddress);
    return this.completeLoginOrchestration(user, dto.deviceInfo, ipAddress, userAgent, risk.riskScore, risk.riskLevel);
  }

  // ============================================================================
  // User Registration
  // ============================================================================

  async register(dto: RegisterDto, ipAddress: string, userAgent: string): Promise<AuthResponse> {
    // Check existing
    const existingEmail = await this.authRepository.findUserByEmail(dto.email);
    if (existingEmail) {
      throw new BadRequestException('An account with this email already exists');
    }
    if (dto.phoneNumber) {
      const existingPhone = await this.authRepository.findUserByPhone(dto.phoneNumber);
      if (existingPhone) {
        throw new BadRequestException('An account with this phone number already exists');
      }
    }

    // Hash password
    const passwordHash = await bcrypt.hash(dto.password, 10);

    // Create User
    const user = await this.authRepository.createUser({
      email: dto.email,
      phoneNumber: dto.phoneNumber,
      passwordHash,
      firstName: dto.firstName,
      lastName: dto.lastName,
      roleName: dto.role,
    });

    // Send email verification OTP
    await this.otpService.generateAndSendOtp(user.email, 'PHONE_VERIFY', 'EMAIL');

    return this.completeLoginOrchestration(user, dto.deviceInfo, ipAddress, userAgent, 0, 'LOW');
  }

  // ============================================================================
  // Password Reset & Account Recovery
  // ============================================================================

  async resetPassword(dto: ResetPasswordDto): Promise<{ success: boolean; message: string }> {
    const cleanId = dto.identifier.trim().toLowerCase();
    await this.otpService.verifyOtp(cleanId, dto.otpCode, 'PASSWORD_RESET');

    let user = await this.authRepository.findUserByEmail(cleanId);
    if (!user) user = await this.authRepository.findUserByPhone(cleanId);
    if (!user) throw new NotFoundException('User account not found');

    const passwordHash = await bcrypt.hash(dto.newPassword, 10);
    await this.authRepository.updatePasswordHash(user.id, passwordHash);

    // Revoke all existing sessions for security
    await this.sessionService.revokeAllUserSessions(user.id);

    await this.authRepository.createAuditLog({
      actorId: user.id,
      action: AUTH_CONSTANTS.AUDIT_ACTION_PASSWORD_CHANGED,
      entityType: 'UserAccount',
      entityId: user.id,
    });

    return { success: true, message: 'Password reset successfully. All existing sessions have been terminated.' };
  }

  // ============================================================================
  // Helper: Complete Login Orchestration (Tokens, Session, Trusted Device, Audit)
  // ============================================================================

  private async completeLoginOrchestration(
    user: any,
    deviceInfo: DeviceInfo,
    ipAddress: string,
    userAgent: string,
    riskScore: number,
    riskLevel: string,
  ): Promise<AuthResponse> {
    // 1. Create Session
    const { sessionId, deviceId } = await this.sessionService.createSession(
      user.id,
      deviceInfo,
      ipAddress,
      userAgent,
    );

    // 2. Check if device is trusted
    const isTrustedDevice = await this.sessionService.isDeviceTrusted(deviceInfo.deviceFingerprint);

    // 3. Generate RS256 Access Token & SHA-256 Refresh Token
    const roles: UserRoleName[] = user.userRoles.map((ur: any) => ur.role.name as UserRoleName);
    const { accessToken } = await this.tokenService.generateAccessToken(
      { id: user.id, email: user.email, roles, tenantId: user.tenantId },
      sessionId,
      deviceId,
    );
    const { refreshToken } = await this.tokenService.generateRefreshToken(user.id, sessionId, deviceId);

    // 4. Log Success in LoginHistory
    await this.riskService.logLoginAttempt(user.id, 'SUCCESS', ipAddress, userAgent, 'Unknown', deviceInfo.deviceType, riskScore);

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
      tokens: {
        accessToken,
        refreshToken,
        expiresIn: AUTH_CONSTANTS.ACCESS_TOKEN_TTL_SECONDS,
        tokenType: 'Bearer',
      },
      session: {
        sessionId,
        isTrustedDevice,
      },
      risk: {
        score: riskScore,
        level: riskLevel,
      },
    };
  }
}

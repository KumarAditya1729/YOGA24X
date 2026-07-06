// ==============================================================================
// Yoga24X AI Engineering OS — Auth Controller (REST API Endpoints)
// ==============================================================================

import { Controller, Post, Body, Req, Res, UseGuards, UseInterceptors, UseFilters, HttpCode, HttpStatus, Get } from '@nestjs/common';
import { Request, Response } from 'express';
import { AuthService } from '../services/auth.service';
import { TokenService } from '../services/token.service';
import { OtpService } from '../services/otp.service';
import { SessionService } from '../services/session.service';
import { Public, CurrentUser } from '../decorators/auth.decorators';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { RateLimitGuard, RateLimit } from '../guards/rate-limit.guard';
import { AuditLogInterceptor } from '../interceptors/audit-log.interceptor';
import { AuthExceptionFilter } from '../filters/auth-exception.filter';
import {
  AUTH_CONSTANTS,
  LoginDto,
  RegisterDto,
  OtpRequestDto,
  OtpVerifyDto,
  GoogleLoginDto,
  AppleLoginDto,
  BiometricLoginDto,
  ResetPasswordDto,
  JwtAccessPayload,
} from '@yoga24x/shared-types';

@Controller('api/v1/auth')
@UseGuards(RateLimitGuard)
@UseInterceptors(AuditLogInterceptor)
@UseFilters(AuthExceptionFilter)
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly tokenService: TokenService,
    private readonly otpService: OtpService,
    private readonly sessionService: SessionService,
  ) {}

  // ============================================================================
  // Password Login
  // ============================================================================

  @Public()
  @Post('login')
  @HttpCode(HttpStatus.OK)
  @RateLimit(10, 300)
  async login(@Body() dto: LoginDto, @Req() req: Request, @Res({ passthrough: true }) res: Response) {
    const ip = req.headers['x-forwarded-for'] as string || req.socket.remoteAddress || '127.0.0.1';
    const ua = req.headers['user-agent'] || 'unknown';
    const result = await this.authService.loginWithPassword(dto, ip, ua);

    this.setTokenCookies(res, result.tokens.accessToken, result.tokens.refreshToken);
    return { success: true, data: result };
  }

  // ============================================================================
  // User Registration
  // ============================================================================

  @Public()
  @Post('register')
  @HttpCode(HttpStatus.CREATED)
  @RateLimit(5, 3600)
  async register(@Body() dto: RegisterDto, @Req() req: Request, @Res({ passthrough: true }) res: Response) {
    const ip = req.headers['x-forwarded-for'] as string || req.socket.remoteAddress || '127.0.0.1';
    const ua = req.headers['user-agent'] || 'unknown';
    const result = await this.authService.register(dto, ip, ua);

    this.setTokenCookies(res, result.tokens.accessToken, result.tokens.refreshToken);
    return { success: true, data: result };
  }

  // ============================================================================
  // OTP Generation & Dispatch
  // ============================================================================

  @Public()
  @Post('otp/request')
  @HttpCode(HttpStatus.OK)
  @RateLimit(5, 900)
  async requestOtp(@Body() dto: OtpRequestDto) {
    const result = await this.otpService.generateAndSendOtp(dto.identifier, dto.purpose, dto.channel || 'SMS');
    return { success: true, data: result };
  }

  // ============================================================================
  // OTP Verification / Passwordless Login / 2FA Completion
  // ============================================================================

  @Public()
  @Post('otp/verify')
  @HttpCode(HttpStatus.OK)
  @RateLimit(10, 600)
  async verifyOtp(@Body() dto: OtpVerifyDto, @Req() req: Request, @Res({ passthrough: true }) res: Response) {
    const ip = req.headers['x-forwarded-for'] as string || req.socket.remoteAddress || '127.0.0.1';
    const ua = req.headers['user-agent'] || 'unknown';

    if (dto.purpose === 'LOGIN' || dto.purpose === 'TWO_FACTOR' || dto.purpose === 'PHONE_VERIFY') {
      const result = await this.authService.loginWithOtp(dto.identifier, dto.otpCode, dto.purpose, dto.deviceInfo, ip, ua);
      this.setTokenCookies(res, result.tokens.accessToken, result.tokens.refreshToken);
      return { success: true, data: result };
    }

    // For non-login OTP verification (e.g., password reset pre-verification)
    await this.otpService.verifyOtp(dto.identifier, dto.otpCode, dto.purpose);
    return { success: true, message: 'OTP verified successfully' };
  }

  // ============================================================================
  // Google OAuth Login
  // ============================================================================

  @Public()
  @Post('oauth/google')
  @HttpCode(HttpStatus.OK)
  @RateLimit(15, 300)
  async loginGoogle(@Body() dto: GoogleLoginDto, @Req() req: Request, @Res({ passthrough: true }) res: Response) {
    const ip = req.headers['x-forwarded-for'] as string || req.socket.remoteAddress || '127.0.0.1';
    const ua = req.headers['user-agent'] || 'unknown';
    const result = await this.authService.loginWithGoogle(dto, ip, ua);

    this.setTokenCookies(res, result.tokens.accessToken, result.tokens.refreshToken);
    return { success: true, data: result };
  }

  // ============================================================================
  // Apple Sign-In OAuth Login
  // ============================================================================

  @Public()
  @Post('oauth/apple')
  @HttpCode(HttpStatus.OK)
  @RateLimit(15, 300)
  async loginApple(@Body() dto: AppleLoginDto, @Req() req: Request, @Res({ passthrough: true }) res: Response) {
    const ip = req.headers['x-forwarded-for'] as string || req.socket.remoteAddress || '127.0.0.1';
    const ua = req.headers['user-agent'] || 'unknown';
    const result = await this.authService.loginWithApple(dto, ip, ua);

    this.setTokenCookies(res, result.tokens.accessToken, result.tokens.refreshToken);
    return { success: true, data: result };
  }

  // ============================================================================
  // Biometric Passkey Login
  // ============================================================================

  @Public()
  @Post('biometric/login')
  @HttpCode(HttpStatus.OK)
  @RateLimit(15, 300)
  async loginBiometric(@Body() dto: BiometricLoginDto, @Req() req: Request, @Res({ passthrough: true }) res: Response) {
    const ip = req.headers['x-forwarded-for'] as string || req.socket.remoteAddress || '127.0.0.1';
    const ua = req.headers['user-agent'] || 'unknown';
    const result = await this.authService.loginWithBiometric(dto, ip, ua);

    this.setTokenCookies(res, result.tokens.accessToken, result.tokens.refreshToken);
    return { success: true, data: result };
  }

  // ============================================================================
  // Refresh Token Rotation (Theft Detection & Family Rotation)
  // ============================================================================

  @Public()
  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  @RateLimit(30, 300)
  async refreshToken(@Body('refreshToken') bodyToken: string, @Req() req: Request, @Res({ passthrough: true }) res: Response) {
    const token = bodyToken || (req.cookies ? req.cookies[AUTH_CONSTANTS.COOKIE_REFRESH_TOKEN] : null);
    if (!token) {
      return res.status(HttpStatus.UNAUTHORIZED).json({ success: false, message: 'Refresh token missing' });
    }

    const ip = req.headers['x-forwarded-for'] as string || req.socket.remoteAddress || '127.0.0.1';
    const fp = req.headers['x-device-fingerprint'] as string || 'unknown';

    const result = await this.tokenService.rotateRefreshToken(token, fp, ip);
    this.setTokenCookies(res, result.accessToken, result.newRefreshToken);

    return {
      success: true,
      data: {
        user: result.user,
        tokens: {
          accessToken: result.accessToken,
          refreshToken: result.newRefreshToken,
          expiresIn: AUTH_CONSTANTS.ACCESS_TOKEN_TTL_SECONDS,
          tokenType: 'Bearer',
        },
        sessionId: result.sessionId,
      },
    };
  }

  // ============================================================================
  // Logout (Single Device vs All Devices)
  // ============================================================================

  @UseGuards(JwtAuthGuard)
  @Post('logout')
  @HttpCode(HttpStatus.OK)
  async logout(@CurrentUser() user: JwtAccessPayload, @Body('allDevices') allDevices: boolean, @Res({ passthrough: true }) res: Response) {
    if (allDevices) {
      await this.sessionService.revokeAllUserSessions(user.sub);
    } else if (user.sessionId) {
      await this.sessionService.revokeSession(user.sessionId);
    }

    // Blacklist current access token JTI
    await this.tokenService.revokeAccessToken(user.jti, AUTH_CONSTANTS.ACCESS_TOKEN_TTL_SECONDS);

    // Clear Cookies
    res.clearCookie(AUTH_CONSTANTS.COOKIE_ACCESS_TOKEN);
    res.clearCookie(AUTH_CONSTANTS.COOKIE_REFRESH_TOKEN);

    return { success: true, message: allDevices ? 'Logged out from all devices' : 'Logged out successfully' };
  }

  // ============================================================================
  // Password Reset
  // ============================================================================

  @Public()
  @Post('password/reset')
  @HttpCode(HttpStatus.OK)
  @RateLimit(5, 3600)
  async resetPassword(@Body() dto: ResetPasswordDto) {
    const result = await this.authService.resetPassword(dto);
    return { success: true, data: result };
  }

  // ============================================================================
  // Get Current Profile (Me)
  // ============================================================================

  @UseGuards(JwtAuthGuard)
  @Get('me')
  @HttpCode(HttpStatus.OK)
  async getProfile(@CurrentUser() user: JwtAccessPayload) {
    return { success: true, data: { user } };
  }

  // ============================================================================
  // Cookie Helper
  // ============================================================================

  private setTokenCookies(res: Response, accessToken: string, refreshToken: string): void {
    const isProd = process.env.NODE_ENV === 'production';

    res.cookie(AUTH_CONSTANTS.COOKIE_ACCESS_TOKEN, accessToken, {
      httpOnly: true,
      secure: isProd,
      sameSite: 'strict',
      maxAge: AUTH_CONSTANTS.ACCESS_TOKEN_TTL_SECONDS * 1000,
      path: '/',
    });

    res.cookie(AUTH_CONSTANTS.COOKIE_REFRESH_TOKEN, refreshToken, {
      httpOnly: true,
      secure: isProd,
      sameSite: 'strict',
      maxAge: AUTH_CONSTANTS.REFRESH_TOKEN_TTL_SECONDS * 1000,
      path: '/api/v1/auth/refresh',
    });
  }
}

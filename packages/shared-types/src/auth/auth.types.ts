// ==============================================================================
// Yoga24X AI Engineering OS — Auth TypeScript Interfaces & Contracts
// ==============================================================================

export type UserRoleName =
  | "STUDENT"
  | "TEACHER"
  | "DOCTOR"
  | "NUTRITIONIST"
  | "MEDITATION_COACH"
  | "STUDIO_OWNER"
  | "CORPORATE_HR"
  | "ADMIN"
  | "SUPER_ADMIN";

export type IdentityProviderType = "EMAIL" | "PHONE" | "GOOGLE" | "APPLE";

export interface JwtAccessPayload {
  sub: string; // User UUID
  email: string;
  roles: UserRoleName[];
  tenantId: string | null;
  sessionId: string;
  deviceId: string | null;
  jti: string; // Unique JWT ID for instant blacklisting
  iat: number;
  exp: number;
}

export interface JwtRefreshPayload {
  sub: string;
  familyId: string;
  tokenHash: string;
  sessionId: string;
  deviceId: string | null;
  iat: number;
  exp: number;
}

export interface SessionData {
  sessionId: string;
  userId: string;
  deviceId: string | null;
  deviceFingerprint: string;
  ipAddress: string;
  userAgent: string;
  location: string;
  deviceType: string;
  isActive: boolean;
  createdAt: string;
  lastActiveAt: string;
}

export interface DeviceInfo {
  deviceId?: string;
  deviceFingerprint: string;
  deviceName: string;
  deviceType:
    "MOBILE_IOS" | "MOBILE_ANDROID" | "WEB_BROWSER" | "DESKTOP" | "TABLET";
  osVersion?: string;
  appVersion?: string;
  fcmToken?: string;
}

export interface RiskEvaluationResult {
  riskScore: number; // 0 to 100
  riskLevel: "LOW" | "MEDIUM" | "HIGH" | "CRITICAL";
  factors: string[];
  requireMfa: boolean;
  blockLogin: boolean;
}

export interface AuthResponse {
  user: {
    id: string;
    email: string;
    phoneNumber: string | null;
    firstName: string;
    lastName: string;
    avatarUrl: string | null;
    roles: UserRoleName[];
    status: string;
    isEmailVerified: boolean;
    isPhoneVerified: boolean;
    twoFactorEnabled: boolean;
    tenantId: string | null;
  };
  tokens: {
    accessToken: string;
    refreshToken: string;
    expiresIn: number;
    tokenType: "Bearer";
  };
  session: {
    sessionId: string;
    isTrustedDevice: boolean;
  };
  risk?: {
    score: number;
    level: string;
  };
}

export interface OtpDeliveryResult {
  identifier: string;
  purpose: string;
  channel: "SMS" | "WHATSAPP" | "EMAIL";
  expiresInSeconds: number;
  deliveryStatus: "SENT" | "FAILED" | "QUEUED";
}

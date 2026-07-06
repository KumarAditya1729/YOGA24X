// ==============================================================================
// Yoga24X AI Engineering OS — Auth Zod Schemas & DTOs
// ==============================================================================

import { z } from "zod";

export const DeviceInfoSchema = z.object({
  deviceId: z.string().uuid().optional(),
  deviceFingerprint: z.string().min(10).max(255),
  deviceName: z.string().min(1).max(100),
  deviceType: z.enum([
    "MOBILE_IOS",
    "MOBILE_ANDROID",
    "WEB_BROWSER",
    "DESKTOP",
    "TABLET",
  ]),
  osVersion: z.string().max(50).optional(),
  appVersion: z.string().max(50).optional(),
  fcmToken: z.string().optional(),
});

export const LoginDtoSchema = z.object({
  emailOrPhone: z.string().min(3).max(255),
  password: z.string().min(8).max(100),
  rememberMe: z.boolean().default(false),
  deviceInfo: DeviceInfoSchema,
});
export type LoginDto = z.infer<typeof LoginDtoSchema>;

export const RegisterDtoSchema = z.object({
  email: z.string().email().max(255),
  phoneNumber: z
    .string()
    .regex(/^\+?[1-9]\d{6,14}$/, "Invalid international phone number")
    .optional(),
  password: z
    .string()
    .min(8, "Password must be at least 8 characters")
    .regex(/[A-Z]/, "Must contain at least one uppercase letter")
    .regex(/[a-z]/, "Must contain at least one lowercase letter")
    .regex(/[0-9]/, "Must contain at least one number")
    .regex(/[^A-Za-z0-9]/, "Must contain at least one special character"),
  firstName: z.string().min(1).max(100),
  lastName: z.string().min(1).max(100),
  role: z.enum(["STUDENT", "TEACHER", "DOCTOR"]).default("STUDENT"),
  deviceInfo: DeviceInfoSchema,
});
export type RegisterDto = z.infer<typeof RegisterDtoSchema>;

export const OtpRequestDtoSchema = z.object({
  identifier: z.string().min(3).max(255), // Phone or Email
  purpose: z.enum(["LOGIN", "PASSWORD_RESET", "PHONE_VERIFY", "TWO_FACTOR"]),
  channel: z.enum(["SMS", "WHATSAPP", "EMAIL"]).default("SMS"),
  deviceInfo: DeviceInfoSchema.optional(),
});
export type OtpRequestDto = z.infer<typeof OtpRequestDtoSchema>;

export const OtpVerifyDtoSchema = z.object({
  identifier: z.string().min(3).max(255),
  otpCode: z
    .string()
    .length(6, "OTP must be exactly 6 digits")
    .regex(/^\d{6}$/, "OTP must contain only digits"),
  purpose: z.enum(["LOGIN", "PASSWORD_RESET", "PHONE_VERIFY", "TWO_FACTOR"]),
  rememberMe: z.boolean().default(false),
  deviceInfo: DeviceInfoSchema,
});
export type OtpVerifyDto = z.infer<typeof OtpVerifyDtoSchema>;

export const GoogleLoginDtoSchema = z.object({
  idToken: z.string().min(20),
  role: z.enum(["STUDENT", "TEACHER", "DOCTOR"]).default("STUDENT"),
  rememberMe: z.boolean().default(false),
  deviceInfo: DeviceInfoSchema,
});
export type GoogleLoginDto = z.infer<typeof GoogleLoginDtoSchema>;

export const AppleLoginDtoSchema = z.object({
  identityToken: z.string().min(20),
  authorizationCode: z.string().min(10),
  firstName: z.string().max(100).optional(),
  lastName: z.string().max(100).optional(),
  role: z.enum(["STUDENT", "TEACHER", "DOCTOR"]).default("STUDENT"),
  rememberMe: z.boolean().default(false),
  deviceInfo: DeviceInfoSchema,
});
export type AppleLoginDto = z.infer<typeof AppleLoginDtoSchema>;

export const BiometricLoginDtoSchema = z.object({
  userId: z.string().uuid(),
  deviceFingerprint: z.string().min(10),
  cryptographicSignature: z.string().min(20), // Signed passkey challenge
  payloadChallenge: z.string().min(10),
  deviceInfo: DeviceInfoSchema,
});
export type BiometricLoginDto = z.infer<typeof BiometricLoginDtoSchema>;

export const BiometricRegisterDtoSchema = z.object({
  deviceFingerprint: z.string().min(10),
  deviceName: z.string().min(1).max(100),
  publicKey: z.string().min(20),
});
export type BiometricRegisterDto = z.infer<typeof BiometricRegisterDtoSchema>;

export const RefreshTokenDtoSchema = z.object({
  refreshToken: z.string().min(20),
  deviceFingerprint: z.string().min(10),
});
export type RefreshTokenDto = z.infer<typeof RefreshTokenDtoSchema>;

export const LogoutDtoSchema = z.object({
  refreshToken: z.string().min(20).optional(),
  logoutAllDevices: z.boolean().default(false),
  deviceFingerprint: z.string().optional(),
});
export type LogoutDto = z.infer<typeof LogoutDtoSchema>;

export const ForgotPasswordDtoSchema = z.object({
  identifier: z.string().min(3).max(255),
  channel: z.enum(["EMAIL", "SMS", "WHATSAPP"]).default("EMAIL"),
});
export type ForgotPasswordDto = z.infer<typeof ForgotPasswordDtoSchema>;

export const ResetPasswordDtoSchema = z.object({
  identifier: z.string().min(3).max(255),
  otpCode: z.string().length(6),
  newPassword: z
    .string()
    .min(8)
    .regex(/[A-Z]/, "Must contain uppercase")
    .regex(/[a-z]/, "Must contain lowercase")
    .regex(/[0-9]/, "Must contain number")
    .regex(/[^A-Za-z0-9]/, "Must contain special character"),
  deviceInfo: DeviceInfoSchema,
});
export type ResetPasswordDto = z.infer<typeof ResetPasswordDtoSchema>;

export const AdminForceLogoutDtoSchema = z.object({
  userId: z.string().uuid(),
  reason: z.string().min(3).max(255),
});
export type AdminForceLogoutDto = z.infer<typeof AdminForceLogoutDtoSchema>;

export const AdminAccountControlDtoSchema = z.object({
  userId: z.string().uuid(),
  action: z.enum(["LOCK", "UNLOCK", "SUSPEND", "ACTIVATE", "REVOKE_DEVICE"]),
  deviceId: z.string().uuid().optional(),
  reason: z.string().min(3).max(255),
});
export type AdminAccountControlDto = z.infer<
  typeof AdminAccountControlDtoSchema
>;

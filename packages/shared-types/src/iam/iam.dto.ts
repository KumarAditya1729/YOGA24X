// ==============================================================================
// Yoga24X AI Engineering OS — IAM & User Management Zod Schemas & DTOs
// ==============================================================================

import { z } from "zod";

export const UpdateBasicProfileSchema = z.object({
  firstName: z
    .string()
    .min(2, "First name must be at least 2 characters")
    .max(50)
    .optional(),
  lastName: z
    .string()
    .min(2, "Last name must be at least 2 characters")
    .max(50)
    .optional(),
  phoneNumber: z
    .string()
    .regex(/^\+[1-9]\d{6,14}$/, "Invalid international phone format")
    .optional(),
});
export type UpdateBasicProfileDto = z.infer<typeof UpdateBasicProfileSchema>;

export const UpdateStudentProfileSchema = z.object({
  dateOfBirth: z.string().datetime().optional(),
  gender: z.enum(["MALE", "FEMALE", "OTHER", "PREFER_NOT_TO_SAY"]).optional(),
  heightCm: z.number().min(50).max(250).optional(),
  weightKg: z.number().min(20).max(300).optional(),
  experienceLevel: z.enum(["BEGINNER", "INTERMEDIATE", "ADVANCED"]).optional(),
  ayurvedicDosha: z
    .enum([
      "VATA",
      "PITTA",
      "KAPHA",
      "VATA_PITTA",
      "PITTA_KAPHA",
      "VATA_KAPHA",
      "TRIDOSHA",
    ])
    .optional(),
  medicalConditions: z.array(z.string()).optional(),
  emergencyContactPhone: z.string().optional(),
});
export type UpdateStudentProfileDto = z.infer<
  typeof UpdateStudentProfileSchema
>;

export const UpdateTeacherProfileSchema = z.object({
  bio: z
    .string()
    .min(10, "Bio must be at least 10 characters")
    .max(2000)
    .optional(),
  yearsExperience: z.number().int().min(0).max(70).optional(),
  specializations: z
    .array(z.string())
    .min(1, "At least one specialization required")
    .optional(),
  hourlyRateCents: z.number().int().min(0).optional(),
});
export type UpdateTeacherProfileDto = z.infer<
  typeof UpdateTeacherProfileSchema
>;

export const UpdateDoctorProfileSchema = z.object({
  medicalRegistrationNumber: z.string().min(3).max(100).optional(),
  qualification: z.string().min(2).max(255).optional(),
  consultationFeeCents: z.number().int().min(0).optional(),
});
export type UpdateDoctorProfileDto = z.infer<typeof UpdateDoctorProfileSchema>;

export const UpdateSettingsSchema = z.object({
  theme: z.enum(["LIGHT", "DARK", "SYSTEM"]).optional(),
  language: z.string().min(2).max(10).optional(),
  timezone: z.string().min(3).max(50).optional(),
  currency: z.string().length(3).optional(),
  measurementUnit: z.enum(["METRIC", "IMPERIAL"]).optional(),
  accessibilityPrefJson: z.record(z.any()).optional(),
  privacyPrefJson: z.record(z.any()).optional(),
});
export type UpdateSettingsDto = z.infer<typeof UpdateSettingsSchema>;

export const UpdateNotificationPrefSchema = z.object({
  pushEnabled: z.boolean().optional(),
  emailEnabled: z.boolean().optional(),
  smsEnabled: z.boolean().optional(),
  marketingPref: z.boolean().optional(),
});
export type UpdateNotificationPrefDto = z.infer<
  typeof UpdateNotificationPrefSchema
>;

export const CreateOrganizationSchema = z.object({
  name: z.string().min(2, "Organization name required").max(255),
  type: z.enum(["STUDIO", "CORPORATE"]),
  address: z.string().optional(),
  city: z.string().optional(),
  country: z.string().optional(),
});
export type CreateOrganizationDto = z.infer<typeof CreateOrganizationSchema>;

export const InviteOrgMemberSchema = z.object({
  email: z.string().email("Invalid email format"),
  role: z.enum(["OWNER", "ADMIN", "MEMBER"]).default("MEMBER"),
  teamId: z.string().uuid().optional(),
});
export type InviteOrgMemberDto = z.infer<typeof InviteOrgMemberSchema>;

export const SubmitVerificationSchema = z.object({
  verificationType: z.enum([
    "EMAIL",
    "PHONE",
    "GOVERNMENT_ID",
    "TEACHER_CERT",
    "DOCTOR_REG",
    "STUDIO_REG",
    "CORPORATE_REG",
  ]),
  submittedDataJson: z.record(z.any()).optional(),
  documents: z
    .array(
      z.object({
        documentType: z.string().min(2),
        fileUrl: z.string().url(),
        fileSizeBytes: z.number().int().positive(),
        mimeType: z.string(),
      }),
    )
    .min(1, "At least one document is required for verification"),
});
export type SubmitVerificationDto = z.infer<typeof SubmitVerificationSchema>;

export const ReviewVerificationSchema = z.object({
  status: z.enum(["APPROVED", "REJECTED", "RESUBMISSION_REQUIRED"]),
  rejectionReason: z.string().optional(),
});
export type ReviewVerificationDto = z.infer<typeof ReviewVerificationSchema>;

export const UpdateConsentSchema = z.object({
  consentType: z.enum([
    "TERMS_OF_SERVICE",
    "PRIVACY_POLICY",
    "COOKIE_PREFERENCES",
    "MARKETING_COMMUNICATIONS",
    "AI_COACHING",
    "HEALTH_DATA_PROCESSING",
  ]),
  isAccepted: z.boolean(),
});
export type UpdateConsentDto = z.infer<typeof UpdateConsentSchema>;

export const AccountDeletionRequestSchema = z.object({
  reason: z.string().max(1000).optional(),
  passwordConfirmation: z
    .string()
    .min(1, "Password confirmation required to request account deletion"),
});
export type AccountDeletionRequestDto = z.infer<
  typeof AccountDeletionRequestSchema
>;

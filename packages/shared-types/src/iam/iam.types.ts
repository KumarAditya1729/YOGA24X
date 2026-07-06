// ==============================================================================
// Yoga24X AI Engineering OS — IAM & User Management Types & Interfaces
// ==============================================================================

export type VerificationStatusType =
  "PENDING" | "IN_REVIEW" | "APPROVED" | "REJECTED" | "RESUBMISSION_REQUIRED";
export type OrganizationRoleType = "OWNER" | "ADMIN" | "MEMBER";
export type OrganizationType = "STUDIO" | "CORPORATE";
export type ConsentType =
  | "TERMS_OF_SERVICE"
  | "PRIVACY_POLICY"
  | "COOKIE_PREFERENCES"
  | "MARKETING_COMMUNICATIONS"
  | "AI_COACHING"
  | "HEALTH_DATA_PROCESSING";

export interface ProfileCompletionResult {
  percentage: number;
  completedFields: string[];
  missingRequiredFields: string[];
  missingOptionalFields: string[];
  isVerified: boolean;
  nextRecommendedAction: string | null;
}

export interface UserProfileOverview {
  id: string;
  email: string;
  phoneNumber?: string;
  firstName: string;
  lastName: string;
  avatarUrl?: string;
  status: string;
  isEmailVerified: boolean;
  isPhoneVerified: boolean;
  twoFactorEnabled: boolean;
  profileCompletionPercentage: number;
  roles: string[];
  studentProfile?: any;
  instructorProfile?: any;
  doctorProfile?: any;
  nutritionistProfile?: any;
  studioProfile?: any;
  corporateProfile?: any;
  adminProfile?: any;
  superAdminProfile?: any;
  userSettings?: UserSettingsInterface;
  notificationPref?: UserNotificationPrefInterface;
  createdAt: Date;
  updatedAt: Date;
}

export interface UserSettingsInterface {
  theme: string;
  language: string;
  timezone: string;
  currency: string;
  measurementUnit: string;
  accessibilityPrefJson?: Record<string, any>;
  privacyPrefJson?: Record<string, any>;
}

export interface UserNotificationPrefInterface {
  pushEnabled: boolean;
  emailEnabled: boolean;
  smsEnabled: boolean;
  marketingPref: boolean;
}

export interface OrganizationOverview {
  id: string;
  name: string;
  type: OrganizationType;
  ownerId: string;
  logoUrl?: string;
  address?: string;
  city?: string;
  country?: string;
  status: string;
  memberCount: number;
  teamCount: number;
  branchCount: number;
  createdAt: Date;
}

export interface VerificationOverview {
  id: string;
  userId: string;
  verificationType: string;
  status: VerificationStatusType;
  submittedDataJson?: Record<string, any>;
  rejectionReason?: string;
  submittedAt: Date;
  reviewedAt?: Date;
  documents: {
    id: string;
    documentType: string;
    fileUrl: string;
    fileSizeBytes: number;
    mimeType: string;
  }[];
}

export interface PrivacyConsentRecord {
  id: string;
  consentType: ConsentType;
  isAccepted: boolean;
  acceptedAt: Date;
  revokedAt?: Date;
}

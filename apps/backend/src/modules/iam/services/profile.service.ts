// ==============================================================================
// Yoga24X AI Engineering OS — User Profile Service
// Handles profile updates, completion percentage calculation, and media uploads
// ==============================================================================

import { Injectable, BadRequestException } from "@nestjs/common";
import { UserProfileRepository } from "../repositories/user-profile.repository";
import {
  UpdateBasicProfileDto,
  UpdateStudentProfileDto,
  UpdateTeacherProfileDto,
  UpdateDoctorProfileDto,
  UpdateSettingsDto,
  UpdateNotificationPrefDto,
  ProfileCompletionResult,
  IAM_CONSTANTS,
} from "@yoga24x/shared-types";

@Injectable()
export class ProfileService {
  constructor(private readonly profileRepo: UserProfileRepository) {}

  async getProfileOverview(userId: string): Promise<any> {
    return this.profileRepo.getCompleteProfile(userId);
  }

  async calculateProfileCompletion(
    userId: string,
  ): Promise<ProfileCompletionResult> {
    const profile = await this.profileRepo.getCompleteProfile(userId);

    const completedFields: string[] = [];
    const missingRequiredFields: string[] = [];
    const missingOptionalFields: string[] = [];

    // Basic Info Check (30%)
    let score = 0;
    if (profile.firstName && profile.lastName) {
      completedFields.push("firstName", "lastName");
      score += 15;
    } else {
      missingRequiredFields.push("firstName", "lastName");
    }

    if (profile.phoneNumber) {
      completedFields.push("phoneNumber");
      score += 15;
    } else {
      missingRequiredFields.push("phoneNumber");
    }

    // Contact Verification (20%)
    if (profile.isEmailVerified) {
      completedFields.push("isEmailVerified");
      score += 10;
    } else {
      missingRequiredFields.push("email Verification");
    }

    if (profile.isPhoneVerified) {
      completedFields.push("isPhoneVerified");
      score += 10;
    } else {
      missingOptionalFields.push("phone Verification");
    }

    // Avatar Uploaded (10%)
    if (profile.avatarUrl) {
      completedFields.push("avatarUrl");
      score += 10;
    } else {
      missingOptionalFields.push("avatar Upload");
    }

    // Role-specific checks (30%)
    let isVerified = false;
    let nextRecommendedAction: string | null = null;

    if (profile.roles.includes("STUDENT")) {
      if (
        profile.studentProfile?.gender &&
        profile.studentProfile?.experienceLevel
      ) {
        completedFields.push("studentProfile");
        score += 30;
      } else {
        missingRequiredFields.push("student dosha & experience level");
        nextRecommendedAction =
          "Complete your Ayurvedic Dosha assessment and experience level";
      }
    } else if (profile.roles.includes("TEACHER")) {
      if (
        profile.instructorProfile?.bio &&
        profile.instructorProfile?.specializations?.length > 0
      ) {
        completedFields.push("instructorProfile");
        score += 30;
      } else {
        missingRequiredFields.push("teacher bio & specializations");
        nextRecommendedAction =
          "Add your teaching bio, RYT certifications, and specializations";
      }
      isVerified = profile.instructorProfile?.isVerified || false;
    } else if (profile.roles.includes("DOCTOR")) {
      if (profile.doctorProfile?.medicalRegistrationNumber) {
        completedFields.push("doctorProfile");
        score += 30;
      } else {
        missingRequiredFields.push("medical registration number");
        nextRecommendedAction =
          "Upload your Ayurvedic medical registration certificate for verification";
      }
      isVerified = profile.doctorProfile?.isVerified || false;
    } else {
      // Default fallback for other roles
      score += 30;
    }

    // Privacy Consent (10%)
    completedFields.push("privacyConsents");
    score += 10;

    const percentage = Math.min(100, Math.round(score));
    await this.profileRepo.setProfileCompletionPercentage(userId, percentage);

    if (!nextRecommendedAction) {
      if (!profile.avatarUrl)
        nextRecommendedAction = "Upload a professional profile photo";
      else if (!profile.isPhoneVerified)
        nextRecommendedAction = "Verify your phone number with OTP";
      else nextRecommendedAction = "Your profile is 100% complete!";
    }

    return {
      percentage,
      completedFields,
      missingRequiredFields,
      missingOptionalFields,
      isVerified,
      nextRecommendedAction,
    };
  }

  async updateBasicProfile(
    userId: string,
    dto: UpdateBasicProfileDto,
  ): Promise<any> {
    const updated = await this.profileRepo.updateBasicProfile(userId, dto);
    await this.calculateProfileCompletion(userId);
    return updated;
  }

  async updateStudentProfile(
    userId: string,
    dto: UpdateStudentProfileDto,
  ): Promise<any> {
    const updated = await this.profileRepo.updateStudentProfile(userId, dto);
    await this.calculateProfileCompletion(userId);
    return updated;
  }

  async updateTeacherProfile(
    userId: string,
    dto: UpdateTeacherProfileDto,
  ): Promise<any> {
    const updated = await this.profileRepo.updateTeacherProfile(userId, dto);
    await this.calculateProfileCompletion(userId);
    return updated;
  }

  async updateDoctorProfile(
    userId: string,
    dto: UpdateDoctorProfileDto,
  ): Promise<any> {
    const updated = await this.profileRepo.updateDoctorProfile(userId, dto);
    await this.calculateProfileCompletion(userId);
    return updated;
  }

  async updateSettings(userId: string, dto: UpdateSettingsDto): Promise<any> {
    return this.profileRepo.updateUserSettings(userId, dto);
  }

  async updateNotificationPref(
    userId: string,
    dto: UpdateNotificationPrefDto,
  ): Promise<any> {
    return this.profileRepo.updateNotificationPref(userId, dto);
  }

  async uploadProfileMedia(
    userId: string,
    mediaType: "AVATAR" | "COVER_IMAGE",
    fileUrl: string,
    fileSizeBytes: number,
    mimeType: string,
  ): Promise<any> {
    if (!IAM_CONSTANTS.ALLOWED_IMAGE_MIMES.includes(mimeType as any)) {
      throw new BadRequestException(
        IAM_CONSTANTS.ERROR_CODES.INVALID_IMAGE_FORMAT,
      );
    }

    const maxSize =
      mediaType === "AVATAR"
        ? IAM_CONSTANTS.MAX_AVATAR_SIZE_BYTES
        : IAM_CONSTANTS.MAX_COVER_SIZE_BYTES;
    if (fileSizeBytes > maxSize) {
      throw new BadRequestException(
        `File size exceeds limit of ${maxSize / (1024 * 1024)}MB`,
      );
    }

    const media = await this.profileRepo.addProfileMedia(
      userId,
      mediaType,
      fileUrl,
      fileSizeBytes,
      mimeType,
      fileUrl,
      fileUrl,
    );
    await this.calculateProfileCompletion(userId);
    return media;
  }
}

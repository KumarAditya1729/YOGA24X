// ==============================================================================
// Yoga24X AI Engineering OS — User Profile Repository
// Handles basic profile, all 9 specialized profiles, settings, media, and completion %
// ==============================================================================

import { Injectable, NotFoundException } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import {
  UpdateBasicProfileDto,
  UpdateStudentProfileDto,
  UpdateTeacherProfileDto,
  UpdateDoctorProfileDto,
  UpdateSettingsDto,
  UpdateNotificationPrefDto,
  IAM_CONSTANTS,
} from "@yoga24x/shared-types";

@Injectable()
export class UserProfileRepository {
  constructor(private readonly prisma: PrismaService) {}

  async getCompleteProfile(userId: string): Promise<any> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      include: {
        studentProfile: true,
        instructorProfile: true,
        doctorProfile: true,
        nutritionistProfile: true,
        studioProfile: true,
        corporateProfile: true,
        adminProfile: true,
        superAdminProfile: true,
        userSettings: true,
        notificationPref: true,
        profileMedia: {
          where: { isValidated: true },
          orderBy: { version: "desc" },
        },
        identities: true,
        userRoles: { include: { role: true } },
      },
    });

    if (!user) {
      throw new NotFoundException(IAM_CONSTANTS.ERROR_CODES.USER_NOT_FOUND);
    }

    const roles = user.userRoles.map((ur: any) => ur.role.name);
    return {
      ...user,
      roles,
      passwordHash: undefined,
      twoFactorSecret: undefined,
    };
  }

  async updateBasicProfile(
    userId: string,
    dto: UpdateBasicProfileDto,
  ): Promise<any> {
    const updated = await this.prisma.user.update({
      where: { id: userId },
      data: {
        firstName: dto.firstName,
        lastName: dto.lastName,
        phoneNumber: dto.phoneNumber,
      },
    });
    return updated;
  }

  async updateStudentProfile(
    userId: string,
    dto: UpdateStudentProfileDto,
  ): Promise<any> {
    const data: any = {};
    if (dto.dateOfBirth) data.dateOfBirth = new Date(dto.dateOfBirth);
    if (dto.gender) data.gender = dto.gender as any;
    if (dto.heightCm !== undefined) data.heightCm = dto.heightCm;
    if (dto.weightKg !== undefined) data.weightKg = dto.weightKg;
    if (dto.experienceLevel) data.experienceLevel = dto.experienceLevel as any;
    if (dto.ayurvedicDosha) data.ayurvedicDosha = dto.ayurvedicDosha as any;
    if (dto.medicalConditions) data.medicalConditions = dto.medicalConditions;
    if (dto.emergencyContactPhone)
      data.emergencyContactPhone = dto.emergencyContactPhone;

    return this.prisma.studentProfile.upsert({
      where: { userId },
      update: data,
      create: {
        userId,
        gender: (dto.gender as any) || "PREFER_NOT_TO_SAY",
        experienceLevel: (dto.experienceLevel as any) || "BEGINNER",
        ...data,
      },
    });
  }

  async updateTeacherProfile(
    userId: string,
    dto: UpdateTeacherProfileDto,
  ): Promise<any> {
    return this.prisma.instructorProfile.upsert({
      where: { userId },
      update: {
        bio: dto.bio,
        yearsExperience: dto.yearsExperience,
        specializations: dto.specializations,
        hourlyRateCents: dto.hourlyRateCents,
      },
      create: {
        userId,
        bio: dto.bio || "",
        yearsExperience: dto.yearsExperience || 0,
        specializations: dto.specializations || [],
        hourlyRateCents: dto.hourlyRateCents || 0,
      },
    });
  }

  async updateDoctorProfile(
    userId: string,
    dto: UpdateDoctorProfileDto,
  ): Promise<any> {
    return this.prisma.doctorProfile.upsert({
      where: { userId },
      update: {
        medicalRegistrationNumber: dto.medicalRegistrationNumber,
        qualification: dto.qualification,
        consultationFeeCents: dto.consultationFeeCents,
      },
      create: {
        userId,
        medicalRegistrationNumber:
          dto.medicalRegistrationNumber || `REG_${Date.now()}`,
        qualification: dto.qualification || "Medical Practitioner",
        consultationFeeCents: dto.consultationFeeCents || 0,
      },
    });
  }

  async updateUserSettings(
    userId: string,
    dto: UpdateSettingsDto,
  ): Promise<any> {
    return this.prisma.userSettings.upsert({
      where: { userId },
      update: {
        theme: dto.theme,
        language: dto.language,
        timezone: dto.timezone,
        currency: dto.currency,
        measurementUnit: dto.measurementUnit,
        accessibilityPrefJson: dto.accessibilityPrefJson,
        privacyPrefJson: dto.privacyPrefJson,
      },
      create: {
        userId,
        theme: dto.theme || "DARK",
        language: dto.language || "en",
        timezone: dto.timezone || "UTC",
        currency: dto.currency || "USD",
        measurementUnit: dto.measurementUnit || "METRIC",
        accessibilityPrefJson: dto.accessibilityPrefJson || {},
        privacyPrefJson: dto.privacyPrefJson || {},
      },
    });
  }

  async updateNotificationPref(
    userId: string,
    dto: UpdateNotificationPrefDto,
  ): Promise<any> {
    return this.prisma.userNotificationPreference.upsert({
      where: { userId },
      update: {
        pushEnabled: dto.pushEnabled,
        emailEnabled: dto.emailEnabled,
        smsEnabled: dto.smsEnabled,
        marketingPref: dto.marketingPref,
      },
      create: {
        userId,
        pushEnabled: dto.pushEnabled ?? true,
        emailEnabled: dto.emailEnabled ?? true,
        smsEnabled: dto.smsEnabled ?? false,
        marketingPref: dto.marketingPref ?? false,
      },
    });
  }

  async addProfileMedia(
    userId: string,
    mediaType: "AVATAR" | "COVER_IMAGE",
    originalUrl: string,
    fileSizeBytes: number,
    mimeType: string,
    compressedUrl?: string,
    thumbnailUrl?: string,
  ): Promise<any> {
    const latest = await this.prisma.profileMedia.findFirst({
      where: { userId, mediaType },
      orderBy: { version: "desc" },
    });
    const nextVersion = (latest?.version || 0) + 1;

    const media = await this.prisma.profileMedia.create({
      data: {
        userId,
        mediaType,
        originalUrl,
        compressedUrl,
        thumbnailUrl,
        fileSizeBytes,
        mimeType,
        version: nextVersion,
        isValidated: true,
      },
    });

    if (mediaType === "AVATAR") {
      await this.prisma.user.update({
        where: { id: userId },
        data: { avatarUrl: compressedUrl || originalUrl },
      });
    }

    return media;
  }

  async setProfileCompletionPercentage(
    userId: string,
    percentage: number,
  ): Promise<void> {
    await this.prisma.user.update({
      where: { id: userId },
      data: { profileCompletionPercentage: percentage },
    });
  }
}

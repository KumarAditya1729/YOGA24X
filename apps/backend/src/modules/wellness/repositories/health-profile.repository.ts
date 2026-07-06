// ==============================================================================
// Yoga24X AI Engineering OS — Health Profile Repository
// Handles Health Profile CRUD, Doctor Verification, and Medical History Storage
// ==============================================================================

import { Injectable, NotFoundException } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { UpdateHealthProfileDto } from "@yoga24x/shared-types";

@Injectable()
export class HealthProfileRepository {
  constructor(private readonly prisma: PrismaService) {}

  async getByUserId(userId: string): Promise<any | null> {
    return this.prisma.healthProfile.findUnique({
      where: { userId },
    });
  }

  async upsertHealthProfile(
    userId: string,
    dto: UpdateHealthProfileDto,
  ): Promise<any> {
    const dataToUpdate: any = {};
    if (dto.bloodGroup !== undefined) dataToUpdate.bloodGroup = dto.bloodGroup;
    if (dto.emergencyContactName !== undefined)
      dataToUpdate.emergencyContactName = dto.emergencyContactName;
    if (dto.emergencyContactPhone !== undefined)
      dataToUpdate.emergencyContactPhone = dto.emergencyContactPhone;
    if (dto.emergencyContactRelation !== undefined)
      dataToUpdate.emergencyContactRelation = dto.emergencyContactRelation;
    if (dto.pregnancyStatus !== undefined)
      dataToUpdate.pregnancyStatus = dto.pregnancyStatus;
    if (dto.medicalHistory !== undefined)
      dataToUpdate.medicalHistoryJson = dto.medicalHistory;
    if (dto.currentConditions !== undefined)
      dataToUpdate.currentConditionsJson = dto.currentConditions;
    if (dto.pastConditions !== undefined)
      dataToUpdate.pastConditionsJson = dto.pastConditions;
    if (dto.surgeries !== undefined) dataToUpdate.surgeriesJson = dto.surgeries;
    if (dto.medications !== undefined)
      dataToUpdate.medicationsJson = dto.medications;
    if (dto.allergies !== undefined) dataToUpdate.allergiesJson = dto.allergies;
    if (dto.physicalLimitations !== undefined)
      dataToUpdate.physicalLimitationsJson = dto.physicalLimitations;
    if (dto.lifestyle !== undefined) dataToUpdate.lifestyleJson = dto.lifestyle;

    return this.prisma.healthProfile.upsert({
      where: { userId },
      update: dataToUpdate,
      create: {
        userId,
        bloodGroup: dto.bloodGroup || "UNKNOWN",
        emergencyContactName: dto.emergencyContactName,
        emergencyContactPhone: dto.emergencyContactPhone,
        emergencyContactRelation: dto.emergencyContactRelation,
        pregnancyStatus: dto.pregnancyStatus || "NONE",
        medicalHistoryJson: dto.medicalHistory || [],
        currentConditionsJson: dto.currentConditions || [],
        pastConditionsJson: dto.pastConditions || [],
        surgeriesJson: dto.surgeries || [],
        medicationsJson: dto.medications || [],
        allergiesJson: dto.allergies || [],
        physicalLimitationsJson: dto.physicalLimitations || [],
        lifestyleJson: dto.lifestyle || {},
      },
    });
  }

  async verifyByDoctor(
    userId: string,
    doctorId: string,
    notes: string,
  ): Promise<any> {
    const existing = await this.getByUserId(userId);
    if (!existing) {
      throw new NotFoundException("Health profile not found for user");
    }

    return this.prisma.healthProfile.update({
      where: { userId },
      data: {
        isVerifiedByDoctor: true,
        verifiedByDoctorId: doctorId,
        verificationNotes: notes,
      },
    });
  }

  async getVerifiedProfilesCount(): Promise<number> {
    return this.prisma.healthProfile.count({
      where: { isVerifiedByDoctor: true },
    });
  }
}

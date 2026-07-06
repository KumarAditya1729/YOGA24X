// ==============================================================================
// Yoga24X AI Engineering OS — Medical Safety Service
// Business Logic for Safety Flags, Contraindications, and Pose Restrictions
// ==============================================================================

import { Injectable } from '@nestjs/common';
import { MedicalSafetyRepository } from '../repositories/medical-safety.repository';
import { CreateMedicalSafetyFlagDto } from '@yoga24x/shared-types';

@Injectable()
export class MedicalSafetyService {
  constructor(private readonly safetyRepo: MedicalSafetyRepository) {}

  async createSafetyFlag(dto: CreateMedicalSafetyFlagDto): Promise<any> {
    return this.safetyRepo.createFlag(dto);
  }

  async getActiveFlags(userId: string): Promise<any[]> {
    return this.safetyRepo.getActiveFlags(userId);
  }

  async getAllFlags(userId: string): Promise<any[]> {
    return this.safetyRepo.getAllFlags(userId);
  }

  async deactivateFlag(flagId: string, userId?: string): Promise<any> {
    return this.safetyRepo.deactivateFlag(flagId, userId);
  }

  async checkPoseRestrictions(userId: string, poseNames: string[]): Promise<any> {
    const warnings = await this.safetyRepo.checkRestrictedPoses(userId, poseNames);
    return {
      userId,
      checkedPosesCount: poseNames.length,
      isSafe: warnings.length === 0,
      warnings,
    };
  }
}

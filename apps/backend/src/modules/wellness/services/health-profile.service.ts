// ==============================================================================
// Yoga24X AI Engineering OS — Health Profile Service
// Business Logic for Medical History, PII Protection, and Safety Flag Auto-Creation
// ==============================================================================

import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { HealthProfileRepository } from '../repositories/health-profile.repository';
import { MedicalSafetyRepository } from '../repositories/medical-safety.repository';
import { UpdateHealthProfileDto, DoctorVerifyHealthProfileDto } from '@yoga24x/shared-types';

@Injectable()
export class HealthProfileService {
  constructor(
    private readonly healthRepo: HealthProfileRepository,
    private readonly safetyRepo: MedicalSafetyRepository,
  ) {}

  async getHealthProfile(userId: string): Promise<any> {
    const profile = await this.healthRepo.getByUserId(userId);
    if (!profile) {
      // Return empty default structure if not initialized
      return {
        userId,
        bloodGroup: 'UNKNOWN',
        pregnancyStatus: 'NONE',
        medicalHistory: [],
        currentConditions: [],
        pastConditions: [],
        surgeries: [],
        medications: [],
        allergies: [],
        physicalLimitations: [],
        lifestyle: {},
        isVerifiedByDoctor: false,
      };
    }
    return profile;
  }

  async updateHealthProfile(userId: string, dto: UpdateHealthProfileDto): Promise<any> {
    const updated = await this.healthRepo.upsertHealthProfile(userId, dto);

    // Automated Medical Safety Flag Generation
    await this.evaluateSafetyFlags(userId, dto);

    return updated;
  }

  async verifyHealthProfileByDoctor(doctorId: string, dto: DoctorVerifyHealthProfileDto): Promise<any> {
    return this.healthRepo.verifyByDoctor(dto.userId, doctorId, dto.verificationNotes);
  }

  private async evaluateSafetyFlags(userId: string, dto: UpdateHealthProfileDto): Promise<void> {
    // 1. Pregnancy check
    if (dto.pregnancyStatus && dto.pregnancyStatus.startsWith('PREGNANT')) {
      await this.safetyRepo.createFlag({
        userId,
        flagType: 'CONTRAINDICATION',
        severity: 'HIGH',
        title: 'Pregnancy Safety Alert',
        description: `User reported pregnancy status: ${dto.pregnancyStatus}. Avoid deep twists, intense core work, prone poses, and heated practices.`,
        restrictedPoses: ['SIRSASANA', 'SARVANGASANA', 'CHAKRASANA', 'NAVASANA', 'BHUJANGASANA', 'DHANURASANA'],
        recommendedBy: 'AI Medical Safety Gate',
        isActive: true,
      });
    }

    // 2. High severity physical limitations
    if (dto.physicalLimitations) {
      for (const lim of dto.physicalLimitations) {
        if (lim.severity === 'HIGH' || lim.issue.toUpperCase().includes('DISC') || lim.issue.toUpperCase().includes('SPINE')) {
          await this.safetyRepo.createFlag({
            userId,
            flagType: 'RESTRICTED_POSE',
            severity: 'HIGH',
            title: `Spine/Joint Limitation: ${lim.bodyPart} (${lim.issue})`,
            description: `High severity limitation reported on ${lim.bodyPart}. Restricted movements: ${(lim.restrictedMovements || []).join(', ')}.`,
            restrictedPoses: ['SIRSASANA', 'SARVANGASANA', 'HALASANA', 'CHAKRASANA'],
            recommendedBy: 'AI Medical Safety Gate',
            isActive: true,
          });
        }
      }
    }

    // 3. Heart or hypertension conditions
    if (dto.currentConditions) {
      for (const cond of dto.currentConditions) {
        const name = cond.condition.toUpperCase();
        if (name.includes('HEART') || name.includes('HYPERTENSION') || name.includes('BLOOD PRESSURE') || name.includes('CARDIAC')) {
          await this.safetyRepo.createFlag({
            userId,
            flagType: 'CONTRAINDICATION',
            severity: 'CRITICAL',
            title: `Cardiovascular Condition: ${cond.condition}`,
            description: `Active cardiovascular condition detected. Inverted poses and rapid breath retention (Kumbhaka) are strictly contraindicated.`,
            restrictedPoses: ['SIRSASANA', 'SARVANGASANA', 'HALASANA', 'ADHO MUKHA VRKSASANA', 'KAPALABHATI', 'BHASTRIKA'],
            recommendedBy: 'AI Medical Safety Gate',
            isActive: true,
          });
        }
      }
    }
  }
}

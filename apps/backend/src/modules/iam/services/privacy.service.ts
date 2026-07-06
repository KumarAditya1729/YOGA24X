// ==============================================================================
// Yoga24X AI Engineering OS — Privacy & Consent Service
// Handles Terms, Cookie, AI, Health consents, GDPR Data Export & Account Deletion
// ==============================================================================

import { Injectable, BadRequestException } from '@nestjs/common';
import { PrivacyRepository } from '../repositories/privacy.repository';
import { UpdateConsentDto, AccountDeletionRequestDto } from '@yoga24x/shared-types';

@Injectable()
export class PrivacyService {
  constructor(private readonly privacyRepo: PrivacyRepository) {}

  async getUserConsents(userId: string): Promise<any[]> {
    return this.privacyRepo.getUserConsents(userId);
  }

  async updateConsent(userId: string, dto: UpdateConsentDto, ipAddress?: string, userAgent?: string): Promise<any> {
    return this.privacyRepo.updateConsent(userId, dto, ipAddress, userAgent);
  }

  async requestDataExport(userId: string): Promise<any> {
    return this.privacyRepo.createDataExportRequest(userId);
  }

  async getDataExportHistory(userId: string): Promise<any[]> {
    return this.privacyRepo.getDataExportRequests(userId);
  }

  async scheduleAccountDeletion(userId: string, dto: AccountDeletionRequestDto): Promise<any> {
    if (!dto.passwordConfirmation) {
      throw new BadRequestException('Password confirmation is required to schedule account deletion');
    }
    return this.privacyRepo.scheduleAccountDeletion(userId, dto.reason);
  }

  async cancelAccountDeletion(userId: string): Promise<any> {
    return this.privacyRepo.cancelAccountDeletion(userId);
  }
}

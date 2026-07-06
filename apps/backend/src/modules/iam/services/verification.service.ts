// ==============================================================================
// Yoga24X AI Engineering OS — Verification Service
// Handles Email, Phone, Gov ID, Teacher, Doctor, Studio, Corporate Verification
// ==============================================================================

import { Injectable } from "@nestjs/common";
import { VerificationRepository } from "../repositories/verification.repository";
import {
  SubmitVerificationDto,
  ReviewVerificationDto,
} from "@yoga24x/shared-types";

@Injectable()
export class VerificationService {
  constructor(private readonly verificationRepo: VerificationRepository) {}

  async submitVerification(
    userId: string,
    dto: SubmitVerificationDto,
  ): Promise<any> {
    return this.verificationRepo.submitVerificationRequest(userId, dto);
  }

  async getVerificationHistory(userId: string): Promise<any[]> {
    return this.verificationRepo.getVerificationHistory(userId);
  }

  async getAdminVerificationQueue(
    status?: string,
    type?: string,
  ): Promise<any[]> {
    return this.verificationRepo.getVerificationQueue(status, type);
  }

  async reviewVerification(
    requestId: string,
    reviewerId: string,
    dto: ReviewVerificationDto,
  ): Promise<any> {
    return this.verificationRepo.reviewVerification(requestId, reviewerId, dto);
  }
}

// ==============================================================================
// Yoga24X — Teacher Verification Service
// KYC workflow: submit → under review → approve/reject → resubmit
// ==============================================================================
import {
  Injectable,
  BadRequestException,
  NotFoundException,
} from "@nestjs/common";
import { EventEmitter2 } from "@nestjs/event-emitter";
import { TeacherVerificationRepository } from "../repositories/teacher-verification.repository";
import { TeacherProfileRepository } from "../repositories/teacher-profile.repository";
import {
  SubmitVerificationDto,
  ReviewVerificationDto,
} from "../dto/teacher.dto";
import { TeacherEventType } from "../events/teacher.events";
import { randomUUID } from "crypto";

const RESUBMITTABLE_STATUSES = ["REJECTED"];

@Injectable()
export class TeacherVerificationService {
  constructor(
    private readonly verifRepo: TeacherVerificationRepository,
    private readonly profileRepo: TeacherProfileRepository,
    private readonly events: EventEmitter2,
  ) {}

  async submitVerification(userId: string, dto: SubmitVerificationDto) {
    const profile = await this.profileRepo.findByUserId(userId);
    if (!profile)
      throw new NotFoundException(
        "Teacher profile not found. Create it first.",
      );

    const existing = await this.verifRepo.getVerification(userId);
    if (existing && !RESUBMITTABLE_STATUSES.includes(existing.status)) {
      throw new BadRequestException(
        `Cannot submit verification. Current status: ${existing.status}. Only REJECTED verifications can be resubmitted.`,
      );
    }

    const verif = await this.verifRepo.submitVerification(userId, dto);

    // Update profile status
    await this.profileRepo.setVerificationStatus(userId, "PENDING");

    const eventType = existing
      ? TeacherEventType.VERIFICATION_RESUBMITTED
      : TeacherEventType.VERIFICATION_SUBMITTED;

    this.events.emit(eventType, {
      type: eventType,
      userId,
      status: "PENDING",
      timestamp: new Date(),
      correlationId: randomUUID(),
    });

    return verif;
  }

  async getVerificationStatus(userId: string) {
    const verif = await this.verifRepo.getVerification(userId);
    if (!verif) return { status: "NOT_SUBMITTED", submissionCount: 0 };
    return verif;
  }

  async adminReview(
    userId: string,
    dto: ReviewVerificationDto,
    reviewerId: string,
  ) {
    const verif = await this.verifRepo.getVerification(userId);
    if (!verif)
      throw new NotFoundException(
        "No verification submission found for this teacher",
      );

    if (!["PENDING", "RESUBMITTED", "UNDER_REVIEW"].includes(verif.status)) {
      throw new BadRequestException(
        `Cannot review verification in status: ${verif.status}`,
      );
    }

    const updated = await this.verifRepo.review(userId, dto, reviewerId);

    // Sync status to teacher profile
    await this.profileRepo.setVerificationStatus(userId, dto.decision, {
      approvedBy: dto.decision === "APPROVED" ? reviewerId : undefined,
      rejectionReason: dto.rejectionReason,
    });

    const eventType =
      dto.decision === "APPROVED"
        ? TeacherEventType.VERIFICATION_APPROVED
        : TeacherEventType.VERIFICATION_REJECTED;

    this.events.emit(eventType, {
      type: eventType,
      userId,
      status: dto.decision,
      reviewedBy: reviewerId,
      timestamp: new Date(),
      correlationId: randomUUID(),
    });

    return updated;
  }

  async startManualReview(userId: string, reviewerId: string) {
    const verif = await this.verifRepo.getVerification(userId);
    if (!verif) throw new NotFoundException("No verification found");
    return this.verifRepo.startReview(userId, reviewerId);
  }

  async flagFraud(userId: string, fraudScore: number, reason: string) {
    return this.verifRepo.flagFraud(userId, fraudScore, reason);
  }

  async listPending(page: number, limit: number) {
    return this.verifRepo.listPendingReviews(page, limit);
  }
}

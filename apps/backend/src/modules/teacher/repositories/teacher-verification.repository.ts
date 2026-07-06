// ==============================================================================
// Yoga24X — Teacher Verification Repository
// KYC workflow state machine: submit → review → approve/reject → resubmit
// ==============================================================================
import { Injectable } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import {
  SubmitVerificationDto,
  ReviewVerificationDto,
} from "../dto/teacher.dto";

@Injectable()
export class TeacherVerificationRepository {
  constructor(private readonly prisma: PrismaService) {}

  async submitVerification(userId: string, dto: SubmitVerificationDto) {
    const existing = await this.prisma.teacherVerification.findUnique({
      where: { userId },
    });

    if (existing) {
      // Resubmission flow
      const updated = await this.prisma.teacherVerification.update({
        where: { userId },
        data: {
          status: "RESUBMITTED",
          submissionCount: { increment: 1 },
          lastSubmittedAt: new Date(),
          reviewedBy: null,
          reviewedAt: null,
          reviewNotes: null,
          rejectionReason: null,
          aiFraudScore: null,
          aiFraudFlagged: false,
          aiFraudReason: null,
        },
      });

      // Add new documents
      await this.prisma.teacherVerificationDocument.createMany({
        data: [
          {
            verificationId: updated.id,
            documentType: "GOVERNMENT_ID",
            documentUrl: dto.identityDocumentUrl,
          },
          {
            verificationId: updated.id,
            documentType: "GOVERNMENT_ID_SECONDARY",
            documentUrl: dto.identityDocumentSecondaryUrl,
          },
        ],
      });

      return this.prisma.teacherVerification.findUnique({
        where: { userId },
        include: { documents: true },
      });
    }

    // First-time submission
    return this.prisma.teacherVerification.create({
      data: {
        userId,
        status: "PENDING",
        documents: {
          create: [
            {
              documentType: "GOVERNMENT_ID",
              documentUrl: dto.identityDocumentUrl,
            },
            {
              documentType: "GOVERNMENT_ID_SECONDARY",
              documentUrl: dto.identityDocumentSecondaryUrl,
            },
          ],
        },
      },
      include: { documents: true },
    });
  }

  async getVerification(userId: string) {
    return this.prisma.teacherVerification.findUnique({
      where: { userId },
      include: {
        documents: { orderBy: { uploadedAt: "desc" } },
      },
    });
  }

  async startReview(userId: string, reviewerId: string) {
    return this.prisma.teacherVerification.update({
      where: { userId },
      data: {
        status: "UNDER_REVIEW",
        reviewedBy: reviewerId,
        manualReviewRequired: true,
      },
    });
  }

  async review(userId: string, dto: ReviewVerificationDto, reviewerId: string) {
    const status = dto.decision === "APPROVED" ? "APPROVED" : "REJECTED";
    return this.prisma.teacherVerification.update({
      where: { userId },
      data: {
        status,
        reviewedBy: reviewerId,
        reviewedAt: new Date(),
        reviewNotes: dto.reviewNotes,
        rejectionReason: dto.rejectionReason,
        identityVerified: dto.identityVerified ?? false,
        certificateVerified: dto.certificateVerified ?? false,
        approvedAt: status === "APPROVED" ? new Date() : null,
        rejectedAt: status === "REJECTED" ? new Date() : null,
      },
    });
  }

  async flagFraud(userId: string, fraudScore: number, reason: string) {
    return this.prisma.teacherVerification.update({
      where: { userId },
      data: {
        aiFraudScore: fraudScore as any,
        aiFraudFlagged: true,
        aiFraudReason: reason,
        manualReviewRequired: true,
      },
    });
  }

  async listPendingReviews(page: number, limit: number) {
    const skip = (page - 1) * limit;
    const where = {
      status: { in: ["PENDING", "RESUBMITTED", "UNDER_REVIEW"] as any },
    };
    const [data, total] = await Promise.all([
      this.prisma.teacherVerification.findMany({
        where,
        skip,
        take: limit,
        orderBy: [{ aiFraudFlagged: "desc" }, { lastSubmittedAt: "asc" }],
        include: {
          documents: true,
          teacher: {
            include: {
              user: {
                select: {
                  firstName: true,
                  lastName: true,
                  email: true,
                  avatarUrl: true,
                },
              },
            },
          },
        },
      }),
      this.prisma.teacherVerification.count({ where }),
    ]);
    return { data, total, page, limit, totalPages: Math.ceil(total / limit) };
  }
}

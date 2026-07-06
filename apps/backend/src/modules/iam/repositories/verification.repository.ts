// ==============================================================================
// Yoga24X AI Engineering OS — Verification Repository
// Handles email/phone/gov ID/teacher/doctor/studio/corporate verification workflows
// ==============================================================================

import {
  Injectable,
  NotFoundException,
  ConflictException,
} from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import {
  SubmitVerificationDto,
  ReviewVerificationDto,
  IAM_CONSTANTS,
} from "@yoga24x/shared-types";

@Injectable()
export class VerificationRepository {
  constructor(private readonly prisma: PrismaService) {}

  async submitVerificationRequest(
    userId: string,
    dto: SubmitVerificationDto,
  ): Promise<any> {
    // Check if there is already an approved or pending verification for this type
    const existing = await this.prisma.verificationRequest.findFirst({
      where: {
        userId,
        verificationType: dto.verificationType,
        status: { in: ["PENDING", "IN_REVIEW", "APPROVED"] },
      },
    });

    if (existing && existing.status === "APPROVED") {
      throw new ConflictException(
        IAM_CONSTANTS.ERROR_CODES.VERIFICATION_ALREADY_APPROVED,
      );
    }

    return this.prisma.$transaction(async (tx: any) => {
      const request = await tx.verificationRequest.create({
        data: {
          userId,
          verificationType: dto.verificationType,
          status: "PENDING",
          submittedDataJson: dto.submittedDataJson || {},
        },
      });

      for (const doc of dto.documents) {
        await tx.verificationDocument.create({
          data: {
            requestId: request.id,
            documentType: doc.documentType,
            fileUrl: doc.fileUrl,
            fileSizeBytes: doc.fileSizeBytes,
            mimeType: doc.mimeType,
          },
        });
      }

      return tx.verificationRequest.findUnique({
        where: { id: request.id },
        include: { documents: true },
      });
    });
  }

  async getVerificationHistory(userId: string): Promise<any[]> {
    return this.prisma.verificationRequest.findMany({
      where: { userId },
      include: { documents: true },
      orderBy: { submittedAt: "desc" },
    });
  }

  async getVerificationQueue(status?: string, type?: string): Promise<any[]> {
    const where: any = {};
    if (status) where.status = status;
    if (type) where.verificationType = type;

    return this.prisma.verificationRequest.findMany({
      where,
      include: {
        user: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            email: true,
            avatarUrl: true,
          },
        },
        documents: true,
      },
      orderBy: { submittedAt: "asc" },
    });
  }

  async reviewVerification(
    requestId: string,
    reviewerId: string,
    dto: ReviewVerificationDto,
  ): Promise<any> {
    const req = await this.prisma.verificationRequest.findUnique({
      where: { id: requestId },
    });

    if (!req) {
      throw new NotFoundException("Verification request not found");
    }

    return this.prisma.$transaction(async (tx: any) => {
      const updated = await tx.verificationRequest.update({
        where: { id: requestId },
        data: {
          status: dto.status,
          reviewedBy: reviewerId,
          rejectionReason: dto.rejectionReason || null,
          reviewedAt: new Date(),
        },
      });

      // If approved, update user's verification flags and role-specific profile verification
      if (dto.status === "APPROVED") {
        if (req.verificationType === "EMAIL") {
          await tx.user.update({
            where: { id: req.userId },
            data: { isEmailVerified: true },
          });
        } else if (req.verificationType === "PHONE") {
          await tx.user.update({
            where: { id: req.userId },
            data: { isPhoneVerified: true },
          });
        } else if (req.verificationType === "TEACHER_CERT") {
          await tx.instructorProfile.updateMany({
            where: { userId: req.userId },
            data: { isVerified: true },
          });
        } else if (req.verificationType === "DOCTOR_REG") {
          await tx.doctorProfile.updateMany({
            where: { userId: req.userId },
            data: { isVerified: true },
          });
        } else if (req.verificationType === "STUDIO_REG") {
          await tx.studioProfile.updateMany({
            where: { userId: req.userId },
            data: { isVerified: true },
          });
        } else if (req.verificationType === "CORPORATE_REG") {
          await tx.corporateProfile.updateMany({
            where: { userId: req.userId },
            data: { isVerified: true },
          });
        }
      }

      return updated;
    });
  }
}

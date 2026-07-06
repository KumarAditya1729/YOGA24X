// ==============================================================================
// Yoga24X AI Engineering OS — Medical Safety Repository
// Handles Contraindications, Restricted Poses, Doctor Warnings & Emergency Notes
// ==============================================================================

import { Injectable, NotFoundException } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { CreateMedicalSafetyFlagDto } from "@yoga24x/shared-types";

@Injectable()
export class MedicalSafetyRepository {
  constructor(private readonly prisma: PrismaService) {}

  async createFlag(dto: CreateMedicalSafetyFlagDto): Promise<any> {
    return this.prisma.medicalSafetyFlag.create({
      data: {
        userId: dto.userId,
        flagType: dto.flagType,
        severity: dto.severity,
        title: dto.title,
        description: dto.description,
        restrictedPosesJson: dto.restrictedPoses || [],
        recommendedBy: dto.recommendedBy,
        isActive: dto.isActive ?? true,
      },
    });
  }

  async getActiveFlags(userId: string): Promise<any[]> {
    return this.prisma.medicalSafetyFlag.findMany({
      where: { userId, isActive: true },
      orderBy: [
        { severity: "desc" }, // CRITICAL, HIGH, MEDIUM, LOW
        { createdAt: "desc" },
      ],
    });
  }

  async getAllFlags(userId: string): Promise<any[]> {
    return this.prisma.medicalSafetyFlag.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
    });
  }

  async deactivateFlag(flagId: string, userId?: string): Promise<any> {
    const where: any = { id: flagId };
    if (userId) where.userId = userId;

    const flag = await this.prisma.medicalSafetyFlag.findFirst({ where });
    if (!flag) throw new NotFoundException("Safety flag not found");

    return this.prisma.medicalSafetyFlag.update({
      where: { id: flagId },
      data: { isActive: false },
    });
  }

  async checkRestrictedPoses(
    userId: string,
    poseNames: string[],
  ): Promise<any[]> {
    const activeFlags = await this.getActiveFlags(userId);
    const triggeredWarnings: any[] = [];

    for (const flag of activeFlags) {
      const restricted: string[] = (flag.restrictedPosesJson as string[]) || [];
      const matches = poseNames.filter((p) =>
        restricted.includes(p.toUpperCase()),
      );
      if (matches.length > 0 || flag.flagType === "CONTRAINDICATION") {
        triggeredWarnings.push({
          flagId: flag.id,
          flagType: flag.flagType,
          severity: flag.severity,
          title: flag.title,
          description: flag.description,
          matchedPoses: matches,
          recommendedBy: flag.recommendedBy,
        });
      }
    }

    return triggeredWarnings;
  }
}

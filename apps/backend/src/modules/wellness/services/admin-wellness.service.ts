// ==============================================================================
// Yoga24X AI Engineering OS — Admin Wellness Service
// Business Logic for Admin Health Profile Viewer, Verification Queue, and Risk Dashboard
// ==============================================================================

import { Injectable, NotFoundException } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { HealthProfileRepository } from "../repositories/health-profile.repository";
import { MedicalSafetyRepository } from "../repositories/medical-safety.repository";

@Injectable()
export class AdminWellnessService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly healthRepo: HealthProfileRepository,
    private readonly safetyRepo: MedicalSafetyRepository,
  ) {}

  async getRiskDashboard(): Promise<any> {
    const totalHealthProfiles = await this.prisma.healthProfile.count();
    const verifiedProfiles = await this.healthRepo.getVerifiedProfilesCount();
    const criticalSafetyFlags = await this.prisma.medicalSafetyFlag.count({
      where: { isActive: true, severity: "CRITICAL" },
    });
    const highSafetyFlags = await this.prisma.medicalSafetyFlag.count({
      where: { isActive: true, severity: "HIGH" },
    });

    const recentCriticalAlerts = await this.prisma.medicalSafetyFlag.findMany({
      where: { isActive: true, severity: "CRITICAL" },
      include: {
        user: {
          select: { id: true, email: true, firstName: true, lastName: true },
        },
      },
      orderBy: { createdAt: "desc" },
      take: 20,
    });

    return {
      overview: {
        totalHealthProfiles,
        verifiedProfiles,
        unverifiedProfiles: totalHealthProfiles - verifiedProfiles,
        criticalSafetyFlags,
        highSafetyFlags,
      },
      recentCriticalAlerts,
    };
  }

  async getHealthProfileViewer(userId: string): Promise<any> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        email: true,
        firstName: true,
        lastName: true,
        phoneNumber: true,
        status: true,
        healthProfile: true,
        wellnessAssessments: { orderBy: { assessedAt: "desc" }, take: 5 },
        medicalSafetyFlags: { where: { isActive: true } },
      },
    });

    if (!user) throw new NotFoundException("User not found");
    return user;
  }

  async getAssessmentAnalytics(): Promise<any> {
    const totalAssessments = await this.prisma.wellnessAssessment.count();
    const avgScores = await this.prisma.wellnessAssessment.aggregate({
      _avg: {
        stressLevel: true,
        sleepQuality: true,
        energyLevel: true,
        hydrationScore: true,
        flexibilityScore: true,
      },
    });

    return {
      totalAssessments,
      averages: avgScores._avg,
    };
  }
}

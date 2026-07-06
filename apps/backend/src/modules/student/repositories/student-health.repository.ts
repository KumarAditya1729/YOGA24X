import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';
import { Prisma } from '@prisma/client';

@Injectable()
export class StudentHealthRepository {
  constructor(private readonly prisma: PrismaService) {}

  async getHealthProfile(userId: string) {
    return this.prisma.healthProfile.findUnique({
      where: { userId }
    });
  }

  async getWellnessAssessments(userId: string) {
    return this.prisma.wellnessAssessment.findMany({
      where: { userId },
      orderBy: { assessedAt: 'desc' }
    });
  }

  async getTimelineLogs(userId: string, limit: number = 30) {
    return this.prisma.wellnessTimelineLog.findMany({
      where: { userId },
      orderBy: { logDate: 'desc' },
      take: limit,
    });
  }

  async addTimelineLog(data: Prisma.WellnessTimelineLogUncheckedCreateInput) {
    return this.prisma.wellnessTimelineLog.create({
      data
    });
  }

  async getMedicalVisibility(userId: string) {
    return this.prisma.medicalVisibilityControl.findUnique({
      where: { userId }
    });
  }

  async updateMedicalVisibility(userId: string, data: Prisma.MedicalVisibilityControlUpdateInput) {
    return this.prisma.medicalVisibilityControl.upsert({
      where: { userId },
      update: data,
      create: {
        userId,
        ...data as any,
      }
    });
  }
}

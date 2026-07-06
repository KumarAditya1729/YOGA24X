import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';
import { Prisma } from '@prisma/client';

@Injectable()
export class StudentRepository {
  constructor(private readonly prisma: PrismaService) {}

  async getProfile(userId: string) {
    return this.prisma.studentProfile.findUnique({
      where: { userId },
      include: {
        user: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            email: true,
            phoneNumber: true,
            avatarUrl: true,
          }
        },
      }
    });
  }

  async updateProfile(userId: string, data: Prisma.StudentProfileUpdateInput) {
    return this.prisma.studentProfile.upsert({
      where: { userId },
      update: data,
      create: {
        userId,
        ...data as any,
      }
    });
  }

  async getPreferences(userId: string) {
    return this.prisma.studentPreference.findUnique({
      where: { userId }
    });
  }

  async updatePreferences(userId: string, data: Prisma.StudentPreferenceUpdateInput) {
    return this.prisma.studentPreference.upsert({
      where: { userId },
      update: data,
      create: {
        userId,
        ...data as any,
      }
    });
  }

  async getAchievements(userId: string) {
    return this.prisma.studentAchievement.findMany({
      where: { userId },
      orderBy: { awardedAt: 'desc' }
    });
  }

  async createAchievement(data: Prisma.StudentAchievementUncheckedCreateInput) {
    return this.prisma.studentAchievement.create({
      data
    });
  }

  async getGuardians(studentUserId: string) {
    return this.prisma.guardianProfile.findUnique({
      where: { studentUserId },
      include: {
        guardian: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            email: true,
            phoneNumber: true,
          }
        }
      }
    });
  }

  async setGuardian(data: Prisma.GuardianProfileUncheckedCreateInput) {
    return this.prisma.guardianProfile.upsert({
      where: { studentUserId: data.studentUserId },
      update: data,
      create: data as any,
    });
  }

  async getEmergencyContacts(userId: string) {
    return this.prisma.emergencyContact.findMany({
      where: { userId },
      orderBy: { isPrimary: 'desc' }
    });
  }

  async addEmergencyContact(data: Prisma.EmergencyContactUncheckedCreateInput) {
    return this.prisma.emergencyContact.create({
      data
    });
  }
}

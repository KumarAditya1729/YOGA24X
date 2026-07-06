// ==============================================================================
// Yoga24X AI Engineering OS — Timeline & Goal Management Repository
// Handles Daily Wellness Timeline Logs, Streaks, and User Goals/Milestones
// ==============================================================================

import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';
import { LogTimelineDto, CreateUserGoalDto, UpdateUserGoalDto } from '@yoga24x/shared-types';

@Injectable()
export class TimelineGoalRepository {
  constructor(private readonly prisma: PrismaService) {}

  // 1. Timeline Logs
  async logDailyTimeline(userId: string, dto: LogTimelineDto): Promise<any> {
    const logDate = new Date(dto.logDate);
    const data: any = {
      logDate,
      dailyMood: dto.dailyMood || 'GOOD',
      painLevel: dto.painLevel ?? 0,
      stressScore: dto.stressScore ?? 4,
      sleepHours: dto.sleepHours ?? 7.5,
      waterIntakeMl: dto.waterIntakeMl ?? 2500,
      weightKg: dto.weightKg,
      yogaMinutes: dto.yogaMinutes ?? 0,
      meditationMinutes: dto.meditationMinutes ?? 0,
      caloriesBurned: dto.caloriesBurned ?? 0,
      journalEntry: dto.journalEntry,
      energyScore: dto.energyScore ?? 7,
    };

    return this.prisma.wellnessTimelineLog.upsert({
      where: { uq_timeline_log_user_date: { userId, logDate } },
      update: data,
      create: { userId, ...data },
    });
  }

  async getTimelineLogs(userId: string, startDate?: string, endDate?: string): Promise<any[]> {
    const where: any = { userId };
    if (startDate || endDate) {
      where.logDate = {};
      if (startDate) where.logDate.gte = new Date(startDate);
      if (endDate) where.logDate.lte = new Date(endDate);
    }

    return this.prisma.wellnessTimelineLog.findMany({
      where,
      orderBy: { logDate: 'desc' },
      take: 90, // Last 90 days max by default
    });
  }

  // 2. Goal Management
  async createGoal(userId: string, dto: CreateUserGoalDto): Promise<any> {
    return this.prisma.userGoal.create({
      data: {
        userId,
        goalType: dto.goalType,
        title: dto.title,
        description: dto.description,
        targetValue: dto.targetValue,
        currentValue: dto.currentValue ?? 0,
        unit: dto.unit,
        targetDate: dto.targetDate ? new Date(dto.targetDate) : null,
        milestonesJson: dto.milestones || [],
        achievementsJson: [],
      },
    });
  }

  async getGoals(userId: string, status?: string): Promise<any[]> {
    const where: any = { userId };
    if (status) where.status = status;

    return this.prisma.userGoal.findMany({
      where,
      orderBy: { createdAt: 'desc' },
    });
  }

  async getGoalById(goalId: string, userId: string): Promise<any> {
    const goal = await this.prisma.userGoal.findFirst({
      where: { id: goalId, userId },
    });
    if (!goal) throw new NotFoundException('Goal not found');
    return goal;
  }

  async updateGoal(goalId: string, userId: string, dto: UpdateUserGoalDto): Promise<any> {
    const existing = await this.getGoalById(goalId, userId);
    const data: any = {};
    if (dto.title !== undefined) data.title = dto.title;
    if (dto.description !== undefined) data.description = dto.description;
    if (dto.targetValue !== undefined) data.targetValue = dto.targetValue;
    if (dto.currentValue !== undefined) data.currentValue = dto.currentValue;
    if (dto.status !== undefined) {
      data.status = dto.status;
      if (dto.status === 'COMPLETED' && existing.status !== 'COMPLETED') {
        data.completedAt = new Date();
      }
    }
    if (dto.targetDate !== undefined) data.targetDate = dto.targetDate ? new Date(dto.targetDate) : null;
    if (dto.milestones !== undefined) data.milestonesJson = dto.milestones;
    if (dto.achievements !== undefined) data.achievementsJson = dto.achievements;

    return this.prisma.userGoal.update({
      where: { id: goalId },
      data,
    });
  }

  async deleteGoal(goalId: string, userId: string): Promise<void> {
    await this.getGoalById(goalId, userId);
    await this.prisma.userGoal.delete({ where: { id: goalId } });
  }
}

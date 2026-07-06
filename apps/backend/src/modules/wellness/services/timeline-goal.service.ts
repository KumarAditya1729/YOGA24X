// ==============================================================================
// Yoga24X AI Engineering OS — Timeline & Goal Management Service
// Business Logic for Timeline Logs, Streaks, Milestones, and Goal Tracking
// ==============================================================================

import { Injectable, NotFoundException } from '@nestjs/common';
import { TimelineGoalRepository } from '../repositories/timeline-goal.repository';
import { PrismaService } from '../../prisma/prisma.module';
import { LogTimelineDto, CreateUserGoalDto, UpdateUserGoalDto } from '@yoga24x/shared-types';

@Injectable()
export class TimelineAndGoalService {
  constructor(
    private readonly timelineGoalRepo: TimelineGoalRepository,
    private readonly prisma: PrismaService,
  ) {}

  // 1. Timeline Logs
  async logDailyTimeline(userId: string, dto: LogTimelineDto): Promise<any> {
    const log = await this.timelineGoalRepo.logDailyTimeline(userId, dto);

    // Update user streak if yogaMinutes or meditationMinutes > 0
    if ((dto.yogaMinutes && dto.yogaMinutes > 0) || (dto.meditationMinutes && dto.meditationMinutes > 0)) {
      await this.updateUserStreak(userId);
    }

    // Check active goals for automatic progress updates
    await this.evaluateGoalsProgress(userId, dto);

    return log;
  }

  async getTimelineLogs(userId: string, startDate?: string, endDate?: string): Promise<any[]> {
    return this.timelineGoalRepo.getTimelineLogs(userId, startDate, endDate);
  }

  private async updateUserStreak(userId: string): Promise<void> {
    const now = new Date();
    const streak = await this.prisma.userStreak.findUnique({ where: { userId } });
    if (!streak) {
      await this.prisma.userStreak.create({
        data: {
          userId,
          currentStreakDays: 1,
          longestStreakDays: 1,
          lastActivityDate: now,
        },
      });
    } else {
      const lastDate = streak.lastActivityDate ? new Date(streak.lastActivityDate) : new Date(0);
      const diffDays = Math.floor((now.getTime() - lastDate.getTime()) / (1000 * 3600 * 24));

      if (diffDays === 1) {
        // Consecutive day
        const newCurrent = streak.currentStreakDays + 1;
        const newLongest = Math.max(newCurrent, streak.longestStreakDays);
        await this.prisma.userStreak.update({
          where: { userId },
          data: {
            currentStreakDays: newCurrent,
            longestStreakDays: newLongest,
            lastActivityDate: now,
          },
        });
      } else if (diffDays > 1) {
        // Streak broken
        await this.prisma.userStreak.update({
          where: { userId },
          data: {
            currentStreakDays: 1,
            lastActivityDate: now,
          },
        });
      }
      // If diffDays === 0, already logged today, keep streak intact
    }
  }

  private async evaluateGoalsProgress(userId: string, logDto: LogTimelineDto): Promise<void> {
    const activeGoals = await this.timelineGoalRepo.getGoals(userId, 'ACTIVE');
    for (const goal of activeGoals) {
      if (goal.goalType === 'WEIGHT' && logDto.weightKg) {
        await this.timelineGoalRepo.updateGoal(goal.id, userId, {
          currentValue: logDto.weightKg,
          status: logDto.weightKg <= (goal.targetValue || 0) ? 'COMPLETED' : 'ACTIVE',
        });
      }
    }
  }

  // 2. Goal Management
  async createGoal(userId: string, dto: CreateUserGoalDto): Promise<any> {
    return this.timelineGoalRepo.createGoal(userId, dto);
  }

  async getGoals(userId: string, status?: string): Promise<any[]> {
    return this.timelineGoalRepo.getGoals(userId, status);
  }

  async getGoalById(goalId: string, userId: string): Promise<any> {
    return this.timelineGoalRepo.getGoalById(goalId, userId);
  }

  async updateGoal(goalId: string, userId: string, dto: UpdateUserGoalDto): Promise<any> {
    return this.timelineGoalRepo.updateGoal(goalId, userId, dto);
  }

  async deleteGoal(goalId: string, userId: string): Promise<void> {
    return this.timelineGoalRepo.deleteGoal(goalId, userId);
  }
}

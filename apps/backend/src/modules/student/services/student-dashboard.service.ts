import { Injectable } from '@nestjs/common';
import { StudentService } from './student.service';
import { StudentHealthService } from './student-health.service';
import { StudentAnalyticsRepository } from '../repositories/student-analytics.repository';

@Injectable()
export class StudentDashboardService {
  constructor(
    private readonly studentService: StudentService,
    private readonly studentHealthService: StudentHealthService,
    private readonly analyticsRepository: StudentAnalyticsRepository
  ) {}

  async getDashboardData(userId: string) {
    const [profile, preferences, achievements, timelineLogs] = await Promise.all([
      this.studentService.getProfile(userId).catch(() => null),
      this.studentService.getPreferences(userId).catch(() => null),
      this.studentService.getAchievements(userId).catch(() => []),
      this.studentHealthService.getTimelineLogs(userId).catch(() => []),
    ]);

    // Aggregate data for the frontend dashboard
    return {
      profile,
      preferences,
      recentAchievements: achievements.slice(0, 5),
      todaysWellness: timelineLogs[0] || null,
      upcomingClasses: [], // To be fetched from booking module
      recommendations: [], // To be fetched from AI module
    };
  }

  async getAnalyticsSnapshots(userId: string) {
    return this.analyticsRepository.getSnapshots(userId);
  }
}

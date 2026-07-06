// ==============================================================================
// Yoga24X — Teacher Stats Service
// Professional statistics computation and analytics
// ==============================================================================
import { Injectable, NotFoundException } from '@nestjs/common';
import { TeacherStatsRepository } from '../repositories/teacher-stats.repository';
import { TeacherProfileRepository } from '../repositories/teacher-profile.repository';

@Injectable()
export class TeacherStatsService {
  constructor(
    private readonly statsRepo: TeacherStatsRepository,
    private readonly profileRepo: TeacherProfileRepository,
  ) {}

  async getStats(userId: string, requesterId?: string) {
    const profile = await this.profileRepo.findByUserId(userId);
    if (!profile) throw new NotFoundException('Teacher profile not found');

    // Track profile views (only when someone else views)
    if (requesterId && requesterId !== userId) {
      await this.statsRepo.incrementProfileView(userId).catch(() => {});
    }

    const stats = await this.statsRepo.getStats(userId);
    return stats ?? { userId, totalStudents: 0, totalClasses: 0, totalReviews: 0, averageRating: 0 };
  }

  async triggerRecalculation(userId: string) {
    return this.statsRepo.recalculate(userId);
  }

  async onBookingCompleted(teacherUserId: string, studentUserId: string, amountCents: number) {
    await Promise.all([
      this.statsRepo.updateFromBooking(teacherUserId, studentUserId),
      this.statsRepo.updateEarnings(teacherUserId, amountCents),
    ]);
  }

  async getLeaderboard(limit = 10) {
    // Top teachers by average rating with min review threshold
    return { message: 'Leaderboard endpoint — implemented in analytics module' };
  }
}

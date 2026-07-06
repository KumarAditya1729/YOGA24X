import { Injectable } from '@nestjs/common';
import { LeaderboardRepository } from '../repositories/leaderboard.repository';

@Injectable()
export class LeaderboardService {
  constructor(private readonly leaderboardRepo: LeaderboardRepository) {}

  async getLeaderboard(category: string, limit: number = 100) {
    return this.leaderboardRepo.getLeaderboard(category, limit);
  }

  async updateScore(userId: string, category: string, scoreDelta: number) {
    return this.leaderboardRepo.updateScore(userId, category, scoreDelta);
  }
}

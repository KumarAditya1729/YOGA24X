import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';

@Injectable()
export class LeaderboardRepository {
  constructor(private prisma: PrismaService) {}

  async getLeaderboard(category: string, limit: number = 100) {
    return this.prisma.leaderboardEntry.findMany({
      where: { category },
      include: {
        user: { select: { id: true, email: true } }
      },
      orderBy: [
        { score: 'desc' },
        { updatedAt: 'desc' }
      ],
      take: limit
    });
  }

  async updateScore(userId: string, category: string, scoreDelta: number) {
    const existing = await this.prisma.leaderboardEntry.findFirst({
      where: { userId, category }
    });

    if (existing) {
      return this.prisma.leaderboardEntry.update({
        where: { id: existing.id },
        data: { score: { increment: scoreDelta } }
      });
    } else {
      return this.prisma.leaderboardEntry.create({
        data: {
          userId,
          category,
          score: scoreDelta
        }
      });
    }
  }
}

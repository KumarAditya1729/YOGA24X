import { Injectable } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { CreateChallengeDto } from "../dto/social.dto";

@Injectable()
export class ChallengeRepository {
  constructor(private prisma: PrismaService) {}

  async createChallenge(data: CreateChallengeDto) {
    return this.prisma.challenge.create({
      data: {
        title: data.title,
        description: data.description,
        challengeType: data.challengeType,
        startDate: new Date(data.startDate),
        endDate: new Date(data.endDate),
        rewardsXp: data.rewardsXp || 0,
      },
    });
  }

  async getActiveChallenges() {
    return this.prisma.challenge.findMany({
      where: {
        endDate: { gte: new Date() },
      },
    });
  }

  async joinChallenge(challengeId: string, userId: string) {
    return this.prisma.challengeParticipant.create({
      data: {
        challengeId,
        userId,
      },
    });
  }
}

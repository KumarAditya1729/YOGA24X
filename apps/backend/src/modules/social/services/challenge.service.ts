import { Injectable } from '@nestjs/common';
import { ChallengeRepository } from '../repositories/challenge.repository';
import { CreateChallengeDto } from '../dto/social.dto';

@Injectable()
export class ChallengeService {
  constructor(private readonly challengeRepo: ChallengeRepository) {}

  async createChallenge(data: CreateChallengeDto) {
    return this.challengeRepo.createChallenge(data);
  }

  async getActiveChallenges() {
    return this.challengeRepo.getActiveChallenges();
  }

  async joinChallenge(challengeId: string, userId: string) {
    return this.challengeRepo.joinChallenge(challengeId, userId);
  }
}

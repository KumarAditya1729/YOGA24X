import { Injectable } from '@nestjs/common';
import { FeedRepository } from '../repositories/feed.repository';

@Injectable()
export class FeedService {
  constructor(private readonly feedRepo: FeedRepository) {}

  async getGlobalFeed(limit: number = 20) {
    return this.feedRepo.getGlobalFeed(limit);
  }

  async getGroupFeed(groupId: string, limit: number = 20) {
    return this.feedRepo.getGroupFeed(groupId, limit);
  }
}

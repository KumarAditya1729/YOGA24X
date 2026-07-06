import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { SocialController } from './controllers/social.controller';
import { ChatController } from './controllers/chat.controller';
import { ChallengeController } from './controllers/challenge.controller';
import { ModerationController } from './controllers/moderation.controller';
import { LeaderboardController } from './controllers/leaderboard.controller';
import { GroupService } from './services/group.service';
import { ChatService } from './services/chat.service';
import { ChallengeService } from './services/challenge.service';
import { FeedService } from './services/feed.service';
import { ModerationService } from './services/moderation.service';
import { LeaderboardService } from './services/leaderboard.service';
import { GroupRepository } from './repositories/group.repository';
import { ChatRepository } from './repositories/chat.repository';
import { ChallengeRepository } from './repositories/challenge.repository';
import { FeedRepository } from './repositories/feed.repository';
import { ModerationRepository } from './repositories/moderation.repository';
import { LeaderboardRepository } from './repositories/leaderboard.repository';

import { ChatGateway } from './gateways/chat.gateway';
import { FeedGateway } from './gateways/feed.gateway';

@Module({
  imports: [PrismaModule],
  controllers: [
    SocialController,
    ChatController,
    ChallengeController,
    ModerationController,
    LeaderboardController,
  ],
  providers: [
    GroupService,
    ChatService,
    ChallengeService,
    FeedService,
    ModerationService,
    LeaderboardService,
    GroupRepository,
    ChatRepository,
    ChallengeRepository,
    FeedRepository,
    ModerationRepository,
    LeaderboardRepository,
    ChatGateway,
    FeedGateway,
  ],
  exports: [
    GroupService,
    ChatService,
    ChallengeService,
    FeedService,
    ModerationService,
    LeaderboardService,
  ]
})
export class SocialModule {}

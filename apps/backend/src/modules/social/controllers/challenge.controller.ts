import { Controller, Get, Post, Body, Param, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RequirePermissions } from '../../security/decorators/authorization.decorators';
import { PERMISSIONS } from '../../security/constants/permissions.registry';
import { ChallengeService } from '../services/challenge.service';
import { CreateChallengeDto } from '../dto/social.dto';

@ApiTags('Challenges')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('api/v1/challenges')
export class ChallengeController {
  constructor(private readonly challengeService: ChallengeService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new challenge' })
  @RequirePermissions(PERMISSIONS.CHALLENGE_MANAGE)
  async createChallenge(@Body() data: CreateChallengeDto) {
    return this.challengeService.createChallenge(data);
  }

  @Get('active')
  @ApiOperation({ summary: 'Get active challenges' })
  @RequirePermissions(PERMISSIONS.CHALLENGE_READ)
  async getActiveChallenges() {
    return this.challengeService.getActiveChallenges();
  }

  @Post(':id/join')
  @ApiOperation({ summary: 'Join a challenge' })
  @RequirePermissions(PERMISSIONS.CHALLENGE_WRITE)
  async joinChallenge(@Param('id') id: string, @Request() req: any) {
    return this.challengeService.joinChallenge(id, req.user.userId);
  }
}

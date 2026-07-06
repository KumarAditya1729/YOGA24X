import { Controller, Post, Body, Param, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RequirePermissions } from '../../security/decorators/authorization.decorators';
import { PERMISSIONS } from '../../security/constants/permissions.registry';
import { ModerationService } from '../services/moderation.service';
import { ReportContentDto } from '../dto/social.dto';

@ApiTags('Moderation')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('api/v1/moderation')
export class ModerationController {
  constructor(private readonly moderationService: ModerationService) {}

  @Post('report')
  @ApiOperation({ summary: 'Report content or user' })
  @RequirePermissions(PERMISSIONS.MODERATION_REPORT)
  async reportContent(@Request() req: any, @Body() data: ReportContentDto) {
    return this.moderationService.reportContent(req.user.userId, data);
  }

  @Post('block/:userId')
  @ApiOperation({ summary: 'Block a user' })
  @RequirePermissions(PERMISSIONS.MODERATION_REPORT)
  async blockUser(@Request() req: any, @Param('userId') blockedId: string) {
    return this.moderationService.blockUser(req.user.userId, blockedId);
  }
}

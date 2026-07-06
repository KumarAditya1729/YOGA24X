// ==============================================================================
// Yoga24X AI Engineering OS — Waitlist Controller (Prompt 7)
// ==============================================================================

import {
  Controller, Get, Post, Delete, Param, Body, UseGuards, HttpCode, HttpStatus,
} from '@nestjs/common';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RequirePermissions } from '../../security/decorators/authorization.decorators';
import { CurrentUser } from '../../auth/decorators/auth.decorators';
import { JwtAccessPayload as JwtPayload } from '@yoga24x/shared-types';
import { WaitlistService } from '../services/waitlist.service';
import { WAITLIST_PERMISSIONS } from '../constants/booking-permissions';
import { JoinWaitlistDto } from '../dto/booking.dto';

@Controller('api/v1/waitlist')
@UseGuards(JwtAuthGuard)
export class WaitlistController {
  constructor(private readonly waitlistService: WaitlistService) {}

  @Post('join')
  @HttpCode(HttpStatus.CREATED)
  @RequirePermissions(WAITLIST_PERMISSIONS.WRITE)
  async join(@CurrentUser() user: JwtPayload, @Body() dto: JoinWaitlistDto) {
    return this.waitlistService.join(user.sub, dto);
  }

  @Delete(':entryId')
  @RequirePermissions(WAITLIST_PERMISSIONS.WRITE)
  async leave(@CurrentUser() user: JwtPayload, @Param('entryId') entryId: string) {
    return this.waitlistService.leave(user.sub, entryId);
  }

  @Get()
  @RequirePermissions(WAITLIST_PERMISSIONS.READ)
  async getMyWaitlist(@CurrentUser() user: JwtPayload) {
    return this.waitlistService.getMyWaitlist(user.sub);
  }
}

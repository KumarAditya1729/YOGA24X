// ==============================================================================
// Yoga24X AI Engineering OS — Admin User Management Controller
// Endpoints for admin search, details, suspension, and account activation
// ==============================================================================

import { Controller, Get, Post, Put, Body, Param, Query, Request } from '@nestjs/common';
import { AccountLifecycleService } from '../services/account-lifecycle.service';

@Controller('iam/admin/users')
export class AdminUserController {
  constructor(private readonly lifecycleService: AccountLifecycleService) {}

  @Get()
  async searchUsers(
    @Query('query') query?: string,
    @Query('role') role?: string,
    @Query('status') status?: string,
  ): Promise<any[]> {
    return this.lifecycleService.searchUsers(query, role, status);
  }

  @Post(':id/suspend')
  async suspendUser(@Request() req: any, @Param('id') targetUserId: string, @Body() body: { reason: string }): Promise<any> {
    const adminId = req.user?.sub || req.headers['x-user-id'];
    return this.lifecycleService.suspendAccount(adminId, targetUserId, body.reason);
  }

  @Post(':id/activate')
  async activateUser(@Request() req: any, @Param('id') targetUserId: string): Promise<any> {
    const adminId = req.user?.sub || req.headers['x-user-id'];
    return this.lifecycleService.activateAccount(adminId, targetUserId);
  }
}

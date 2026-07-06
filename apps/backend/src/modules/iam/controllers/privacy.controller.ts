// ==============================================================================
// Yoga24X AI Engineering OS — Privacy & Lifecycle Controller
// Endpoints for consents, GDPR data exports, and account deletion
// ==============================================================================

import { Controller, Get, Post, Put, Delete, Body, Request } from '@nestjs/common';
import { PrivacyService } from '../services/privacy.service';
import { UpdateConsentDto, AccountDeletionRequestDto } from '@yoga24x/shared-types';

@Controller('iam/privacy')
export class PrivacyController {
  constructor(private readonly privacyService: PrivacyService) {}

  @Get('consents')
  async getMyConsents(@Request() req: any): Promise<any[]> {
    const userId = req.user?.sub || req.headers['x-user-id'];
    return this.privacyService.getUserConsents(userId);
  }

  @Put('consents')
  async updateConsent(@Request() req: any, @Body() dto: UpdateConsentDto): Promise<any> {
    const userId = req.user?.sub || req.headers['x-user-id'];
    const ip = req.ip || req.headers['x-forwarded-for'] || '127.0.0.1';
    const ua = req.headers['user-agent'] || 'Yoga24X-App/1.0';
    return this.privacyService.updateConsent(userId, dto, ip, ua);
  }

  @Post('export')
  async requestDataExport(@Request() req: any): Promise<any> {
    const userId = req.user?.sub || req.headers['x-user-id'];
    return this.privacyService.requestDataExport(userId);
  }

  @Get('export/history')
  async getExportHistory(@Request() req: any): Promise<any[]> {
    const userId = req.user?.sub || req.headers['x-user-id'];
    return this.privacyService.getDataExportHistory(userId);
  }

  @Post('account/delete')
  async scheduleDeletion(@Request() req: any, @Body() dto: AccountDeletionRequestDto): Promise<any> {
    const userId = req.user?.sub || req.headers['x-user-id'];
    return this.privacyService.scheduleAccountDeletion(userId, dto);
  }

  @Post('account/cancel-delete')
  async cancelDeletion(@Request() req: any): Promise<any> {
    const userId = req.user?.sub || req.headers['x-user-id'];
    return this.privacyService.cancelAccountDeletion(userId);
  }
}

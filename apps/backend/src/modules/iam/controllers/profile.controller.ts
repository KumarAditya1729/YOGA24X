// ==============================================================================
// Yoga24X AI Engineering OS — User Profile Controller
// Endpoints for profile management, settings, preferences, and media
// ==============================================================================

import { Controller, Get, Put, Post, Body, Param, UseInterceptors, Request, UseGuards } from '@nestjs/common';
import { ProfileService } from '../services/profile.service';
import { PiiMaskingInterceptor } from '../interceptors/pii-masking.interceptor';
import {
  UpdateBasicProfileDto,
  UpdateStudentProfileDto,
  UpdateTeacherProfileDto,
  UpdateDoctorProfileDto,
  UpdateSettingsDto,
  UpdateNotificationPrefDto,
} from '@yoga24x/shared-types';

@Controller('iam/profiles')
@UseInterceptors(PiiMaskingInterceptor)
export class ProfileController {
  constructor(private readonly profileService: ProfileService) {}

  @Get('me')
  async getMyProfile(@Request() req: any): Promise<any> {
    const userId = req.user?.sub || req.headers['x-user-id'];
    return this.profileService.getProfileOverview(userId);
  }

  @Get(':id')
  async getUserProfile(@Param('id') id: string): Promise<any> {
    return this.profileService.getProfileOverview(id);
  }

  @Get('me/completion')
  async getMyProfileCompletion(@Request() req: any): Promise<any> {
    const userId = req.user?.sub || req.headers['x-user-id'];
    return this.profileService.calculateProfileCompletion(userId);
  }

  @Put('me/basic')
  async updateBasicProfile(@Request() req: any, @Body() dto: UpdateBasicProfileDto): Promise<any> {
    const userId = req.user?.sub || req.headers['x-user-id'];
    return this.profileService.updateBasicProfile(userId, dto);
  }

  @Put('me/student')
  async updateStudentProfile(@Request() req: any, @Body() dto: UpdateStudentProfileDto): Promise<any> {
    const userId = req.user?.sub || req.headers['x-user-id'];
    return this.profileService.updateStudentProfile(userId, dto);
  }

  @Put('me/teacher')
  async updateTeacherProfile(@Request() req: any, @Body() dto: UpdateTeacherProfileDto): Promise<any> {
    const userId = req.user?.sub || req.headers['x-user-id'];
    return this.profileService.updateTeacherProfile(userId, dto);
  }

  @Put('me/doctor')
  async updateDoctorProfile(@Request() req: any, @Body() dto: UpdateDoctorProfileDto): Promise<any> {
    const userId = req.user?.sub || req.headers['x-user-id'];
    return this.profileService.updateDoctorProfile(userId, dto);
  }

  @Put('me/settings')
  async updateSettings(@Request() req: any, @Body() dto: UpdateSettingsDto): Promise<any> {
    const userId = req.user?.sub || req.headers['x-user-id'];
    return this.profileService.updateSettings(userId, dto);
  }

  @Put('me/notifications')
  async updateNotificationPref(@Request() req: any, @Body() dto: UpdateNotificationPrefDto): Promise<any> {
    const userId = req.user?.sub || req.headers['x-user-id'];
    return this.profileService.updateNotificationPref(userId, dto);
  }

  @Post('me/media')
  async uploadMedia(
    @Request() req: any,
    @Body() body: { mediaType: 'AVATAR' | 'COVER_IMAGE'; fileUrl: string; fileSizeBytes: number; mimeType: string },
  ): Promise<any> {
    const userId = req.user?.sub || req.headers['x-user-id'];
    return this.profileService.uploadProfileMedia(userId, body.mediaType, body.fileUrl, body.fileSizeBytes, body.mimeType);
  }
}

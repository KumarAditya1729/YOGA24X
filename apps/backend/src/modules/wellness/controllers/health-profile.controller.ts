// ==============================================================================
// Yoga24X AI Engineering OS — Health Profile Controller
// REST APIs for Health Identity, Medical History, and Doctor Verification
// ==============================================================================

import {
  Controller,
  Get,
  Put,
  Post,
  Body,
  UseGuards,
  UseInterceptors,
  Request,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { PiiHealthMaskingInterceptor } from '../interceptors/pii-health-masking.interceptor';
import { HealthProfileService } from '../services/health-profile.service';
import {
  UpdateHealthProfileDto,
  UpdateHealthProfileSchema,
  DoctorVerifyHealthProfileDto,
  DoctorVerifyHealthProfileSchema,
} from '@yoga24x/shared-types';

@ApiTags('Wellness - Health Profile')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@UseInterceptors(PiiHealthMaskingInterceptor)
@Controller('wellness/health-profile')
export class HealthProfileController {
  constructor(private readonly healthService: HealthProfileService) {}

  @Get()
  @ApiOperation({ summary: 'Get current user health profile and medical history' })
  @ApiResponse({ status: 200, description: 'Health profile retrieved successfully.' })
  async getMyHealthProfile(@Request() req: any) {
    return this.healthService.getHealthProfile(req.user.id);
  }

  @Put()
  @ApiOperation({ summary: 'Update health profile, conditions, surgeries, and limitations' })
  @ApiResponse({ status: 200, description: 'Health profile updated and safety flags evaluated.' })
  async updateMyHealthProfile(@Request() req: any, @Body() body: any) {
    const validated = UpdateHealthProfileSchema.parse(body);
    return this.healthService.updateHealthProfile(req.user.id, validated as UpdateHealthProfileDto);
  }

  @Post('verify')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Doctor verification of user health profile (Doctor/Admin only)' })
  @ApiResponse({ status: 200, description: 'Health profile verified by doctor.' })
  async verifyHealthProfile(@Request() req: any, @Body() body: any) {
    const validated = DoctorVerifyHealthProfileSchema.parse(body);
    return this.healthService.verifyHealthProfileByDoctor(req.user.id, validated as DoctorVerifyHealthProfileDto);
  }
}

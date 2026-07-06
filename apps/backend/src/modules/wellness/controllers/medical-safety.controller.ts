// ==============================================================================
// Yoga24X AI Engineering OS — Medical Safety Controller
// REST APIs for Safety Flags, Contraindications, and Pose Restriction Checking
// ==============================================================================

import {
  Controller,
  Get,
  Post,
  Put,
  Body,
  Param,
  UseGuards,
  Request,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { MedicalSafetyService } from '../services/medical-safety.service';
import {
  CreateMedicalSafetyFlagDto,
  CreateMedicalSafetyFlagSchema,
} from '@yoga24x/shared-types';

@ApiTags('Wellness - Medical Safety & Pose Restrictions')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('wellness/safety-flags')
export class MedicalSafetyController {
  constructor(private readonly safetyService: MedicalSafetyService) {}

  @Get('active')
  @ApiOperation({ summary: 'Get active medical safety flags and contraindications' })
  async getActiveFlags(@Request() req: any) {
    return this.safetyService.getActiveFlags(req.user.id);
  }

  @Get('all')
  @ApiOperation({ summary: 'Get all historical medical safety flags' })
  async getAllFlags(@Request() req: any) {
    return this.safetyService.getAllFlags(req.user.id);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create new medical safety flag or warning' })
  async createSafetyFlag(@Request() req: any, @Body() body: any) {
    const validated = CreateMedicalSafetyFlagSchema.parse({ ...body, userId: req.user.id });
    return this.safetyService.createSafetyFlag(validated as CreateMedicalSafetyFlagDto);
  }

  @Put(':id/deactivate')
  @ApiOperation({ summary: 'Deactivate or resolve a medical safety flag' })
  async deactivateFlag(@Request() req: any, @Param('id') id: string) {
    return this.safetyService.deactivateFlag(id, req.user.id);
  }

  @Post('check-pose')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Check if specific yoga poses are safe for the current user' })
  @ApiResponse({ status: 200, description: 'Returns safety check results and triggered warnings.' })
  async checkPoseRestrictions(@Request() req: any, @Body() body: { poseNames: string[] }) {
    return this.safetyService.checkPoseRestrictions(req.user.id, body.poseNames || []);
  }
}

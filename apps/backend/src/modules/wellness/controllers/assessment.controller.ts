// ==============================================================================
// Yoga24X AI Engineering OS — Assessment Controller
// REST APIs for Wellness, Yoga, Nutrition, Meditation & AI Personalization
// ==============================================================================

import {
  Controller,
  Get,
  Put,
  Post,
  Body,
  UseGuards,
  Request,
  Query,
  HttpCode,
  HttpStatus,
} from "@nestjs/common";
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from "@nestjs/swagger";
import { JwtAuthGuard } from "../../auth/guards/jwt-auth.guard";
import { AssessmentService } from "../services/assessment.service";
import {
  SubmitWellnessAssessmentDto,
  SubmitWellnessAssessmentSchema,
  UpdateYogaAssessmentDto,
  UpdateYogaAssessmentSchema,
  UpdateNutritionProfileDto,
  UpdateNutritionProfileSchema,
  UpdateMeditationProfileDto,
  UpdateMeditationProfileSchema,
  UpdateAiPersonalizationDto,
  UpdateAiPersonalizationSchema,
} from "@yoga24x/shared-types";

@ApiTags("Wellness - Assessments & AI Personalization")
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller("wellness/assessment")
export class AssessmentController {
  constructor(private readonly assessService: AssessmentService) {}

  // 1. General Wellness Assessment
  @Post("general")
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: "Submit new wellness assessment (stress, sleep, energy, BMI)",
  })
  @ApiResponse({
    status: 201,
    description: "Assessment submitted successfully.",
  })
  async submitWellnessAssessment(@Request() req: any, @Body() body: any) {
    const validated = SubmitWellnessAssessmentSchema.parse(body);
    return this.assessService.submitWellnessAssessment(
      req.user.id,
      validated as SubmitWellnessAssessmentDto,
    );
  }

  @Get("general/latest")
  @ApiOperation({ summary: "Get latest general wellness assessment" })
  async getLatestWellnessAssessment(@Request() req: any) {
    return this.assessService.getLatestWellnessAssessment(req.user.id);
  }

  @Get("general/history")
  @ApiOperation({ summary: "Get general wellness assessment history" })
  async getAssessmentHistory(
    @Request() req: any,
    @Query("limit") limit?: string,
  ) {
    return this.assessService.getAssessmentHistory(
      req.user.id,
      limit ? parseInt(limit, 10) : 30,
    );
  }

  // 2. Yoga Assessment
  @Get("yoga")
  @ApiOperation({ summary: "Get user yoga assessment and style preferences" })
  async getYogaAssessment(@Request() req: any) {
    return this.assessService.getYogaAssessment(req.user.id);
  }

  @Put("yoga")
  @ApiOperation({
    summary: "Update yoga assessment, experience, and preferred styles",
  })
  async updateYogaAssessment(@Request() req: any, @Body() body: any) {
    const validated = UpdateYogaAssessmentSchema.parse(body);
    return this.assessService.updateYogaAssessment(
      req.user.id,
      validated as UpdateYogaAssessmentDto,
    );
  }

  // 3. Nutrition Profile
  @Get("nutrition")
  @ApiOperation({ summary: "Get user nutrition profile and dietary targets" })
  async getNutritionProfile(@Request() req: any) {
    return this.assessService.getNutritionProfile(req.user.id);
  }

  @Put("nutrition")
  @ApiOperation({
    summary: "Update nutrition profile, calories goal, and meal timing",
  })
  async updateNutritionProfile(@Request() req: any, @Body() body: any) {
    const validated = UpdateNutritionProfileSchema.parse(body);
    return this.assessService.updateNutritionProfile(
      req.user.id,
      validated as UpdateNutritionProfileDto,
    );
  }

  // 4. Meditation Profile
  @Get("meditation")
  @ApiOperation({
    summary: "Get user meditation profile and mindfulness goals",
  })
  async getMeditationProfile(@Request() req: any) {
    return this.assessService.getMeditationProfile(req.user.id);
  }

  @Put("meditation")
  @ApiOperation({
    summary: "Update meditation profile, preferred duration, and voice",
  })
  async updateMeditationProfile(@Request() req: any, @Body() body: any) {
    const validated = UpdateMeditationProfileSchema.parse(body);
    return this.assessService.updateMeditationProfile(
      req.user.id,
      validated as UpdateMeditationProfileDto,
    );
  }

  // 5. AI Personalization Profile
  @Get("ai-personalization")
  @ApiOperation({
    summary: "Get AI coaching style, tone, and reminder behavior",
  })
  async getAiPersonalization(@Request() req: any) {
    return this.assessService.getAiPersonalization(req.user.id);
  }

  @Put("ai-personalization")
  @ApiOperation({
    summary:
      "Update AI coaching style, motivation tone, and difficulty progression",
  })
  async updateAiPersonalization(@Request() req: any, @Body() body: any) {
    const validated = UpdateAiPersonalizationSchema.parse(body);
    return this.assessService.updateAiPersonalization(
      req.user.id,
      validated as UpdateAiPersonalizationDto,
    );
  }
}

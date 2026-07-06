// ==============================================================================
// Yoga24X AI Engineering OS — Timeline & Goal Controller
// REST APIs for Daily Timeline Logs, Streaks, Milestones, and User Goals
// ==============================================================================

import {
  Controller,
  Get,
  Put,
  Post,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  Request,
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
import { TimelineAndGoalService } from "../services/timeline-goal.service";
import {
  LogTimelineDto,
  LogTimelineSchema,
  CreateUserGoalDto,
  CreateUserGoalSchema,
  UpdateUserGoalDto,
  UpdateUserGoalSchema,
} from "@yoga24x/shared-types";

@ApiTags("Wellness - Timeline & Goals")
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller("wellness")
export class TimelineGoalController {
  constructor(private readonly timelineGoalService: TimelineAndGoalService) {}

  // 1. Timeline Logs
  @Post("timeline")
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: "Log daily wellness timeline (mood, sleep, water, yoga minutes)",
  })
  @ApiResponse({
    status: 200,
    description: "Timeline logged and streak updated.",
  })
  async logDailyTimeline(@Request() req: any, @Body() body: any) {
    const validated = LogTimelineSchema.parse(body);
    return this.timelineGoalService.logDailyTimeline(
      req.user.id,
      validated as LogTimelineDto,
    );
  }

  @Get("timeline")
  @ApiOperation({ summary: "Get daily wellness timeline logs" })
  async getTimelineLogs(
    @Request() req: any,
    @Query("startDate") startDate?: string,
    @Query("endDate") endDate?: string,
  ) {
    return this.timelineGoalService.getTimelineLogs(
      req.user.id,
      startDate,
      endDate,
    );
  }

  // 2. User Goals
  @Post("goals")
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: "Create new wellness goal (weight, flexibility, streak, custom)",
  })
  async createGoal(@Request() req: any, @Body() body: any) {
    const validated = CreateUserGoalSchema.parse(body);
    return this.timelineGoalService.createGoal(
      req.user.id,
      validated as CreateUserGoalDto,
    );
  }

  @Get("goals")
  @ApiOperation({ summary: "Get user wellness goals" })
  async getGoals(@Request() req: any, @Query("status") status?: string) {
    return this.timelineGoalService.getGoals(req.user.id, status);
  }

  @Get("goals/:id")
  @ApiOperation({ summary: "Get specific goal by ID" })
  async getGoalById(@Request() req: any, @Param("id") id: string) {
    return this.timelineGoalService.getGoalById(id, req.user.id);
  }

  @Put("goals/:id")
  @ApiOperation({ summary: "Update goal progress, milestones, or status" })
  async updateGoal(
    @Request() req: any,
    @Param("id") id: string,
    @Body() body: any,
  ) {
    const validated = UpdateUserGoalSchema.parse(body);
    return this.timelineGoalService.updateGoal(
      id,
      req.user.id,
      validated as UpdateUserGoalDto,
    );
  }

  @Delete("goals/:id")
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: "Delete a goal" })
  async deleteGoal(@Request() req: any, @Param("id") id: string) {
    await this.timelineGoalService.deleteGoal(id, req.user.id);
  }
}

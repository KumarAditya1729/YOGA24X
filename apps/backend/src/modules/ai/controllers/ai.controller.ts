import {
  Controller,
  Post,
  Body,
  Get,
  UseGuards,
  Req,
  Param,
} from "@nestjs/common";
import { CoachService } from "../services/coach.service";
import { RecommendationEngineService } from "../services/recommendation-engine.service";
import { JwtAuthGuard } from "../../auth/guards/jwt-auth.guard";
import { RequirePermissions } from "../../security/decorators/authorization.decorators";
import { PERMISSIONS } from "../../security/constants/permissions.registry";
import { AuthorizationGuard } from "../../security/guards/authorization.guard";

@Controller("ai")
@UseGuards(JwtAuthGuard, AuthorizationGuard)
export class AiController {
  constructor(
    private readonly coachService: CoachService,
    private readonly recommendationService: RecommendationEngineService,
  ) {}

  @Post("chat")
  @RequirePermissions(PERMISSIONS.AI_CHAT_START)
  async chat(
    @Req() req: any,
    @Body() body: { conversationId: string; message: string },
  ) {
    return this.coachService.chatWithCoach(
      req.user.id,
      body.conversationId,
      body.message,
    );
  }

  @Get("recommendations/courses")
  @RequirePermissions(PERMISSIONS.AI_RECOMMENDATIONS_READ)
  async recommendCourses(@Req() req: any) {
    return this.recommendationService.recommendCourses(req.user.id);
  }

  @Get("recommendations/teachers")
  @RequirePermissions(PERMISSIONS.AI_RECOMMENDATIONS_READ)
  async recommendTeachers(@Req() req: any) {
    return this.recommendationService.recommendTeachers(req.user.id);
  }
}

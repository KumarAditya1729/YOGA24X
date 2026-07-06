import { Controller, Get, Post, Param, Body, UseGuards } from "@nestjs/common";
import { JwtAuthGuard } from "../../auth/guards/jwt-auth.guard";
import { RequirePermissions } from "../../security/decorators/authorization.decorators";
import { LEARNING_PERMISSIONS } from "../constants/learning-permissions";
import { CurrentUser } from "../../auth/decorators/auth.decorators";
import { JwtAccessPayload as JwtPayload } from "@yoga24x/shared-types";

@Controller("learning/assessments")
@UseGuards(JwtAuthGuard)
export class AssessmentController {
  @Get("certificates")
  @RequirePermissions(LEARNING_PERMISSIONS.ASSESSMENT_READ)
  async getCertificates(@CurrentUser() user: JwtPayload) {
    return [];
  }
}

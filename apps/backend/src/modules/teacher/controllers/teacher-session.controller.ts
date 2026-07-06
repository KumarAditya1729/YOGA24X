import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  UseGuards,
  Query,
} from "@nestjs/common";
import { ApiTags, ApiOperation, ApiBearerAuth } from "@nestjs/swagger";
import { JwtAuthGuard } from "../../auth/guards/jwt-auth.guard";
import { RequirePermissions } from "../../security/decorators/authorization.decorators";
import { CurrentUser } from "../../auth/decorators/auth.decorators";
import { JwtAccessPayload as JwtPayload } from "@yoga24x/shared-types";
import { TeacherSessionService } from "../services/teacher-session.service";
import { TEACHER_PERMISSIONS } from "../constants/teacher-permissions";
import {
  CreateTeacherSessionTypeDto,
  UpdateTeacherSessionTypeDto,
  CreateTeacherPricingRuleDto,
  CreateTeacherSessionDto,
} from "../dto/teacher-operations.dto";

@ApiTags("Teacher Sessions (Operations)")
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller("teacher/operations/sessions")
export class TeacherSessionController {
  constructor(private readonly sessionService: TeacherSessionService) {}

  // ── Session Types ────────────────────────────────────────────────────────────

  @Get("types")
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_SESSION_TYPE_READ)
  @ApiOperation({ summary: "Get all session types" })
  async getSessionTypes(@CurrentUser() user: JwtPayload) {
    return this.sessionService.getSessionTypes(user.sub);
  }

  @Post("types")
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_SESSION_TYPE_WRITE)
  @ApiOperation({ summary: "Create session type" })
  async createSessionType(
    @CurrentUser() user: JwtPayload,
    @Body() data: CreateTeacherSessionTypeDto,
  ) {
    return this.sessionService.createSessionType(user.sub, data);
  }

  @Put("types/:id")
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_SESSION_TYPE_WRITE)
  @ApiOperation({ summary: "Update session type" })
  async updateSessionType(
    @CurrentUser() user: JwtPayload,
    @Param("id") id: string,
    @Body() data: UpdateTeacherSessionTypeDto,
  ) {
    return this.sessionService.updateSessionType(user.sub, id, data);
  }

  @Delete("types/:id")
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_SESSION_TYPE_WRITE)
  @ApiOperation({ summary: "Delete session type" })
  async deleteSessionType(
    @CurrentUser() user: JwtPayload,
    @Param("id") id: string,
  ) {
    return this.sessionService.deleteSessionType(user.sub, id);
  }

  // ── Pricing Rules ────────────────────────────────────────────────────────────

  @Get("pricing-rules")
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_SESSION_TYPE_READ)
  @ApiOperation({ summary: "Get pricing rules" })
  async getPricingRules(@CurrentUser() user: JwtPayload) {
    return this.sessionService.getPricingRules(user.sub);
  }

  @Post("pricing-rules")
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_SESSION_TYPE_WRITE)
  @ApiOperation({ summary: "Create pricing rule" })
  async createPricingRule(
    @CurrentUser() user: JwtPayload,
    @Body() data: CreateTeacherPricingRuleDto,
  ) {
    return this.sessionService.createPricingRule(user.sub, data);
  }

  @Delete("pricing-rules/:id")
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_SESSION_TYPE_WRITE)
  @ApiOperation({ summary: "Delete pricing rule" })
  async deletePricingRule(
    @CurrentUser() user: JwtPayload,
    @Param("id") id: string,
  ) {
    return this.sessionService.deletePricingRule(user.sub, id);
  }

  // ── Sessions / Schedule ──────────────────────────────────────────────────────

  @Get("calendar")
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_SCHEDULE_READ)
  @ApiOperation({ summary: "Get scheduled sessions" })
  async getSessions(
    @CurrentUser() user: JwtPayload,
    @Query("from") from?: string,
    @Query("to") to?: string,
  ) {
    const fromDate = from ? new Date(from) : undefined;
    const toDate = to ? new Date(to) : undefined;
    return this.sessionService.getSessions(user.sub, fromDate, toDate);
  }

  @Post("calendar")
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_SCHEDULE_WRITE)
  @ApiOperation({ summary: "Create scheduled session" })
  async createSession(
    @CurrentUser() user: JwtPayload,
    @Body() data: CreateTeacherSessionDto,
  ) {
    return this.sessionService.createSession(user.sub, data);
  }

  @Delete("calendar/:id")
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_SCHEDULE_WRITE)
  @ApiOperation({ summary: "Delete scheduled session" })
  async deleteSession(
    @CurrentUser() user: JwtPayload,
    @Param("id") id: string,
  ) {
    return this.sessionService.deleteSession(user.sub, id);
  }
}

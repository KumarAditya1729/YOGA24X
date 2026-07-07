import {
  Controller,
  Get,
  Put,
  Post,
  Body,
  UseGuards,
  Req,
} from "@nestjs/common";
import { ApiTags, ApiBearerAuth, ApiOperation } from "@nestjs/swagger";
import { StudentHealthService } from "../services/student-health.service";
import { UpdateMedicalVisibilityDto } from "../dto/student.dto";

@ApiTags("Student — Health & Wellness")
@ApiBearerAuth()
@Controller("students/me/health")
export class StudentHealthController {
  constructor(private readonly healthService: StudentHealthService) {}

  @Get("profile")
  @ApiOperation({ summary: "Get student health profile" })
  async getHealthProfile(@Req() req: any) {
    const userId = req.user?.id || "TEST_USER_ID";
    return this.healthService.getHealthProfile(userId);
  }

  @Get("assessments")
  @ApiOperation({ summary: "Get wellness assessments" })
  async getWellnessAssessments(@Req() req: any) {
    const userId = req.user?.id || "TEST_USER_ID";
    return this.healthService.getWellnessAssessments(userId);
  }

  @Get("timeline")
  @ApiOperation({ summary: "Get wellness timeline logs" })
  async getTimelineLogs(@Req() req: any) {
    const userId = req.user?.id || "TEST_USER_ID";
    return this.healthService.getTimelineLogs(userId);
  }

  @Post("timeline")
  @ApiOperation({ summary: "Add a new wellness timeline log (daily check-in)" })
  async addTimelineLog(@Req() req: any, @Body() body: any) {
    const userId = req.user?.id || "TEST_USER_ID";
    return this.healthService.addTimelineLog(userId, body);
  }

  @Get("medical-visibility")
  @ApiOperation({ summary: "Get medical visibility controls" })
  async getMedicalVisibility(@Req() req: any) {
    const userId = req.user?.id || "TEST_USER_ID";
    return this.healthService.getMedicalVisibility(userId);
  }

  @Put("medical-visibility")
  @ApiOperation({ summary: "Update medical visibility controls" })
  async updateMedicalVisibility(
    @Req() req: any,
    @Body() dto: UpdateMedicalVisibilityDto,
  ) {
    const userId = req.user?.id || "TEST_USER_ID";
    return this.healthService.updateMedicalVisibility(userId, dto);
  }
}

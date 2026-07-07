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
import { StudentService } from "../services/student.service";
import { StudentDashboardService } from "../services/student-dashboard.service";
import {
  UpdateStudentProfileDto,
  UpdateStudentPreferenceDto,
  CreateGuardianDto,
  CreateEmergencyContactDto,
} from "../dto/student.dto";

@ApiTags("Student — Profile & Dashboard")
@ApiBearerAuth()
@Controller("students/me")
export class StudentController {
  constructor(
    private readonly studentService: StudentService,
    private readonly dashboardService: StudentDashboardService,
  ) {}

  @Get("dashboard")
  @ApiOperation({ summary: "Get aggregated student dashboard data" })
  async getDashboard(@Req() req: any) {
    // Note: Assuming JWT AuthGuard sets user object on req.
    const userId = req.user?.id || "TEST_USER_ID";
    return this.dashboardService.getDashboardData(userId);
  }

  @Get("profile")
  @ApiOperation({ summary: "Get student profile" })
  async getProfile(@Req() req: any) {
    const userId = req.user?.id || "TEST_USER_ID";
    return this.studentService.getProfile(userId);
  }

  @Put("profile")
  @ApiOperation({ summary: "Update student profile" })
  async updateProfile(@Req() req: any, @Body() dto: UpdateStudentProfileDto) {
    const userId = req.user?.id || "TEST_USER_ID";
    return this.studentService.updateProfile(userId, dto);
  }

  @Get("preferences")
  @ApiOperation({ summary: "Get student preferences" })
  async getPreferences(@Req() req: any) {
    const userId = req.user?.id || "TEST_USER_ID";
    return this.studentService.getPreferences(userId);
  }

  @Put("preferences")
  @ApiOperation({ summary: "Update student preferences" })
  async updatePreferences(
    @Req() req: any,
    @Body() dto: UpdateStudentPreferenceDto,
  ) {
    const userId = req.user?.id || "TEST_USER_ID";
    return this.studentService.updatePreferences(userId, dto);
  }

  @Get("achievements")
  @ApiOperation({ summary: "Get student achievements" })
  async getAchievements(@Req() req: any) {
    const userId = req.user?.id || "TEST_USER_ID";
    return this.studentService.getAchievements(userId);
  }

  @Get("guardians")
  @ApiOperation({ summary: "Get student guardians" })
  async getGuardians(@Req() req: any) {
    const userId = req.user?.id || "TEST_USER_ID";
    return this.studentService.getGuardians(userId);
  }

  @Post("guardians")
  @ApiOperation({ summary: "Set student guardian" })
  async setGuardian(@Req() req: any, @Body() dto: CreateGuardianDto) {
    const userId = req.user?.id || "TEST_USER_ID";
    return this.studentService.setGuardian(userId, dto);
  }

  @Get("emergency-contacts")
  @ApiOperation({ summary: "Get emergency contacts" })
  async getEmergencyContacts(@Req() req: any) {
    const userId = req.user?.id || "TEST_USER_ID";
    return this.studentService.getEmergencyContacts(userId);
  }

  @Post("emergency-contacts")
  @ApiOperation({ summary: "Add emergency contact" })
  async addEmergencyContact(
    @Req() req: any,
    @Body() dto: CreateEmergencyContactDto,
  ) {
    const userId = req.user?.id || "TEST_USER_ID";
    return this.studentService.addEmergencyContact(userId, dto);
  }
}

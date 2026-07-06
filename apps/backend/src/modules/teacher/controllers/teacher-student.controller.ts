import {
  Controller,
  Get,
  Post,
  Put,
  Body,
  Param,
  UseGuards,
} from "@nestjs/common";
import { ApiTags, ApiOperation, ApiBearerAuth } from "@nestjs/swagger";
import { JwtAuthGuard } from "../../auth/guards/jwt-auth.guard";
import { RequirePermissions } from "../../security/decorators/authorization.decorators";
import { CurrentUser } from "../../auth/decorators/auth.decorators";
import { JwtAccessPayload as JwtPayload } from "@yoga24x/shared-types";
import { TeacherStudentService } from "../services/teacher-student.service";
import { TEACHER_PERMISSIONS } from "../constants/teacher-permissions";
import {
  UpdateRosterDto,
  CreateStudentNoteDto,
  MarkAttendanceDto,
} from "../dto/teacher-operations.dto";

@ApiTags("Teacher Students (Operations)")
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller("teacher/operations/students")
export class TeacherStudentController {
  constructor(private readonly studentService: TeacherStudentService) {}

  @Get()
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_ROSTER_READ)
  @ApiOperation({ summary: "Get student roster" })
  async getRoster(@CurrentUser() user: JwtPayload) {
    return this.studentService.getRoster(user.sub);
  }

  @Get(":studentId")
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_ROSTER_READ)
  @ApiOperation({ summary: "Get student details" })
  async getRosterDetail(
    @CurrentUser() user: JwtPayload,
    @Param("studentId") studentId: string,
  ) {
    return this.studentService.getRosterDetail(user.sub, studentId);
  }

  @Put(":studentId")
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_ROSTER_WRITE)
  @ApiOperation({ summary: "Update roster flags (favorite, block)" })
  async updateRoster(
    @CurrentUser() user: JwtPayload,
    @Param("studentId") studentId: string,
    @Body() data: UpdateRosterDto,
  ) {
    return this.studentService.updateRoster(user.sub, studentId, data);
  }

  @Post(":studentId/notes")
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_ROSTER_WRITE)
  @ApiOperation({ summary: "Add note for student" })
  async createNote(
    @CurrentUser() user: JwtPayload,
    @Param("studentId") studentId: string,
    @Body() data: CreateStudentNoteDto,
  ) {
    return this.studentService.createNote(user.sub, studentId, data);
  }

  @Post("attendance/:bookingId")
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_BOOKING_WRITE)
  @ApiOperation({ summary: "Mark attendance for a booking" })
  async markAttendance(
    @CurrentUser() user: JwtPayload,
    @Param("bookingId") bookingId: string,
    @Body() data: MarkAttendanceDto,
  ) {
    return this.studentService.markAttendance(user.sub, bookingId, data);
  }
}

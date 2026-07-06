// ==============================================================================
// Yoga24X — Teacher Certification Controller
// REST API: manage professional certifications
// ==============================================================================
import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Req,
  HttpCode,
  HttpStatus,
} from "@nestjs/common";
import { ApiBearerAuth, ApiOperation, ApiTags } from "@nestjs/swagger";
import { TeacherCertificationService } from "../services/teacher-certification.service";
import {
  AddCertificationDto,
  UpdateCertificationDto,
} from "../dto/teacher.dto";

@ApiTags("Teachers — Certifications")
@ApiBearerAuth()
@Controller("api/v1/teachers")
export class TeacherCertificationController {
  constructor(private readonly certService: TeacherCertificationService) {}

  @Get("me/certifications")
  @ApiOperation({ summary: "List own certifications" })
  listCertifications(@Req() req: any) {
    return this.certService.listCertifications(req.user.userId);
  }

  @Post("me/certifications")
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: "Add a certification" })
  addCertification(@Req() req: any, @Body() dto: AddCertificationDto) {
    return this.certService.addCertification(req.user.userId, dto);
  }

  @Put("me/certifications/:id")
  @ApiOperation({ summary: "Update a certification" })
  updateCertification(
    @Req() req: any,
    @Param("id") id: string,
    @Body() dto: UpdateCertificationDto,
  ) {
    return this.certService.updateCertification(id, req.user.userId, dto);
  }

  @Delete("me/certifications/:id")
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: "Remove a certification" })
  removeCertification(@Req() req: any, @Param("id") id: string) {
    return this.certService.removeCertification(id, req.user.userId);
  }

  // ── Public view ───────────────────────────────────────────────────────────────

  @Get(":userId/certifications")
  @ApiOperation({ summary: "View a teacher's public certifications" })
  publicCertifications(@Param("userId") userId: string) {
    return this.certService.listCertifications(userId);
  }
}

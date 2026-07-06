import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Param,
  Body,
  UseGuards,
} from "@nestjs/common";
import { StudentService } from "../services/student.service";
import { JwtAuthGuard } from "../../auth/guards/jwt-auth.guard";
import { RequirePermissions } from "../../security/decorators/authorization.decorators";
import { LEARNING_PERMISSIONS } from "../constants/learning-permissions";
import { CurrentUser } from "../../auth/decorators/auth.decorators";
import { JwtAccessPayload as JwtPayload } from "@yoga24x/shared-types";

@Controller("learning/students")
@UseGuards(JwtAuthGuard)
export class StudentController {
  constructor(private readonly service: StudentService) {}

  @Get()
  @RequirePermissions(LEARNING_PERMISSIONS.COURSE_READ) // Replace with correct perms in full impl
  async findAll(@CurrentUser() user: JwtPayload) {
    return [];
  }
}

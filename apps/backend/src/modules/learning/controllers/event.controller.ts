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
import { EventService } from "../services/event.service";
import { JwtAuthGuard } from "../../auth/guards/jwt-auth.guard";
import { RequirePermissions } from "../../security/decorators/authorization.decorators";
import { LEARNING_PERMISSIONS } from "../constants/learning-permissions";
import { CurrentUser } from "../../auth/decorators/auth.decorators";
import { JwtAccessPayload as JwtPayload } from "@yoga24x/shared-types";

@Controller("learning/events")
@UseGuards(JwtAuthGuard)
export class EventController {
  constructor(private readonly service: EventService) {}

  @Get()
  @RequirePermissions(LEARNING_PERMISSIONS.COURSE_READ) // Replace with correct perms in full impl
  async findAll(@CurrentUser() user: JwtPayload) {
    return [];
  }
}

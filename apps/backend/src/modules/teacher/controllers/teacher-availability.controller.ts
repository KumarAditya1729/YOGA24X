import { Controller, Get, Post, Put, Delete, Body, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RequirePermissions } from '../../security/decorators/authorization.decorators';
import { CurrentUser } from '../../auth/decorators/auth.decorators';
import { JwtAccessPayload as JwtPayload } from '@yoga24x/shared-types';
import { TeacherAvailabilityService } from '../services/teacher-availability.service';
import { TEACHER_PERMISSIONS } from '../constants/teacher-permissions';
import { UpdateTeacherBookingRuleDto, CreateTeacherHolidayDto } from '../dto/teacher-operations.dto';

@ApiTags('Teacher Availability (Operations)')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('teacher/operations/availability')
export class TeacherAvailabilityController {
  constructor(private readonly availabilityService: TeacherAvailabilityService) {}

  @Get('rules')
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_AVAILABILITY_READ)
  @ApiOperation({ summary: 'Get booking rules for current teacher' })
  async getBookingRule(@CurrentUser() user: JwtPayload) {
    return this.availabilityService.getBookingRule(user.sub);
  }

  @Put('rules')
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_AVAILABILITY_WRITE)
  @ApiOperation({ summary: 'Update booking rules for current teacher' })
  async updateBookingRule(@CurrentUser() user: JwtPayload, @Body() data: UpdateTeacherBookingRuleDto) {
    return this.availabilityService.updateBookingRule(user.sub, data);
  }

  @Get('holidays')
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_AVAILABILITY_READ)
  @ApiOperation({ summary: 'Get holidays for current teacher' })
  async getHolidays(@CurrentUser() user: JwtPayload) {
    return this.availabilityService.getHolidays(user.sub);
  }

  @Post('holidays')
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_AVAILABILITY_WRITE)
  @ApiOperation({ summary: 'Create holiday' })
  async createHoliday(@CurrentUser() user: JwtPayload, @Body() data: CreateTeacherHolidayDto) {
    return this.availabilityService.createHoliday(user.sub, data);
  }

  @Delete('holidays/:id')
  @RequirePermissions(TEACHER_PERMISSIONS.TEACHER_AVAILABILITY_WRITE)
  @ApiOperation({ summary: 'Delete holiday' })
  async deleteHoliday(@CurrentUser() user: JwtPayload, @Param('id') id: string) {
    return this.availabilityService.deleteHoliday(user.sub, id);
  }
}

// ==============================================================================
// Yoga24X — Teacher Admin Controller
// REST API: admin operations — feature, suspend, reinstate, metrics, stats
// ==============================================================================
import {
  Controller, Get, Post, Put, Delete, Body, Param, Query,
  Req, HttpCode, HttpStatus,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { TeacherAdminService } from '../services/teacher-admin.service';
import { TeacherStatsService } from '../services/teacher-stats.service';

@ApiTags('Admin — Teachers')
@ApiBearerAuth()
@Controller('api/v1/admin/teachers')
export class TeacherAdminController {
  constructor(
    private readonly adminService: TeacherAdminService,
    private readonly statsService: TeacherStatsService,
  ) {}

  @Get()
  @ApiOperation({ summary: '[Admin] Search & list all teachers' })
  searchTeachers(
    @Query('search') search = '',
    @Query('page') page = '1',
    @Query('limit') limit = '20',
  ) {
    return this.adminService.searchTeachers(search, parseInt(page), parseInt(limit));
  }

  @Get('metrics')
  @ApiOperation({ summary: '[Admin] Get dashboard metrics (totals, pending, fraud flags)' })
  getDashboardMetrics() {
    return this.adminService.getAdminDashboardMetrics();
  }

  @Put(':userId/feature')
  @ApiOperation({ summary: '[Admin] Feature or un-feature a teacher on homepage' })
  featureTeacher(
    @Param('userId') userId: string,
    @Body() body: { isFeatured: boolean },
  ) {
    return this.adminService.featureTeacher(userId, body.isFeatured);
  }

  @Put(':userId/suspend')
  @ApiOperation({ summary: '[Admin] Suspend a teacher profile' })
  suspendTeacher(
    @Param('userId') userId: string,
    @Body() body: { reason: string },
  ) {
    return this.adminService.suspendTeacher(userId, body.reason);
  }

  @Put(':userId/reinstate')
  @ApiOperation({ summary: '[Admin] Reinstate a suspended teacher' })
  reinstateTeacher(@Param('userId') userId: string) {
    return this.adminService.reinstateTeacher(userId);
  }

  @Post('bulk/recalculate-stats')
  @ApiOperation({ summary: '[Admin] Trigger stat recalculation for multiple teachers' })
  bulkRecalcStats(@Body() body: { userIds: string[] }) {
    return this.adminService.bulkRecalculateStats(body.userIds);
  }

  @Get(':userId/stats')
  @ApiOperation({ summary: '[Admin] View detailed stats for a teacher' })
  getTeacherStats(@Param('userId') userId: string) {
    return this.statsService.getStats(userId);
  }
}

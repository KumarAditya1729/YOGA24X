import { Controller, Get, Post, Patch, Body, Param, UseGuards, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { AuthorizationGuard } from '../../security/guards/authorization.guard';
import { RequirePermissions } from '../../security/decorators/authorization.decorators';
import { PERMISSIONS } from '../../security/constants/permissions.registry';
import { SuperAdminService } from '../services/super-admin.service';

@ApiTags('Admin - Super Admin')
@ApiBearerAuth()
@Controller('admin/super')
@UseGuards(AuthorizationGuard)
export class SuperAdminController {
  constructor(private readonly superAdminService: SuperAdminService) {}

  @Get('health')
  @ApiOperation({ summary: 'Platform health check' })
  @RequirePermissions(PERMISSIONS.ADMIN_SUPER)
  async platformHealth() {
    return this.superAdminService.getPlatformHealth();
  }

  @Get('settings')
  @ApiOperation({ summary: 'Get all system settings' })
  @RequirePermissions(PERMISSIONS.ADMIN_SUPER)
  async getSettings() {
    return this.superAdminService.getAllSettings();
  }

  @Post('settings')
  @ApiOperation({ summary: 'Upsert a system setting' })
  @RequirePermissions(PERMISSIONS.ADMIN_SUPER)
  async upsertSetting(@Body() body: { key: string; value: unknown }) {
    return this.superAdminService.upsertSetting(body.key, body.value);
  }

  @Get('feature-toggles')
  @ApiOperation({ summary: 'Get all feature toggles' })
  @RequirePermissions(PERMISSIONS.ADMIN_SUPER)
  async getFeatureToggles() {
    return this.superAdminService.getAllFeatureToggles();
  }

  @Patch('feature-toggles/:name')
  @ApiOperation({ summary: 'Toggle a feature on/off' })
  @RequirePermissions(PERMISSIONS.ADMIN_SUPER)
  async toggleFeature(@Param('name') name: string, @Body() body: { isEnabled: boolean }) {
    return this.superAdminService.toggleFeature(name, body.isEnabled);
  }
}

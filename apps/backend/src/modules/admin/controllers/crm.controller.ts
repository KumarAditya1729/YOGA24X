import { Controller, Get, Post, Patch, Body, Param, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiQuery } from '@nestjs/swagger';
import { AuthorizationGuard } from '../../security/guards/authorization.guard';
import { RequirePermissions } from '../../security/decorators/authorization.decorators';
import { PERMISSIONS } from '../../security/constants/permissions.registry';
import { CrmService } from '../services/crm.service';
import { LeadStatus } from '@prisma/client';

@ApiTags('Admin - CRM')
@ApiBearerAuth()
@Controller('admin/crm')
@UseGuards(AuthorizationGuard)
export class CrmController {
  constructor(private readonly crmService: CrmService) {}

  @Get('leads')
  @ApiOperation({ summary: 'Get all CRM leads' })
  @RequirePermissions(PERMISSIONS.CRM_MANAGE)
  async getLeads() {
    return this.crmService.getLeads();
  }

  @Post('leads')
  @ApiOperation({ summary: 'Add a new CRM lead' })
  @RequirePermissions(PERMISSIONS.CRM_MANAGE)
  async addLead(@Body() body: { email: string; name: string; phone?: string; source?: string }) {
    return this.crmService.addLead(body.email, body.name, body.phone, body.source);
  }

  @Patch('leads/:id/status')
  @ApiOperation({ summary: 'Update lead status in the sales funnel' })
  @RequirePermissions(PERMISSIONS.CRM_MANAGE)
  async updateLeadStatus(@Param('id') id: string, @Body() body: { status: LeadStatus }) {
    return this.crmService.updateLeadStatus(id, body.status);
  }
}

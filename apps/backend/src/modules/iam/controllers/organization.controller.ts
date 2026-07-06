// ==============================================================================
// Yoga24X AI Engineering OS — Organization Controller
// Endpoints for studios, corporate organizations, teams, branches, and invites
// ==============================================================================

import { Controller, Get, Post, Delete, Body, Param, Request, UseGuards } from '@nestjs/common';
import { OrganizationService } from '../services/organization.service';
import { CreateOrganizationDto, InviteOrgMemberDto } from '@yoga24x/shared-types';
import { OrgRoleGuard } from '../guards/org-role.guard';

@Controller('iam/organizations')
export class OrganizationController {
  constructor(private readonly orgService: OrganizationService) {}

  @Post()
  async createOrganization(@Request() req: any, @Body() dto: CreateOrganizationDto): Promise<any> {
    const userId = req.user?.sub || req.headers['x-user-id'];
    return this.orgService.createOrganization(userId, dto);
  }

  @Get('me')
  async getMyOrganizations(@Request() req: any): Promise<any[]> {
    const userId = req.user?.sub || req.headers['x-user-id'];
    return this.orgService.getUserOrganizations(userId);
  }

  @Get(':id')
  async getOrganizationDetails(@Request() req: any, @Param('id') id: string): Promise<any> {
    const userId = req.user?.sub || req.headers['x-user-id'];
    return this.orgService.getOrganizationDetails(id, userId);
  }

  @Post(':orgId/invites')
  @UseGuards(OrgRoleGuard)
  async inviteMember(@Request() req: any, @Param('orgId') orgId: string, @Body() dto: InviteOrgMemberDto): Promise<any> {
    const inviterId = req.user?.sub || req.headers['x-user-id'];
    return this.orgService.inviteMember(orgId, inviterId, dto);
  }

  @Post('invites/:token/accept')
  async acceptInvite(@Request() req: any, @Param('token') token: string): Promise<any> {
    const userId = req.user?.sub || req.headers['x-user-id'];
    return this.orgService.acceptInvitation(token, userId);
  }

  @Delete(':orgId/members/:userId')
  @UseGuards(OrgRoleGuard)
  async removeMember(@Request() req: any, @Param('orgId') orgId: string, @Param('userId') targetUserId: string): Promise<{ success: boolean }> {
    const removerId = req.user?.sub || req.headers['x-user-id'];
    await this.orgService.removeMember(orgId, removerId, targetUserId);
    return { success: true };
  }

  @Post(':orgId/teams')
  @UseGuards(OrgRoleGuard)
  async createTeam(@Request() req: any, @Param('orgId') orgId: string, @Body() body: { name: string; description?: string; leadUserId?: string }): Promise<any> {
    const userId = req.user?.sub || req.headers['x-user-id'];
    return this.orgService.createTeam(orgId, userId, body.name, body.description, body.leadUserId);
  }

  @Post(':orgId/branches')
  @UseGuards(OrgRoleGuard)
  async createBranch(@Request() req: any, @Param('orgId') orgId: string, @Body() body: { name: string; address?: string; city?: string; managerUserId?: string }): Promise<any> {
    const userId = req.user?.sub || req.headers['x-user-id'];
    return this.orgService.createBranch(orgId, userId, body.name, body.address, body.city, body.managerUserId);
  }
}

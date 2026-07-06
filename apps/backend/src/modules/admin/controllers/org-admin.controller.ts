import { Controller, Get, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { AuthorizationGuard } from '../../security/guards/authorization.guard';
import { RequirePermissions } from '../../security/decorators/authorization.decorators';
import { PERMISSIONS } from '../../security/constants/permissions.registry';
import { PrismaService } from '../../prisma/prisma.module';

@ApiTags('Admin - Organization Admin')
@ApiBearerAuth()
@Controller('admin/orgs')
@UseGuards(AuthorizationGuard)
export class OrgAdminController {
  constructor(private readonly prisma: PrismaService) {}

  @Get()
  @ApiOperation({ summary: 'List all organizations' })
  @RequirePermissions(PERMISSIONS.ORG_MANAGE)
  async listOrgs() {
    return this.prisma.organization.findMany({
      orderBy: { createdAt: 'desc' },
      include: {
        _count: { select: { members: true, branches: true } },
      },
    });
  }

  @Get(':id/members')
  @ApiOperation({ summary: 'Get members of an organization' })
  @RequirePermissions(PERMISSIONS.ORG_MANAGE)
  async getOrgMembers(@Param('id') id: string) {
    return this.prisma.organizationMember.findMany({
      where: { organizationId: id },
      include: {
        user: { select: { id: true, email: true, firstName: true, lastName: true } },
      },
    });
  }
}

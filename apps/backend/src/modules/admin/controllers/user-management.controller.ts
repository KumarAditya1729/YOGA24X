import { Controller, Get, Patch, Body, Param, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiQuery } from '@nestjs/swagger';
import { AuthorizationGuard } from '../../security/guards/authorization.guard';
import { RequirePermissions } from '../../security/decorators/authorization.decorators';
import { PERMISSIONS } from '../../security/constants/permissions.registry';
import { PrismaService } from '../../prisma/prisma.module';
import { UserStatus } from '@prisma/client';

@ApiTags('Admin - User Management')
@ApiBearerAuth()
@Controller('admin/users')
@UseGuards(AuthorizationGuard)
export class UserManagementController {
  constructor(private readonly prisma: PrismaService) {}

  @Get()
  @ApiOperation({ summary: 'List all users with filters' })
  @ApiQuery({ name: 'status', required: false })
  @ApiQuery({ name: 'search', required: false })
  @RequirePermissions(PERMISSIONS.USER_MANAGE)
  async listUsers(@Query('status') status?: UserStatus, @Query('search') search?: string) {
    return this.prisma.user.findMany({
      where: {
        isDeleted: false,
        ...(status ? { status } : {}),
        ...(search ? {
          OR: [
            { email: { contains: search, mode: 'insensitive' } },
            { firstName: { contains: search, mode: 'insensitive' } },
            { lastName: { contains: search, mode: 'insensitive' } },
          ],
        } : {}),
      },
      select: {
        id: true, email: true, firstName: true, lastName: true, status: true,
        isEmailVerified: true, createdAt: true, suspendedAt: true,
      },
      orderBy: { createdAt: 'desc' },
      take: 100,
    });
  }

  @Patch(':id/suspend')
  @ApiOperation({ summary: 'Suspend a user' })
  @RequirePermissions(PERMISSIONS.USER_MANAGE)
  async suspendUser(@Param('id') id: string, @Body() body: { reason: string }) {
    return this.prisma.user.update({
      where: { id },
      data: {
        status: UserStatus.SUSPENDED,
        suspendedAt: new Date(),
        suspensionReason: body.reason,
      },
      select: { id: true, status: true, suspendedAt: true },
    });
  }

  @Patch(':id/reactivate')
  @ApiOperation({ summary: 'Reactivate a suspended user' })
  @RequirePermissions(PERMISSIONS.USER_MANAGE)
  async reactivateUser(@Param('id') id: string) {
    return this.prisma.user.update({
      where: { id },
      data: { status: UserStatus.ACTIVE, suspendedAt: null, suspensionReason: null },
      select: { id: true, status: true },
    });
  }

  @Get('verification-queue')
  @ApiOperation({ summary: 'Identity verification queue' })
  @RequirePermissions(PERMISSIONS.USER_MANAGE)
  async getVerificationQueue() {
    return this.prisma.verificationRequest.findMany({
      where: { status: 'PENDING' },
      include: { user: { select: { id: true, email: true, firstName: true, lastName: true } } },
      orderBy: { submittedAt: 'asc' },
    });
  }
}

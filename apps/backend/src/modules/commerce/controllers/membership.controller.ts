import { Controller, Get, Post, Body, Param, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RequirePermissions } from '../../security/decorators/authorization.decorators';
import { PERMISSIONS } from '../../security/constants/permissions.registry';
import { MembershipService } from '../services/membership.service';
import { CreateMembershipPlanDto, PurchaseMembershipDto, FreezeMembershipDto } from '../dto/commerce.dto';

@ApiTags('Memberships')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('api/v1/memberships')
export class MembershipController {
  constructor(private readonly membershipService: MembershipService) {}

  @Get('plans')
  @RequirePermissions(PERMISSIONS.MEMBERSHIP_READ)
  @ApiOperation({ summary: 'List available membership plans' })
  listPlans() {
    return this.membershipService.listPlans();
  }

  @Post('plans')
  @RequirePermissions(PERMISSIONS.MEMBERSHIP_MANAGE)
  @ApiOperation({ summary: 'Create a membership plan (Admin)' })
  createPlan(@Body() dto: CreateMembershipPlanDto) {
    return this.membershipService.createPlan(dto);
  }

  @Post('purchase')
  @RequirePermissions(PERMISSIONS.MEMBERSHIP_WRITE)
  @ApiOperation({ summary: 'Purchase a membership plan' })
  purchaseMembership(@Request() req: any, @Body() dto: PurchaseMembershipDto) {
    return this.membershipService.purchaseMembership(req.user.userId, dto);
  }

  @Get('me')
  @RequirePermissions(PERMISSIONS.MEMBERSHIP_READ)
  @ApiOperation({ summary: 'Get current user active membership' })
  getActiveMembership(@Request() req: any) {
    return this.membershipService.getActiveMembership(req.user.userId);
  }

  @Post(':id/freeze')
  @RequirePermissions(PERMISSIONS.MEMBERSHIP_WRITE)
  @ApiOperation({ summary: 'Freeze a membership' })
  freeze(@Request() req: any, @Param('id') id: string, @Body() dto: FreezeMembershipDto) {
    return this.membershipService.freezeMembership(req.user.userId, id, dto);
  }

  @Post(':id/cancel')
  @RequirePermissions(PERMISSIONS.MEMBERSHIP_WRITE)
  @ApiOperation({ summary: 'Cancel a membership' })
  cancel(@Request() req: any, @Param('id') id: string) {
    return this.membershipService.cancelMembership(req.user.userId, id);
  }
}

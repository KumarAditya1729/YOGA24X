import { Controller, Get, Post, Body, Param, UseGuards, Request, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RequirePermissions } from '../../security/decorators/authorization.decorators';
import { PERMISSIONS } from '../../security/constants/permissions.registry';
import { RevenueService } from '../services/revenue.service';
import { CreateRevenueShareRuleDto } from '../dto/commerce.dto';

@ApiTags('Revenue & Settlements')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('api/v1/revenue')
export class RevenueController {
  constructor(private readonly revenueService: RevenueService) {}

  @Get('shares/me')
  @RequirePermissions(PERMISSIONS.REVENUE_READ)
  @ApiOperation({ summary: 'Get revenue shares for current user (teacher/affiliate)' })
  getMyShares(@Request() req: any) {
    return this.revenueService.getSharesForRecipient(req.user.userId);
  }

  @Get('settlements/pending')
  @RequirePermissions(PERMISSIONS.SETTLEMENT_MANAGE)
  @ApiOperation({ summary: 'Get all pending settlement batches (Admin)' })
  getPendingSettlements() {
    return this.revenueService.getPendingSettlements();
  }

  @Post('settlements/:id/process')
  @RequirePermissions(PERMISSIONS.SETTLEMENT_MANAGE)
  @ApiOperation({ summary: 'Mark a settlement as processed (Admin)' })
  processSettlement(@Param('id') id: string, @Body() body: { gatewayRef: string }) {
    return this.revenueService.processSettlement(id, body.gatewayRef);
  }
}

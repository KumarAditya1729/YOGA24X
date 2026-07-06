import { Controller, Get, Post, Body, Param, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RequirePermissions } from '../../security/decorators/authorization.decorators';
import { PERMISSIONS } from '../../security/constants/permissions.registry';
import { SubscriptionService } from '../services/subscription.service';
import { CreateSubscriptionDto, CancelSubscriptionDto } from '../dto/commerce.dto';

@ApiTags('Subscriptions')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('api/v1/subscriptions')
export class SubscriptionController {
  constructor(private readonly subscriptionService: SubscriptionService) {}

  @Get('plans')
  @RequirePermissions(PERMISSIONS.SUBSCRIPTION_READ)
  @ApiOperation({ summary: 'List available subscription plans' })
  getPlans() {
    return this.subscriptionService.getPlans();
  }

  @Post()
  @RequirePermissions(PERMISSIONS.SUBSCRIPTION_WRITE)
  @ApiOperation({ summary: 'Subscribe to a plan' })
  createSubscription(@Request() req: any, @Body() dto: CreateSubscriptionDto) {
    return this.subscriptionService.createSubscription(req.user.userId, dto);
  }

  @Get('me')
  @RequirePermissions(PERMISSIONS.SUBSCRIPTION_READ)
  @ApiOperation({ summary: 'Get current user active subscription' })
  getUserSubscription(@Request() req: any) {
    return this.subscriptionService.getUserSubscription(req.user.userId);
  }

  @Post(':id/cancel')
  @RequirePermissions(PERMISSIONS.SUBSCRIPTION_WRITE)
  @ApiOperation({ summary: 'Cancel a subscription' })
  cancelSubscription(@Request() req: any, @Param('id') id: string, @Body() dto: CancelSubscriptionDto) {
    return this.subscriptionService.cancelSubscription(req.user.userId, id, dto);
  }

  @Post(':id/renew')
  @RequirePermissions(PERMISSIONS.SUBSCRIPTION_MANAGE)
  @ApiOperation({ summary: 'Renew a subscription (Admin / cron job)' })
  renewSubscription(@Param('id') id: string) {
    return this.subscriptionService.renewSubscription(id);
  }
}

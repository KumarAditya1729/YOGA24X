import { Controller, Get, Post, Body, UseGuards, Request, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RequirePermissions } from '../../security/decorators/authorization.decorators';
import { PERMISSIONS } from '../../security/constants/permissions.registry';
import { WalletService } from '../services/wallet.service';
import { WalletCreditDto, WalletTransferDto } from '../dto/commerce.dto';

@ApiTags('Wallet')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('api/v1/wallet')
export class WalletController {
  constructor(private readonly walletService: WalletService) {}

  @Get()
  @RequirePermissions(PERMISSIONS.WALLET_READ_SELF)
  @ApiOperation({ summary: 'Get current user wallet balance' })
  getWallet(@Request() req: any) {
    return this.walletService.getWallet(req.user.userId);
  }

  @Get('transactions')
  @RequirePermissions(PERMISSIONS.WALLET_READ_SELF)
  @ApiOperation({ summary: 'Get wallet transaction history' })
  getHistory(@Request() req: any, @Query('limit') limit?: string) {
    return this.walletService.getHistory(req.user.userId);
  }

  @Post('credit')
  @RequirePermissions(PERMISSIONS.WALLET_MANAGE)
  @ApiOperation({ summary: 'Credit wallet (Admin)' })
  credit(@Request() req: any, @Body() dto: WalletCreditDto) {
    return this.walletService.credit(req.user.userId, dto);
  }

  @Post('transfer')
  @RequirePermissions(PERMISSIONS.WALLET_TRANSFER)
  @ApiOperation({ summary: 'Transfer wallet balance to another user' })
  transfer(@Request() req: any, @Body() dto: WalletTransferDto) {
    return this.walletService.transfer(req.user.userId, dto);
  }
}

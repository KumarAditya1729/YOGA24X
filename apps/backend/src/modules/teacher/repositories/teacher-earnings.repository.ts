import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';
import { CreatePayoutRequestDto } from '../dto/teacher-operations.dto';

@Injectable()
export class TeacherEarningsRepository {
  constructor(private readonly prisma: PrismaService) {}

  async getPayouts(userId: string) {
    return this.prisma.teacherPayoutRequest.findMany({
      where: { userId },
      orderBy: { requestedAt: 'desc' },
    });
  }

  async createPayout(userId: string, data: CreatePayoutRequestDto) {
    return this.prisma.teacherPayoutRequest.create({
      data: {
        userId,
        amountCents: data.amountCents,
        currency: data.currency ?? 'USD',
        bankAccountId: data.bankAccountId,
      },
    });
  }

  async getWalletBalance(userId: string) {
    // Falls back to creating a wallet if one doesn't exist
    let wallet = await this.prisma.wallet.findUnique({ where: { userId } });
    if (!wallet) {
      wallet = await this.prisma.wallet.create({
        data: { userId, balanceCents: 0, currency: 'USD' },
      });
    }
    return wallet;
  }
}

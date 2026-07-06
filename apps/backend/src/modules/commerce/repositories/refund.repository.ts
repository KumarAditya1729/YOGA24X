import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';
import { RequestRefundDto, ProcessRefundDto } from '../dto/commerce.dto';
import { EventEmitter2 } from '@nestjs/event-emitter';

@Injectable()
export class RefundRepository {
  constructor(private prisma: PrismaService, private eventEmitter: EventEmitter2) {}

  async requestRefund(userId: string, dto: RequestRefundDto) {
    const tx = await this.prisma.paymentTransaction.findUnique({ where: { id: dto.paymentTransactionId } });
    if (!tx || tx.userId !== userId) throw new NotFoundException('Payment not found');

    return this.prisma.refund.create({
      data: {
        paymentTransactionId: dto.paymentTransactionId,
        userId,
        amountCents: dto.amountCents,
        reason: dto.reason,
        status: 'PENDING',
        refundToWallet: dto.refundToWallet ?? false,
      },
    });
  }

  async processRefund(adminId: string, dto: ProcessRefundDto) {
    const refund = await this.prisma.refund.findUnique({ where: { id: dto.refundId } });
    if (!refund) throw new NotFoundException('Refund not found');

    const updatedRefund = await this.prisma.refund.update({
      where: { id: dto.refundId },
      data: {
        status: dto.decision === 'APPROVED' ? 'APPROVED' : 'REJECTED',
        approvedById: adminId,
        adminNote: dto.adminNote,
        processedAt: new Date(),
      },
    });

    if (dto.decision === 'APPROVED') {
      this.eventEmitter.emit('refund.approved', { refundId: refund.id, userId: refund.userId, amountCents: refund.amountCents, refundToWallet: refund.refundToWallet });
    }

    return updatedRefund;
  }

  async getRefundsForUser(userId: string) {
    return this.prisma.refund.findMany({
      where: { userId },
      orderBy: { requestedAt: 'desc' },
    });
  }

  async getPendingRefunds() {
    return this.prisma.refund.findMany({
      where: { status: 'PENDING' },
      include: { user: { select: { id: true, email: true, firstName: true, lastName: true } } },
    });
  }
}

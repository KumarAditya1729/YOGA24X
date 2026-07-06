import { Injectable, BadRequestException } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { WalletCreditDto, WalletTransferDto } from "../dto/commerce.dto";

@Injectable()
export class WalletRepository {
  constructor(private prisma: PrismaService) {}

  async getWallet(userId: string) {
    return this.prisma.wallet.findUnique({
      where: { userId },
      include: { transactions: { orderBy: { createdAt: "desc" }, take: 20 } },
    });
  }

  async creditWallet(userId: string, dto: WalletCreditDto) {
    return this.prisma.$transaction(async (tx) => {
      const wallet = await tx.wallet.upsert({
        where: { userId },
        create: {
          userId,
          balanceCents: BigInt(dto.amountCents),
          currency: "INR",
        },
        update: { balanceCents: { increment: BigInt(dto.amountCents) } },
      });

      await tx.walletTransaction.create({
        data: {
          walletId: userId,
          amountCents: BigInt(dto.amountCents),
          transactionType: "CREDIT",
          description: dto.description,
          referenceId: dto.referenceId,
        },
      });

      return wallet;
    });
  }

  async debitWallet(
    userId: string,
    amountCents: number,
    description: string,
    referenceId?: string,
  ) {
    return this.prisma.$transaction(async (tx) => {
      const wallet = await tx.wallet.findUnique({ where: { userId } });
      if (!wallet || wallet.balanceCents < BigInt(amountCents)) {
        throw new BadRequestException("Insufficient wallet balance");
      }

      await tx.wallet.update({
        where: { userId },
        data: { balanceCents: { decrement: BigInt(amountCents) } },
      });

      await tx.walletTransaction.create({
        data: {
          walletId: userId,
          amountCents: BigInt(amountCents),
          transactionType: "DEBIT",
          description,
          referenceId,
        },
      });
    });
  }

  async transferWallet(fromUserId: string, dto: WalletTransferDto) {
    return this.prisma.$transaction(async (tx) => {
      const fromWallet = await tx.wallet.findUnique({
        where: { userId: fromUserId },
      });
      if (!fromWallet || fromWallet.balanceCents < BigInt(dto.amountCents)) {
        throw new BadRequestException("Insufficient balance for transfer");
      }

      await tx.wallet.update({
        where: { userId: fromUserId },
        data: { balanceCents: { decrement: BigInt(dto.amountCents) } },
      });

      await tx.wallet.upsert({
        where: { userId: dto.recipientUserId },
        create: {
          userId: dto.recipientUserId,
          balanceCents: BigInt(dto.amountCents),
          currency: "INR",
        },
        update: { balanceCents: { increment: BigInt(dto.amountCents) } },
      });

      await tx.walletTransaction.createMany({
        data: [
          {
            walletId: fromUserId,
            amountCents: BigInt(dto.amountCents),
            transactionType: "TRANSFER_OUT",
            description:
              dto.description ?? `Transfer to ${dto.recipientUserId}`,
          },
          {
            walletId: dto.recipientUserId,
            amountCents: BigInt(dto.amountCents),
            transactionType: "TRANSFER_IN",
            description: dto.description ?? `Transfer from ${fromUserId}`,
          },
        ],
      });
    });
  }

  async getTransactionHistory(userId: string, limit = 50) {
    return this.prisma.walletTransaction.findMany({
      where: { walletId: userId },
      orderBy: { createdAt: "desc" },
      take: limit,
    });
  }
}

import { Injectable } from "@nestjs/common";
import { WalletRepository } from "../repositories/wallet.repository";
import { WalletCreditDto, WalletTransferDto } from "../dto/commerce.dto";

@Injectable()
export class WalletService {
  constructor(private readonly walletRepo: WalletRepository) {}

  getWallet(userId: string) {
    return this.walletRepo.getWallet(userId);
  }
  credit(userId: string, dto: WalletCreditDto) {
    return this.walletRepo.creditWallet(userId, dto);
  }
  debit(
    userId: string,
    amountCents: number,
    description: string,
    referenceId?: string,
  ) {
    return this.walletRepo.debitWallet(
      userId,
      amountCents,
      description,
      referenceId,
    );
  }
  transfer(fromUserId: string, dto: WalletTransferDto) {
    return this.walletRepo.transferWallet(fromUserId, dto);
  }
  getHistory(userId: string) {
    return this.walletRepo.getTransactionHistory(userId);
  }
}

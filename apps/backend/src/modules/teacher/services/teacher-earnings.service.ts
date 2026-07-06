import { Injectable } from '@nestjs/common';
import { TeacherEarningsRepository } from '../repositories/teacher-earnings.repository';
import { CreatePayoutRequestDto } from '../dto/teacher-operations.dto';

@Injectable()
export class TeacherEarningsService {
  constructor(private readonly earningsRepo: TeacherEarningsRepository) {}

  async getPayouts(userId: string) {
    return this.earningsRepo.getPayouts(userId);
  }

  async createPayout(userId: string, data: CreatePayoutRequestDto) {
    // Basic validation to ensure they have enough balance
    const wallet = await this.earningsRepo.getWalletBalance(userId);
    if (wallet.balanceCents < data.amountCents) {
      throw new Error('Insufficient funds');
    }
    // Note: real implementation would deduct the balance here within a transaction
    return this.earningsRepo.createPayout(userId, data);
  }

  async getWalletBalance(userId: string) {
    return this.earningsRepo.getWalletBalance(userId);
  }
}

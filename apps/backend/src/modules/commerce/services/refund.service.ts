import { Injectable } from '@nestjs/common';
import { RefundRepository } from '../repositories/refund.repository';
import { RequestRefundDto, ProcessRefundDto } from '../dto/commerce.dto';

@Injectable()
export class RefundService {
  constructor(private readonly refundRepo: RefundRepository) {}

  requestRefund(userId: string, dto: RequestRefundDto) { return this.refundRepo.requestRefund(userId, dto); }
  processRefund(adminId: string, dto: ProcessRefundDto) { return this.refundRepo.processRefund(adminId, dto); }
  getRefundsForUser(userId: string) { return this.refundRepo.getRefundsForUser(userId); }
  getPendingRefunds() { return this.refundRepo.getPendingRefunds(); }
}

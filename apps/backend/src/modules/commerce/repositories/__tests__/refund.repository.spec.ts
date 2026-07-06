import { Test, TestingModule } from '@nestjs/testing';
import { RefundReason } from '@prisma/client';
import { RefundRepository } from '../refund.repository';
import { PrismaService } from '../../../prisma/prisma.module';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { NotFoundException } from '@nestjs/common';

describe('RefundRepository', () => {
  let repository: RefundRepository;
  let prisma: PrismaService;
  let eventEmitter: EventEmitter2;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        RefundRepository,
        {
          provide: PrismaService,
          useValue: {
            paymentTransaction: {
              findUnique: jest.fn(),
            },
            refund: {
              create: jest.fn(),
              findUnique: jest.fn(),
              update: jest.fn(),
            },
          },
        },
        {
          provide: EventEmitter2,
          useValue: {
            emit: jest.fn(),
          },
        }
      ],
    }).compile();

    repository = module.get<RefundRepository>(RefundRepository);
    prisma = module.get<PrismaService>(PrismaService);
    eventEmitter = module.get<EventEmitter2>(EventEmitter2);
  });

  it('should be defined', () => {
    expect(repository).toBeDefined();
  });

  describe('requestRefund', () => {
    it('should throw NotFoundException if payment not found', async () => {
      jest.spyOn(prisma.paymentTransaction, 'findUnique').mockResolvedValue(null);

      await expect(
        repository.requestRefund('user-1', { paymentTransactionId: 'tx-1', amountCents: 1000, reason: RefundReason.OTHER })
      ).rejects.toThrow(NotFoundException);
    });

    it('should create a refund request', async () => {
      jest.spyOn(prisma.paymentTransaction, 'findUnique').mockResolvedValue({
        id: 'tx-1',
        userId: 'user-1',
      } as any);

      jest.spyOn(prisma.refund, 'create').mockResolvedValue({
        id: 'ref-1',
        status: 'PENDING',
      } as any);

      const result = await repository.requestRefund('user-1', { paymentTransactionId: 'tx-1', amountCents: 1000, reason: RefundReason.OTHER });
      expect(result.id).toBe('ref-1');
      expect(prisma.refund.create).toHaveBeenCalled();
    });
  });

  describe('processRefund', () => {
    it('should emit event when approved', async () => {
      jest.spyOn(prisma.refund, 'findUnique').mockResolvedValue({
        id: 'ref-1',
        userId: 'user-1',
        amountCents: 1000,
        refundToWallet: true,
      } as any);
      
      jest.spyOn(prisma.refund, 'update').mockResolvedValue({
        id: 'ref-1',
        status: 'APPROVED',
      } as any);

      await repository.processRefund('admin-1', { refundId: 'ref-1', decision: 'APPROVED' });

      expect(eventEmitter.emit).toHaveBeenCalledWith('refund.approved', {
        refundId: 'ref-1',
        userId: 'user-1',
        amountCents: 1000,
        refundToWallet: true,
      });
    });
  });
});

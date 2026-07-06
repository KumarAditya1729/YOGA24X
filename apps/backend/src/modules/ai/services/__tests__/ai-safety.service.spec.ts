import { Test, TestingModule } from '@nestjs/testing';
import { AiSafetyService } from '../ai-safety.service';
import { PrismaService } from '../../../prisma/prisma.module';
import { BadRequestException } from '@nestjs/common';
import { AiSafetyLevel } from '@prisma/client';

describe('AiSafetyService', () => {
  let service: AiSafetyService;
  let prisma: PrismaService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AiSafetyService,
        {
          provide: PrismaService,
          useValue: {
            aiSafetyAuditLog: {
              create: jest.fn().mockResolvedValue({ id: 'log-1' }),
            },
          },
        },
      ],
    }).compile();

    service = module.get<AiSafetyService>(AiSafetyService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should pass safe input without modification', async () => {
    const input = 'I want to improve my flexibility in yoga.';
    const result = await service.validateAndSanitize('user-1', input);
    
    expect(result).toBe(input);
    expect(prisma.aiSafetyAuditLog.create).not.toHaveBeenCalled();
  });

  it('should block medical advice requests', async () => {
    const input = 'Can you prescribe something for my cancer?';
    
    await expect(service.validateAndSanitize('user-1', input))
      .rejects.toThrow(BadRequestException);

    expect(prisma.aiSafetyAuditLog.create).toHaveBeenCalledWith({
      data: {
        userId: 'user-1',
        eventType: 'MEDICAL_ADVICE_BLOCKED',
        originalInput: input,
        sanitizedInput: null,
        safetyLevel: AiSafetyLevel.STRICT,
      },
    });
  });

  it('should scrub phone numbers', async () => {
    const input = 'Call me at 555-123-4567 to discuss my plan.';
    const result = await service.validateAndSanitize('user-1', input);
    
    expect(result).toBe('Call me at [PHONE REDACTED] to discuss my plan.');
    
    expect(prisma.aiSafetyAuditLog.create).toHaveBeenCalledWith({
      data: {
        userId: 'user-1',
        eventType: 'PII_SCRUBBED',
        originalInput: input,
        sanitizedInput: 'Call me at [PHONE REDACTED] to discuss my plan.',
        safetyLevel: AiSafetyLevel.MODERATE,
      },
    });
  });

  it('should scrub email addresses', async () => {
    const input = 'Email me at student@yoga24x.com please.';
    const result = await service.validateAndSanitize('user-1', input);
    
    expect(result).toBe('Email me at [EMAIL REDACTED] please.');
    
    expect(prisma.aiSafetyAuditLog.create).toHaveBeenCalledWith({
      data: {
        userId: 'user-1',
        eventType: 'PII_SCRUBBED',
        originalInput: input,
        sanitizedInput: 'Email me at [EMAIL REDACTED] please.',
        safetyLevel: AiSafetyLevel.MODERATE,
      },
    });
  });

  it('should scrub both phone and email in the same message', async () => {
    const input = 'My email is test@test.com and phone is 123-456-7890.';
    const result = await service.validateAndSanitize('user-1', input);
    
    expect(result).toBe('My email is [EMAIL REDACTED] and phone is [PHONE REDACTED].');
  });
});

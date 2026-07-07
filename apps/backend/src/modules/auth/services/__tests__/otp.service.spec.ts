import { Test, TestingModule } from '@nestjs/testing';
import { OtpService } from '../otp.service';
import { RedisService } from '../../../redis/redis.module';
import { AuthRepository } from '../../repositories/auth.repository';
import { ForbiddenException, BadRequestException } from '@nestjs/common';
import * as bcrypt from 'bcrypt';

describe('OtpService', () => {
  let service: OtpService;
  let redisService: jest.Mocked<RedisService>;
  let authRepository: jest.Mocked<AuthRepository>;

  beforeEach(async () => {
    const mockRedisService = {
      checkRateLimit: jest.fn(),
      set: jest.fn(),
      get: jest.fn(),
      exists: jest.fn(),
      del: jest.fn(),
    };

    const mockAuthRepository = {
      createOtpVerification: jest.fn(),
      findLatestValidOtp: jest.fn(),
      markOtpUsed: jest.fn(),
      incrementOtpAttempts: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        OtpService,
        { provide: RedisService, useValue: mockRedisService },
        { provide: AuthRepository, useValue: mockAuthRepository },
      ],
    }).compile();

    service = module.get<OtpService>(OtpService);
    redisService = module.get(RedisService);
    authRepository = module.get(AuthRepository);
  });

  describe('generateAndSendOtp', () => {
    it('should generate and store a 6-digit OTP when rate limit is allowed', async () => {
      redisService.checkRateLimit.mockResolvedValue({ allowed: true, resetInSeconds: 900, remaining: 4 });
      authRepository.createOtpVerification.mockResolvedValue({} as any);
      redisService.set.mockResolvedValue('OK' as any);

      const result = await service.generateAndSendOtp('test@yoga24x.com', 'LOGIN', 'EMAIL');

      expect(result.identifier).toBe('test@yoga24x.com');
      expect(result.purpose).toBe('LOGIN');
      expect(result.deliveryStatus).toBe('SENT');
      expect(authRepository.createOtpVerification).toHaveBeenCalled();
      expect(redisService.set).toHaveBeenCalled();
    });

    it('should throw ForbiddenException if rate limit is exceeded', async () => {
      redisService.checkRateLimit.mockResolvedValue({ allowed: false, resetInSeconds: 600, remaining: 0 });

      await expect(service.generateAndSendOtp('test@yoga24x.com', 'LOGIN')).rejects.toThrow(ForbiddenException);
      expect(authRepository.createOtpVerification).not.toHaveBeenCalled();
    });
  });

  describe('verifyOtp', () => {
    it('should successfully verify a valid OTP code from Redis', async () => {
      redisService.exists.mockResolvedValue(false); // not locked
      const validCode = '123456';
      const otpHash = await bcrypt.hash(validCode, 10);

      redisService.get.mockResolvedValue(JSON.stringify({ otpHash, attempts: 0 }));
      authRepository.markOtpUsed.mockResolvedValue({} as any);
      authRepository.findLatestValidOtp.mockResolvedValue({ id: 'db-id-1' } as any);
      redisService.del.mockResolvedValue(1 as any);

      const isValid = await service.verifyOtp('test@yoga24x.com', validCode, 'LOGIN');
      expect(isValid).toBe(true);
      expect(redisService.del).toHaveBeenCalled();
    });

    it('should throw ForbiddenException if account is locked due to brute force', async () => {
      redisService.exists.mockResolvedValue(true); // locked!

      await expect(service.verifyOtp('test@yoga24x.com', '123456', 'LOGIN')).rejects.toThrow(ForbiddenException);
      expect(redisService.get).not.toHaveBeenCalled();
    });

    it('should throw BadRequestException and record failed attempt on invalid code', async () => {
      redisService.exists.mockResolvedValue(false);
      const otpHash = await bcrypt.hash('999999', 10);
      redisService.get.mockResolvedValue(JSON.stringify({ otpHash, attempts: 0 }));
      redisService.checkRateLimit.mockResolvedValue({ allowed: true, resetInSeconds: 1800, remaining: 2 });

      await expect(service.verifyOtp('test@yoga24x.com', '111111', 'LOGIN')).rejects.toThrow(BadRequestException);
    });
  });
});

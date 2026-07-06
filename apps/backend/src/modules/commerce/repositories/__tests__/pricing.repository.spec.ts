import { Test, TestingModule } from "@nestjs/testing";
import { PricingRepository } from "../pricing.repository";
import { PrismaService } from "../../../prisma/prisma.module";
import { BadRequestException, NotFoundException } from "@nestjs/common";

describe("PricingRepository", () => {
  let repository: PricingRepository;
  let prisma: PrismaService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PricingRepository,
        {
          provide: PrismaService,
          useValue: {
            coupon: {
              findUnique: jest.fn(),
              create: jest.fn(),
              update: jest.fn(),
            },
            couponRedemption: {
              count: jest.fn(),
              create: jest.fn(),
            },
            pricingRule: {
              findMany: jest.fn(),
              create: jest.fn(),
            },
            $transaction: jest.fn(),
          },
        },
      ],
    }).compile();

    repository = module.get<PricingRepository>(PricingRepository);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it("should be defined", () => {
    expect(repository).toBeDefined();
  });

  describe("validateAndApplyCoupon", () => {
    it("should throw NotFoundException if coupon does not exist", async () => {
      jest.spyOn(prisma.coupon, "findUnique").mockResolvedValue(null);

      await expect(
        repository.validateAndApplyCoupon("user-1", {
          code: "INVALID",
          orderAmountCents: 1000,
        }),
      ).rejects.toThrow(NotFoundException);
    });

    it("should calculate percentage discount correctly", async () => {
      jest.spyOn(prisma.coupon, "findUnique").mockResolvedValue({
        id: "coupon-1",
        code: "SUMMER20",
        isActive: true,
        discountPercent: 20,
        perUserLimit: 1,
        usageCount: 0,
      } as any);
      jest.spyOn(prisma.couponRedemption, "count").mockResolvedValue(0);

      const result = await repository.validateAndApplyCoupon("user-1", {
        code: "SUMMER20",
        orderAmountCents: 10000,
      });
      expect(result.discountCents).toBe(2000); // 20% of 10000
      expect(result.finalAmountCents).toBe(8000);
    });

    it("should throw BadRequestException if per-user limit reached", async () => {
      jest.spyOn(prisma.coupon, "findUnique").mockResolvedValue({
        id: "coupon-1",
        code: "ONCE",
        isActive: true,
        discountPercent: 20,
        perUserLimit: 1,
        usageCount: 0,
      } as any);
      jest.spyOn(prisma.couponRedemption, "count").mockResolvedValue(1);

      await expect(
        repository.validateAndApplyCoupon("user-1", {
          code: "ONCE",
          orderAmountCents: 10000,
        }),
      ).rejects.toThrow(BadRequestException);
    });
  });

  describe("calculateFinalPrice", () => {
    it("should apply pricing rules", async () => {
      jest
        .spyOn(prisma.pricingRule, "findMany")
        .mockResolvedValue([{ discountCents: 1000, ruleType: "PROMO" } as any]);

      const result = await repository.calculateFinalPrice(5000);
      expect(result.finalPriceCents).toBe(4000); // 5000 - 1000
      expect(result.appliedDiscounts.length).toBe(1);
    });
  });
});

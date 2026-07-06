import { Test, TestingModule } from "@nestjs/testing";
import { AnalyticsService } from "../services/analytics.service";
import { PrismaService } from "../../prisma/prisma.module";
import { MembershipStatus, SettlementStatus } from "@prisma/client";

const mockPrisma = {
  user: { count: jest.fn() },
  membership: { count: jest.fn() },
  settlementBatch: { aggregate: jest.fn() },
};

describe("AnalyticsService", () => {
  let service: AnalyticsService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AnalyticsService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<AnalyticsService>(AnalyticsService);
  });

  afterEach(() => jest.clearAllMocks());

  it("should compute platform metrics correctly", async () => {
    mockPrisma.user.count.mockResolvedValue(500);
    mockPrisma.membership.count.mockResolvedValue(120);
    mockPrisma.settlementBatch.aggregate.mockResolvedValue({
      _sum: { totalCents: 5000000 },
    });

    const result = await service.getPlatformMetrics();
    expect(result.totalUsers).toBe(500);
    expect(result.activeSubscriptions).toBe(120);
    expect(result.totalRevenueInPaisa).toBe(5000000);
  });

  it("should return 0 revenue when no settled batches", async () => {
    mockPrisma.user.count.mockResolvedValue(10);
    mockPrisma.membership.count.mockResolvedValue(5);
    mockPrisma.settlementBatch.aggregate.mockResolvedValue({
      _sum: { totalCents: null },
    });

    const result = await service.getPlatformMetrics();
    expect(result.totalRevenueInPaisa).toBe(0);
  });

  it("should compute churn rate as 0 when no memberships", async () => {
    mockPrisma.membership.count.mockResolvedValue(0);
    const rate = await service.getChurnRate();
    expect(rate).toBe(0);
  });

  it("should compute churn rate percentage correctly", async () => {
    mockPrisma.membership.count
      .mockResolvedValueOnce(100) // total
      .mockResolvedValueOnce(20); // cancelled
    const rate = await service.getChurnRate();
    expect(rate).toBe(20);
  });

  it("should compute retention metrics", async () => {
    mockPrisma.membership.count
      .mockResolvedValueOnce(100) // total in retentionMetrics
      .mockResolvedValueOnce(80) // active in retentionMetrics
      .mockResolvedValueOnce(100) // total in churnRate
      .mockResolvedValueOnce(20); // cancelled in churnRate
    const result = await service.getRetentionMetrics();
    expect(result.retentionRate).toBe(80);
    expect(result.churnRate).toBe(20);
  });
});

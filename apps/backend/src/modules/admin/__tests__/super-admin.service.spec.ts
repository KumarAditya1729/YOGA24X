import { Test, TestingModule } from "@nestjs/testing";
import { SuperAdminService } from "../services/super-admin.service";
import { PrismaService } from "../../prisma/prisma.module";

const mockPrisma = {
  user: { count: jest.fn() },
  systemSetting: {
    findMany: jest.fn(),
    upsert: jest.fn(),
  },
  featureToggle: {
    findMany: jest.fn(),
    upsert: jest.fn(),
  },
};

describe("SuperAdminService", () => {
  let service: SuperAdminService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SuperAdminService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<SuperAdminService>(SuperAdminService);
  });

  afterEach(() => jest.clearAllMocks());

  it("should return platform health with user count", async () => {
    mockPrisma.user.count.mockResolvedValue(42);
    const result = await service.getPlatformHealth();
    expect(result.status).toBe("ok");
    expect(result.stats.totalUsers).toBe(42);
  });

  it("should upsert a system setting", async () => {
    const setting = { key: "maintenance_mode", value: false };
    mockPrisma.systemSetting.upsert.mockResolvedValue(setting);
    const result = await service.upsertSetting("maintenance_mode", false);
    expect(result.key).toBe("maintenance_mode");
    expect(mockPrisma.systemSetting.upsert).toHaveBeenCalledWith(
      expect.objectContaining({ where: { key: "maintenance_mode" } }),
    );
  });

  it("should enable a feature toggle", async () => {
    const toggle = { featureName: "ai_coach", isEnabled: true };
    mockPrisma.featureToggle.upsert.mockResolvedValue(toggle);
    const result = await service.toggleFeature("ai_coach", true);
    expect(result.isEnabled).toBe(true);
  });

  it("should disable a feature toggle", async () => {
    const toggle = { featureName: "ai_coach", isEnabled: false };
    mockPrisma.featureToggle.upsert.mockResolvedValue(toggle);
    const result = await service.toggleFeature("ai_coach", false);
    expect(result.isEnabled).toBe(false);
  });

  it("should list all system settings", async () => {
    mockPrisma.systemSetting.findMany.mockResolvedValue([
      { key: "theme", value: "dark" },
      { key: "max_users", value: 1000 },
    ]);
    const result = await service.getAllSettings();
    expect(result).toHaveLength(2);
    expect(result[0].key).toBe("theme");
  });
});

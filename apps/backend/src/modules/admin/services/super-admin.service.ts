import { Injectable } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";

@Injectable()
export class SuperAdminService {
  constructor(private readonly prisma: PrismaService) {}

  async getPlatformHealth() {
    const userCount = await this.prisma.user.count({
      where: { isDeleted: false },
    });
    return {
      status: "ok",
      timestamp: new Date().toISOString(),
      stats: { totalUsers: userCount },
    };
  }

  async getAllSettings() {
    return this.prisma.systemSetting.findMany({ orderBy: { key: "asc" } });
  }

  async upsertSetting(key: string, value: unknown) {
    return this.prisma.systemSetting.upsert({
      where: { key },
      update: { value: value as object },
      create: { key, value: value as object },
    });
  }

  async getAllFeatureToggles() {
    return this.prisma.featureToggle.findMany({
      orderBy: { featureName: "asc" },
    });
  }

  async toggleFeature(featureName: string, isEnabled: boolean) {
    return this.prisma.featureToggle.upsert({
      where: { featureName },
      update: { isEnabled },
      create: { featureName, isEnabled },
    });
  }
}

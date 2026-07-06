// ==============================================================================
// Yoga24X AI Engineering OS — Device & Identity Repository
// Handles Registered Devices, Trusted Devices, Nicknames, Fingerprints & Identities
// ==============================================================================

import { Injectable, NotFoundException } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";

@Injectable()
export class DeviceRepository {
  constructor(private readonly prisma: PrismaService) {}

  async getUserDevices(userId: string): Promise<any[]> {
    return this.prisma.userDevice.findMany({
      where: { userId },
      orderBy: { updatedAt: "desc" },
    });
  }

  async getTrustedDevices(userId: string): Promise<any[]> {
    return this.prisma.trustedDevice.findMany({
      where: { userId },
      orderBy: { lastUsedAt: "desc" },
    });
  }

  async getDeviceHistory(userId: string): Promise<any[]> {
    return this.prisma.deviceHistory.findMany({
      where: { userId },
      orderBy: { timestamp: "desc" },
      take: 50,
    });
  }

  async updateDeviceNickname(
    userId: string,
    deviceId: string,
    nickname: string,
  ): Promise<any> {
    const device = await this.prisma.userDevice.findFirst({
      where: { id: deviceId, userId },
    });
    if (!device) {
      throw new NotFoundException("Device not found");
    }

    const updated = await this.prisma.userDevice.update({
      where: { id: deviceId },
      data: { deviceNickname: nickname },
    });

    await this.prisma.deviceHistory.create({
      data: {
        userId,
        deviceId,
        deviceFingerprint: device.deviceFingerprint,
        action: "NICKNAME_UPDATED",
        ipAddress: device.lastIp,
      },
    });

    return updated;
  }

  async removeDevice(userId: string, deviceId: string): Promise<void> {
    const device = await this.prisma.userDevice.findFirst({
      where: { id: deviceId, userId },
    });
    if (device) {
      await this.prisma.deviceHistory.create({
        data: {
          userId,
          deviceId,
          deviceFingerprint: device.deviceFingerprint,
          action: "REVOKED",
          ipAddress: device.lastIp,
        },
      });
      await this.prisma.userDevice.delete({ where: { id: deviceId } });
    }
  }

  async getUserIdentities(userId: string): Promise<any[]> {
    return this.prisma.userIdentity.findMany({
      where: { userId },
      orderBy: { createdAt: "asc" },
    });
  }

  async linkIdentity(
    userId: string,
    provider: string,
    providerId: string,
    profileDataJson?: Record<string, any>,
  ): Promise<any> {
    return this.prisma.userIdentity.upsert({
      where: {
        uq_identities_provider_id: { provider: provider as any, providerId },
      },
      update: { profileDataJson: profileDataJson || {} },
      create: {
        userId,
        provider: provider as any,
        providerId,
        profileDataJson: profileDataJson || {},
      },
    });
  }

  async unlinkIdentity(
    userId: string,
    provider: string,
    providerId: string,
  ): Promise<void> {
    // Check that user has at least one other identity before unlinking
    const count = await this.prisma.userIdentity.count({ where: { userId } });
    if (count <= 1) {
      throw new Error("Cannot remove the only linked login identity");
    }

    await this.prisma.userIdentity.delete({
      where: {
        uq_identities_provider_id: { provider: provider as any, providerId },
      },
    });
  }
}

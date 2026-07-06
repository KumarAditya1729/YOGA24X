// ==============================================================================
// Yoga24X AI Engineering OS — Device Management & Identity Service
// Handles device nicknames, trusted devices, device history, and linked identities
// ==============================================================================

import { Injectable } from "@nestjs/common";
import { DeviceRepository } from "../repositories/device.repository";

@Injectable()
export class DeviceManagementService {
  constructor(private readonly deviceRepo: DeviceRepository) {}

  async getUserDevices(userId: string): Promise<any[]> {
    return this.deviceRepo.getUserDevices(userId);
  }

  async getTrustedDevices(userId: string): Promise<any[]> {
    return this.deviceRepo.getTrustedDevices(userId);
  }

  async getDeviceHistory(userId: string): Promise<any[]> {
    return this.deviceRepo.getDeviceHistory(userId);
  }

  async updateDeviceNickname(
    userId: string,
    deviceId: string,
    nickname: string,
  ): Promise<any> {
    return this.deviceRepo.updateDeviceNickname(userId, deviceId, nickname);
  }

  async removeDevice(userId: string, deviceId: string): Promise<void> {
    return this.deviceRepo.removeDevice(userId, deviceId);
  }

  async getUserIdentities(userId: string): Promise<any[]> {
    return this.deviceRepo.getUserIdentities(userId);
  }

  async linkIdentity(
    userId: string,
    provider: string,
    providerId: string,
    profileDataJson?: Record<string, any>,
  ): Promise<any> {
    return this.deviceRepo.linkIdentity(
      userId,
      provider,
      providerId,
      profileDataJson,
    );
  }

  async unlinkIdentity(
    userId: string,
    provider: string,
    providerId: string,
  ): Promise<void> {
    return this.deviceRepo.unlinkIdentity(userId, provider, providerId);
  }
}

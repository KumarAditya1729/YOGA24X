// ==============================================================================
// Yoga24X AI Engineering OS — Device & Identity Controller
// Endpoints for device nicknames, device history, and linked login identities
// ==============================================================================

import {
  Controller,
  Get,
  Put,
  Post,
  Delete,
  Body,
  Param,
  Request,
} from "@nestjs/common";
import { DeviceManagementService } from "../services/device-management.service";

@Controller("iam")
export class DeviceController {
  constructor(private readonly deviceService: DeviceManagementService) {}

  @Get("devices")
  async getMyDevices(@Request() req: any): Promise<any[]> {
    const userId = req.user?.sub || req.headers["x-user-id"];
    return this.deviceService.getUserDevices(userId);
  }

  @Get("devices/trusted")
  async getTrustedDevices(@Request() req: any): Promise<any[]> {
    const userId = req.user?.sub || req.headers["x-user-id"];
    return this.deviceService.getTrustedDevices(userId);
  }

  @Get("devices/history")
  async getDeviceHistory(@Request() req: any): Promise<any[]> {
    const userId = req.user?.sub || req.headers["x-user-id"];
    return this.deviceService.getDeviceHistory(userId);
  }

  @Put("devices/:id/nickname")
  async updateNickname(
    @Request() req: any,
    @Param("id") deviceId: string,
    @Body() body: { nickname: string },
  ): Promise<any> {
    const userId = req.user?.sub || req.headers["x-user-id"];
    return this.deviceService.updateDeviceNickname(
      userId,
      deviceId,
      body.nickname,
    );
  }

  @Delete("devices/:id")
  async removeDevice(
    @Request() req: any,
    @Param("id") deviceId: string,
  ): Promise<{ success: boolean }> {
    const userId = req.user?.sub || req.headers["x-user-id"];
    await this.deviceService.removeDevice(userId, deviceId);
    return { success: true };
  }

  @Get("identities")
  async getMyIdentities(@Request() req: any): Promise<any[]> {
    const userId = req.user?.sub || req.headers["x-user-id"];
    return this.deviceService.getUserIdentities(userId);
  }

  @Post("identities")
  async linkIdentity(
    @Request() req: any,
    @Body()
    body: {
      provider: string;
      providerId: string;
      profileDataJson?: Record<string, any>;
    },
  ): Promise<any> {
    const userId = req.user?.sub || req.headers["x-user-id"];
    return this.deviceService.linkIdentity(
      userId,
      body.provider,
      body.providerId,
      body.profileDataJson,
    );
  }

  @Delete("identities/:provider/:providerId")
  async unlinkIdentity(
    @Request() req: any,
    @Param("provider") provider: string,
    @Param("providerId") providerId: string,
  ): Promise<{ success: boolean }> {
    const userId = req.user?.sub || req.headers["x-user-id"];
    await this.deviceService.unlinkIdentity(userId, provider, providerId);
    return { success: true };
  }
}

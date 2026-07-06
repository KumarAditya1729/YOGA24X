import { Injectable } from "@nestjs/common";
import { ModerationRepository } from "../repositories/moderation.repository";
import { ReportContentDto } from "../dto/social.dto";

@Injectable()
export class ModerationService {
  constructor(private readonly modRepo: ModerationRepository) {}

  async reportContent(reporterId: string, data: ReportContentDto) {
    return this.modRepo.reportContent(reporterId, data);
  }

  async blockUser(blockerId: string, blockedId: string) {
    return this.modRepo.blockUser(blockerId, blockedId);
  }
}

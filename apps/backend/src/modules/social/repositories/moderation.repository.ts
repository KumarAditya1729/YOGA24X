import { Injectable } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { ReportContentDto } from "../dto/social.dto";

@Injectable()
export class ModerationRepository {
  constructor(private prisma: PrismaService) {}

  async reportContent(reporterId: string, data: ReportContentDto) {
    return this.prisma.reportedContent.create({
      data: {
        reporterId,
        reason: data.reason,
        details: data.details,
        postId: data.postId,
        commentId: data.commentId,
      },
    });
  }

  async blockUser(blockerId: string, blockedId: string) {
    return this.prisma.blockedUser.create({
      data: {
        blockerId,
        blockedId,
      },
    });
  }
}

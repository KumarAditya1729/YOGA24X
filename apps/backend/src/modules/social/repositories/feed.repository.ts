import { Injectable } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";

@Injectable()
export class FeedRepository {
  constructor(private prisma: PrismaService) {}

  async getGlobalFeed(limit: number = 20) {
    return this.prisma.communityPost.findMany({
      where: {
        isPublished: true,
        groupId: null, // Only global posts
      },
      include: {
        author: { select: { id: true, email: true } },
        _count: { select: { likes: true, comments: true } },
      },
      orderBy: { createdAt: "desc" },
      take: limit,
    });
  }

  async getGroupFeed(groupId: string, limit: number = 20) {
    return this.prisma.communityPost.findMany({
      where: {
        isPublished: true,
        groupId,
      },
      include: {
        author: { select: { id: true, email: true } },
        _count: { select: { likes: true, comments: true } },
      },
      orderBy: { createdAt: "desc" },
      take: limit,
    });
  }
}

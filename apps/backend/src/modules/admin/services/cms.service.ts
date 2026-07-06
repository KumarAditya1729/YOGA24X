import { Injectable } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { CmsType, CmsStatus } from "@prisma/client";

@Injectable()
export class CmsService {
  constructor(private readonly prisma: PrismaService) {}

  async createArticle(
    authorId: string,
    title: string,
    slug: string,
    content: string,
    type: CmsType,
  ) {
    return this.prisma.cmsArticle.create({
      data: { authorId, title, slug, content, type, status: CmsStatus.DRAFT },
    });
  }

  async publishArticle(id: string) {
    return this.prisma.cmsArticle.update({
      where: { id },
      data: { status: CmsStatus.PUBLISHED },
    });
  }

  async listArticles(type?: CmsType) {
    return this.prisma.cmsArticle.findMany({
      where: type ? { type } : undefined,
      orderBy: { createdAt: "desc" },
      include: { author: { select: { email: true, firstName: true } } },
    });
  }
}

// ==============================================================================
// Yoga24X — Teacher Portfolio Service
// Gallery, videos, awards, publications, achievements management
// ==============================================================================
import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';
import { AddPortfolioItemDto } from '../dto/teacher.dto';

@Injectable()
export class TeacherPortfolioService {
  constructor(private readonly prisma: PrismaService) {}

  async addItem(userId: string, dto: AddPortfolioItemDto) {
    return this.prisma.teacherPortfolioItem.create({
      data: {
        userId,
        itemType: dto.itemType,
        title: dto.title,
        description: dto.description,
        mediaUrl: dto.mediaUrl,
        externalUrl: dto.externalUrl,
        issuedAt: dto.issuedAt ? new Date(dto.issuedAt) : undefined,
        isFeatured: dto.isFeatured ?? false,
        displayOrder: dto.displayOrder ?? 0,
      },
    });
  }

  async updateItem(id: string, userId: string, dto: Partial<AddPortfolioItemDto>) {
    await this.assertOwnership(id, userId);
    return this.prisma.teacherPortfolioItem.update({
      where: { id },
      data: {
        ...dto,
        issuedAt: dto.issuedAt ? new Date(dto.issuedAt) : undefined,
        updatedAt: new Date(),
      },
    });
  }

  async removeItem(id: string, userId: string) {
    await this.assertOwnership(id, userId);
    await this.prisma.teacherPortfolioItem.delete({ where: { id } });
    return { success: true };
  }

  async listItems(userId: string, itemType?: string) {
    return this.prisma.teacherPortfolioItem.findMany({
      where: { userId, ...(itemType ? { itemType: itemType as any } : {}) },
      orderBy: [{ isFeatured: 'desc' }, { displayOrder: 'asc' }],
    });
  }

  async reorder(userId: string, orderedIds: string[]) {
    const updates = orderedIds.map((id, index) =>
      this.prisma.teacherPortfolioItem.updateMany({
        where: { id, userId },
        data: { displayOrder: index },
      }),
    );
    await Promise.all(updates);
    return { success: true };
  }

  async toggleFeatured(id: string, userId: string) {
    await this.assertOwnership(id, userId);
    const item = await this.prisma.teacherPortfolioItem.findUnique({ where: { id } });
    if (!item) throw new NotFoundException('Portfolio item not found');
    return this.prisma.teacherPortfolioItem.update({
      where: { id },
      data: { isFeatured: !item.isFeatured },
    });
  }

  private async assertOwnership(id: string, userId: string) {
    const item = await this.prisma.teacherPortfolioItem.findUnique({ where: { id } });
    if (!item) throw new NotFoundException('Portfolio item not found');
    if (item.userId !== userId) throw new ForbiddenException('You do not own this portfolio item');
  }
}

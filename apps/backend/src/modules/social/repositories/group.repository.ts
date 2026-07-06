import { Injectable } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { CreateGroupDto } from "../dto/social.dto";

@Injectable()
export class GroupRepository {
  constructor(private prisma: PrismaService) {}

  async createGroup(data: CreateGroupDto) {
    return this.prisma.communityGroup.create({
      data: {
        name: data.name,
        description: data.description,
        groupType: data.groupType,
      },
    });
  }

  async getGroups(type?: string) {
    return this.prisma.communityGroup.findMany({
      where: type ? { groupType: type as any } : undefined,
      include: {
        _count: {
          select: { members: true },
        },
      },
    });
  }

  async joinGroup(groupId: string, userId: string) {
    return this.prisma.groupMember.create({
      data: {
        groupId,
        userId,
      },
    });
  }
}

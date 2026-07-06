import { Injectable } from "@nestjs/common";
import { GroupRepository } from "../repositories/group.repository";
import { CreateGroupDto } from "../dto/social.dto";

@Injectable()
export class GroupService {
  constructor(private readonly groupRepo: GroupRepository) {}

  async createGroup(data: CreateGroupDto) {
    return this.groupRepo.createGroup(data);
  }

  async getGroups(type?: string) {
    return this.groupRepo.getGroups(type);
  }

  async joinGroup(groupId: string, userId: string) {
    return this.groupRepo.joinGroup(groupId, userId);
  }
}

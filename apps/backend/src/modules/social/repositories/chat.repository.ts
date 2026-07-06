import { Injectable } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import {
  CreateChatConversationDto,
  SendChatMessageDto,
} from "../dto/social.dto";

@Injectable()
export class ChatRepository {
  constructor(private prisma: PrismaService) {}

  async createConversation(data: CreateChatConversationDto) {
    return this.prisma.chatConversation.create({
      data: {
        chatType: data.chatType,
        name: data.name,
        participants: {
          create: data.participantIds.map((id) => ({ userId: id })),
        },
      },
    });
  }

  async getConversations(userId: string) {
    return this.prisma.chatConversation.findMany({
      where: {
        participants: {
          some: { userId },
        },
      },
      include: {
        participants: true,
        messages: {
          orderBy: { createdAt: "desc" },
          take: 1,
        },
      },
      orderBy: { updatedAt: "desc" },
    });
  }

  async sendMessage(senderId: string, data: SendChatMessageDto) {
    const message = await this.prisma.chatMessage.create({
      data: {
        conversationId: data.conversationId,
        senderId,
        contentText: data.contentText,
        attachmentUrl: data.attachmentUrl,
      },
    });

    // Update conversation timestamp
    await this.prisma.chatConversation.update({
      where: { id: data.conversationId },
      data: { updatedAt: new Date() },
    });

    return message;
  }
}

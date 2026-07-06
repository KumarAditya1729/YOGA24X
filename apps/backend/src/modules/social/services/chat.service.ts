import { Injectable } from '@nestjs/common';
import { ChatRepository } from '../repositories/chat.repository';
import { CreateChatConversationDto, SendChatMessageDto } from '../dto/social.dto';

@Injectable()
export class ChatService {
  constructor(private readonly chatRepo: ChatRepository) {}

  async createConversation(data: CreateChatConversationDto) {
    return this.chatRepo.createConversation(data);
  }

  async getConversations(userId: string) {
    return this.chatRepo.getConversations(userId);
  }

  async sendMessage(senderId: string, data: SendChatMessageDto) {
    return this.chatRepo.sendMessage(senderId, data);
  }
}

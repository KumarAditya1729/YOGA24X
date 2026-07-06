import {
  Controller,
  Get,
  Post,
  Body,
  UseGuards,
  Request,
} from "@nestjs/common";
import { ApiTags, ApiOperation, ApiBearerAuth } from "@nestjs/swagger";
import { JwtAuthGuard } from "../../auth/guards/jwt-auth.guard";
import { RequirePermissions } from "../../security/decorators/authorization.decorators";
import { PERMISSIONS } from "../../security/constants/permissions.registry";
import { ChatService } from "../services/chat.service";
import {
  CreateChatConversationDto,
  SendChatMessageDto,
} from "../dto/social.dto";

@ApiTags("Chat & Messaging")
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller("api/v1/chat")
export class ChatController {
  constructor(private readonly chatService: ChatService) {}

  @Post("conversations")
  @ApiOperation({ summary: "Create a new chat conversation" })
  @RequirePermissions(PERMISSIONS.CHAT_WRITE)
  async createConversation(@Body() data: CreateChatConversationDto) {
    return this.chatService.createConversation(data);
  }

  @Get("conversations")
  @ApiOperation({ summary: "Get user conversations" })
  @RequirePermissions(PERMISSIONS.CHAT_READ)
  async getConversations(@Request() req: any) {
    return this.chatService.getConversations(req.user.userId);
  }

  @Post("messages")
  @ApiOperation({ summary: "Send a chat message" })
  @RequirePermissions(PERMISSIONS.CHAT_WRITE)
  async sendMessage(@Request() req: any, @Body() data: SendChatMessageDto) {
    return this.chatService.sendMessage(req.user.userId, data);
  }
}

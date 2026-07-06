import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  MessageBody,
  ConnectedSocket,
  OnGatewayConnection,
  OnGatewayDisconnect,
} from "@nestjs/websockets";
import { Server, Socket } from "socket.io";
import { ChatService } from "../services/chat.service";

@WebSocketGateway({
  cors: {
    origin: "*",
  },
  namespace: "/chat",
})
export class ChatGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  constructor(private readonly chatService: ChatService) {}

  handleConnection(client: Socket) {
    console.log(`Client connected to Chat: ${client.id}`);
  }

  handleDisconnect(client: Socket) {
    console.log(`Client disconnected from Chat: ${client.id}`);
  }

  @SubscribeMessage("joinConversation")
  handleJoinConversation(
    @MessageBody() data: { conversationId: string },
    @ConnectedSocket() client: Socket,
  ) {
    client.join(data.conversationId);
    return { event: "joined", data: { conversationId: data.conversationId } };
  }

  @SubscribeMessage("typing")
  handleTyping(
    @MessageBody()
    data: { conversationId: string; userId: string; isTyping: boolean },
    @ConnectedSocket() client: Socket,
  ) {
    client.to(data.conversationId).emit("typingIndicator", {
      userId: data.userId,
      isTyping: data.isTyping,
    });
  }
}

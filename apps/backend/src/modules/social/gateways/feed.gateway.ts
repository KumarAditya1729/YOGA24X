import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  MessageBody,
  ConnectedSocket,
  OnGatewayConnection,
  OnGatewayDisconnect,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { FeedService } from '../services/feed.service';

@WebSocketGateway({
  cors: {
    origin: '*',
  },
  namespace: '/feed'
})
export class FeedGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  constructor(private readonly feedService: FeedService) {}

  handleConnection(client: Socket) {
    console.log(`Client connected to Feed: ${client.id}`);
  }

  handleDisconnect(client: Socket) {
    console.log(`Client disconnected from Feed: ${client.id}`);
  }

  @SubscribeMessage('subscribeFeed')
  handleSubscribeFeed(
    @MessageBody() data: { groupId?: string },
    @ConnectedSocket() client: Socket,
  ) {
    const room = data.groupId ? `feed:group:${data.groupId}` : 'feed:global';
    client.join(room);
    return { event: 'subscribed', data: { room } };
  }
}

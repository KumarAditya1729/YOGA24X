import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';
import { TicketStatus, TicketPriority } from '@prisma/client';

@Injectable()
export class SupportService {
  constructor(private readonly prisma: PrismaService) {}

  async createTicket(userId: string, subject: string, description: string, priority: TicketPriority) {
    return this.prisma.supportTicket.create({
      data: { userId, subject, description, priority, status: TicketStatus.OPEN },
    });
  }

  async assignTicket(ticketId: string, agentId: string) {
    return this.prisma.supportTicket.update({
      where: { id: ticketId },
      data: { assignedTo: agentId, status: TicketStatus.IN_PROGRESS },
    });
  }

  async addComment(ticketId: string, userId: string, content: string, isInternal = false) {
    return this.prisma.ticketComment.create({
      data: { ticketId, userId, content, isInternal },
    });
  }
}

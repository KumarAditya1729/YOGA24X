import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';
import { LeadStatus } from '@prisma/client';

@Injectable()
export class CrmService {
  constructor(private readonly prisma: PrismaService) {}

  async addLead(email: string, name: string, phone?: string, source?: string) {
    return this.prisma.crmLead.create({
      data: { email, name, phone, source, status: LeadStatus.NEW },
    });
  }

  async updateLeadStatus(id: string, status: LeadStatus) {
    return this.prisma.crmLead.update({
      where: { id },
      data: { status },
    });
  }

  async getLeads() {
    return this.prisma.crmLead.findMany({ orderBy: { createdAt: 'desc' } });
  }
}

import { Injectable, NotFoundException } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import {
  CreateTeacherSessionTypeDto,
  UpdateTeacherSessionTypeDto,
  CreateTeacherPricingRuleDto,
  CreateTeacherSessionDto,
} from "../dto/teacher-operations.dto";

@Injectable()
export class TeacherSessionRepository {
  constructor(private readonly prisma: PrismaService) {}

  // ── Session Types ────────────────────────────────────────────────────────────

  async getSessionTypes(userId: string) {
    return this.prisma.teacherSessionType.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
    });
  }

  async getActiveSessionTypes(userId: string) {
    return this.prisma.teacherSessionType.findMany({
      where: { userId, isActive: true },
      orderBy: { createdAt: "desc" },
    });
  }

  async createSessionType(userId: string, data: CreateTeacherSessionTypeDto) {
    return this.prisma.teacherSessionType.create({
      data: { ...data, userId },
    });
  }

  async updateSessionType(
    userId: string,
    id: string,
    data: UpdateTeacherSessionTypeDto,
  ) {
    const st = await this.prisma.teacherSessionType.findUnique({
      where: { id },
    });
    if (!st || st.userId !== userId)
      throw new NotFoundException("Session Type not found");
    return this.prisma.teacherSessionType.update({ where: { id }, data });
  }

  async deleteSessionType(userId: string, id: string) {
    const st = await this.prisma.teacherSessionType.findUnique({
      where: { id },
    });
    if (!st || st.userId !== userId)
      throw new NotFoundException("Session Type not found");
    return this.prisma.teacherSessionType.delete({ where: { id } });
  }

  // ── Pricing Rules ────────────────────────────────────────────────────────────

  async getPricingRules(userId: string) {
    return this.prisma.teacherPricingRule.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
    });
  }

  async createPricingRule(userId: string, data: CreateTeacherPricingRuleDto) {
    return this.prisma.teacherPricingRule.create({
      data: { ...data, userId },
    });
  }

  async deletePricingRule(userId: string, id: string) {
    const pr = await this.prisma.teacherPricingRule.findUnique({
      where: { id },
    });
    if (!pr || pr.userId !== userId)
      throw new NotFoundException("Pricing Rule not found");
    return this.prisma.teacherPricingRule.delete({ where: { id } });
  }

  // ── Sessions & Scheduling ────────────────────────────────────────────────────

  async getSessions(userId: string, from?: Date, to?: Date) {
    return this.prisma.teacherSession.findMany({
      where: {
        teacherUserId: userId,
        ...(from && to
          ? { startTime: { gte: from }, endTime: { lte: to } }
          : {}),
      },
      include: {
        sessionType: true,
      },
      orderBy: { startTime: "asc" },
    });
  }

  async createSession(userId: string, data: CreateTeacherSessionDto) {
    return this.prisma.teacherSession.create({
      data: {
        teacherUserId: userId,
        sessionTypeId: data.sessionTypeId,
        title: data.title,
        startTime: new Date(data.startTime),
        endTime: new Date(data.endTime),
        maxParticipants: data.maxParticipants ?? 1,
        meetingUrl: data.meetingUrl,
      },
    });
  }

  async deleteSession(userId: string, id: string) {
    const sess = await this.prisma.teacherSession.findUnique({ where: { id } });
    if (!sess || sess.teacherUserId !== userId)
      throw new NotFoundException("Session not found");
    return this.prisma.teacherSession.delete({ where: { id } });
  }
}

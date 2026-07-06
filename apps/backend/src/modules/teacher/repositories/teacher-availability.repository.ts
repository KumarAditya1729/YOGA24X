import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';
import {
  UpdateTeacherBookingRuleDto,
  CreateTeacherHolidayDto,
} from '../dto/teacher-operations.dto';

@Injectable()
export class TeacherAvailabilityRepository {
  constructor(private readonly prisma: PrismaService) {}

  async getBookingRule(userId: string) {
    let rule = await this.prisma.teacherBookingRule.findUnique({ where: { userId } });
    if (!rule) {
      // create default
      rule = await this.prisma.teacherBookingRule.create({ data: { userId } });
    }
    return rule;
  }

  async updateBookingRule(userId: string, data: UpdateTeacherBookingRuleDto) {
    return this.prisma.teacherBookingRule.upsert({
      where: { userId },
      update: data,
      create: { userId, ...data },
    });
  }

  async getHolidays(userId: string) {
    return this.prisma.teacherHoliday.findMany({
      where: { userId },
      orderBy: { startDate: 'asc' },
    });
  }

  async createHoliday(userId: string, data: CreateTeacherHolidayDto) {
    return this.prisma.teacherHoliday.create({
      data: {
        userId,
        startDate: new Date(data.startDate),
        endDate: new Date(data.endDate),
        reason: data.reason,
        isEmergency: data.isEmergency ?? false,
      },
    });
  }

  async deleteHoliday(userId: string, id: string) {
    const holiday = await this.prisma.teacherHoliday.findUnique({ where: { id } });
    if (!holiday || holiday.userId !== userId) {
      throw new NotFoundException('Holiday not found');
    }
    return this.prisma.teacherHoliday.delete({ where: { id } });
  }
}

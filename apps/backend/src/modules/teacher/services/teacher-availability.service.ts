import { Injectable } from '@nestjs/common';
import { TeacherAvailabilityRepository } from '../repositories/teacher-availability.repository';
import {
  UpdateTeacherBookingRuleDto, CreateTeacherHolidayDto,
} from '../dto/teacher-operations.dto';

@Injectable()
export class TeacherAvailabilityService {
  constructor(private readonly availabilityRepo: TeacherAvailabilityRepository) {}

  async getBookingRule(userId: string) {
    return this.availabilityRepo.getBookingRule(userId);
  }

  async updateBookingRule(userId: string, data: UpdateTeacherBookingRuleDto) {
    return this.availabilityRepo.updateBookingRule(userId, data);
  }

  async getHolidays(userId: string) {
    return this.availabilityRepo.getHolidays(userId);
  }

  async createHoliday(userId: string, data: CreateTeacherHolidayDto) {
    return this.availabilityRepo.createHoliday(userId, data);
  }

  async deleteHoliday(userId: string, id: string) {
    return this.availabilityRepo.deleteHoliday(userId, id);
  }
}

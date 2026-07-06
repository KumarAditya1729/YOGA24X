import { Injectable } from '@nestjs/common';
import { TeacherSessionRepository } from '../repositories/teacher-session.repository';
import {
  CreateTeacherSessionTypeDto, UpdateTeacherSessionTypeDto,
  CreateTeacherPricingRuleDto, CreateTeacherSessionDto,
} from '../dto/teacher-operations.dto';

@Injectable()
export class TeacherSessionService {
  constructor(private readonly sessionRepo: TeacherSessionRepository) {}

  // ── Session Types ────────────────────────────────────────────────────────────
  async getSessionTypes(userId: string) {
    return this.sessionRepo.getSessionTypes(userId);
  }

  async getActiveSessionTypes(userId: string) {
    return this.sessionRepo.getActiveSessionTypes(userId);
  }

  async createSessionType(userId: string, data: CreateTeacherSessionTypeDto) {
    return this.sessionRepo.createSessionType(userId, data);
  }

  async updateSessionType(userId: string, id: string, data: UpdateTeacherSessionTypeDto) {
    return this.sessionRepo.updateSessionType(userId, id, data);
  }

  async deleteSessionType(userId: string, id: string) {
    return this.sessionRepo.deleteSessionType(userId, id);
  }

  // ── Pricing Rules ────────────────────────────────────────────────────────────
  async getPricingRules(userId: string) {
    return this.sessionRepo.getPricingRules(userId);
  }

  async createPricingRule(userId: string, data: CreateTeacherPricingRuleDto) {
    return this.sessionRepo.createPricingRule(userId, data);
  }

  async deletePricingRule(userId: string, id: string) {
    return this.sessionRepo.deletePricingRule(userId, id);
  }

  // ── Sessions & Scheduling ────────────────────────────────────────────────────
  async getSessions(userId: string, from?: Date, to?: Date) {
    return this.sessionRepo.getSessions(userId, from, to);
  }

  async createSession(userId: string, data: CreateTeacherSessionDto) {
    return this.sessionRepo.createSession(userId, data);
  }

  async deleteSession(userId: string, id: string) {
    return this.sessionRepo.deleteSession(userId, id);
  }
}

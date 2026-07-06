import { Injectable } from '@nestjs/common';
import { AnalyticsRepository } from '../repositories/analytics.repository';

@Injectable()
export class CommerceAnalyticsService {
  constructor(private readonly analyticsRepo: AnalyticsRepository) {}

  getRevenueSummary(startDate: Date, endDate: Date) { return this.analyticsRepo.getRevenueSummary(startDate, endDate); }
  getMRR() { return this.analyticsRepo.getMRR(); }
  getARR() { return this.analyticsRepo.getARR(); }
  getARPU() { return this.analyticsRepo.getARPU(); }
  getConversionFunnel() { return this.analyticsRepo.getConversionFunnel(); }
  getActiveSubscriptions() { return this.analyticsRepo.getActiveSubscriptions(); }
  getActiveMemberships() { return this.analyticsRepo.getActiveMemberships(); }
  getTeacherEarnings(teacherId: string, startDate: Date, endDate: Date) {
    return this.analyticsRepo.getTeacherEarnings(teacherId, startDate, endDate);
  }
}

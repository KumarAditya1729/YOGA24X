// ==============================================================================
// Yoga24X AI Engineering OS — PII Health Masking Interceptor
// Masks Sensitive Medical History & Emergency Contact Details for Non-Owners
// ==============================================================================

import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

@Injectable()
export class PiiHealthMaskingInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const req = context.switchToHttp().getRequest();
    const currentUser = req.user;

    return next.handle().pipe(
      map(data => {
        if (!data) return data;
        return this.maskHealthData(data, currentUser);
      }),
    );
  }

  private maskHealthData(data: any, currentUser: any): any {
    if (Array.isArray(data)) {
      return data.map(item => this.maskHealthData(item, currentUser));
    }

    if (typeof data !== 'object' || data === null) {
      return data;
    }

    const masked = { ...data };

    // Check if current user is owner or admin/doctor
    const isOwner = currentUser && (currentUser.id === masked.userId || currentUser.sub === masked.userId);
    const isDoctorOrAdmin =
      currentUser &&
      currentUser.roles &&
      (currentUser.roles.includes('SUPER_ADMIN') ||
        currentUser.roles.includes('ADMIN') ||
        currentUser.roles.includes('DOCTOR'));

    if (!isOwner && !isDoctorOrAdmin) {
      if (masked.emergencyContactPhone) {
        masked.emergencyContactPhone = masked.emergencyContactPhone.replace(/.(?=.{4})/g, '*');
      }
      if (masked.medicalHistoryJson && Array.isArray(masked.medicalHistoryJson)) {
        masked.medicalHistoryJson = masked.medicalHistoryJson.map((item: any) => ({
          ...item,
          condition: '[[CONFIDENTIAL MEDICAL RECORD]]',
          notes: undefined,
        }));
      }
      if (masked.surgeriesJson && Array.isArray(masked.surgeriesJson)) {
        masked.surgeriesJson = masked.surgeriesJson.map((item: any) => ({
          ...item,
          procedure: '[[CONFIDENTIAL SURGICAL RECORD]]',
          recoveryNotes: undefined,
        }));
      }
    }

    return masked;
  }
}

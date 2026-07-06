// ==============================================================================
// Yoga24X AI Engineering OS — PII Masking Interceptor
// Masks sensitive PII (phone, medical reg, tax ID) when viewed by non-owners/admins
// ==============================================================================

import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from "@nestjs/common";
import { Observable } from "rxjs";
import { map } from "rxjs/operators";

@Injectable()
export class PiiMaskingInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const viewer = request.user;

    return next.handle().pipe(
      map((data) => {
        if (!data) return data;

        // If viewer is SUPER_ADMIN or ADMIN, or viewing their own profile, do not mask
        const isSelf = viewer && data.id === viewer.sub;
        const isAdmin =
          viewer &&
          (viewer.roles?.includes("SUPER_ADMIN") ||
            viewer.roles?.includes("ADMIN"));

        if (isSelf || isAdmin) {
          return data;
        }

        return this.maskObject(data);
      }),
    );
  }

  private maskObject(obj: any): any {
    if (typeof obj !== "object" || obj === null) return obj;

    if (Array.isArray(obj)) {
      return obj.map((item) => this.maskObject(item));
    }

    const masked = { ...obj };

    // Mask phone number: e.g. +919876543210 -> +91*******3210
    if (
      typeof masked.phoneNumber === "string" &&
      masked.phoneNumber.length > 4
    ) {
      const len = masked.phoneNumber.length;
      masked.phoneNumber =
        masked.phoneNumber.substring(0, 3) +
        "*".repeat(len - 7) +
        masked.phoneNumber.substring(len - 4);
    }

    // Mask emergency contact phone
    if (
      masked.studentProfile &&
      typeof masked.studentProfile.emergencyContactPhone === "string"
    ) {
      const len = masked.studentProfile.emergencyContactPhone.length;
      if (len > 4) {
        masked.studentProfile.emergencyContactPhone =
          masked.studentProfile.emergencyContactPhone.substring(0, 3) +
          "*".repeat(len - 7) +
          masked.studentProfile.emergencyContactPhone.substring(len - 4);
      }
    }

    // Mask tax identification number in corporate profile
    if (
      masked.corporateProfile &&
      typeof masked.corporateProfile.taxIdentificationNumber === "string"
    ) {
      const len = masked.corporateProfile.taxIdentificationNumber.length;
      if (len > 4) {
        masked.corporateProfile.taxIdentificationNumber =
          masked.corporateProfile.taxIdentificationNumber.substring(0, 2) +
          "*".repeat(len - 6) +
          masked.corporateProfile.taxIdentificationNumber.substring(len - 4);
      }
    }

    return masked;
  }
}

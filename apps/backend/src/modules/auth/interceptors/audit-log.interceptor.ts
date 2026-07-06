// ==============================================================================
// Yoga24X AI Engineering OS — Audit Log Interceptor (Security Audit Persistence)
// ==============================================================================

import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { AuthRepository } from '../repositories/auth.repository';

@Injectable()
export class AuditLogInterceptor implements NestInterceptor {
  constructor(private readonly authRepository: AuthRepository) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const user = request.user;
    const method = request.method;
    const url = request.url;
    const ipAddress = request.headers['x-forwarded-for'] || request.socket?.remoteAddress || '127.0.0.1';

    // Only audit mutating auth actions
    if (method === 'GET') {
      return next.handle();
    }

    const startTime = Date.now();

    return next.handle().pipe(
      tap(async (responseBody) => {
        try {
          const actionName = `API_${method}_${url.replace(/\//g, '_').toUpperCase()}`;
          await this.authRepository.createAuditLog({
            actorId: user?.sub || null,
            action: actionName.substring(0, 100),
            entityType: 'API_ENDPOINT',
            entityId: user?.sub || '00000000-0000-0000-0000-000000000000',
            newValuesJson: {
              status: 'SUCCESS',
              durationMs: Date.now() - startTime,
              method,
              url,
            },
            ipAddress,
          });
        } catch (err) {
          console.error('⚠️ Failed to persist audit log:', err);
        }
      }),
    );
  }
}

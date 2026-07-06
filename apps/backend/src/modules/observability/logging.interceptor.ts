// ==============================================================================
// Yoga24X — Structured JSON Logging Interceptor
// Emits: trace ID, correlation ID, method, url, status, duration, userId
// ==============================================================================

import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  Logger,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap, catchError } from 'rxjs/operators';
import { throwError } from 'rxjs';
import { randomUUID } from 'crypto';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  private readonly logger = new Logger('HTTP');

  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    const req = context.switchToHttp().getRequest();
    const res = context.switchToHttp().getResponse();

    // Generate trace / correlation IDs
    const traceId = (req.headers['x-trace-id'] as string) || randomUUID();
    const correlationId = (req.headers['x-correlation-id'] as string) || randomUUID();

    // Attach to request for downstream use
    req.traceId = traceId;
    req.correlationId = correlationId;

    // Propagate to response headers
    res.setHeader('X-Trace-ID', traceId);
    res.setHeader('X-Correlation-ID', correlationId);

    const { method, url, ip } = req;
    const userAgent = req.headers['user-agent'] || '';
    const userId = (req.user as { id?: string } | undefined)?.id ?? 'anonymous';
    const startTime = Date.now();

    return next.handle().pipe(
      tap(() => {
        const statusCode = res.statusCode;
        const duration = Date.now() - startTime;

        this.logger.log(
          JSON.stringify({
            level: 'info',
            event: 'http_request',
            traceId,
            correlationId,
            method,
            url,
            statusCode,
            duration,
            ip,
            userAgent,
            userId,
            timestamp: new Date().toISOString(),
          }),
        );
      }),
      catchError((err) => {
        const duration = Date.now() - startTime;
        const statusCode = err.status || 500;

        this.logger.error(
          JSON.stringify({
            level: 'error',
            event: 'http_error',
            traceId,
            correlationId,
            method,
            url,
            statusCode,
            duration,
            ip,
            userId,
            errorMessage: err.message,
            errorType: err.constructor?.name,
            timestamp: new Date().toISOString(),
          }),
        );
        return throwError(() => err);
      }),
    );
  }
}

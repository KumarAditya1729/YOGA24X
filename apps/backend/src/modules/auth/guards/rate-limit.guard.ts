// ==============================================================================
// Yoga24X AI Engineering OS — Rate Limit Guard (Sliding Window Redis Lua)
// ==============================================================================

import {
  Injectable,
  CanActivate,
  ExecutionContext,
  HttpException,
  HttpStatus,
} from "@nestjs/common";
import { Reflector } from "@nestjs/core";
import { RedisService } from "../../redis/redis.module";

export const RATE_LIMIT_KEY = "rate_limit";
export const RateLimit =
  (limit = 20, windowSeconds = 60) =>
  (target: any, key?: string | symbol, descriptor?: PropertyDescriptor) => {
    Reflector.createDecorator<{ limit: number; windowSeconds: number }>()({
      limit,
      windowSeconds,
    })(target, key as any, descriptor as any);
  };

@Injectable()
export class RateLimitGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly redisService: RedisService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const config = this.reflector.getAllAndOverride<{
      limit: number;
      windowSeconds: number;
    }>(RATE_LIMIT_KEY, [context.getHandler(), context.getClass()]) || {
      limit: 100,
      windowSeconds: 60,
    };

    const request = context.switchToHttp().getRequest();
    const response = context.switchToHttp().getResponse();
    const ip =
      request.headers["x-forwarded-for"] ||
      request.socket?.remoteAddress ||
      "127.0.0.1";
    const route = request.route?.path || request.url;
    const key = `rl:${route}:${ip}`;

    const res = await this.redisService.checkRateLimit(
      key,
      config.limit,
      config.windowSeconds,
    );

    if (response && response.setHeader) {
      response.setHeader("X-RateLimit-Limit", config.limit);
      response.setHeader("X-RateLimit-Remaining", Math.max(0, res.remaining));
      response.setHeader("X-RateLimit-Reset", res.resetInSeconds);
    }

    if (!res.allowed) {
      throw new HttpException(
        {
          statusCode: HttpStatus.TOO_MANY_REQUESTS,
          error: "Too Many Requests",
          message: `Rate limit exceeded for route ${route}. Try again in ${res.resetInSeconds} seconds.`,
          retryAfter: res.resetInSeconds,
        },
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }

    return true;
  }
}

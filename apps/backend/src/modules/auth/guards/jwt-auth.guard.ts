// ==============================================================================
// Yoga24X AI Engineering OS — JWT Auth Guard (with JTI Blacklist & Account Lock check)
// ==============================================================================

import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
  ForbiddenException,
} from "@nestjs/common";
import { Reflector } from "@nestjs/core";
import { JwtService } from "@nestjs/jwt";
import { IS_PUBLIC_KEY } from "../decorators/auth.decorators";
import { TokenService } from "../services/token.service";
import { RedisService } from "../../redis/redis.module";
import { AUTH_CONSTANTS, JwtAccessPayload } from "@yoga24x/shared-types";

@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly jwtService: JwtService,
    private readonly tokenService: TokenService,
    private readonly redisService: RedisService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (isPublic) {
      return true;
    }

    const request = context.switchToHttp().getRequest();
    const token = this.extractTokenFromHeaderOrCookie(request);

    if (!token) {
      throw new UnauthorizedException("Authentication token missing");
    }

    try {
      const payload = await this.jwtService.verifyAsync<JwtAccessPayload>(
        token,
        {
          secret:
            process.env.JWT_ACCESS_SECRET ||
            "yoga24x-enterprise-access-secret-key-2026",
        },
      );

      // 1. Check if JTI is explicitly blacklisted in Redis (Instant Revocation)
      const isRevoked = await this.tokenService.isAccessTokenRevoked(
        payload.jti,
      );
      if (isRevoked) {
        throw new UnauthorizedException("Access token has been revoked");
      }

      // 2. Check if user account is locked in Redis
      const lockKey = `${AUTH_CONSTANTS.REDIS_KEY_ACCOUNT_LOCK_PREFIX}${payload.sub}`;
      const isLocked = await this.redisService.exists(lockKey);
      if (isLocked) {
        throw new ForbiddenException(
          "Account temporarily locked due to security alerts",
        );
      }

      // Attach user payload to request
      request.user = payload;
      return true;
    } catch (err: any) {
      if (
        err instanceof ForbiddenException ||
        err instanceof UnauthorizedException
      ) {
        throw err;
      }
      throw new UnauthorizedException("Invalid or expired access token");
    }
  }

  private extractTokenFromHeaderOrCookie(request: any): string | undefined {
    // 1. Check Authorization Bearer header
    const [type, token] = request.headers.authorization?.split(" ") ?? [];
    if (type === "Bearer" && token) {
      return token;
    }
    // 2. Check HTTP-Only Cookie
    if (
      request.cookies &&
      request.cookies[AUTH_CONSTANTS.COOKIE_ACCESS_TOKEN]
    ) {
      return request.cookies[AUTH_CONSTANTS.COOKIE_ACCESS_TOKEN];
    }
    return undefined;
  }
}

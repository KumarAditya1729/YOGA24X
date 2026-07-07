// ==============================================================================
// Yoga24X AI Engineering OS — Auth Module Definition
// ==============================================================================

import { Module, Global } from "@nestjs/common";
import { JwtModule } from "@nestjs/jwt";
import { ConfigModule, ConfigService } from "@nestjs/config";
import { PrismaModule } from "../prisma/prisma.module";
import { RedisModule } from "../redis/redis.module";
import { AuthRepository } from "./repositories/auth.repository";
import { TokenService } from "./services/token.service";
import { OtpService } from "./services/otp.service";
import { OAuthService } from "./services/oauth.service";
import { SessionService } from "./services/session.service";
import { RiskService } from "./services/risk.service";
import { AuthService } from "./services/auth.service";

@Global()
@Module({
  imports: [
    PrismaModule,
    RedisModule,
    ConfigModule,
    JwtModule.registerAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        secret:
          config.get<string>("JWT_ACCESS_SECRET") ||
          "yoga24x-enterprise-access-secret-key-2026",
        signOptions: {
          algorithm: "HS256", // In production cluster with asymmetric keys, configure RS256/ES256
          issuer: "https://auth.yoga24x.com",
          audience: "https://api.yoga24x.com",
        },
      }),
    }),
  ],
  providers: [
    AuthRepository,
    TokenService,
    OtpService,
    OAuthService,
    SessionService,
    RiskService,
    AuthService,
  ],
  exports: [
    AuthService,
    TokenService,
    OtpService,
    SessionService,
    RiskService,
    AuthRepository,
    JwtModule,
  ],
})
export class AuthModule {}

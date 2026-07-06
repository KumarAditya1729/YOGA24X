// ==============================================================================
// Yoga24X AI Engineering OS — Redis Module & Service (ioredis + Lua Scripts)
// ==============================================================================

import {
  Injectable,
  OnModuleInit,
  OnModuleDestroy,
  Module,
  Global,
} from "@nestjs/common";
import Redis from "ioredis";
import { AUTH_CONSTANTS } from "@yoga24x/shared-types";

@Injectable()
export class RedisService implements OnModuleInit, OnModuleDestroy {
  private redisClient!: Redis;

  async onModuleInit() {
    const redisUrl = process.env.REDIS_URL || "redis://localhost:6379/0";
    this.redisClient = new Redis(redisUrl, {
      maxRetriesPerRequest: 3,
      retryStrategy(times) {
        return Math.min(times * 50, 2000);
      },
    });

    this.redisClient.on("error", (err) => {
      console.error("❌ Redis Connection Error:", err.message);
    });
  }

  async onModuleDestroy() {
    if (this.redisClient) {
      await this.redisClient.quit();
    }
  }

  getClient(): Redis {
    return this.redisClient;
  }

  // ============================================================================
  // Basic Key-Value Storage
  // ============================================================================

  async set(key: string, value: string, ttlSeconds?: number): Promise<void> {
    if (ttlSeconds && ttlSeconds > 0) {
      await this.redisClient.set(key, value, "EX", ttlSeconds);
    } else {
      await this.redisClient.set(key, value);
    }
  }

  async get(key: string): Promise<string | null> {
    return this.redisClient.get(key);
  }

  async del(key: string): Promise<number> {
    return this.redisClient.del(key);
  }

  async exists(key: string): Promise<boolean> {
    const count = await this.redisClient.exists(key);
    return count > 0;
  }

  // ============================================================================
  // Sliding Window Rate Limiter (Lua Script for Atomic Evaluation)
  // ============================================================================

  async checkRateLimit(
    key: string,
    limit: number,
    windowSeconds: number,
  ): Promise<{ allowed: boolean; remaining: number; resetInSeconds: number }> {
    const now = Date.now();
    const clearBefore = now - windowSeconds * 1000;
    const redisKey = `${AUTH_CONSTANTS.REDIS_KEY_RATE_LIMIT_PREFIX}${key}`;

    const luaScript = `
      redis.call('ZREMRANGEBYSCORE', KEYS[1], 0, ARGV[1])
      local currentCount = redis.call('ZCARD', KEYS[1])
      if currentCount < tonumber(ARGV[2]) then
        redis.call('ZADD', KEYS[1], ARGV[3], ARGV[3])
        redis.call('EXPIRE', KEYS[1], tonumber(ARGV[4]))
        return { 1, tonumber(ARGV[2]) - currentCount - 1 }
      else
        return { 0, 0 }
      end
    `;

    const result = (await this.redisClient.eval(
      luaScript,
      1,
      redisKey,
      clearBefore.toString(),
      limit.toString(),
      now.toString(),
      windowSeconds.toString(),
    )) as [number, number];

    const allowed = result[0] === 1;
    const remaining = result[1];
    return {
      allowed,
      remaining,
      resetInSeconds: windowSeconds,
    };
  }

  // ============================================================================
  // Distributed Locking (Redis Lock with Auto-Release TTL)
  // ============================================================================

  async acquireLock(
    resourceKey: string,
    ttlSeconds = 10,
  ): Promise<string | null> {
    const lockKey = `${AUTH_CONSTANTS.REDIS_KEY_DISTRIBUTED_LOCK_PREFIX}${resourceKey}`;
    const token = Math.random().toString(36).substring(2, 15);
    const acquired = await this.redisClient.set(
      lockKey,
      token,
      "EX",
      ttlSeconds,
      "NX",
    );
    return acquired === "OK" ? token : null;
  }

  async releaseLock(resourceKey: string, token: string): Promise<boolean> {
    const lockKey = `${AUTH_CONSTANTS.REDIS_KEY_DISTRIBUTED_LOCK_PREFIX}${resourceKey}`;
    const luaScript = `
      if redis.call('GET', KEYS[1]) == ARGV[1] then
        return redis.call('DEL', KEYS[1])
      else
        return 0
      end
    `;
    const res = await this.redisClient.eval(luaScript, 1, lockKey, token);
    return res === 1;
  }

  // ============================================================================
  // Refresh Token Family Storage & Theft Detection
  // ============================================================================

  async storeRefreshFamily(
    familyId: string,
    currentTokenHash: string,
    userId: string,
    ttlSeconds: number,
  ): Promise<void> {
    const key = `${AUTH_CONSTANTS.REDIS_KEY_REFRESH_FAMILY_PREFIX}${familyId}`;
    await this.redisClient.hset(key, {
      userId,
      currentTokenHash,
      status: "ACTIVE",
      updatedAt: new Date().toISOString(),
    });
    await this.redisClient.expire(key, ttlSeconds);
  }

  async getRefreshFamily(
    familyId: string,
  ): Promise<{
    userId: string;
    currentTokenHash: string;
    status: string;
  } | null> {
    const key = `${AUTH_CONSTANTS.REDIS_KEY_REFRESH_FAMILY_PREFIX}${familyId}`;
    const data = await this.redisClient.hgetall(key);
    if (!data || !data.userId) return null;
    return {
      userId: data.userId,
      currentTokenHash: data.currentTokenHash,
      status: data.status,
    };
  }

  async revokeRefreshFamily(familyId: string): Promise<void> {
    const key = `${AUTH_CONSTANTS.REDIS_KEY_REFRESH_FAMILY_PREFIX}${familyId}`;
    await this.redisClient.hset(key, "status", "REVOKED");
  }

  // ============================================================================
  // JWT Blacklist (Instant JTI Revocation)
  // ============================================================================

  async blacklistJti(jti: string, ttlSeconds: number): Promise<void> {
    const key = `${AUTH_CONSTANTS.REDIS_KEY_JTI_BLACKLIST_PREFIX}${jti}`;
    await this.set(key, "REVOKED", ttlSeconds);
  }

  async isJtiBlacklisted(jti: string): Promise<boolean> {
    const key = `${AUTH_CONSTANTS.REDIS_KEY_JTI_BLACKLIST_PREFIX}${jti}`;
    return this.exists(key);
  }

  // ============================================================================
  // Security Platform Helpers
  // ============================================================================

  /** Set key with expiry (alias matching ioredis SETEX signature) */
  async setex(key: string, ttlSeconds: number, value: string): Promise<void> {
    await this.redisClient.set(key, value, "EX", ttlSeconds);
  }

  /** Atomic increment (returns new value) */
  async incr(key: string): Promise<number> {
    return this.redisClient.incr(key);
  }

  /** Set TTL on an existing key */
  async expire(key: string, ttlSeconds: number): Promise<void> {
    await this.redisClient.expire(key, ttlSeconds);
  }
}

@Global()
@Module({
  providers: [RedisService],
  exports: [RedisService],
})
export class RedisModule {}

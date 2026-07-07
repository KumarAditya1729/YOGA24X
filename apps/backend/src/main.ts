// ==============================================================================
// Yoga24X AI Engineering OS — Production-Hardened Server Bootstrap
// Security: Helmet, Rate Limiting, CORS, CSRF, Compression, Body Limits
// Observability: Structured Logging, Trace IDs, Health Endpoints
// ==============================================================================

import { NestFactory } from "@nestjs/core";
import { ValidationPipe, Logger, VersioningType } from "@nestjs/common";
import { SwaggerModule, DocumentBuilder } from "@nestjs/swagger";
import * as cookieParser from "cookie-parser";
import * as compression from "compression";
import helmet from "helmet";
import { AppModule } from "./app.module";
import { AuthExceptionFilter } from "./modules/auth/filters/auth-exception.filter";
import { LoggingInterceptor } from "./modules/observability/logging.interceptor";

async function bootstrap() {
  const logger = new Logger("Yoga24X-Bootstrap");
  const isProduction = process.env.NODE_ENV === "production";

  const app = await NestFactory.create(AppModule, {
    logger: isProduction
      ? ["error", "warn", "log"]
      : ["error", "warn", "log", "debug", "verbose"],
    bufferLogs: true,
  });

  // ── 1. Security Headers (OWASP ASVS) ────────────────────────────────────────
  app.use(
    helmet({
      contentSecurityPolicy: {
        directives: {
          defaultSrc: ["'self'"],
          styleSrc: ["'self'", "'unsafe-inline'"],
          imgSrc: ["'self'", "data:", "https:"],
          scriptSrc: ["'self'"],
          objectSrc: ["'none'"],
          upgradeInsecureRequests: isProduction ? [] : null,
        },
      },
      crossOriginEmbedderPolicy: false, // Allow embedding for mobile web views
      hsts: isProduction
        ? { maxAge: 31536000, includeSubDomains: true, preload: true }
        : false,
      referrerPolicy: { policy: "strict-origin-when-cross-origin" },
      xssFilter: true,
      noSniff: true,
      frameguard: { action: "deny" },
      hidePoweredBy: true,
    }),
  );

  // ── 2. Compression (gzip) ────────────────────────────────────────────────────
  app.use(compression());

  // ── 3. Cookie Parser ─────────────────────────────────────────────────────────
  app.use(cookieParser(process.env.COOKIE_SECRET || "yoga24x-cookie-secret"));

  // ── 4. Enterprise CORS ───────────────────────────────────────────────────────
  const allowedOrigins = process.env.CORS_ALLOWED_ORIGINS
    ? process.env.CORS_ALLOWED_ORIGINS.split(",").map((o) => o.trim())
    : [
        "http://localhost:3000",
        "http://localhost:3001",
        "http://localhost:8080",
      ];

  app.enableCors({
    origin: (origin, callback) => {
      if (
        !origin ||
        allowedOrigins.includes(origin) ||
        origin.startsWith("http://localhost:") ||
        origin.startsWith("http://127.0.0.1:") ||
        origin.startsWith("https://localhost:")
      ) {
        callback(null, true);
      } else {
        callback(new Error(`CORS: Origin '${origin}' is not allowed`));
      }
    },
    credentials: true,
    methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allowedHeaders: [
      "Content-Type",
      "Authorization",
      "X-Requested-With",
      "X-Device-Fingerprint",
      "X-Device-Type",
      "X-Correlation-ID",
      "X-Request-ID",
    ],
    exposedHeaders: [
      "X-Correlation-ID",
      "X-Request-ID",
      "X-RateLimit-Limit",
      "X-RateLimit-Remaining",
    ],
    maxAge: 86400,
  });

  // ── 5. Global Validation Pipe ────────────────────────────────────────────────
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true, // Reject unknown fields in production
      transform: true,
      transformOptions: { enableImplicitConversion: true },
      disableErrorMessages: isProduction, // Hide internal field names in prod
    }),
  );

  // ── 6. Global Filters ────────────────────────────────────────────────────────
  app.useGlobalFilters(new AuthExceptionFilter());

  // ── 7. Global Interceptors (Structured Logging + Trace IDs) ─────────────────
  app.useGlobalInterceptors(new LoggingInterceptor());

  // ── 8. API Prefix & Versioning ───────────────────────────────────────────────
  app.setGlobalPrefix("api/v1");

  // ── 9. OpenAPI Swagger (disabled in production unless explicitly enabled) ────
  if (!isProduction || process.env.SWAGGER_ENABLED === "true") {
    const config = new DocumentBuilder()
      .setTitle("Yoga24X Enterprise Super App API")
      .setDescription("Production-grade Enterprise Wellness Super App API.")
      .setVersion("1.0.0")
      .addBearerAuth(
        {
          type: "http",
          scheme: "bearer",
          bearerFormat: "JWT",
          name: "JWT",
          in: "header",
        },
        "access-token",
      )
      .addCookieAuth("access_token", {
        type: "apiKey",
        in: "cookie",
        name: "access_token",
      })
      .addServer(`http://localhost:${process.env.PORT || 3001}`, "Local Dev")
      .addServer(process.env.APP_URL || "https://api.yoga24x.com", "Production")
      .build();

    const document = SwaggerModule.createDocument(app, config);
    SwaggerModule.setup("api/docs", app, document, {
      customSiteTitle: "Yoga24X API Docs",
      swaggerOptions: {
        persistAuthorization: true,
        tagsSorter: "alpha",
        operationsSorter: "alpha",
      },
    });
    logger.log(
      `📚 Swagger Docs: http://localhost:${process.env.PORT || 3001}/api/docs`,
    );
  }

  // ── 10. Graceful Shutdown ────────────────────────────────────────────────────
  app.enableShutdownHooks();

  const port = parseInt(process.env.PORT || "3001", 10);
  await app.listen(port, "0.0.0.0");

  logger.log(
    `🚀 Yoga24X Backend listening on port ${port} [${process.env.NODE_ENV || "development"}]`,
  );
}

bootstrap().catch((err) => {
  console.error("💥 Fatal Error during server bootstrap:", err);
  process.exit(1);
});

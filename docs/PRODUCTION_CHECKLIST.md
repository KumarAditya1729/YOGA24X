# Yoga24X Production Launch Checklist

## How to Use
Work through each section in order before launch. Check off every item. Any unchecked item is a launch blocker.

---

## ✅ Infrastructure

- [ ] PostgreSQL: production instance provisioned (not shared/dev)
- [ ] PostgreSQL: automated backups configured (daily, 30-day retention)
- [ ] PostgreSQL: connection pooling configured (PgBouncer or Prisma pool)
- [ ] Redis: password authentication enabled
- [ ] Redis: maxmemory and eviction policy set (`allkeys-lru`)
- [ ] Redis: persistence enabled (AOF)
- [ ] Kubernetes: cluster provisioned with ≥ 3 nodes
- [ ] Kubernetes: namespace, RBAC, and network policies applied
- [ ] Domain: `api.yoga24x.com` DNS record pointing to load balancer
- [ ] TLS: Let's Encrypt cert issued and auto-renewing (cert-manager)
- [ ] Object Storage: S3 bucket created with versioning and lifecycle policies

## ✅ Security

- [ ] All `.env` CHANGE_ME values replaced with real secrets
- [ ] JWT secrets are ≥ 64 random characters (not dictionary words)
- [ ] Database password ≥ 32 random characters
- [ ] Redis password ≥ 24 random characters
- [ ] CORS_ALLOWED_ORIGINS set to production domains only
- [ ] SWAGGER_ENABLED=false in production
- [ ] `pnpm audit --audit-level high` shows 0 critical/high vulnerabilities
- [ ] Dockerfile: runs as non-root user (UID 1001) ✅
- [ ] Kubernetes: securityContext with runAsNonRoot: true ✅
- [ ] Rate limiting: ThrottlerGuard active ✅
- [ ] Helmet security headers applied ✅
- [ ] HTTP → HTTPS redirect enforced at Ingress level

## ✅ Backend

- [ ] `nest build` compiles with 0 errors ✅
- [ ] All unit tests pass (43/43) ✅
- [ ] `GET /health` returns 200 with status: ok ✅
- [ ] `GET /ready` returns 200 with all dependencies healthy
- [ ] `POST /api/v1/auth/register` successfully creates a user
- [ ] `POST /api/v1/auth/login` returns access + refresh tokens
- [ ] JWT access token correctly expires after 15 minutes
- [ ] Rate limiting returns 429 after threshold is exceeded
- [ ] Security headers present in all responses (Helmet) ✅
- [ ] X-Trace-ID and X-Correlation-ID present in all responses ✅

## ✅ Database

- [ ] All Prisma migrations applied (`prisma migrate deploy`)
- [ ] Database indexes validated for performance-critical queries
- [ ] No tables with missing indexes on foreign keys
- [ ] Connection pool size set appropriately for pod count
- [ ] First-run seed data removed (development seeds only)

## ✅ CI/CD

- [ ] `.github/workflows/ci.yml` runs on every PR ✅
- [ ] `.github/workflows/security.yml` runs weekly ✅
- [ ] `.github/workflows/release.yml` triggers on version tags ✅
- [ ] Branch protection: main requires passing CI before merge
- [ ] Docker image pushed to registry on release
- [ ] Rollback procedure tested

## ✅ Observability

- [ ] Structured JSON logs flowing to log aggregation
- [ ] Health endpoint `/health` registered with monitoring system
- [ ] Alerts configured for P95 > 500ms, error rate > 1%
- [ ] On-call rotation scheduled

## ✅ Documentation

- [ ] DEPLOYMENT_GUIDE.md complete ✅
- [ ] RUNBOOK.md complete ✅
- [ ] README.md updated with production deployment instructions
- [ ] Environment variables documented (.env.production.example) ✅

## ✅ Mobile

- [ ] Flutter app version bumped
- [ ] App icons configured for all resolutions
- [ ] Splash screen configured
- [ ] Deep links and universal links tested
- [ ] Crash reporting (Firebase Crashlytics) integrated
- [ ] Android build signed with production keystore
- [ ] iOS build signed with distribution certificate
- [ ] Store metadata (description, screenshots, keywords) prepared

---

## Go/No-Go Decision

| Owner | Sign-Off | Date |
|---|---|---|
| CTO | | |
| Principal SRE | | |
| Principal Security | | |
| QA Lead | | |
| Product Lead | | |

> All five sign-offs required before production traffic is switched.

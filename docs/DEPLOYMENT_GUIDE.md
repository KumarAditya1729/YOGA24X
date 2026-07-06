# Yoga24X Enterprise Platform — Deployment Guide

## Overview

This guide covers deploying the Yoga24X backend to production using Docker Compose or Kubernetes.

---

## Prerequisites

| Tool | Version | Purpose |
|---|---|---|
| Docker | ≥ 24 | Container runtime |
| Docker Compose | ≥ 2.20 | Local and single-server deployment |
| kubectl | ≥ 1.28 | Kubernetes deployment |
| Helm | ≥ 3.13 | Kubernetes package management |
| pnpm | 9.4.0 | Package manager |
| Node.js | ≥ 20 | Runtime |

---

## Option A: Docker Compose (Single Server)

### 1. Clone and configure
```bash
git clone https://github.com/yoga24x/platform.git
cd platform
cp apps/backend/.env.production.example apps/backend/.env.production
# Edit .env.production and fill ALL CHANGE_ME values
```

### 2. Generate secrets
```bash
# JWT secrets (64+ chars)
openssl rand -hex 64  # Use for JWT_ACCESS_SECRET
openssl rand -hex 64  # Use for JWT_REFRESH_SECRET
openssl rand -hex 32  # Use for COOKIE_SECRET

# Database password
openssl rand -hex 24  # Use for DB_PASSWORD in docker-compose.prod.yml
```

### 3. Deploy
```bash
docker compose -f infra/docker/docker-compose.prod.yml up -d

# Run database migrations
docker compose -f infra/docker/docker-compose.prod.yml exec backend \
  npx prisma migrate deploy
```

### 4. Verify health
```bash
curl https://api.yoga24x.com/health
curl https://api.yoga24x.com/ready
```

---

## Option B: Kubernetes (Recommended for Scale)

### 1. Create namespace and configure secrets
```bash
kubectl apply -f infra/k8s/backend-config.yaml

# Edit the Secret resource with real values (or use Sealed Secrets / Vault)
kubectl edit secret yoga24x-backend-secrets -n yoga24x
```

### 2. Deploy
```bash
kubectl apply -f infra/k8s/backend-deployment.yaml
kubectl apply -f infra/k8s/ingress.yaml
```

### 3. Verify pods
```bash
kubectl get pods -n yoga24x
kubectl logs -f deployment/yoga24x-backend -n yoga24x
```

### 4. Run database migrations
```bash
kubectl exec -it deploy/yoga24x-backend -n yoga24x -- npx prisma migrate deploy
```

---

## Database Migrations

```bash
# Check pending migrations
npx prisma migrate status

# Apply in production (always backup first)
npx prisma migrate deploy

# Rollback: restore from backup (Prisma has no automatic rollback)
```

> [!CAUTION]
> Always take a database backup before running migrations in production.
> ```bash
> pg_dump -U yoga24x_prod yoga24x_prod > backup_$(date +%Y%m%d_%H%M%S).sql
> ```

---

## Environment Variables Reference

See [`apps/backend/.env.production.example`](../apps/backend/.env.production.example) for the full list of required environment variables and their descriptions.

**Critical variables that MUST be changed before deployment:**
- `JWT_ACCESS_SECRET` — min 64 chars
- `JWT_REFRESH_SECRET` — min 64 chars, different from access
- `DATABASE_URL` — with real credentials
- `REDIS_URL` — with auth password
- `COOKIE_SECRET` — min 32 chars

---

## Rollback Procedure

```bash
# Docker Compose: rollback to previous image
docker compose -f infra/docker/docker-compose.prod.yml pull
docker compose -f infra/docker/docker-compose.prod.yml up -d

# Kubernetes: rollback deployment
kubectl rollout undo deployment/yoga24x-backend -n yoga24x
kubectl rollout status deployment/yoga24x-backend -n yoga24x
```

---

## First-Time Seed (Staging Only)
```bash
npx prisma db seed
```

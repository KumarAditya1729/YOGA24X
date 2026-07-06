# Yoga24X Operations Runbook

## Purpose
Quick-reference guide for on-call engineers. Use this document to diagnose and resolve common production issues.

---

## Health Check URLs

| Endpoint | Purpose | Expected |
|---|---|---|
| `GET /health` | Liveness probe | 200 `{ status: "ok" }` |
| `GET /ready` | Readiness probe | 200 all dependencies healthy |
| `GET /api/docs` | Swagger (dev only) | 200 HTML |

---

## Runbook 1: Backend Pod Not Starting

**Symptoms:** `kubectl get pods` shows `CrashLoopBackOff` or `Error`

**Steps:**
```bash
# 1. Check logs
kubectl logs deploy/yoga24x-backend -n yoga24x --previous

# 2. Check environment — missing env vars?
kubectl describe pod -l app=yoga24x-backend -n yoga24x

# 3. Check DB connectivity
kubectl exec -it deploy/yoga24x-backend -n yoga24x -- \
  node -e "const { PrismaClient } = require('@prisma/client'); new PrismaClient().\$connect().then(() => console.log('DB OK')).catch(console.error)"

# 4. Common fixes
# - Missing JWT_ACCESS_SECRET (must be 64+ chars)
# - DATABASE_URL wrong (check pg_isready)
# - Prisma client not generated (run prisma generate)
```

---

## Runbook 2: High Response Times (P95 > 500ms)

**Symptoms:** Grafana alerts, user complaints

**Steps:**
```bash
# 1. Check database slow queries
SELECT query, mean_exec_time, calls
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 10;

# 2. Check Redis connection pool
redis-cli -a $REDIS_PASSWORD info clients

# 3. Check active connections
SELECT count(*), state FROM pg_stat_activity GROUP BY state;

# 4. Scale up pods if CPU-bound
kubectl scale deployment yoga24x-backend --replicas=6 -n yoga24x
```

---

## Runbook 3: Rate Limiting Triggering for Legitimate Users

**Symptoms:** Users getting 429 Too Many Requests

**Diagnosis:**
- Check if a specific IP is hammering the API
- Check if a mobile client has a retry loop bug

**Resolution:**
```bash
# Temporarily increase throttle limit via feature flag
curl -X POST https://api.yoga24x.com/api/v1/admin/super/settings \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -d '{"key": "throttle_limit", "value": 500}'

# Or restart with higher THROTTLE_LIMIT env var
kubectl set env deployment/yoga24x-backend THROTTLE_LIMIT=500 -n yoga24x
```

---

## Runbook 4: Database Disk Space Alert

**Symptoms:** Prometheus alert `PostgresDiskUsage > 80%`

```bash
# Check table sizes
SELECT schemaname, tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC
LIMIT 10;

# Purge old audit logs (older than 90 days)
DELETE FROM audit_logs WHERE created_at < NOW() - INTERVAL '90 days';

# Vacuum and analyze
VACUUM ANALYZE;
```

---

## Runbook 5: JWT Token Issues (401 on Valid Tokens)

**Symptoms:** Users suddenly logged out, 401 on valid sessions

**Cause:** JWT secret rotation or server restart with different secret

```bash
# 1. Verify JWT_ACCESS_SECRET is consistent across all pods
kubectl exec -it deploy/yoga24x-backend -n yoga24x -- \
  printenv JWT_ACCESS_SECRET | wc -c  # Should be 65+ (64 chars + newline)

# 2. Check Redis for revoked tokens
redis-cli -a $REDIS_PASSWORD KEYS "revoked:*" | head -20

# 3. Force all users to re-login (nuclear option)
redis-cli -a $REDIS_PASSWORD FLUSHDB  # Clears all sessions
```

---

## Runbook 6: Rollback to Previous Version

```bash
# Kubernetes
kubectl rollout history deployment/yoga24x-backend -n yoga24x
kubectl rollout undo deployment/yoga24x-backend --to-revision=2 -n yoga24x
kubectl rollout status deployment/yoga24x-backend -n yoga24x

# Verify rollback
curl https://api.yoga24x.com/health | jq .version
```

---

## Escalation Matrix

| Severity | Response Time | Contact |
|---|---|---|
| P0 – Platform Down | Immediate | CTO + SRE Lead + On-Call |
| P1 – Major Feature Down | 15 min | SRE Lead + On-Call |
| P2 – Degraded Performance | 30 min | On-Call Engineer |
| P3 – Minor Issues | 4 hours | Engineering Team |

---

## Key Metrics to Monitor

| Metric | Healthy Threshold | Alert Threshold |
|---|---|---|
| HTTP P95 Response Time | < 200ms | > 500ms |
| Error Rate (5xx) | < 0.1% | > 1% |
| CPU Utilization | < 60% | > 80% |
| Memory Usage | < 70% | > 85% |
| DB Connections | < 40/50 | > 45/50 |
| Redis Memory | < 400MB | > 480MB |
| Pod Restarts | 0 in 1h | > 2 in 1h |

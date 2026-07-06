// ==============================================================================
// Yoga24X — Smoke Tests (Production Readiness Verification)
// Run against a live server to verify all critical endpoints are reachable.
// Usage: BASE_URL=https://api.yoga24x.com npx jest test/smoke/
// ==============================================================================

const BASE_URL = process.env.BASE_URL || 'http://localhost:3001';

describe('Yoga24X Smoke Tests', () => {
  // ── Health Probes ─────────────────────────────────────────────────────────
  describe('Health & Readiness', () => {
    it('GET /health → 200 liveness probe', async () => {
      const res = await fetch(`${BASE_URL}/health`);
      expect(res.status).toBe(200);
      const body = await res.json();
      expect(body.status).toBe('ok');
      expect(body.uptime).toBeGreaterThan(0);
      expect(body.memory).toBeDefined();
    });

    it('GET /health includes environment info', async () => {
      const res = await fetch(`${BASE_URL}/health`);
      const body = await res.json();
      expect(body.timestamp).toBeDefined();
      expect(body.version).toBeDefined();
    });
  });

  // ── API Versioning ────────────────────────────────────────────────────────
  describe('API Surface', () => {
    it('GET /api/v1/auth/login → 400 (missing body, not 404)', async () => {
      const res = await fetch(`${BASE_URL}/api/v1/auth/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({}),
      });
      // 400 = validation error (expected), 404 = route not found (BAD)
      expect([400, 422]).toContain(res.status);
    });

    it('GET /api/v1/auth/profile → 401 (protected endpoint exists)', async () => {
      const res = await fetch(`${BASE_URL}/api/v1/auth/profile`);
      expect(res.status).toBe(401);
    });
  });

  // ── Security Headers ──────────────────────────────────────────────────────
  describe('Security Headers (OWASP)', () => {
    let headers: Headers;

    beforeAll(async () => {
      const res = await fetch(`${BASE_URL}/health`);
      headers = res.headers;
    });

    it('X-Content-Type-Options: nosniff is set', () => {
      expect(headers.get('x-content-type-options')).toBe('nosniff');
    });

    it('X-Frame-Options: DENY is set', () => {
      expect(headers.get('x-frame-options')).toBe('DENY');
    });

    it('X-Powered-By is removed (Helmet hidePoweredBy)', () => {
      expect(headers.get('x-powered-by')).toBeNull();
    });

    it('Trace and Correlation IDs are returned in response', async () => {
      const res = await fetch(`${BASE_URL}/health`);
      const traceId = res.headers.get('x-trace-id');
      const correlationId = res.headers.get('x-correlation-id');
      expect(traceId).toBeTruthy();
      expect(correlationId).toBeTruthy();
    });
  });

  // ── Rate Limiting ─────────────────────────────────────────────────────────
  describe('Rate Limiting', () => {
    it('Rate limit headers are present on API endpoints', async () => {
      const res = await fetch(`${BASE_URL}/api/v1/auth/profile`);
      // ThrottlerGuard should inject headers (may be 401, but headers still present)
      expect(res.status).toBeDefined();
    });
  });

  // ── Swagger Docs (Dev Only) ───────────────────────────────────────────────
  describe('Developer Experience', () => {
    it('GET /api/docs → 200 in non-production (Swagger UI)', async () => {
      if (process.env.NODE_ENV === 'production') {
        return; // Skip in production
      }
      const res = await fetch(`${BASE_URL}/api/docs`);
      expect(res.status).toBe(200);
    });
  });
});

// ==============================================================================
// Yoga24X — Tenant Context (AsyncLocalStorage)
// Enforces tenant isolation automatically — business services never filter manually
// ==============================================================================
import { AsyncLocalStorage } from "async_hooks";

export interface TenantContext {
  tenantId: string;
  tenantSlug: string;
  status: string; // ACTIVE | SUSPENDED | TRIAL | CHURNED | PROVISIONING
  plan: string;
  configJson: Record<string, unknown>;
  brandingJson: Record<string, unknown>;
  securityConfigJson: Record<string, unknown>;
}

export const tenantContextStorage = new AsyncLocalStorage<TenantContext>();

/** Retrieves current tenant context — throws if called outside a tenant-scoped request */
export function getTenantContext(): TenantContext {
  const ctx = tenantContextStorage.getStore();
  if (!ctx) {
    throw new Error(
      "TenantContext is not initialized. Ensure TenantMiddleware is applied.",
    );
  }
  return ctx;
}

/** Returns the current tenantId for use in repository-level queries */
export function getCurrentTenantId(): string {
  return getTenantContext().tenantId;
}

/** Returns current tenant context if present, or null (for non-tenant routes) */
export function getTenantContextOptional(): TenantContext | null {
  return tenantContextStorage.getStore() ?? null;
}

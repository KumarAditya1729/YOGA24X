// ==============================================================================
// Yoga24X — Authorization Context
// Carrier for every attribute needed by the unified RBAC+ABAC engine
// ==============================================================================

export interface AuthorizationContext {
  /** Authenticated user UUID (undefined for anonymous) */
  userId?: string;
  /** Active tenant UUID resolved by middleware */
  tenantId?: string;
  /** Active organization UUID (optional — for org-scoped requests) */
  organizationId?: string;
  /** Active roles of the user in this tenant/org context */
  roles: string[];
  /** Effective permission keys after inheritance + overrides  */
  permissions: string[];
  /** Device fingerprint UUID */
  deviceId?: string;
  /** Caller IP address */
  ipAddress?: string;
  /** Device trust level resolved by DevicePolicy */
  deviceTrust?: 'TRUSTED' | 'UNKNOWN' | 'BLOCKED';
  /** Subscription tier of the user */
  subscriptionTier?: string;
  /** Computed risk score (0-100) */
  riskScore?: number;
  /** Current UTC hour (0-23) for time-based rules */
  currentHour?: number;
  /** ISO 3166-1 alpha-2 country code resolved from IP */
  countryCode?: string;
  /** Whether the user has active health data restrictions */
  hasHealthRestrictions?: boolean;
  /** Request correlation ID (UUID v4) for audit linkage */
  correlationId: string;
  /** Raw HTTP request path */
  requestPath?: string;
  /** HTTP method */
  requestMethod?: string;
}

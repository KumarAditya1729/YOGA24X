// ==============================================================================
// Yoga24X — Permission Registry
// Single source of truth for all 16-role permission definitions
// Format: "module:action"  →  coarse + fine-grained control
// ==============================================================================

export const PERMISSIONS = {
  // ── Users ──────────────────────────────────────────────────────────────────
  USERS_READ_SELF: "users:read_self",
  USERS_READ_ANY: "users:read_any",
  USERS_UPDATE_SELF: "users:update_self",
  USERS_UPDATE_ANY: "users:update_any",
  USERS_DELETE_SELF: "users:delete_self",
  USERS_DELETE_ANY: "users:delete_any",
  USERS_MANAGE_ROLES: "users:manage_roles",
  USERS_SUSPEND: "users:suspend",
  USERS_EXPORT: "users:export",

  // ── Health / Wellness ──────────────────────────────────────────────────────
  HEALTH_READ_SELF: "health:read_self",
  HEALTH_READ_ANY: "health:read_any",
  HEALTH_WRITE_SELF: "health:write_self",
  HEALTH_WRITE_ANY: "health:write_any",
  HEALTH_VERIFY: "health:verify", // Doctor only
  HEALTH_POSE_SAFETY: "health:pose_safety",

  // ── Courses & LMS ─────────────────────────────────────────────────────────
  COURSES_READ: "courses:read",
  COURSES_ENROLL: "courses:enroll",
  COURSES_CREATE: "courses:create",
  COURSES_UPDATE: "courses:update",
  COURSES_DELETE: "courses:delete",
  COURSES_PUBLISH: "courses:publish",
  COURSES_GRADE: "courses:grade",
  LESSONS_CREATE: "lessons:create",
  LESSONS_UPDATE: "lessons:update",

  // ── Live Classes / Bookings ────────────────────────────────────────────────
  CLASSES_READ: "classes:read",
  CLASSES_BOOK: "classes:book",
  CLASSES_HOST: "classes:host",
  CLASSES_CANCEL: "classes:cancel",
  CLASSES_MANAGE: "classes:manage",

  // ── Payments & Finance ─────────────────────────────────────────────────────
  PAYMENTS_READ_SELF: "payments:read_self",
  PAYMENTS_READ_ANY: "payments:read_any",
  PAYMENTS_INITIATE: "payments:initiate",
  PAYMENTS_REFUND: "payments:refund",
  PAYMENTS_REPORT: "payments:report",
  WALLET_READ_SELF: "wallet:read_self",
  WALLET_TOPUP: "wallet:topup",
  WALLET_WITHDRAW: "wallet:withdraw",

  // ── Subscriptions ─────────────────────────────────────────────────────────
  SUBSCRIPTIONS_READ: "subscriptions:read",
  SUBSCRIPTIONS_MANAGE: "subscriptions:manage",
  SUBSCRIPTIONS_ASSIGN: "subscriptions:assign",

  // ── Organizations ──────────────────────────────────────────────────────────
  ORGS_READ: "orgs:read",
  ORGS_CREATE: "orgs:create",
  ORGS_UPDATE: "orgs:update",
  ORGS_DELETE: "orgs:delete",
  ORGS_INVITE: "orgs:invite",
  ORGS_MANAGE_MEMBERS: "orgs:manage_members",
  ORGS_TRANSFER_OWNERSHIP: "orgs:transfer_ownership",

  // ── Tenant Management ──────────────────────────────────────────────────────
  TENANTS_READ: "tenants:read",
  TENANTS_MANAGE: "tenants:manage",
  TENANTS_BRANDING: "tenants:branding",
  TENANTS_CONFIG: "tenants:config",
  TENANTS_SUSPEND: "tenants:suspend",

  // ── Feature Flags ─────────────────────────────────────────────────────────
  FLAGS_READ: "flags:read",
  FLAGS_MANAGE: "flags:manage",
  FLAGS_KILL_SWITCH: "flags:kill_switch",

  // ── RBAC & Security ───────────────────────────────────────────────────────
  SECURITY_ROLES_MANAGE: "security:roles_manage",
  SECURITY_PERMS_MANAGE: "security:perms_manage",
  SECURITY_POLICIES_MANAGE: "security:policies_manage",
  SECURITY_AUDIT_READ: "security:audit_read",
  SECURITY_EVENTS_READ: "security:events_read",
  SECURITY_EVENTS_ACK: "security:events_ack",

  // ── Community ─────────────────────────────────────────────────────────────
  COMMUNITY_READ: "community:read",
  COMMUNITY_POST: "community:post",
  COMMUNITY_MODERATE: "community:moderate",

  // ── AI Features ───────────────────────────────────────────────────────────
  AI_COACH_USE: "ai:coach_use",
  AI_COACH_MANAGE: "ai:coach_manage",
  AI_POSE_DETECT: "ai:pose_detect",
  AI_NUTRITION_PLAN: "ai:nutrition_plan",
  AI_ADMIN: "ai:admin",

  // ── Content ───────────────────────────────────────────────────────────────
  CONTENT_READ: "content:read",
  CONTENT_CREATE: "content:create",
  CONTENT_UPDATE: "content:update",
  CONTENT_DELETE: "content:delete",
  CONTENT_PUBLISH: "content:publish",
  MEDIA_UPLOAD: "media:upload",
  MEDIA_DELETE: "media:delete",

  // ── Analytics ─────────────────────────────────────────────────────────────
  ANALYTICS_READ_SELF: "analytics:read_self",
  ANALYTICS_READ_ORG: "analytics:read_org",
  ANALYTICS_READ_PLATFORM: "analytics:read_platform",

  // ── Support ───────────────────────────────────────────────────────────────
  SUPPORT_TICKETS_READ: "support:tickets_read",
  SUPPORT_TICKETS_MANAGE: "support:tickets_manage",
  SUPPORT_IMPERSONATE: "support:impersonate", // Super Admin only

  // ── Teacher Operations (Prompt 6.2) ───────────────────────────────────────
  TEACHER_AVAILABILITY_READ: "teacher:availability_read",
  TEACHER_AVAILABILITY_WRITE: "teacher:availability_write",
  TEACHER_SESSION_TYPE_READ: "teacher:session_type_read",
  TEACHER_SESSION_TYPE_WRITE: "teacher:session_type_write",
  TEACHER_SCHEDULE_READ: "teacher:schedule_read",
  TEACHER_SCHEDULE_WRITE: "teacher:schedule_write",
  TEACHER_BOOKING_READ: "teacher:booking_read",
  TEACHER_BOOKING_WRITE: "teacher:booking_write",
  TEACHER_ROSTER_READ: "teacher:roster_read",
  TEACHER_ROSTER_WRITE: "teacher:roster_write",
  TEACHER_EARNINGS_READ: "teacher:earnings_read",
  TEACHER_EARNINGS_WRITE: "teacher:earnings_write",

  // ── Learning & Content (Prompt 6.3) ───────────────────────────────────────
  LEARNING_COURSE_READ: "learning:course_read",
  LEARNING_COURSE_WRITE: "learning:course_write",
  LEARNING_LESSON_READ: "learning:lesson_read",
  LEARNING_LESSON_WRITE: "learning:lesson_write",
  LEARNING_EVENT_READ: "learning:event_read",
  LEARNING_EVENT_WRITE: "learning:event_write",
  LEARNING_PUBLICATION_READ: "learning:publication_read",
  LEARNING_PUBLICATION_WRITE: "learning:publication_write",
  LEARNING_STUDENT_INTERACTION: "learning:student_interaction",
  LEARNING_ASSESSMENT_READ: "learning:assessment_read",
  LEARNING_ASSESSMENT_WRITE: "learning:assessment_write",

  // ── Booking, Scheduling & Enrollment (Prompt 7) ──────────────────────────
  BOOKING_READ: "booking:read",
  BOOKING_WRITE: "booking:write",
  BOOKING_CANCEL: "booking:cancel",
  BOOKING_RESCHEDULE: "booking:reschedule",
  BOOKING_ADMIN: "booking:admin",
  SCHEDULE_READ: "schedule:read",
  SCHEDULE_WRITE: "schedule:write",
  ENROLLMENT_READ: "enrollment:read",
  ENROLLMENT_WRITE: "enrollment:write",
  ATTENDANCE_READ: "attendance:read",
  ATTENDANCE_WRITE: "attendance:write",
  WAITLIST_READ: "waitlist:read",
  WAITLIST_WRITE: "waitlist:write",
  CALENDAR_SYNC: "calendar:sync",

  // ── Student Experience (Prompt 8) ──────────────────────────────────────────
  STUDENT_PROFILE_READ: "student:profile_read",
  STUDENT_PROFILE_WRITE: "student:profile_write",
  STUDENT_ACHIEVEMENT_READ: "student:achievement_read",
  STUDENT_ACHIEVEMENT_WRITE: "student:achievement_write",
  STUDENT_PREFERENCE_READ: "student:preference_read",
  STUDENT_PREFERENCE_WRITE: "student:preference_write",
  STUDENT_ANALYTICS_READ: "student:analytics_read",
  STUDENT_ANALYTICS_WRITE: "student:analytics_write",
  GUARDIAN_READ: "guardian:read",
  GUARDIAN_WRITE: "guardian:write",

  // ── Community, Social & Engagement (Prompt 9) ────────────────────────────
  COMMUNITY_FEED_READ: "community:feed_read",
  COMMUNITY_FEED_WRITE: "community:feed_write",
  COMMUNITY_GROUP_READ: "community:group_read",
  COMMUNITY_GROUP_WRITE: "community:group_write",
  COMMUNITY_GROUP_MANAGE: "community:group_manage",
  CHAT_READ: "chat:read",
  CHAT_WRITE: "chat:write",
  CHALLENGE_READ: "challenge:read",
  CHALLENGE_WRITE: "challenge:write",
  CHALLENGE_MANAGE: "challenge:manage",
  MODERATION_REPORT: "moderation:report",
  MODERATION_MANAGE: "moderation:manage",
  LEADERBOARD_READ: "leaderboard:read",

  // ── Commerce Platform (Prompt 10) ────────────────────────────────────────────
  PAYMENT_READ: "payment:read",
  PAYMENT_INITIATE_ADVANCED: "payment:initiate_advanced",
  PAYMENT_MANAGE: "payment:manage",
  PAYMENT_WEBHOOK_MANAGE: "payment:webhook_manage",
  WALLET_MANAGE: "wallet:manage",
  WALLET_TRANSFER: "wallet:transfer",
  MEMBERSHIP_READ: "membership:read",
  MEMBERSHIP_WRITE: "membership:write",
  MEMBERSHIP_MANAGE: "membership:manage",
  SUBSCRIPTION_READ: "subscription:read",
  SUBSCRIPTION_WRITE: "subscription:write",
  SUBSCRIPTION_MANAGE: "subscription:manage",
  COUPON_READ: "coupon:read",
  COUPON_REDEEM: "coupon:redeem",
  COUPON_MANAGE: "coupon:manage",
  GIFT_CARD_READ: "gift_card:read",
  GIFT_CARD_PURCHASE: "gift_card:purchase",
  GIFT_CARD_MANAGE: "gift_card:manage",
  REFUND_READ: "refund:read",
  REFUND_REQUEST: "refund:request",
  REFUND_APPROVE: "refund:approve",
  REFUND_MANAGE: "refund:manage",
  REVENUE_READ: "revenue:read",
  REVENUE_MANAGE: "revenue:manage",
  SETTLEMENT_READ: "settlement:read",
  SETTLEMENT_MANAGE: "settlement:manage",
  INVOICE_READ: "invoice:read",
  INVOICE_MANAGE: "invoice:manage",
  PRICING_READ: "pricing:read",
  PRICING_MANAGE: "pricing:manage",
  COMMERCE_ANALYTICS_READ: "commerce_analytics:read",
  COMMERCE_ANALYTICS_MANAGE: "commerce_analytics:manage",

  // ── Sovereign AI Platform (Prompt 11) ────────────────────────────────────────
  AI_CHAT_START: "ai:chat_start",
  AI_CHAT_READ: "ai:chat_read",
  AI_RECOMMENDATIONS_READ: "ai:recommendations_read",
  AI_PROMPT_MANAGE: "ai:prompt_manage",
  AI_PROVIDER_MANAGE: "ai:provider_manage",
  AI_KNOWLEDGE_MANAGE: "ai:knowledge_manage",
  AI_SAFETY_READ: "ai:safety_read",

  // ── Enterprise Administration (Prompt 12) ────────────────────────────────────
  ADMIN_SUPER: "admin:super",
  ORG_MANAGE: "org:manage",
  USER_MANAGE: "user:manage",
  CMS_MANAGE: "cms:manage",
  CRM_MANAGE: "crm:manage",
  SUPPORT_MANAGE: "support:manage",
  ANALYTICS_READ: "analytics:read",
} as const;

export type PermissionKey = (typeof PERMISSIONS)[keyof typeof PERMISSIONS];

// ── Role → Permission Matrix ──────────────────────────────────────────────────
// Each role inherits all permissions of roles listed in `inherits`.
// Effective permissions = own + all inherited (recursively).

export interface RoleDefinition {
  name: string;
  inherits: string[];
  permissions: PermissionKey[];
}

export const ROLE_PERMISSION_MATRIX: Record<string, RoleDefinition> = {
  GUEST: {
    name: "GUEST",
    inherits: [],
    permissions: [
      PERMISSIONS.COURSES_READ,
      PERMISSIONS.COMMUNITY_READ,
      PERMISSIONS.CONTENT_READ,
    ],
  },
  STUDENT: {
    name: "STUDENT",
    inherits: ["GUEST"],
    permissions: [
      PERMISSIONS.USERS_READ_SELF,
      PERMISSIONS.USERS_UPDATE_SELF,
      PERMISSIONS.USERS_DELETE_SELF,
      PERMISSIONS.HEALTH_READ_SELF,
      PERMISSIONS.HEALTH_WRITE_SELF,
      PERMISSIONS.HEALTH_POSE_SAFETY,
      PERMISSIONS.COURSES_ENROLL,
      PERMISSIONS.CLASSES_READ,
      PERMISSIONS.CLASSES_BOOK,
      PERMISSIONS.CLASSES_CANCEL,
      PERMISSIONS.PAYMENTS_READ_SELF,
      PERMISSIONS.PAYMENTS_INITIATE,
      PERMISSIONS.WALLET_READ_SELF,
      PERMISSIONS.WALLET_TOPUP,
      PERMISSIONS.SUBSCRIPTIONS_READ,
      PERMISSIONS.COMMUNITY_POST,
      PERMISSIONS.AI_COACH_USE,
      PERMISSIONS.AI_POSE_DETECT,
      PERMISSIONS.AI_CHAT_START,
      PERMISSIONS.AI_CHAT_READ,
      PERMISSIONS.AI_RECOMMENDATIONS_READ,
      PERMISSIONS.MEDIA_UPLOAD,
      PERMISSIONS.ANALYTICS_READ_SELF,
      PERMISSIONS.STUDENT_PROFILE_READ,
      PERMISSIONS.STUDENT_PROFILE_WRITE,
      PERMISSIONS.STUDENT_ACHIEVEMENT_READ,
      PERMISSIONS.STUDENT_PREFERENCE_READ,
      PERMISSIONS.STUDENT_PREFERENCE_WRITE,
      PERMISSIONS.STUDENT_ANALYTICS_READ,
      PERMISSIONS.GUARDIAN_READ,
      PERMISSIONS.GUARDIAN_WRITE,

      // Social permissions
      PERMISSIONS.COMMUNITY_FEED_READ,
      PERMISSIONS.COMMUNITY_FEED_WRITE,
      PERMISSIONS.COMMUNITY_GROUP_READ,
      PERMISSIONS.COMMUNITY_GROUP_WRITE,
      PERMISSIONS.CHAT_READ,
      PERMISSIONS.CHAT_WRITE,
      PERMISSIONS.CHALLENGE_READ,
      PERMISSIONS.CHALLENGE_WRITE,
      PERMISSIONS.MODERATION_REPORT,
      PERMISSIONS.LEADERBOARD_READ,

      // Commerce permissions (Prompt 10)
      PERMISSIONS.PAYMENT_READ,
      PERMISSIONS.WALLET_READ_SELF,
      PERMISSIONS.WALLET_TOPUP,
      PERMISSIONS.MEMBERSHIP_READ,
      PERMISSIONS.MEMBERSHIP_WRITE,
      PERMISSIONS.SUBSCRIPTION_READ,
      PERMISSIONS.SUBSCRIPTION_WRITE,
      PERMISSIONS.COUPON_READ,
      PERMISSIONS.COUPON_REDEEM,
      PERMISSIONS.GIFT_CARD_READ,
      PERMISSIONS.GIFT_CARD_PURCHASE,
      PERMISSIONS.REFUND_READ,
      PERMISSIONS.REFUND_REQUEST,
      PERMISSIONS.INVOICE_READ,
      PERMISSIONS.PRICING_READ,
    ],
  },
  TEACHER: {
    name: "TEACHER",
    inherits: ["STUDENT"],
    permissions: [
      PERMISSIONS.COURSES_CREATE,
      PERMISSIONS.COURSES_UPDATE,
      PERMISSIONS.COURSES_PUBLISH,
      PERMISSIONS.COURSES_GRADE,
      PERMISSIONS.LESSONS_CREATE,
      PERMISSIONS.LESSONS_UPDATE,
      PERMISSIONS.CLASSES_HOST,
      PERMISSIONS.CLASSES_MANAGE,
      PERMISSIONS.HEALTH_READ_ANY, // to check student health before class
      PERMISSIONS.AI_NUTRITION_PLAN,
      PERMISSIONS.CONTENT_CREATE,
      PERMISSIONS.CONTENT_UPDATE,
      PERMISSIONS.ANALYTICS_READ_ORG,
    ],
  },
  DOCTOR: {
    name: "DOCTOR",
    inherits: ["STUDENT"],
    permissions: [
      PERMISSIONS.HEALTH_READ_ANY,
      PERMISSIONS.HEALTH_WRITE_ANY,
      PERMISSIONS.HEALTH_VERIFY,
      PERMISSIONS.HEALTH_POSE_SAFETY,
    ],
  },
  NUTRITIONIST: {
    name: "NUTRITIONIST",
    inherits: ["STUDENT"],
    permissions: [
      PERMISSIONS.HEALTH_READ_ANY,
      PERMISSIONS.AI_NUTRITION_PLAN,
      PERMISSIONS.CONTENT_CREATE,
    ],
  },
  MEDITATION_COACH: {
    name: "MEDITATION_COACH",
    inherits: ["TEACHER"],
    permissions: [],
  },
  MODERATOR: {
    name: "MODERATOR",
    inherits: ["STUDENT"],
    permissions: [
      PERMISSIONS.COMMUNITY_MODERATE,
      PERMISSIONS.CONTENT_DELETE,
      PERMISSIONS.USERS_READ_ANY,
    ],
  },
  SUPPORT_AGENT: {
    name: "SUPPORT_AGENT",
    inherits: ["GUEST"],
    permissions: [
      PERMISSIONS.USERS_READ_ANY,
      PERMISSIONS.SUPPORT_TICKETS_READ,
      PERMISSIONS.SUPPORT_TICKETS_MANAGE,
      PERMISSIONS.PAYMENTS_READ_ANY,
    ],
  },
  FINANCE: {
    name: "FINANCE",
    inherits: ["GUEST"],
    permissions: [
      PERMISSIONS.PAYMENTS_READ_ANY,
      PERMISSIONS.PAYMENTS_REFUND,
      PERMISSIONS.PAYMENTS_REPORT,
      PERMISSIONS.WALLET_WITHDRAW,
      PERMISSIONS.ANALYTICS_READ_PLATFORM,
    ],
  },
  CONTENT_MANAGER: {
    name: "CONTENT_MANAGER",
    inherits: ["GUEST"],
    permissions: [
      PERMISSIONS.CONTENT_CREATE,
      PERMISSIONS.CONTENT_UPDATE,
      PERMISSIONS.CONTENT_DELETE,
      PERMISSIONS.CONTENT_PUBLISH,
      PERMISSIONS.MEDIA_UPLOAD,
      PERMISSIONS.MEDIA_DELETE,
    ],
  },
  CORPORATE_MANAGER: {
    name: "CORPORATE_MANAGER",
    inherits: ["STUDENT"],
    permissions: [
      PERMISSIONS.ORGS_READ,
      PERMISSIONS.ORGS_INVITE,
      PERMISSIONS.ORGS_MANAGE_MEMBERS,
      PERMISSIONS.SUBSCRIPTIONS_ASSIGN,
      PERMISSIONS.ANALYTICS_READ_ORG,
    ],
  },
  CORPORATE_HR: {
    name: "CORPORATE_HR",
    inherits: ["CORPORATE_MANAGER"],
    permissions: [PERMISSIONS.USERS_READ_ANY, PERMISSIONS.USERS_EXPORT],
  },
  STUDIO_MANAGER: {
    name: "STUDIO_MANAGER",
    inherits: ["TEACHER"],
    permissions: [
      PERMISSIONS.ORGS_READ,
      PERMISSIONS.ORGS_UPDATE,
      PERMISSIONS.ORGS_INVITE,
      PERMISSIONS.ORGS_MANAGE_MEMBERS,
      PERMISSIONS.USERS_READ_ANY,
      PERMISSIONS.USERS_SUSPEND,
      PERMISSIONS.SUBSCRIPTIONS_MANAGE,
      PERMISSIONS.ANALYTICS_READ_ORG,
      PERMISSIONS.FLAGS_READ,
    ],
  },
  STUDIO_OWNER: {
    name: "STUDIO_OWNER",
    inherits: ["STUDIO_MANAGER"],
    permissions: [
      PERMISSIONS.ORGS_CREATE,
      PERMISSIONS.ORGS_DELETE,
      PERMISSIONS.ORGS_TRANSFER_OWNERSHIP,
      PERMISSIONS.TENANTS_BRANDING,
      PERMISSIONS.TENANTS_CONFIG,
      PERMISSIONS.PAYMENTS_REFUND,
      PERMISSIONS.ANALYTICS_READ_PLATFORM,
    ],
  },
  PLATFORM_ADMIN: {
    name: "PLATFORM_ADMIN",
    inherits: ["STUDIO_OWNER"],
    permissions: [
      PERMISSIONS.USERS_DELETE_ANY,
      PERMISSIONS.USERS_MANAGE_ROLES,
      PERMISSIONS.TENANTS_READ,
      PERMISSIONS.TENANTS_MANAGE,
      PERMISSIONS.TENANTS_SUSPEND,
      PERMISSIONS.FLAGS_MANAGE,
      PERMISSIONS.SECURITY_ROLES_MANAGE,
      PERMISSIONS.SECURITY_PERMS_MANAGE,
      PERMISSIONS.SECURITY_POLICIES_MANAGE,
      PERMISSIONS.SECURITY_AUDIT_READ,
      PERMISSIONS.SECURITY_EVENTS_READ,
      PERMISSIONS.SECURITY_EVENTS_ACK,
      PERMISSIONS.AI_COACH_MANAGE,
      PERMISSIONS.AI_ADMIN,
      PERMISSIONS.AI_PROMPT_MANAGE,
      PERMISSIONS.AI_PROVIDER_MANAGE,
      PERMISSIONS.AI_KNOWLEDGE_MANAGE,
      PERMISSIONS.ADMIN_SUPER,
      PERMISSIONS.ORG_MANAGE,
      PERMISSIONS.USER_MANAGE,
      PERMISSIONS.CMS_MANAGE,
      PERMISSIONS.CRM_MANAGE,
      PERMISSIONS.SUPPORT_MANAGE,
      PERMISSIONS.ANALYTICS_READ,
      PERMISSIONS.AI_SAFETY_READ,
      PERMISSIONS.ANALYTICS_READ_PLATFORM,
    ],
  },
  SUPER_ADMIN: {
    name: "SUPER_ADMIN",
    inherits: ["PLATFORM_ADMIN"],
    permissions: [
      PERMISSIONS.FLAGS_KILL_SWITCH,
      PERMISSIONS.SUPPORT_IMPERSONATE,
    ],
  },
};

// ==============================================================================
// Yoga24X — Teacher Permission Constants
// Extends the Security Platform PERMISSIONS registry for teacher operations
// ==============================================================================
export const TEACHER_PERMISSIONS = {
  // Profile
  TEACHER_PROFILE_READ:    'teacher:profile_read',
  TEACHER_PROFILE_WRITE:   'teacher:profile_write',
  TEACHER_PROFILE_DELETE:  'teacher:profile_delete',
  TEACHER_PROFILE_PUBLISH: 'teacher:profile_publish',

  // Certifications
  TEACHER_CERT_READ:    'teacher:cert_read',
  TEACHER_CERT_WRITE:   'teacher:cert_write',
  TEACHER_CERT_DELETE:  'teacher:cert_delete',
  TEACHER_CERT_VERIFY:  'teacher:cert_verify',

  // Portfolio
  TEACHER_PORTFOLIO_READ:   'teacher:portfolio_read',
  TEACHER_PORTFOLIO_WRITE:  'teacher:portfolio_write',
  TEACHER_PORTFOLIO_DELETE: 'teacher:portfolio_delete',

  // Verification (KYC)
  TEACHER_VERIF_SUBMIT:   'teacher:verif_submit',
  TEACHER_VERIF_READ:     'teacher:verif_read',
  TEACHER_VERIF_MANAGE:   'teacher:verif_manage',
  TEACHER_VERIF_APPROVE:  'teacher:verif_approve',
  TEACHER_VERIF_REJECT:   'teacher:verif_reject',

  // Stats
  TEACHER_STATS_READ: 'teacher:stats_read',
  TEACHER_STATS_OWN:  'teacher:stats_own',

  // Reviews
  TEACHER_REVIEW_READ:    'teacher:review_read',
  TEACHER_REVIEW_REPLY:   'teacher:review_reply',
  TEACHER_REVIEW_MANAGE:  'teacher:review_manage',

  // Admin
  TEACHER_ADMIN_LIST:     'teacher:admin_list',
  TEACHER_ADMIN_FEATURE:  'teacher:admin_feature',
  TEACHER_ADMIN_SUSPEND:  'teacher:admin_suspend',
  // Operations (Prompt 6.2)
  TEACHER_AVAILABILITY_READ: 'teacher:availability_read',
  TEACHER_AVAILABILITY_WRITE: 'teacher:availability_write',
  
  TEACHER_SESSION_TYPE_READ: 'teacher:session_type_read',
  TEACHER_SESSION_TYPE_WRITE: 'teacher:session_type_write',
  
  TEACHER_SCHEDULE_READ: 'teacher:schedule_read',
  TEACHER_SCHEDULE_WRITE: 'teacher:schedule_write',

  TEACHER_BOOKING_READ: 'teacher:booking_read',
  TEACHER_BOOKING_WRITE: 'teacher:booking_write',

  TEACHER_ROSTER_READ: 'teacher:roster_read',
  TEACHER_ROSTER_WRITE: 'teacher:roster_write',

  TEACHER_EARNINGS_READ: 'teacher:earnings_read',
  TEACHER_EARNINGS_WRITE: 'teacher:earnings_write',
} as const;

export type TeacherPermission = typeof TEACHER_PERMISSIONS[keyof typeof TEACHER_PERMISSIONS];

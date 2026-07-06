// ==============================================================================
// Yoga24X — Teacher Domain Events
// Event contracts emitted by the Teacher module for cross-module communication
// ==============================================================================

export enum TeacherEventType {
  PROFILE_CREATED = "teacher.profile.created",
  PROFILE_UPDATED = "teacher.profile.updated",
  PROFILE_PUBLISHED = "teacher.profile.published",
  CERT_ADDED = "teacher.cert.added",
  CERT_REMOVED = "teacher.cert.removed",
  CERT_VERIFIED = "teacher.cert.verified",
  VERIFICATION_SUBMITTED = "teacher.verification.submitted",
  VERIFICATION_APPROVED = "teacher.verification.approved",
  VERIFICATION_REJECTED = "teacher.verification.rejected",
  VERIFICATION_RESUBMITTED = "teacher.verification.resubmitted",
  STATS_RECALCULATED = "teacher.stats.recalculated",
  REVIEW_POSTED = "teacher.review.posted",
  REVIEW_REPLIED = "teacher.review.replied",
}

export interface TeacherProfileCreatedEvent {
  type: TeacherEventType.PROFILE_CREATED;
  userId: string;
  tenantId?: string;
  timestamp: Date;
  correlationId: string;
}

export interface TeacherVerificationStatusChangedEvent {
  type:
    | TeacherEventType.VERIFICATION_SUBMITTED
    | TeacherEventType.VERIFICATION_APPROVED
    | TeacherEventType.VERIFICATION_REJECTED
    | TeacherEventType.VERIFICATION_RESUBMITTED;
  userId: string;
  tenantId?: string;
  status: string;
  reviewedBy?: string;
  timestamp: Date;
  correlationId: string;
}

export interface TeacherStatsRecalculatedEvent {
  type: TeacherEventType.STATS_RECALCULATED;
  userId: string;
  totalStudents: number;
  totalClasses: number;
  averageRating: number;
  timestamp: Date;
}

export type TeacherEvent =
  | TeacherProfileCreatedEvent
  | TeacherVerificationStatusChangedEvent
  | TeacherStatsRecalculatedEvent;

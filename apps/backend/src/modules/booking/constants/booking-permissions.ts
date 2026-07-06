// ==============================================================================
// Yoga24X AI Engineering OS — Booking Module Permission Constants (Prompt 7)
// ==============================================================================

export const BOOKING_PERMISSIONS = {
  READ: "booking:read",
  WRITE: "booking:write",
  CANCEL: "booking:cancel",
  RESCHEDULE: "booking:reschedule",
  ADMIN: "booking:admin",
} as const;

export const SCHEDULE_PERMISSIONS = {
  READ: "schedule:read",
  WRITE: "schedule:write",
} as const;

export const ENROLLMENT_PERMISSIONS = {
  READ: "enrollment:read",
  WRITE: "enrollment:write",
} as const;

export const ATTENDANCE_PERMISSIONS = {
  READ: "attendance:read",
  WRITE: "attendance:write",
} as const;

export const WAITLIST_PERMISSIONS = {
  READ: "waitlist:read",
  WRITE: "waitlist:write",
} as const;

export const CALENDAR_PERMISSIONS = {
  SYNC: "calendar:sync",
} as const;

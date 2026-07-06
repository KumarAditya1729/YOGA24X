// ==============================================================================
// Yoga24X AI Engineering OS — Booking Domain Models (Prompt 7)
// ==============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_models.freezed.dart';
part 'booking_models.g.dart';

// ─── Booking Status ─────────────────────────────────────────────────────────
enum BookingStatus {
  @JsonValue('DRAFT') draft,
  @JsonValue('PENDING') pending,
  @JsonValue('CONFIRMED') confirmed,
  @JsonValue('RESCHEDULED') rescheduled,
  @JsonValue('CHECKED_IN') checkedIn,
  @JsonValue('STARTED') started,
  @JsonValue('COMPLETED') completed,
  @JsonValue('CANCELLED') cancelled,
  @JsonValue('EXPIRED') expired,
  @JsonValue('NO_SHOW') noShow,
  @JsonValue('REFUNDED') refunded,
  @JsonValue('AUTO_CLOSED') autoClosed,
}

// ─── Booking ────────────────────────────────────────────────────────────────
@freezed
class BookingItem with _$BookingItem {
  const factory BookingItem({
    required String id,
    required String sessionId,
    required BookingStatus status,
    required DateTime bookedAt,
    String? bookingNotes,
    DateTime? expiresAt,
    ScheduleSession? session,
    AttendanceRecord? attendance,
  }) = _BookingItem;

  factory BookingItem.fromJson(Map<String, dynamic> json) =>
      _$BookingItemFromJson(json);
}

// ─── Schedule Session ────────────────────────────────────────────────────────
@freezed
class ScheduleSession with _$ScheduleSession {
  const factory ScheduleSession({
    required String id,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    required int maxParticipants,
    required int currentBookings,
    String? meetingUrl,
    String? teacherFirstName,
    String? teacherLastName,
  }) = _ScheduleSession;

  factory ScheduleSession.fromJson(Map<String, dynamic> json) =>
      _$ScheduleSessionFromJson(json);
}

// ─── Unified Calendar Item ───────────────────────────────────────────────────
@freezed
class CalendarItem with _$CalendarItem {
  const factory CalendarItem({
    required String id,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    required String type, // 'SESSION' | 'EVENT'
    required BookingStatus status,
    String? meetingUrl,
    String? instructorName,
  }) = _CalendarItem;

  factory CalendarItem.fromJson(Map<String, dynamic> json) =>
      _$CalendarItemFromJson(json);
}

// ─── Waitlist Entry ──────────────────────────────────────────────────────────
@freezed
class WaitlistEntry with _$WaitlistEntry {
  const factory WaitlistEntry({
    required String id,
    required int priority,
    required String status,
    required DateTime createdAt,
    DateTime? expiresAt,
    ScheduleSession? session,
  }) = _WaitlistEntry;

  factory WaitlistEntry.fromJson(Map<String, dynamic> json) =>
      _$WaitlistEntryFromJson(json);
}

// ─── Attendance Record ───────────────────────────────────────────────────────
@freezed
class AttendanceRecord with _$AttendanceRecord {
  const factory AttendanceRecord({
    required String id,
    required bool attended,
    required String checkInMethod,
    DateTime? joinedAt,
    bool? isLate,
  }) = _AttendanceRecord;

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRecordFromJson(json);
}

// ─── Available Slot ──────────────────────────────────────────────────────────
@freezed
class AvailableSlot with _$AvailableSlot {
  const factory AvailableSlot({
    required String sessionId,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    required int maxParticipants,
    required int availableSpots,
  }) = _AvailableSlot;

  factory AvailableSlot.fromJson(Map<String, dynamic> json) =>
      _$AvailableSlotFromJson(json);
}

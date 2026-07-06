import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher_operations_models.freezed.dart';
part 'teacher_operations_models.g.dart';

// ── Enums ────────────────────────────────────────────────────────────────────

enum SessionFormat {
  PRIVATE,
  GROUP,
  CORPORATE,
  STUDIO,
  HOME_VISIT,
  ONLINE,
  HYBRID,
  RETREAT,
  WORKSHOP,
  TEACHER_TRAINING
}

enum PayoutStatus {
  PENDING,
  PROCESSING,
  PAID,
  FAILED,
  CANCELLED
}

// ── Models ───────────────────────────────────────────────────────────────────

@freezed
class TeacherBookingRule with _$TeacherBookingRule {
  const factory TeacherBookingRule({
    required String id,
    required String userId,
    required int advanceBookingDays,
    required int minimumNoticeHours,
    required int cancellationWindowHours,
    required int reschedulePolicyHours,
    required int bufferTimeMinutes,
    int? maxDailySessions,
    int? maxWeeklyHours,
    required int lateArrivalGraceMins,
    required bool preventOverbooking,
    required bool allowWaitlist,
  }) = _TeacherBookingRule;

  factory TeacherBookingRule.fromJson(Map<String, dynamic> json) =>
      _$TeacherBookingRuleFromJson(json);
}

@freezed
class TeacherHoliday with _$TeacherHoliday {
  const factory TeacherHoliday({
    required String id,
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    String? reason,
    required bool isEmergency,
  }) = _TeacherHoliday;

  factory TeacherHoliday.fromJson(Map<String, dynamic> json) =>
      _$TeacherHolidayFromJson(json);
}

@freezed
class TeacherSessionType with _$TeacherSessionType {
  const factory TeacherSessionType({
    required String id,
    required String userId,
    required String title,
    String? description,
    @JsonValue('format') required SessionFormat format,
    required int durationMinutes,
    required int basePriceCents,
    required String currency,
    required int maxParticipants,
    required bool isActive,
    required bool isOnline,
    required double taxRatePercent,
  }) = _TeacherSessionType;

  factory TeacherSessionType.fromJson(Map<String, dynamic> json) =>
      _$TeacherSessionTypeFromJson(json);
}

@freezed
class TeacherPricingRule with _$TeacherPricingRule {
  const factory TeacherPricingRule({
    required String id,
    required String userId,
    required String ruleName,
    double? markupPercent,
    double? discountPercent,
    required bool isWeekend,
    required bool isPeakHour,
    required List<SessionFormat> applicableFormats,
  }) = _TeacherPricingRule;

  factory TeacherPricingRule.fromJson(Map<String, dynamic> json) =>
      _$TeacherPricingRuleFromJson(json);
}

@freezed
class TeacherSession with _$TeacherSession {
  const factory TeacherSession({
    required String id,
    required String teacherUserId,
    required String sessionTypeId,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    required int maxParticipants,
    required int currentBookings,
    required String status,
    String? meetingUrl,
  }) = _TeacherSession;

  factory TeacherSession.fromJson(Map<String, dynamic> json) =>
      _$TeacherSessionFromJson(json);
}

@freezed
class TeacherStudentRoster with _$TeacherStudentRoster {
  const factory TeacherStudentRoster({
    required String id,
    required String teacherUserId,
    required String studentUserId,
    required bool isFavorite,
    required bool isBlocked,
    required int totalSessions,
    DateTime? firstSessionAt,
    DateTime? lastSessionAt,
    // Note: In real app, we'd include nested Student object
  }) = _TeacherStudentRoster;

  factory TeacherStudentRoster.fromJson(Map<String, dynamic> json) =>
      _$TeacherStudentRosterFromJson(json);
}

@freezed
class TeacherPayoutRequest with _$TeacherPayoutRequest {
  const factory TeacherPayoutRequest({
    required String id,
    required String userId,
    required int amountCents,
    required String currency,
    @JsonValue('status') required PayoutStatus status,
    String? bankAccountId,
    String? transactionRef,
    required DateTime requestedAt,
    DateTime? processedAt,
  }) = _TeacherPayoutRequest;

  factory TeacherPayoutRequest.fromJson(Map<String, dynamic> json) =>
      _$TeacherPayoutRequestFromJson(json);
}

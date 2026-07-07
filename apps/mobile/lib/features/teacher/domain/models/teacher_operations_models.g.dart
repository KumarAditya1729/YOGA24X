// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_operations_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeacherBookingRuleImpl _$$TeacherBookingRuleImplFromJson(
        Map<String, dynamic> json) =>
    _$TeacherBookingRuleImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      advanceBookingDays: (json['advanceBookingDays'] as num).toInt(),
      minimumNoticeHours: (json['minimumNoticeHours'] as num).toInt(),
      cancellationWindowHours: (json['cancellationWindowHours'] as num).toInt(),
      reschedulePolicyHours: (json['reschedulePolicyHours'] as num).toInt(),
      bufferTimeMinutes: (json['bufferTimeMinutes'] as num).toInt(),
      maxDailySessions: (json['maxDailySessions'] as num?)?.toInt(),
      maxWeeklyHours: (json['maxWeeklyHours'] as num?)?.toInt(),
      lateArrivalGraceMins: (json['lateArrivalGraceMins'] as num).toInt(),
      preventOverbooking: json['preventOverbooking'] as bool,
      allowWaitlist: json['allowWaitlist'] as bool,
    );

Map<String, dynamic> _$$TeacherBookingRuleImplToJson(
        _$TeacherBookingRuleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'advanceBookingDays': instance.advanceBookingDays,
      'minimumNoticeHours': instance.minimumNoticeHours,
      'cancellationWindowHours': instance.cancellationWindowHours,
      'reschedulePolicyHours': instance.reschedulePolicyHours,
      'bufferTimeMinutes': instance.bufferTimeMinutes,
      'maxDailySessions': instance.maxDailySessions,
      'maxWeeklyHours': instance.maxWeeklyHours,
      'lateArrivalGraceMins': instance.lateArrivalGraceMins,
      'preventOverbooking': instance.preventOverbooking,
      'allowWaitlist': instance.allowWaitlist,
    };

_$TeacherHolidayImpl _$$TeacherHolidayImplFromJson(Map<String, dynamic> json) =>
    _$TeacherHolidayImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      reason: json['reason'] as String?,
      isEmergency: json['isEmergency'] as bool,
    );

Map<String, dynamic> _$$TeacherHolidayImplToJson(
        _$TeacherHolidayImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'reason': instance.reason,
      'isEmergency': instance.isEmergency,
    };

_$TeacherSessionTypeImpl _$$TeacherSessionTypeImplFromJson(
        Map<String, dynamic> json) =>
    _$TeacherSessionTypeImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      format: $enumDecode(_$SessionFormatEnumMap, json['format']),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      basePriceCents: (json['basePriceCents'] as num).toInt(),
      currency: json['currency'] as String,
      maxParticipants: (json['maxParticipants'] as num).toInt(),
      isActive: json['isActive'] as bool,
      isOnline: json['isOnline'] as bool,
      taxRatePercent: (json['taxRatePercent'] as num).toDouble(),
    );

Map<String, dynamic> _$$TeacherSessionTypeImplToJson(
        _$TeacherSessionTypeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'format': _$SessionFormatEnumMap[instance.format]!,
      'durationMinutes': instance.durationMinutes,
      'basePriceCents': instance.basePriceCents,
      'currency': instance.currency,
      'maxParticipants': instance.maxParticipants,
      'isActive': instance.isActive,
      'isOnline': instance.isOnline,
      'taxRatePercent': instance.taxRatePercent,
    };

const _$SessionFormatEnumMap = {
  SessionFormat.PRIVATE: 'PRIVATE',
  SessionFormat.GROUP: 'GROUP',
  SessionFormat.CORPORATE: 'CORPORATE',
  SessionFormat.STUDIO: 'STUDIO',
  SessionFormat.HOME_VISIT: 'HOME_VISIT',
  SessionFormat.ONLINE: 'ONLINE',
  SessionFormat.HYBRID: 'HYBRID',
  SessionFormat.RETREAT: 'RETREAT',
  SessionFormat.WORKSHOP: 'WORKSHOP',
  SessionFormat.TEACHER_TRAINING: 'TEACHER_TRAINING',
};

_$TeacherPricingRuleImpl _$$TeacherPricingRuleImplFromJson(
        Map<String, dynamic> json) =>
    _$TeacherPricingRuleImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      ruleName: json['ruleName'] as String,
      markupPercent: (json['markupPercent'] as num?)?.toDouble(),
      discountPercent: (json['discountPercent'] as num?)?.toDouble(),
      isWeekend: json['isWeekend'] as bool,
      isPeakHour: json['isPeakHour'] as bool,
      applicableFormats: (json['applicableFormats'] as List<dynamic>)
          .map((e) => $enumDecode(_$SessionFormatEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$$TeacherPricingRuleImplToJson(
        _$TeacherPricingRuleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'ruleName': instance.ruleName,
      'markupPercent': instance.markupPercent,
      'discountPercent': instance.discountPercent,
      'isWeekend': instance.isWeekend,
      'isPeakHour': instance.isPeakHour,
      'applicableFormats': instance.applicableFormats
          .map((e) => _$SessionFormatEnumMap[e]!)
          .toList(),
    };

_$TeacherSessionImpl _$$TeacherSessionImplFromJson(Map<String, dynamic> json) =>
    _$TeacherSessionImpl(
      id: json['id'] as String,
      teacherUserId: json['teacherUserId'] as String,
      sessionTypeId: json['sessionTypeId'] as String,
      title: json['title'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      maxParticipants: (json['maxParticipants'] as num).toInt(),
      currentBookings: (json['currentBookings'] as num).toInt(),
      status: json['status'] as String,
      meetingUrl: json['meetingUrl'] as String?,
    );

Map<String, dynamic> _$$TeacherSessionImplToJson(
        _$TeacherSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teacherUserId': instance.teacherUserId,
      'sessionTypeId': instance.sessionTypeId,
      'title': instance.title,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'maxParticipants': instance.maxParticipants,
      'currentBookings': instance.currentBookings,
      'status': instance.status,
      'meetingUrl': instance.meetingUrl,
    };

_$TeacherStudentRosterImpl _$$TeacherStudentRosterImplFromJson(
        Map<String, dynamic> json) =>
    _$TeacherStudentRosterImpl(
      id: json['id'] as String,
      teacherUserId: json['teacherUserId'] as String,
      studentUserId: json['studentUserId'] as String,
      isFavorite: json['isFavorite'] as bool,
      isBlocked: json['isBlocked'] as bool,
      totalSessions: (json['totalSessions'] as num).toInt(),
      firstSessionAt: json['firstSessionAt'] == null
          ? null
          : DateTime.parse(json['firstSessionAt'] as String),
      lastSessionAt: json['lastSessionAt'] == null
          ? null
          : DateTime.parse(json['lastSessionAt'] as String),
    );

Map<String, dynamic> _$$TeacherStudentRosterImplToJson(
        _$TeacherStudentRosterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teacherUserId': instance.teacherUserId,
      'studentUserId': instance.studentUserId,
      'isFavorite': instance.isFavorite,
      'isBlocked': instance.isBlocked,
      'totalSessions': instance.totalSessions,
      'firstSessionAt': instance.firstSessionAt?.toIso8601String(),
      'lastSessionAt': instance.lastSessionAt?.toIso8601String(),
    };

_$TeacherPayoutRequestImpl _$$TeacherPayoutRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$TeacherPayoutRequestImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amountCents: (json['amountCents'] as num).toInt(),
      currency: json['currency'] as String,
      status: $enumDecode(_$PayoutStatusEnumMap, json['status']),
      bankAccountId: json['bankAccountId'] as String?,
      transactionRef: json['transactionRef'] as String?,
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      processedAt: json['processedAt'] == null
          ? null
          : DateTime.parse(json['processedAt'] as String),
    );

Map<String, dynamic> _$$TeacherPayoutRequestImplToJson(
        _$TeacherPayoutRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'amountCents': instance.amountCents,
      'currency': instance.currency,
      'status': _$PayoutStatusEnumMap[instance.status]!,
      'bankAccountId': instance.bankAccountId,
      'transactionRef': instance.transactionRef,
      'requestedAt': instance.requestedAt.toIso8601String(),
      'processedAt': instance.processedAt?.toIso8601String(),
    };

const _$PayoutStatusEnumMap = {
  PayoutStatus.PENDING: 'PENDING',
  PayoutStatus.PROCESSING: 'PROCESSING',
  PayoutStatus.PAID: 'PAID',
  PayoutStatus.FAILED: 'FAILED',
  PayoutStatus.CANCELLED: 'CANCELLED',
};

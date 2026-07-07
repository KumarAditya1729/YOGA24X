// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingItemImpl _$$BookingItemImplFromJson(Map<String, dynamic> json) =>
    _$BookingItemImpl(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      status: $enumDecode(_$BookingStatusEnumMap, json['status']),
      bookedAt: DateTime.parse(json['bookedAt'] as String),
      bookingNotes: json['bookingNotes'] as String?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      session: json['session'] == null
          ? null
          : ScheduleSession.fromJson(json['session'] as Map<String, dynamic>),
      attendance: json['attendance'] == null
          ? null
          : AttendanceRecord.fromJson(
              json['attendance'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$BookingItemImplToJson(_$BookingItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'status': _$BookingStatusEnumMap[instance.status]!,
      'bookedAt': instance.bookedAt.toIso8601String(),
      'bookingNotes': instance.bookingNotes,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'session': instance.session,
      'attendance': instance.attendance,
    };

const _$BookingStatusEnumMap = {
  BookingStatus.draft: 'DRAFT',
  BookingStatus.pending: 'PENDING',
  BookingStatus.confirmed: 'CONFIRMED',
  BookingStatus.rescheduled: 'RESCHEDULED',
  BookingStatus.checkedIn: 'CHECKED_IN',
  BookingStatus.started: 'STARTED',
  BookingStatus.completed: 'COMPLETED',
  BookingStatus.cancelled: 'CANCELLED',
  BookingStatus.expired: 'EXPIRED',
  BookingStatus.noShow: 'NO_SHOW',
  BookingStatus.refunded: 'REFUNDED',
  BookingStatus.autoClosed: 'AUTO_CLOSED',
};

_$ScheduleSessionImpl _$$ScheduleSessionImplFromJson(
        Map<String, dynamic> json) =>
    _$ScheduleSessionImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      maxParticipants: (json['maxParticipants'] as num).toInt(),
      currentBookings: (json['currentBookings'] as num).toInt(),
      meetingUrl: json['meetingUrl'] as String?,
      teacherFirstName: json['teacherFirstName'] as String?,
      teacherLastName: json['teacherLastName'] as String?,
    );

Map<String, dynamic> _$$ScheduleSessionImplToJson(
        _$ScheduleSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'maxParticipants': instance.maxParticipants,
      'currentBookings': instance.currentBookings,
      'meetingUrl': instance.meetingUrl,
      'teacherFirstName': instance.teacherFirstName,
      'teacherLastName': instance.teacherLastName,
    };

_$CalendarItemImpl _$$CalendarItemImplFromJson(Map<String, dynamic> json) =>
    _$CalendarItemImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      type: json['type'] as String,
      status: $enumDecode(_$BookingStatusEnumMap, json['status']),
      meetingUrl: json['meetingUrl'] as String?,
      instructorName: json['instructorName'] as String?,
    );

Map<String, dynamic> _$$CalendarItemImplToJson(_$CalendarItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'type': instance.type,
      'status': _$BookingStatusEnumMap[instance.status]!,
      'meetingUrl': instance.meetingUrl,
      'instructorName': instance.instructorName,
    };

_$WaitlistEntryImpl _$$WaitlistEntryImplFromJson(Map<String, dynamic> json) =>
    _$WaitlistEntryImpl(
      id: json['id'] as String,
      priority: (json['priority'] as num).toInt(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      session: json['session'] == null
          ? null
          : ScheduleSession.fromJson(json['session'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$WaitlistEntryImplToJson(_$WaitlistEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'priority': instance.priority,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'session': instance.session,
    };

_$AttendanceRecordImpl _$$AttendanceRecordImplFromJson(
        Map<String, dynamic> json) =>
    _$AttendanceRecordImpl(
      id: json['id'] as String,
      attended: json['attended'] as bool,
      checkInMethod: json['checkInMethod'] as String,
      joinedAt: json['joinedAt'] == null
          ? null
          : DateTime.parse(json['joinedAt'] as String),
      isLate: json['isLate'] as bool?,
    );

Map<String, dynamic> _$$AttendanceRecordImplToJson(
        _$AttendanceRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attended': instance.attended,
      'checkInMethod': instance.checkInMethod,
      'joinedAt': instance.joinedAt?.toIso8601String(),
      'isLate': instance.isLate,
    };

_$AvailableSlotImpl _$$AvailableSlotImplFromJson(Map<String, dynamic> json) =>
    _$AvailableSlotImpl(
      sessionId: json['sessionId'] as String,
      title: json['title'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      maxParticipants: (json['maxParticipants'] as num).toInt(),
      availableSpots: (json['availableSpots'] as num).toInt(),
    );

Map<String, dynamic> _$$AvailableSlotImplToJson(_$AvailableSlotImpl instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'title': instance.title,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'maxParticipants': instance.maxParticipants,
      'availableSpots': instance.availableSpots,
    };

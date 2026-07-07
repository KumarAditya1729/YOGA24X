// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BookingItem _$BookingItemFromJson(Map<String, dynamic> json) {
  return _BookingItem.fromJson(json);
}

/// @nodoc
mixin _$BookingItem {
  String get id => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  BookingStatus get status => throw _privateConstructorUsedError;
  DateTime get bookedAt => throw _privateConstructorUsedError;
  String? get bookingNotes => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  ScheduleSession? get session => throw _privateConstructorUsedError;
  AttendanceRecord? get attendance => throw _privateConstructorUsedError;

  /// Serializes this BookingItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingItemCopyWith<BookingItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingItemCopyWith<$Res> {
  factory $BookingItemCopyWith(
          BookingItem value, $Res Function(BookingItem) then) =
      _$BookingItemCopyWithImpl<$Res, BookingItem>;
  @useResult
  $Res call(
      {String id,
      String sessionId,
      BookingStatus status,
      DateTime bookedAt,
      String? bookingNotes,
      DateTime? expiresAt,
      ScheduleSession? session,
      AttendanceRecord? attendance});

  $ScheduleSessionCopyWith<$Res>? get session;
  $AttendanceRecordCopyWith<$Res>? get attendance;
}

/// @nodoc
class _$BookingItemCopyWithImpl<$Res, $Val extends BookingItem>
    implements $BookingItemCopyWith<$Res> {
  _$BookingItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? status = null,
    Object? bookedAt = null,
    Object? bookingNotes = freezed,
    Object? expiresAt = freezed,
    Object? session = freezed,
    Object? attendance = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      bookedAt: null == bookedAt
          ? _value.bookedAt
          : bookedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bookingNotes: freezed == bookingNotes
          ? _value.bookingNotes
          : bookingNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      session: freezed == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as ScheduleSession?,
      attendance: freezed == attendance
          ? _value.attendance
          : attendance // ignore: cast_nullable_to_non_nullable
              as AttendanceRecord?,
    ) as $Val);
  }

  /// Create a copy of BookingItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScheduleSessionCopyWith<$Res>? get session {
    if (_value.session == null) {
      return null;
    }

    return $ScheduleSessionCopyWith<$Res>(_value.session!, (value) {
      return _then(_value.copyWith(session: value) as $Val);
    });
  }

  /// Create a copy of BookingItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AttendanceRecordCopyWith<$Res>? get attendance {
    if (_value.attendance == null) {
      return null;
    }

    return $AttendanceRecordCopyWith<$Res>(_value.attendance!, (value) {
      return _then(_value.copyWith(attendance: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingItemImplCopyWith<$Res>
    implements $BookingItemCopyWith<$Res> {
  factory _$$BookingItemImplCopyWith(
          _$BookingItemImpl value, $Res Function(_$BookingItemImpl) then) =
      __$$BookingItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String sessionId,
      BookingStatus status,
      DateTime bookedAt,
      String? bookingNotes,
      DateTime? expiresAt,
      ScheduleSession? session,
      AttendanceRecord? attendance});

  @override
  $ScheduleSessionCopyWith<$Res>? get session;
  @override
  $AttendanceRecordCopyWith<$Res>? get attendance;
}

/// @nodoc
class __$$BookingItemImplCopyWithImpl<$Res>
    extends _$BookingItemCopyWithImpl<$Res, _$BookingItemImpl>
    implements _$$BookingItemImplCopyWith<$Res> {
  __$$BookingItemImplCopyWithImpl(
      _$BookingItemImpl _value, $Res Function(_$BookingItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookingItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? status = null,
    Object? bookedAt = null,
    Object? bookingNotes = freezed,
    Object? expiresAt = freezed,
    Object? session = freezed,
    Object? attendance = freezed,
  }) {
    return _then(_$BookingItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      bookedAt: null == bookedAt
          ? _value.bookedAt
          : bookedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bookingNotes: freezed == bookingNotes
          ? _value.bookingNotes
          : bookingNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      session: freezed == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as ScheduleSession?,
      attendance: freezed == attendance
          ? _value.attendance
          : attendance // ignore: cast_nullable_to_non_nullable
              as AttendanceRecord?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingItemImpl implements _BookingItem {
  const _$BookingItemImpl(
      {required this.id,
      required this.sessionId,
      required this.status,
      required this.bookedAt,
      this.bookingNotes,
      this.expiresAt,
      this.session,
      this.attendance});

  factory _$BookingItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingItemImplFromJson(json);

  @override
  final String id;
  @override
  final String sessionId;
  @override
  final BookingStatus status;
  @override
  final DateTime bookedAt;
  @override
  final String? bookingNotes;
  @override
  final DateTime? expiresAt;
  @override
  final ScheduleSession? session;
  @override
  final AttendanceRecord? attendance;

  @override
  String toString() {
    return 'BookingItem(id: $id, sessionId: $sessionId, status: $status, bookedAt: $bookedAt, bookingNotes: $bookingNotes, expiresAt: $expiresAt, session: $session, attendance: $attendance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.bookedAt, bookedAt) ||
                other.bookedAt == bookedAt) &&
            (identical(other.bookingNotes, bookingNotes) ||
                other.bookingNotes == bookingNotes) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.attendance, attendance) ||
                other.attendance == attendance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, sessionId, status, bookedAt,
      bookingNotes, expiresAt, session, attendance);

  /// Create a copy of BookingItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingItemImplCopyWith<_$BookingItemImpl> get copyWith =>
      __$$BookingItemImplCopyWithImpl<_$BookingItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingItemImplToJson(
      this,
    );
  }
}

abstract class _BookingItem implements BookingItem {
  const factory _BookingItem(
      {required final String id,
      required final String sessionId,
      required final BookingStatus status,
      required final DateTime bookedAt,
      final String? bookingNotes,
      final DateTime? expiresAt,
      final ScheduleSession? session,
      final AttendanceRecord? attendance}) = _$BookingItemImpl;

  factory _BookingItem.fromJson(Map<String, dynamic> json) =
      _$BookingItemImpl.fromJson;

  @override
  String get id;
  @override
  String get sessionId;
  @override
  BookingStatus get status;
  @override
  DateTime get bookedAt;
  @override
  String? get bookingNotes;
  @override
  DateTime? get expiresAt;
  @override
  ScheduleSession? get session;
  @override
  AttendanceRecord? get attendance;

  /// Create a copy of BookingItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingItemImplCopyWith<_$BookingItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScheduleSession _$ScheduleSessionFromJson(Map<String, dynamic> json) {
  return _ScheduleSession.fromJson(json);
}

/// @nodoc
mixin _$ScheduleSession {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  int get maxParticipants => throw _privateConstructorUsedError;
  int get currentBookings => throw _privateConstructorUsedError;
  String? get meetingUrl => throw _privateConstructorUsedError;
  String? get teacherFirstName => throw _privateConstructorUsedError;
  String? get teacherLastName => throw _privateConstructorUsedError;

  /// Serializes this ScheduleSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleSessionCopyWith<ScheduleSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleSessionCopyWith<$Res> {
  factory $ScheduleSessionCopyWith(
          ScheduleSession value, $Res Function(ScheduleSession) then) =
      _$ScheduleSessionCopyWithImpl<$Res, ScheduleSession>;
  @useResult
  $Res call(
      {String id,
      String title,
      DateTime startTime,
      DateTime endTime,
      int maxParticipants,
      int currentBookings,
      String? meetingUrl,
      String? teacherFirstName,
      String? teacherLastName});
}

/// @nodoc
class _$ScheduleSessionCopyWithImpl<$Res, $Val extends ScheduleSession>
    implements $ScheduleSessionCopyWith<$Res> {
  _$ScheduleSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? maxParticipants = null,
    Object? currentBookings = null,
    Object? meetingUrl = freezed,
    Object? teacherFirstName = freezed,
    Object? teacherLastName = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      maxParticipants: null == maxParticipants
          ? _value.maxParticipants
          : maxParticipants // ignore: cast_nullable_to_non_nullable
              as int,
      currentBookings: null == currentBookings
          ? _value.currentBookings
          : currentBookings // ignore: cast_nullable_to_non_nullable
              as int,
      meetingUrl: freezed == meetingUrl
          ? _value.meetingUrl
          : meetingUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      teacherFirstName: freezed == teacherFirstName
          ? _value.teacherFirstName
          : teacherFirstName // ignore: cast_nullable_to_non_nullable
              as String?,
      teacherLastName: freezed == teacherLastName
          ? _value.teacherLastName
          : teacherLastName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleSessionImplCopyWith<$Res>
    implements $ScheduleSessionCopyWith<$Res> {
  factory _$$ScheduleSessionImplCopyWith(_$ScheduleSessionImpl value,
          $Res Function(_$ScheduleSessionImpl) then) =
      __$$ScheduleSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      DateTime startTime,
      DateTime endTime,
      int maxParticipants,
      int currentBookings,
      String? meetingUrl,
      String? teacherFirstName,
      String? teacherLastName});
}

/// @nodoc
class __$$ScheduleSessionImplCopyWithImpl<$Res>
    extends _$ScheduleSessionCopyWithImpl<$Res, _$ScheduleSessionImpl>
    implements _$$ScheduleSessionImplCopyWith<$Res> {
  __$$ScheduleSessionImplCopyWithImpl(
      _$ScheduleSessionImpl _value, $Res Function(_$ScheduleSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScheduleSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? maxParticipants = null,
    Object? currentBookings = null,
    Object? meetingUrl = freezed,
    Object? teacherFirstName = freezed,
    Object? teacherLastName = freezed,
  }) {
    return _then(_$ScheduleSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      maxParticipants: null == maxParticipants
          ? _value.maxParticipants
          : maxParticipants // ignore: cast_nullable_to_non_nullable
              as int,
      currentBookings: null == currentBookings
          ? _value.currentBookings
          : currentBookings // ignore: cast_nullable_to_non_nullable
              as int,
      meetingUrl: freezed == meetingUrl
          ? _value.meetingUrl
          : meetingUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      teacherFirstName: freezed == teacherFirstName
          ? _value.teacherFirstName
          : teacherFirstName // ignore: cast_nullable_to_non_nullable
              as String?,
      teacherLastName: freezed == teacherLastName
          ? _value.teacherLastName
          : teacherLastName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleSessionImpl implements _ScheduleSession {
  const _$ScheduleSessionImpl(
      {required this.id,
      required this.title,
      required this.startTime,
      required this.endTime,
      required this.maxParticipants,
      required this.currentBookings,
      this.meetingUrl,
      this.teacherFirstName,
      this.teacherLastName});

  factory _$ScheduleSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final int maxParticipants;
  @override
  final int currentBookings;
  @override
  final String? meetingUrl;
  @override
  final String? teacherFirstName;
  @override
  final String? teacherLastName;

  @override
  String toString() {
    return 'ScheduleSession(id: $id, title: $title, startTime: $startTime, endTime: $endTime, maxParticipants: $maxParticipants, currentBookings: $currentBookings, meetingUrl: $meetingUrl, teacherFirstName: $teacherFirstName, teacherLastName: $teacherLastName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.maxParticipants, maxParticipants) ||
                other.maxParticipants == maxParticipants) &&
            (identical(other.currentBookings, currentBookings) ||
                other.currentBookings == currentBookings) &&
            (identical(other.meetingUrl, meetingUrl) ||
                other.meetingUrl == meetingUrl) &&
            (identical(other.teacherFirstName, teacherFirstName) ||
                other.teacherFirstName == teacherFirstName) &&
            (identical(other.teacherLastName, teacherLastName) ||
                other.teacherLastName == teacherLastName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      startTime,
      endTime,
      maxParticipants,
      currentBookings,
      meetingUrl,
      teacherFirstName,
      teacherLastName);

  /// Create a copy of ScheduleSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleSessionImplCopyWith<_$ScheduleSessionImpl> get copyWith =>
      __$$ScheduleSessionImplCopyWithImpl<_$ScheduleSessionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleSessionImplToJson(
      this,
    );
  }
}

abstract class _ScheduleSession implements ScheduleSession {
  const factory _ScheduleSession(
      {required final String id,
      required final String title,
      required final DateTime startTime,
      required final DateTime endTime,
      required final int maxParticipants,
      required final int currentBookings,
      final String? meetingUrl,
      final String? teacherFirstName,
      final String? teacherLastName}) = _$ScheduleSessionImpl;

  factory _ScheduleSession.fromJson(Map<String, dynamic> json) =
      _$ScheduleSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  int get maxParticipants;
  @override
  int get currentBookings;
  @override
  String? get meetingUrl;
  @override
  String? get teacherFirstName;
  @override
  String? get teacherLastName;

  /// Create a copy of ScheduleSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleSessionImplCopyWith<_$ScheduleSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CalendarItem _$CalendarItemFromJson(Map<String, dynamic> json) {
  return _CalendarItem.fromJson(json);
}

/// @nodoc
mixin _$CalendarItem {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError; // 'SESSION' | 'EVENT'
  BookingStatus get status => throw _privateConstructorUsedError;
  String? get meetingUrl => throw _privateConstructorUsedError;
  String? get instructorName => throw _privateConstructorUsedError;

  /// Serializes this CalendarItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CalendarItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalendarItemCopyWith<CalendarItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarItemCopyWith<$Res> {
  factory $CalendarItemCopyWith(
          CalendarItem value, $Res Function(CalendarItem) then) =
      _$CalendarItemCopyWithImpl<$Res, CalendarItem>;
  @useResult
  $Res call(
      {String id,
      String title,
      DateTime startTime,
      DateTime endTime,
      String type,
      BookingStatus status,
      String? meetingUrl,
      String? instructorName});
}

/// @nodoc
class _$CalendarItemCopyWithImpl<$Res, $Val extends CalendarItem>
    implements $CalendarItemCopyWith<$Res> {
  _$CalendarItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalendarItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? type = null,
    Object? status = null,
    Object? meetingUrl = freezed,
    Object? instructorName = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      meetingUrl: freezed == meetingUrl
          ? _value.meetingUrl
          : meetingUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      instructorName: freezed == instructorName
          ? _value.instructorName
          : instructorName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CalendarItemImplCopyWith<$Res>
    implements $CalendarItemCopyWith<$Res> {
  factory _$$CalendarItemImplCopyWith(
          _$CalendarItemImpl value, $Res Function(_$CalendarItemImpl) then) =
      __$$CalendarItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      DateTime startTime,
      DateTime endTime,
      String type,
      BookingStatus status,
      String? meetingUrl,
      String? instructorName});
}

/// @nodoc
class __$$CalendarItemImplCopyWithImpl<$Res>
    extends _$CalendarItemCopyWithImpl<$Res, _$CalendarItemImpl>
    implements _$$CalendarItemImplCopyWith<$Res> {
  __$$CalendarItemImplCopyWithImpl(
      _$CalendarItemImpl _value, $Res Function(_$CalendarItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of CalendarItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? type = null,
    Object? status = null,
    Object? meetingUrl = freezed,
    Object? instructorName = freezed,
  }) {
    return _then(_$CalendarItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      meetingUrl: freezed == meetingUrl
          ? _value.meetingUrl
          : meetingUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      instructorName: freezed == instructorName
          ? _value.instructorName
          : instructorName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CalendarItemImpl implements _CalendarItem {
  const _$CalendarItemImpl(
      {required this.id,
      required this.title,
      required this.startTime,
      required this.endTime,
      required this.type,
      required this.status,
      this.meetingUrl,
      this.instructorName});

  factory _$CalendarItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CalendarItemImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final String type;
// 'SESSION' | 'EVENT'
  @override
  final BookingStatus status;
  @override
  final String? meetingUrl;
  @override
  final String? instructorName;

  @override
  String toString() {
    return 'CalendarItem(id: $id, title: $title, startTime: $startTime, endTime: $endTime, type: $type, status: $status, meetingUrl: $meetingUrl, instructorName: $instructorName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.meetingUrl, meetingUrl) ||
                other.meetingUrl == meetingUrl) &&
            (identical(other.instructorName, instructorName) ||
                other.instructorName == instructorName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, startTime, endTime,
      type, status, meetingUrl, instructorName);

  /// Create a copy of CalendarItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarItemImplCopyWith<_$CalendarItemImpl> get copyWith =>
      __$$CalendarItemImplCopyWithImpl<_$CalendarItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CalendarItemImplToJson(
      this,
    );
  }
}

abstract class _CalendarItem implements CalendarItem {
  const factory _CalendarItem(
      {required final String id,
      required final String title,
      required final DateTime startTime,
      required final DateTime endTime,
      required final String type,
      required final BookingStatus status,
      final String? meetingUrl,
      final String? instructorName}) = _$CalendarItemImpl;

  factory _CalendarItem.fromJson(Map<String, dynamic> json) =
      _$CalendarItemImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  String get type; // 'SESSION' | 'EVENT'
  @override
  BookingStatus get status;
  @override
  String? get meetingUrl;
  @override
  String? get instructorName;

  /// Create a copy of CalendarItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalendarItemImplCopyWith<_$CalendarItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WaitlistEntry _$WaitlistEntryFromJson(Map<String, dynamic> json) {
  return _WaitlistEntry.fromJson(json);
}

/// @nodoc
mixin _$WaitlistEntry {
  String get id => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  ScheduleSession? get session => throw _privateConstructorUsedError;

  /// Serializes this WaitlistEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WaitlistEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WaitlistEntryCopyWith<WaitlistEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaitlistEntryCopyWith<$Res> {
  factory $WaitlistEntryCopyWith(
          WaitlistEntry value, $Res Function(WaitlistEntry) then) =
      _$WaitlistEntryCopyWithImpl<$Res, WaitlistEntry>;
  @useResult
  $Res call(
      {String id,
      int priority,
      String status,
      DateTime createdAt,
      DateTime? expiresAt,
      ScheduleSession? session});

  $ScheduleSessionCopyWith<$Res>? get session;
}

/// @nodoc
class _$WaitlistEntryCopyWithImpl<$Res, $Val extends WaitlistEntry>
    implements $WaitlistEntryCopyWith<$Res> {
  _$WaitlistEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WaitlistEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? priority = null,
    Object? status = null,
    Object? createdAt = null,
    Object? expiresAt = freezed,
    Object? session = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      session: freezed == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as ScheduleSession?,
    ) as $Val);
  }

  /// Create a copy of WaitlistEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScheduleSessionCopyWith<$Res>? get session {
    if (_value.session == null) {
      return null;
    }

    return $ScheduleSessionCopyWith<$Res>(_value.session!, (value) {
      return _then(_value.copyWith(session: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WaitlistEntryImplCopyWith<$Res>
    implements $WaitlistEntryCopyWith<$Res> {
  factory _$$WaitlistEntryImplCopyWith(
          _$WaitlistEntryImpl value, $Res Function(_$WaitlistEntryImpl) then) =
      __$$WaitlistEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int priority,
      String status,
      DateTime createdAt,
      DateTime? expiresAt,
      ScheduleSession? session});

  @override
  $ScheduleSessionCopyWith<$Res>? get session;
}

/// @nodoc
class __$$WaitlistEntryImplCopyWithImpl<$Res>
    extends _$WaitlistEntryCopyWithImpl<$Res, _$WaitlistEntryImpl>
    implements _$$WaitlistEntryImplCopyWith<$Res> {
  __$$WaitlistEntryImplCopyWithImpl(
      _$WaitlistEntryImpl _value, $Res Function(_$WaitlistEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of WaitlistEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? priority = null,
    Object? status = null,
    Object? createdAt = null,
    Object? expiresAt = freezed,
    Object? session = freezed,
  }) {
    return _then(_$WaitlistEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      session: freezed == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as ScheduleSession?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WaitlistEntryImpl implements _WaitlistEntry {
  const _$WaitlistEntryImpl(
      {required this.id,
      required this.priority,
      required this.status,
      required this.createdAt,
      this.expiresAt,
      this.session});

  factory _$WaitlistEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$WaitlistEntryImplFromJson(json);

  @override
  final String id;
  @override
  final int priority;
  @override
  final String status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? expiresAt;
  @override
  final ScheduleSession? session;

  @override
  String toString() {
    return 'WaitlistEntry(id: $id, priority: $priority, status: $status, createdAt: $createdAt, expiresAt: $expiresAt, session: $session)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaitlistEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.session, session) || other.session == session));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, priority, status, createdAt, expiresAt, session);

  /// Create a copy of WaitlistEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WaitlistEntryImplCopyWith<_$WaitlistEntryImpl> get copyWith =>
      __$$WaitlistEntryImplCopyWithImpl<_$WaitlistEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WaitlistEntryImplToJson(
      this,
    );
  }
}

abstract class _WaitlistEntry implements WaitlistEntry {
  const factory _WaitlistEntry(
      {required final String id,
      required final int priority,
      required final String status,
      required final DateTime createdAt,
      final DateTime? expiresAt,
      final ScheduleSession? session}) = _$WaitlistEntryImpl;

  factory _WaitlistEntry.fromJson(Map<String, dynamic> json) =
      _$WaitlistEntryImpl.fromJson;

  @override
  String get id;
  @override
  int get priority;
  @override
  String get status;
  @override
  DateTime get createdAt;
  @override
  DateTime? get expiresAt;
  @override
  ScheduleSession? get session;

  /// Create a copy of WaitlistEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WaitlistEntryImplCopyWith<_$WaitlistEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AttendanceRecord _$AttendanceRecordFromJson(Map<String, dynamic> json) {
  return _AttendanceRecord.fromJson(json);
}

/// @nodoc
mixin _$AttendanceRecord {
  String get id => throw _privateConstructorUsedError;
  bool get attended => throw _privateConstructorUsedError;
  String get checkInMethod => throw _privateConstructorUsedError;
  DateTime? get joinedAt => throw _privateConstructorUsedError;
  bool? get isLate => throw _privateConstructorUsedError;

  /// Serializes this AttendanceRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AttendanceRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttendanceRecordCopyWith<AttendanceRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendanceRecordCopyWith<$Res> {
  factory $AttendanceRecordCopyWith(
          AttendanceRecord value, $Res Function(AttendanceRecord) then) =
      _$AttendanceRecordCopyWithImpl<$Res, AttendanceRecord>;
  @useResult
  $Res call(
      {String id,
      bool attended,
      String checkInMethod,
      DateTime? joinedAt,
      bool? isLate});
}

/// @nodoc
class _$AttendanceRecordCopyWithImpl<$Res, $Val extends AttendanceRecord>
    implements $AttendanceRecordCopyWith<$Res> {
  _$AttendanceRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AttendanceRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? attended = null,
    Object? checkInMethod = null,
    Object? joinedAt = freezed,
    Object? isLate = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      attended: null == attended
          ? _value.attended
          : attended // ignore: cast_nullable_to_non_nullable
              as bool,
      checkInMethod: null == checkInMethod
          ? _value.checkInMethod
          : checkInMethod // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: freezed == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isLate: freezed == isLate
          ? _value.isLate
          : isLate // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AttendanceRecordImplCopyWith<$Res>
    implements $AttendanceRecordCopyWith<$Res> {
  factory _$$AttendanceRecordImplCopyWith(_$AttendanceRecordImpl value,
          $Res Function(_$AttendanceRecordImpl) then) =
      __$$AttendanceRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      bool attended,
      String checkInMethod,
      DateTime? joinedAt,
      bool? isLate});
}

/// @nodoc
class __$$AttendanceRecordImplCopyWithImpl<$Res>
    extends _$AttendanceRecordCopyWithImpl<$Res, _$AttendanceRecordImpl>
    implements _$$AttendanceRecordImplCopyWith<$Res> {
  __$$AttendanceRecordImplCopyWithImpl(_$AttendanceRecordImpl _value,
      $Res Function(_$AttendanceRecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of AttendanceRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? attended = null,
    Object? checkInMethod = null,
    Object? joinedAt = freezed,
    Object? isLate = freezed,
  }) {
    return _then(_$AttendanceRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      attended: null == attended
          ? _value.attended
          : attended // ignore: cast_nullable_to_non_nullable
              as bool,
      checkInMethod: null == checkInMethod
          ? _value.checkInMethod
          : checkInMethod // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: freezed == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isLate: freezed == isLate
          ? _value.isLate
          : isLate // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AttendanceRecordImpl implements _AttendanceRecord {
  const _$AttendanceRecordImpl(
      {required this.id,
      required this.attended,
      required this.checkInMethod,
      this.joinedAt,
      this.isLate});

  factory _$AttendanceRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttendanceRecordImplFromJson(json);

  @override
  final String id;
  @override
  final bool attended;
  @override
  final String checkInMethod;
  @override
  final DateTime? joinedAt;
  @override
  final bool? isLate;

  @override
  String toString() {
    return 'AttendanceRecord(id: $id, attended: $attended, checkInMethod: $checkInMethod, joinedAt: $joinedAt, isLate: $isLate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendanceRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.attended, attended) ||
                other.attended == attended) &&
            (identical(other.checkInMethod, checkInMethod) ||
                other.checkInMethod == checkInMethod) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt) &&
            (identical(other.isLate, isLate) || other.isLate == isLate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, attended, checkInMethod, joinedAt, isLate);

  /// Create a copy of AttendanceRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttendanceRecordImplCopyWith<_$AttendanceRecordImpl> get copyWith =>
      __$$AttendanceRecordImplCopyWithImpl<_$AttendanceRecordImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttendanceRecordImplToJson(
      this,
    );
  }
}

abstract class _AttendanceRecord implements AttendanceRecord {
  const factory _AttendanceRecord(
      {required final String id,
      required final bool attended,
      required final String checkInMethod,
      final DateTime? joinedAt,
      final bool? isLate}) = _$AttendanceRecordImpl;

  factory _AttendanceRecord.fromJson(Map<String, dynamic> json) =
      _$AttendanceRecordImpl.fromJson;

  @override
  String get id;
  @override
  bool get attended;
  @override
  String get checkInMethod;
  @override
  DateTime? get joinedAt;
  @override
  bool? get isLate;

  /// Create a copy of AttendanceRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttendanceRecordImplCopyWith<_$AttendanceRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AvailableSlot _$AvailableSlotFromJson(Map<String, dynamic> json) {
  return _AvailableSlot.fromJson(json);
}

/// @nodoc
mixin _$AvailableSlot {
  String get sessionId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  int get maxParticipants => throw _privateConstructorUsedError;
  int get availableSpots => throw _privateConstructorUsedError;

  /// Serializes this AvailableSlot to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AvailableSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AvailableSlotCopyWith<AvailableSlot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailableSlotCopyWith<$Res> {
  factory $AvailableSlotCopyWith(
          AvailableSlot value, $Res Function(AvailableSlot) then) =
      _$AvailableSlotCopyWithImpl<$Res, AvailableSlot>;
  @useResult
  $Res call(
      {String sessionId,
      String title,
      DateTime startTime,
      DateTime endTime,
      int maxParticipants,
      int availableSpots});
}

/// @nodoc
class _$AvailableSlotCopyWithImpl<$Res, $Val extends AvailableSlot>
    implements $AvailableSlotCopyWith<$Res> {
  _$AvailableSlotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AvailableSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? title = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? maxParticipants = null,
    Object? availableSpots = null,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      maxParticipants: null == maxParticipants
          ? _value.maxParticipants
          : maxParticipants // ignore: cast_nullable_to_non_nullable
              as int,
      availableSpots: null == availableSpots
          ? _value.availableSpots
          : availableSpots // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AvailableSlotImplCopyWith<$Res>
    implements $AvailableSlotCopyWith<$Res> {
  factory _$$AvailableSlotImplCopyWith(
          _$AvailableSlotImpl value, $Res Function(_$AvailableSlotImpl) then) =
      __$$AvailableSlotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      String title,
      DateTime startTime,
      DateTime endTime,
      int maxParticipants,
      int availableSpots});
}

/// @nodoc
class __$$AvailableSlotImplCopyWithImpl<$Res>
    extends _$AvailableSlotCopyWithImpl<$Res, _$AvailableSlotImpl>
    implements _$$AvailableSlotImplCopyWith<$Res> {
  __$$AvailableSlotImplCopyWithImpl(
      _$AvailableSlotImpl _value, $Res Function(_$AvailableSlotImpl) _then)
      : super(_value, _then);

  /// Create a copy of AvailableSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? title = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? maxParticipants = null,
    Object? availableSpots = null,
  }) {
    return _then(_$AvailableSlotImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      maxParticipants: null == maxParticipants
          ? _value.maxParticipants
          : maxParticipants // ignore: cast_nullable_to_non_nullable
              as int,
      availableSpots: null == availableSpots
          ? _value.availableSpots
          : availableSpots // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailableSlotImpl implements _AvailableSlot {
  const _$AvailableSlotImpl(
      {required this.sessionId,
      required this.title,
      required this.startTime,
      required this.endTime,
      required this.maxParticipants,
      required this.availableSpots});

  factory _$AvailableSlotImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailableSlotImplFromJson(json);

  @override
  final String sessionId;
  @override
  final String title;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final int maxParticipants;
  @override
  final int availableSpots;

  @override
  String toString() {
    return 'AvailableSlot(sessionId: $sessionId, title: $title, startTime: $startTime, endTime: $endTime, maxParticipants: $maxParticipants, availableSpots: $availableSpots)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailableSlotImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.maxParticipants, maxParticipants) ||
                other.maxParticipants == maxParticipants) &&
            (identical(other.availableSpots, availableSpots) ||
                other.availableSpots == availableSpots));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sessionId, title, startTime,
      endTime, maxParticipants, availableSpots);

  /// Create a copy of AvailableSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailableSlotImplCopyWith<_$AvailableSlotImpl> get copyWith =>
      __$$AvailableSlotImplCopyWithImpl<_$AvailableSlotImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailableSlotImplToJson(
      this,
    );
  }
}

abstract class _AvailableSlot implements AvailableSlot {
  const factory _AvailableSlot(
      {required final String sessionId,
      required final String title,
      required final DateTime startTime,
      required final DateTime endTime,
      required final int maxParticipants,
      required final int availableSpots}) = _$AvailableSlotImpl;

  factory _AvailableSlot.fromJson(Map<String, dynamic> json) =
      _$AvailableSlotImpl.fromJson;

  @override
  String get sessionId;
  @override
  String get title;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  int get maxParticipants;
  @override
  int get availableSpots;

  /// Create a copy of AvailableSlot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AvailableSlotImplCopyWith<_$AvailableSlotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

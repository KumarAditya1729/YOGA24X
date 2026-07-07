// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_operations_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TeacherBookingRule _$TeacherBookingRuleFromJson(Map<String, dynamic> json) {
  return _TeacherBookingRule.fromJson(json);
}

/// @nodoc
mixin _$TeacherBookingRule {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  int get advanceBookingDays => throw _privateConstructorUsedError;
  int get minimumNoticeHours => throw _privateConstructorUsedError;
  int get cancellationWindowHours => throw _privateConstructorUsedError;
  int get reschedulePolicyHours => throw _privateConstructorUsedError;
  int get bufferTimeMinutes => throw _privateConstructorUsedError;
  int? get maxDailySessions => throw _privateConstructorUsedError;
  int? get maxWeeklyHours => throw _privateConstructorUsedError;
  int get lateArrivalGraceMins => throw _privateConstructorUsedError;
  bool get preventOverbooking => throw _privateConstructorUsedError;
  bool get allowWaitlist => throw _privateConstructorUsedError;

  /// Serializes this TeacherBookingRule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeacherBookingRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherBookingRuleCopyWith<TeacherBookingRule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherBookingRuleCopyWith<$Res> {
  factory $TeacherBookingRuleCopyWith(
          TeacherBookingRule value, $Res Function(TeacherBookingRule) then) =
      _$TeacherBookingRuleCopyWithImpl<$Res, TeacherBookingRule>;
  @useResult
  $Res call(
      {String id,
      String userId,
      int advanceBookingDays,
      int minimumNoticeHours,
      int cancellationWindowHours,
      int reschedulePolicyHours,
      int bufferTimeMinutes,
      int? maxDailySessions,
      int? maxWeeklyHours,
      int lateArrivalGraceMins,
      bool preventOverbooking,
      bool allowWaitlist});
}

/// @nodoc
class _$TeacherBookingRuleCopyWithImpl<$Res, $Val extends TeacherBookingRule>
    implements $TeacherBookingRuleCopyWith<$Res> {
  _$TeacherBookingRuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeacherBookingRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? advanceBookingDays = null,
    Object? minimumNoticeHours = null,
    Object? cancellationWindowHours = null,
    Object? reschedulePolicyHours = null,
    Object? bufferTimeMinutes = null,
    Object? maxDailySessions = freezed,
    Object? maxWeeklyHours = freezed,
    Object? lateArrivalGraceMins = null,
    Object? preventOverbooking = null,
    Object? allowWaitlist = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      advanceBookingDays: null == advanceBookingDays
          ? _value.advanceBookingDays
          : advanceBookingDays // ignore: cast_nullable_to_non_nullable
              as int,
      minimumNoticeHours: null == minimumNoticeHours
          ? _value.minimumNoticeHours
          : minimumNoticeHours // ignore: cast_nullable_to_non_nullable
              as int,
      cancellationWindowHours: null == cancellationWindowHours
          ? _value.cancellationWindowHours
          : cancellationWindowHours // ignore: cast_nullable_to_non_nullable
              as int,
      reschedulePolicyHours: null == reschedulePolicyHours
          ? _value.reschedulePolicyHours
          : reschedulePolicyHours // ignore: cast_nullable_to_non_nullable
              as int,
      bufferTimeMinutes: null == bufferTimeMinutes
          ? _value.bufferTimeMinutes
          : bufferTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      maxDailySessions: freezed == maxDailySessions
          ? _value.maxDailySessions
          : maxDailySessions // ignore: cast_nullable_to_non_nullable
              as int?,
      maxWeeklyHours: freezed == maxWeeklyHours
          ? _value.maxWeeklyHours
          : maxWeeklyHours // ignore: cast_nullable_to_non_nullable
              as int?,
      lateArrivalGraceMins: null == lateArrivalGraceMins
          ? _value.lateArrivalGraceMins
          : lateArrivalGraceMins // ignore: cast_nullable_to_non_nullable
              as int,
      preventOverbooking: null == preventOverbooking
          ? _value.preventOverbooking
          : preventOverbooking // ignore: cast_nullable_to_non_nullable
              as bool,
      allowWaitlist: null == allowWaitlist
          ? _value.allowWaitlist
          : allowWaitlist // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeacherBookingRuleImplCopyWith<$Res>
    implements $TeacherBookingRuleCopyWith<$Res> {
  factory _$$TeacherBookingRuleImplCopyWith(_$TeacherBookingRuleImpl value,
          $Res Function(_$TeacherBookingRuleImpl) then) =
      __$$TeacherBookingRuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      int advanceBookingDays,
      int minimumNoticeHours,
      int cancellationWindowHours,
      int reschedulePolicyHours,
      int bufferTimeMinutes,
      int? maxDailySessions,
      int? maxWeeklyHours,
      int lateArrivalGraceMins,
      bool preventOverbooking,
      bool allowWaitlist});
}

/// @nodoc
class __$$TeacherBookingRuleImplCopyWithImpl<$Res>
    extends _$TeacherBookingRuleCopyWithImpl<$Res, _$TeacherBookingRuleImpl>
    implements _$$TeacherBookingRuleImplCopyWith<$Res> {
  __$$TeacherBookingRuleImplCopyWithImpl(_$TeacherBookingRuleImpl _value,
      $Res Function(_$TeacherBookingRuleImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeacherBookingRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? advanceBookingDays = null,
    Object? minimumNoticeHours = null,
    Object? cancellationWindowHours = null,
    Object? reschedulePolicyHours = null,
    Object? bufferTimeMinutes = null,
    Object? maxDailySessions = freezed,
    Object? maxWeeklyHours = freezed,
    Object? lateArrivalGraceMins = null,
    Object? preventOverbooking = null,
    Object? allowWaitlist = null,
  }) {
    return _then(_$TeacherBookingRuleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      advanceBookingDays: null == advanceBookingDays
          ? _value.advanceBookingDays
          : advanceBookingDays // ignore: cast_nullable_to_non_nullable
              as int,
      minimumNoticeHours: null == minimumNoticeHours
          ? _value.minimumNoticeHours
          : minimumNoticeHours // ignore: cast_nullable_to_non_nullable
              as int,
      cancellationWindowHours: null == cancellationWindowHours
          ? _value.cancellationWindowHours
          : cancellationWindowHours // ignore: cast_nullable_to_non_nullable
              as int,
      reschedulePolicyHours: null == reschedulePolicyHours
          ? _value.reschedulePolicyHours
          : reschedulePolicyHours // ignore: cast_nullable_to_non_nullable
              as int,
      bufferTimeMinutes: null == bufferTimeMinutes
          ? _value.bufferTimeMinutes
          : bufferTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      maxDailySessions: freezed == maxDailySessions
          ? _value.maxDailySessions
          : maxDailySessions // ignore: cast_nullable_to_non_nullable
              as int?,
      maxWeeklyHours: freezed == maxWeeklyHours
          ? _value.maxWeeklyHours
          : maxWeeklyHours // ignore: cast_nullable_to_non_nullable
              as int?,
      lateArrivalGraceMins: null == lateArrivalGraceMins
          ? _value.lateArrivalGraceMins
          : lateArrivalGraceMins // ignore: cast_nullable_to_non_nullable
              as int,
      preventOverbooking: null == preventOverbooking
          ? _value.preventOverbooking
          : preventOverbooking // ignore: cast_nullable_to_non_nullable
              as bool,
      allowWaitlist: null == allowWaitlist
          ? _value.allowWaitlist
          : allowWaitlist // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherBookingRuleImpl implements _TeacherBookingRule {
  const _$TeacherBookingRuleImpl(
      {required this.id,
      required this.userId,
      required this.advanceBookingDays,
      required this.minimumNoticeHours,
      required this.cancellationWindowHours,
      required this.reschedulePolicyHours,
      required this.bufferTimeMinutes,
      this.maxDailySessions,
      this.maxWeeklyHours,
      required this.lateArrivalGraceMins,
      required this.preventOverbooking,
      required this.allowWaitlist});

  factory _$TeacherBookingRuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherBookingRuleImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final int advanceBookingDays;
  @override
  final int minimumNoticeHours;
  @override
  final int cancellationWindowHours;
  @override
  final int reschedulePolicyHours;
  @override
  final int bufferTimeMinutes;
  @override
  final int? maxDailySessions;
  @override
  final int? maxWeeklyHours;
  @override
  final int lateArrivalGraceMins;
  @override
  final bool preventOverbooking;
  @override
  final bool allowWaitlist;

  @override
  String toString() {
    return 'TeacherBookingRule(id: $id, userId: $userId, advanceBookingDays: $advanceBookingDays, minimumNoticeHours: $minimumNoticeHours, cancellationWindowHours: $cancellationWindowHours, reschedulePolicyHours: $reschedulePolicyHours, bufferTimeMinutes: $bufferTimeMinutes, maxDailySessions: $maxDailySessions, maxWeeklyHours: $maxWeeklyHours, lateArrivalGraceMins: $lateArrivalGraceMins, preventOverbooking: $preventOverbooking, allowWaitlist: $allowWaitlist)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherBookingRuleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.advanceBookingDays, advanceBookingDays) ||
                other.advanceBookingDays == advanceBookingDays) &&
            (identical(other.minimumNoticeHours, minimumNoticeHours) ||
                other.minimumNoticeHours == minimumNoticeHours) &&
            (identical(
                    other.cancellationWindowHours, cancellationWindowHours) ||
                other.cancellationWindowHours == cancellationWindowHours) &&
            (identical(other.reschedulePolicyHours, reschedulePolicyHours) ||
                other.reschedulePolicyHours == reschedulePolicyHours) &&
            (identical(other.bufferTimeMinutes, bufferTimeMinutes) ||
                other.bufferTimeMinutes == bufferTimeMinutes) &&
            (identical(other.maxDailySessions, maxDailySessions) ||
                other.maxDailySessions == maxDailySessions) &&
            (identical(other.maxWeeklyHours, maxWeeklyHours) ||
                other.maxWeeklyHours == maxWeeklyHours) &&
            (identical(other.lateArrivalGraceMins, lateArrivalGraceMins) ||
                other.lateArrivalGraceMins == lateArrivalGraceMins) &&
            (identical(other.preventOverbooking, preventOverbooking) ||
                other.preventOverbooking == preventOverbooking) &&
            (identical(other.allowWaitlist, allowWaitlist) ||
                other.allowWaitlist == allowWaitlist));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      advanceBookingDays,
      minimumNoticeHours,
      cancellationWindowHours,
      reschedulePolicyHours,
      bufferTimeMinutes,
      maxDailySessions,
      maxWeeklyHours,
      lateArrivalGraceMins,
      preventOverbooking,
      allowWaitlist);

  /// Create a copy of TeacherBookingRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherBookingRuleImplCopyWith<_$TeacherBookingRuleImpl> get copyWith =>
      __$$TeacherBookingRuleImplCopyWithImpl<_$TeacherBookingRuleImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherBookingRuleImplToJson(
      this,
    );
  }
}

abstract class _TeacherBookingRule implements TeacherBookingRule {
  const factory _TeacherBookingRule(
      {required final String id,
      required final String userId,
      required final int advanceBookingDays,
      required final int minimumNoticeHours,
      required final int cancellationWindowHours,
      required final int reschedulePolicyHours,
      required final int bufferTimeMinutes,
      final int? maxDailySessions,
      final int? maxWeeklyHours,
      required final int lateArrivalGraceMins,
      required final bool preventOverbooking,
      required final bool allowWaitlist}) = _$TeacherBookingRuleImpl;

  factory _TeacherBookingRule.fromJson(Map<String, dynamic> json) =
      _$TeacherBookingRuleImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  int get advanceBookingDays;
  @override
  int get minimumNoticeHours;
  @override
  int get cancellationWindowHours;
  @override
  int get reschedulePolicyHours;
  @override
  int get bufferTimeMinutes;
  @override
  int? get maxDailySessions;
  @override
  int? get maxWeeklyHours;
  @override
  int get lateArrivalGraceMins;
  @override
  bool get preventOverbooking;
  @override
  bool get allowWaitlist;

  /// Create a copy of TeacherBookingRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherBookingRuleImplCopyWith<_$TeacherBookingRuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeacherHoliday _$TeacherHolidayFromJson(Map<String, dynamic> json) {
  return _TeacherHoliday.fromJson(json);
}

/// @nodoc
mixin _$TeacherHoliday {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  bool get isEmergency => throw _privateConstructorUsedError;

  /// Serializes this TeacherHoliday to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeacherHoliday
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherHolidayCopyWith<TeacherHoliday> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherHolidayCopyWith<$Res> {
  factory $TeacherHolidayCopyWith(
          TeacherHoliday value, $Res Function(TeacherHoliday) then) =
      _$TeacherHolidayCopyWithImpl<$Res, TeacherHoliday>;
  @useResult
  $Res call(
      {String id,
      String userId,
      DateTime startDate,
      DateTime endDate,
      String? reason,
      bool isEmergency});
}

/// @nodoc
class _$TeacherHolidayCopyWithImpl<$Res, $Val extends TeacherHoliday>
    implements $TeacherHolidayCopyWith<$Res> {
  _$TeacherHolidayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeacherHoliday
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? reason = freezed,
    Object? isEmergency = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      isEmergency: null == isEmergency
          ? _value.isEmergency
          : isEmergency // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeacherHolidayImplCopyWith<$Res>
    implements $TeacherHolidayCopyWith<$Res> {
  factory _$$TeacherHolidayImplCopyWith(_$TeacherHolidayImpl value,
          $Res Function(_$TeacherHolidayImpl) then) =
      __$$TeacherHolidayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      DateTime startDate,
      DateTime endDate,
      String? reason,
      bool isEmergency});
}

/// @nodoc
class __$$TeacherHolidayImplCopyWithImpl<$Res>
    extends _$TeacherHolidayCopyWithImpl<$Res, _$TeacherHolidayImpl>
    implements _$$TeacherHolidayImplCopyWith<$Res> {
  __$$TeacherHolidayImplCopyWithImpl(
      _$TeacherHolidayImpl _value, $Res Function(_$TeacherHolidayImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeacherHoliday
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? reason = freezed,
    Object? isEmergency = null,
  }) {
    return _then(_$TeacherHolidayImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      isEmergency: null == isEmergency
          ? _value.isEmergency
          : isEmergency // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherHolidayImpl implements _TeacherHoliday {
  const _$TeacherHolidayImpl(
      {required this.id,
      required this.userId,
      required this.startDate,
      required this.endDate,
      this.reason,
      required this.isEmergency});

  factory _$TeacherHolidayImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherHolidayImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final String? reason;
  @override
  final bool isEmergency;

  @override
  String toString() {
    return 'TeacherHoliday(id: $id, userId: $userId, startDate: $startDate, endDate: $endDate, reason: $reason, isEmergency: $isEmergency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherHolidayImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.isEmergency, isEmergency) ||
                other.isEmergency == isEmergency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, userId, startDate, endDate, reason, isEmergency);

  /// Create a copy of TeacherHoliday
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherHolidayImplCopyWith<_$TeacherHolidayImpl> get copyWith =>
      __$$TeacherHolidayImplCopyWithImpl<_$TeacherHolidayImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherHolidayImplToJson(
      this,
    );
  }
}

abstract class _TeacherHoliday implements TeacherHoliday {
  const factory _TeacherHoliday(
      {required final String id,
      required final String userId,
      required final DateTime startDate,
      required final DateTime endDate,
      final String? reason,
      required final bool isEmergency}) = _$TeacherHolidayImpl;

  factory _TeacherHoliday.fromJson(Map<String, dynamic> json) =
      _$TeacherHolidayImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  String? get reason;
  @override
  bool get isEmergency;

  /// Create a copy of TeacherHoliday
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherHolidayImplCopyWith<_$TeacherHolidayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeacherSessionType _$TeacherSessionTypeFromJson(Map<String, dynamic> json) {
  return _TeacherSessionType.fromJson(json);
}

/// @nodoc
mixin _$TeacherSessionType {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonValue('format')
  SessionFormat get format => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  int get basePriceCents => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  int get maxParticipants => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isOnline => throw _privateConstructorUsedError;
  double get taxRatePercent => throw _privateConstructorUsedError;

  /// Serializes this TeacherSessionType to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeacherSessionType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherSessionTypeCopyWith<TeacherSessionType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherSessionTypeCopyWith<$Res> {
  factory $TeacherSessionTypeCopyWith(
          TeacherSessionType value, $Res Function(TeacherSessionType) then) =
      _$TeacherSessionTypeCopyWithImpl<$Res, TeacherSessionType>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      String? description,
      @JsonValue('format') SessionFormat format,
      int durationMinutes,
      int basePriceCents,
      String currency,
      int maxParticipants,
      bool isActive,
      bool isOnline,
      double taxRatePercent});
}

/// @nodoc
class _$TeacherSessionTypeCopyWithImpl<$Res, $Val extends TeacherSessionType>
    implements $TeacherSessionTypeCopyWith<$Res> {
  _$TeacherSessionTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeacherSessionType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? description = freezed,
    Object? format = null,
    Object? durationMinutes = null,
    Object? basePriceCents = null,
    Object? currency = null,
    Object? maxParticipants = null,
    Object? isActive = null,
    Object? isOnline = null,
    Object? taxRatePercent = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as SessionFormat,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      basePriceCents: null == basePriceCents
          ? _value.basePriceCents
          : basePriceCents // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      maxParticipants: null == maxParticipants
          ? _value.maxParticipants
          : maxParticipants // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      taxRatePercent: null == taxRatePercent
          ? _value.taxRatePercent
          : taxRatePercent // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeacherSessionTypeImplCopyWith<$Res>
    implements $TeacherSessionTypeCopyWith<$Res> {
  factory _$$TeacherSessionTypeImplCopyWith(_$TeacherSessionTypeImpl value,
          $Res Function(_$TeacherSessionTypeImpl) then) =
      __$$TeacherSessionTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      String? description,
      @JsonValue('format') SessionFormat format,
      int durationMinutes,
      int basePriceCents,
      String currency,
      int maxParticipants,
      bool isActive,
      bool isOnline,
      double taxRatePercent});
}

/// @nodoc
class __$$TeacherSessionTypeImplCopyWithImpl<$Res>
    extends _$TeacherSessionTypeCopyWithImpl<$Res, _$TeacherSessionTypeImpl>
    implements _$$TeacherSessionTypeImplCopyWith<$Res> {
  __$$TeacherSessionTypeImplCopyWithImpl(_$TeacherSessionTypeImpl _value,
      $Res Function(_$TeacherSessionTypeImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeacherSessionType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? description = freezed,
    Object? format = null,
    Object? durationMinutes = null,
    Object? basePriceCents = null,
    Object? currency = null,
    Object? maxParticipants = null,
    Object? isActive = null,
    Object? isOnline = null,
    Object? taxRatePercent = null,
  }) {
    return _then(_$TeacherSessionTypeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as SessionFormat,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      basePriceCents: null == basePriceCents
          ? _value.basePriceCents
          : basePriceCents // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      maxParticipants: null == maxParticipants
          ? _value.maxParticipants
          : maxParticipants // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      taxRatePercent: null == taxRatePercent
          ? _value.taxRatePercent
          : taxRatePercent // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherSessionTypeImpl implements _TeacherSessionType {
  const _$TeacherSessionTypeImpl(
      {required this.id,
      required this.userId,
      required this.title,
      this.description,
      @JsonValue('format') required this.format,
      required this.durationMinutes,
      required this.basePriceCents,
      required this.currency,
      required this.maxParticipants,
      required this.isActive,
      required this.isOnline,
      required this.taxRatePercent});

  factory _$TeacherSessionTypeImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherSessionTypeImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonValue('format')
  final SessionFormat format;
  @override
  final int durationMinutes;
  @override
  final int basePriceCents;
  @override
  final String currency;
  @override
  final int maxParticipants;
  @override
  final bool isActive;
  @override
  final bool isOnline;
  @override
  final double taxRatePercent;

  @override
  String toString() {
    return 'TeacherSessionType(id: $id, userId: $userId, title: $title, description: $description, format: $format, durationMinutes: $durationMinutes, basePriceCents: $basePriceCents, currency: $currency, maxParticipants: $maxParticipants, isActive: $isActive, isOnline: $isOnline, taxRatePercent: $taxRatePercent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherSessionTypeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.basePriceCents, basePriceCents) ||
                other.basePriceCents == basePriceCents) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.maxParticipants, maxParticipants) ||
                other.maxParticipants == maxParticipants) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.taxRatePercent, taxRatePercent) ||
                other.taxRatePercent == taxRatePercent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      title,
      description,
      format,
      durationMinutes,
      basePriceCents,
      currency,
      maxParticipants,
      isActive,
      isOnline,
      taxRatePercent);

  /// Create a copy of TeacherSessionType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherSessionTypeImplCopyWith<_$TeacherSessionTypeImpl> get copyWith =>
      __$$TeacherSessionTypeImplCopyWithImpl<_$TeacherSessionTypeImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherSessionTypeImplToJson(
      this,
    );
  }
}

abstract class _TeacherSessionType implements TeacherSessionType {
  const factory _TeacherSessionType(
      {required final String id,
      required final String userId,
      required final String title,
      final String? description,
      @JsonValue('format') required final SessionFormat format,
      required final int durationMinutes,
      required final int basePriceCents,
      required final String currency,
      required final int maxParticipants,
      required final bool isActive,
      required final bool isOnline,
      required final double taxRatePercent}) = _$TeacherSessionTypeImpl;

  factory _TeacherSessionType.fromJson(Map<String, dynamic> json) =
      _$TeacherSessionTypeImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonValue('format')
  SessionFormat get format;
  @override
  int get durationMinutes;
  @override
  int get basePriceCents;
  @override
  String get currency;
  @override
  int get maxParticipants;
  @override
  bool get isActive;
  @override
  bool get isOnline;
  @override
  double get taxRatePercent;

  /// Create a copy of TeacherSessionType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherSessionTypeImplCopyWith<_$TeacherSessionTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeacherPricingRule _$TeacherPricingRuleFromJson(Map<String, dynamic> json) {
  return _TeacherPricingRule.fromJson(json);
}

/// @nodoc
mixin _$TeacherPricingRule {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get ruleName => throw _privateConstructorUsedError;
  double? get markupPercent => throw _privateConstructorUsedError;
  double? get discountPercent => throw _privateConstructorUsedError;
  bool get isWeekend => throw _privateConstructorUsedError;
  bool get isPeakHour => throw _privateConstructorUsedError;
  List<SessionFormat> get applicableFormats =>
      throw _privateConstructorUsedError;

  /// Serializes this TeacherPricingRule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeacherPricingRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherPricingRuleCopyWith<TeacherPricingRule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherPricingRuleCopyWith<$Res> {
  factory $TeacherPricingRuleCopyWith(
          TeacherPricingRule value, $Res Function(TeacherPricingRule) then) =
      _$TeacherPricingRuleCopyWithImpl<$Res, TeacherPricingRule>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String ruleName,
      double? markupPercent,
      double? discountPercent,
      bool isWeekend,
      bool isPeakHour,
      List<SessionFormat> applicableFormats});
}

/// @nodoc
class _$TeacherPricingRuleCopyWithImpl<$Res, $Val extends TeacherPricingRule>
    implements $TeacherPricingRuleCopyWith<$Res> {
  _$TeacherPricingRuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeacherPricingRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? ruleName = null,
    Object? markupPercent = freezed,
    Object? discountPercent = freezed,
    Object? isWeekend = null,
    Object? isPeakHour = null,
    Object? applicableFormats = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      ruleName: null == ruleName
          ? _value.ruleName
          : ruleName // ignore: cast_nullable_to_non_nullable
              as String,
      markupPercent: freezed == markupPercent
          ? _value.markupPercent
          : markupPercent // ignore: cast_nullable_to_non_nullable
              as double?,
      discountPercent: freezed == discountPercent
          ? _value.discountPercent
          : discountPercent // ignore: cast_nullable_to_non_nullable
              as double?,
      isWeekend: null == isWeekend
          ? _value.isWeekend
          : isWeekend // ignore: cast_nullable_to_non_nullable
              as bool,
      isPeakHour: null == isPeakHour
          ? _value.isPeakHour
          : isPeakHour // ignore: cast_nullable_to_non_nullable
              as bool,
      applicableFormats: null == applicableFormats
          ? _value.applicableFormats
          : applicableFormats // ignore: cast_nullable_to_non_nullable
              as List<SessionFormat>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeacherPricingRuleImplCopyWith<$Res>
    implements $TeacherPricingRuleCopyWith<$Res> {
  factory _$$TeacherPricingRuleImplCopyWith(_$TeacherPricingRuleImpl value,
          $Res Function(_$TeacherPricingRuleImpl) then) =
      __$$TeacherPricingRuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String ruleName,
      double? markupPercent,
      double? discountPercent,
      bool isWeekend,
      bool isPeakHour,
      List<SessionFormat> applicableFormats});
}

/// @nodoc
class __$$TeacherPricingRuleImplCopyWithImpl<$Res>
    extends _$TeacherPricingRuleCopyWithImpl<$Res, _$TeacherPricingRuleImpl>
    implements _$$TeacherPricingRuleImplCopyWith<$Res> {
  __$$TeacherPricingRuleImplCopyWithImpl(_$TeacherPricingRuleImpl _value,
      $Res Function(_$TeacherPricingRuleImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeacherPricingRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? ruleName = null,
    Object? markupPercent = freezed,
    Object? discountPercent = freezed,
    Object? isWeekend = null,
    Object? isPeakHour = null,
    Object? applicableFormats = null,
  }) {
    return _then(_$TeacherPricingRuleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      ruleName: null == ruleName
          ? _value.ruleName
          : ruleName // ignore: cast_nullable_to_non_nullable
              as String,
      markupPercent: freezed == markupPercent
          ? _value.markupPercent
          : markupPercent // ignore: cast_nullable_to_non_nullable
              as double?,
      discountPercent: freezed == discountPercent
          ? _value.discountPercent
          : discountPercent // ignore: cast_nullable_to_non_nullable
              as double?,
      isWeekend: null == isWeekend
          ? _value.isWeekend
          : isWeekend // ignore: cast_nullable_to_non_nullable
              as bool,
      isPeakHour: null == isPeakHour
          ? _value.isPeakHour
          : isPeakHour // ignore: cast_nullable_to_non_nullable
              as bool,
      applicableFormats: null == applicableFormats
          ? _value._applicableFormats
          : applicableFormats // ignore: cast_nullable_to_non_nullable
              as List<SessionFormat>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherPricingRuleImpl implements _TeacherPricingRule {
  const _$TeacherPricingRuleImpl(
      {required this.id,
      required this.userId,
      required this.ruleName,
      this.markupPercent,
      this.discountPercent,
      required this.isWeekend,
      required this.isPeakHour,
      required final List<SessionFormat> applicableFormats})
      : _applicableFormats = applicableFormats;

  factory _$TeacherPricingRuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherPricingRuleImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String ruleName;
  @override
  final double? markupPercent;
  @override
  final double? discountPercent;
  @override
  final bool isWeekend;
  @override
  final bool isPeakHour;
  final List<SessionFormat> _applicableFormats;
  @override
  List<SessionFormat> get applicableFormats {
    if (_applicableFormats is EqualUnmodifiableListView)
      return _applicableFormats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_applicableFormats);
  }

  @override
  String toString() {
    return 'TeacherPricingRule(id: $id, userId: $userId, ruleName: $ruleName, markupPercent: $markupPercent, discountPercent: $discountPercent, isWeekend: $isWeekend, isPeakHour: $isPeakHour, applicableFormats: $applicableFormats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherPricingRuleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.ruleName, ruleName) ||
                other.ruleName == ruleName) &&
            (identical(other.markupPercent, markupPercent) ||
                other.markupPercent == markupPercent) &&
            (identical(other.discountPercent, discountPercent) ||
                other.discountPercent == discountPercent) &&
            (identical(other.isWeekend, isWeekend) ||
                other.isWeekend == isWeekend) &&
            (identical(other.isPeakHour, isPeakHour) ||
                other.isPeakHour == isPeakHour) &&
            const DeepCollectionEquality()
                .equals(other._applicableFormats, _applicableFormats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      ruleName,
      markupPercent,
      discountPercent,
      isWeekend,
      isPeakHour,
      const DeepCollectionEquality().hash(_applicableFormats));

  /// Create a copy of TeacherPricingRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherPricingRuleImplCopyWith<_$TeacherPricingRuleImpl> get copyWith =>
      __$$TeacherPricingRuleImplCopyWithImpl<_$TeacherPricingRuleImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherPricingRuleImplToJson(
      this,
    );
  }
}

abstract class _TeacherPricingRule implements TeacherPricingRule {
  const factory _TeacherPricingRule(
          {required final String id,
          required final String userId,
          required final String ruleName,
          final double? markupPercent,
          final double? discountPercent,
          required final bool isWeekend,
          required final bool isPeakHour,
          required final List<SessionFormat> applicableFormats}) =
      _$TeacherPricingRuleImpl;

  factory _TeacherPricingRule.fromJson(Map<String, dynamic> json) =
      _$TeacherPricingRuleImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get ruleName;
  @override
  double? get markupPercent;
  @override
  double? get discountPercent;
  @override
  bool get isWeekend;
  @override
  bool get isPeakHour;
  @override
  List<SessionFormat> get applicableFormats;

  /// Create a copy of TeacherPricingRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherPricingRuleImplCopyWith<_$TeacherPricingRuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeacherSession _$TeacherSessionFromJson(Map<String, dynamic> json) {
  return _TeacherSession.fromJson(json);
}

/// @nodoc
mixin _$TeacherSession {
  String get id => throw _privateConstructorUsedError;
  String get teacherUserId => throw _privateConstructorUsedError;
  String get sessionTypeId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  int get maxParticipants => throw _privateConstructorUsedError;
  int get currentBookings => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get meetingUrl => throw _privateConstructorUsedError;

  /// Serializes this TeacherSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeacherSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherSessionCopyWith<TeacherSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherSessionCopyWith<$Res> {
  factory $TeacherSessionCopyWith(
          TeacherSession value, $Res Function(TeacherSession) then) =
      _$TeacherSessionCopyWithImpl<$Res, TeacherSession>;
  @useResult
  $Res call(
      {String id,
      String teacherUserId,
      String sessionTypeId,
      String title,
      DateTime startTime,
      DateTime endTime,
      int maxParticipants,
      int currentBookings,
      String status,
      String? meetingUrl});
}

/// @nodoc
class _$TeacherSessionCopyWithImpl<$Res, $Val extends TeacherSession>
    implements $TeacherSessionCopyWith<$Res> {
  _$TeacherSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeacherSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? teacherUserId = null,
    Object? sessionTypeId = null,
    Object? title = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? maxParticipants = null,
    Object? currentBookings = null,
    Object? status = null,
    Object? meetingUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      teacherUserId: null == teacherUserId
          ? _value.teacherUserId
          : teacherUserId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionTypeId: null == sessionTypeId
          ? _value.sessionTypeId
          : sessionTypeId // ignore: cast_nullable_to_non_nullable
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      meetingUrl: freezed == meetingUrl
          ? _value.meetingUrl
          : meetingUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeacherSessionImplCopyWith<$Res>
    implements $TeacherSessionCopyWith<$Res> {
  factory _$$TeacherSessionImplCopyWith(_$TeacherSessionImpl value,
          $Res Function(_$TeacherSessionImpl) then) =
      __$$TeacherSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String teacherUserId,
      String sessionTypeId,
      String title,
      DateTime startTime,
      DateTime endTime,
      int maxParticipants,
      int currentBookings,
      String status,
      String? meetingUrl});
}

/// @nodoc
class __$$TeacherSessionImplCopyWithImpl<$Res>
    extends _$TeacherSessionCopyWithImpl<$Res, _$TeacherSessionImpl>
    implements _$$TeacherSessionImplCopyWith<$Res> {
  __$$TeacherSessionImplCopyWithImpl(
      _$TeacherSessionImpl _value, $Res Function(_$TeacherSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeacherSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? teacherUserId = null,
    Object? sessionTypeId = null,
    Object? title = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? maxParticipants = null,
    Object? currentBookings = null,
    Object? status = null,
    Object? meetingUrl = freezed,
  }) {
    return _then(_$TeacherSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      teacherUserId: null == teacherUserId
          ? _value.teacherUserId
          : teacherUserId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionTypeId: null == sessionTypeId
          ? _value.sessionTypeId
          : sessionTypeId // ignore: cast_nullable_to_non_nullable
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      meetingUrl: freezed == meetingUrl
          ? _value.meetingUrl
          : meetingUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherSessionImpl implements _TeacherSession {
  const _$TeacherSessionImpl(
      {required this.id,
      required this.teacherUserId,
      required this.sessionTypeId,
      required this.title,
      required this.startTime,
      required this.endTime,
      required this.maxParticipants,
      required this.currentBookings,
      required this.status,
      this.meetingUrl});

  factory _$TeacherSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String teacherUserId;
  @override
  final String sessionTypeId;
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
  final String status;
  @override
  final String? meetingUrl;

  @override
  String toString() {
    return 'TeacherSession(id: $id, teacherUserId: $teacherUserId, sessionTypeId: $sessionTypeId, title: $title, startTime: $startTime, endTime: $endTime, maxParticipants: $maxParticipants, currentBookings: $currentBookings, status: $status, meetingUrl: $meetingUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.teacherUserId, teacherUserId) ||
                other.teacherUserId == teacherUserId) &&
            (identical(other.sessionTypeId, sessionTypeId) ||
                other.sessionTypeId == sessionTypeId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.maxParticipants, maxParticipants) ||
                other.maxParticipants == maxParticipants) &&
            (identical(other.currentBookings, currentBookings) ||
                other.currentBookings == currentBookings) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.meetingUrl, meetingUrl) ||
                other.meetingUrl == meetingUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      teacherUserId,
      sessionTypeId,
      title,
      startTime,
      endTime,
      maxParticipants,
      currentBookings,
      status,
      meetingUrl);

  /// Create a copy of TeacherSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherSessionImplCopyWith<_$TeacherSessionImpl> get copyWith =>
      __$$TeacherSessionImplCopyWithImpl<_$TeacherSessionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherSessionImplToJson(
      this,
    );
  }
}

abstract class _TeacherSession implements TeacherSession {
  const factory _TeacherSession(
      {required final String id,
      required final String teacherUserId,
      required final String sessionTypeId,
      required final String title,
      required final DateTime startTime,
      required final DateTime endTime,
      required final int maxParticipants,
      required final int currentBookings,
      required final String status,
      final String? meetingUrl}) = _$TeacherSessionImpl;

  factory _TeacherSession.fromJson(Map<String, dynamic> json) =
      _$TeacherSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get teacherUserId;
  @override
  String get sessionTypeId;
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
  String get status;
  @override
  String? get meetingUrl;

  /// Create a copy of TeacherSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherSessionImplCopyWith<_$TeacherSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeacherStudentRoster _$TeacherStudentRosterFromJson(Map<String, dynamic> json) {
  return _TeacherStudentRoster.fromJson(json);
}

/// @nodoc
mixin _$TeacherStudentRoster {
  String get id => throw _privateConstructorUsedError;
  String get teacherUserId => throw _privateConstructorUsedError;
  String get studentUserId => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  bool get isBlocked => throw _privateConstructorUsedError;
  int get totalSessions => throw _privateConstructorUsedError;
  DateTime? get firstSessionAt => throw _privateConstructorUsedError;
  DateTime? get lastSessionAt => throw _privateConstructorUsedError;

  /// Serializes this TeacherStudentRoster to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeacherStudentRoster
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherStudentRosterCopyWith<TeacherStudentRoster> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherStudentRosterCopyWith<$Res> {
  factory $TeacherStudentRosterCopyWith(TeacherStudentRoster value,
          $Res Function(TeacherStudentRoster) then) =
      _$TeacherStudentRosterCopyWithImpl<$Res, TeacherStudentRoster>;
  @useResult
  $Res call(
      {String id,
      String teacherUserId,
      String studentUserId,
      bool isFavorite,
      bool isBlocked,
      int totalSessions,
      DateTime? firstSessionAt,
      DateTime? lastSessionAt});
}

/// @nodoc
class _$TeacherStudentRosterCopyWithImpl<$Res,
        $Val extends TeacherStudentRoster>
    implements $TeacherStudentRosterCopyWith<$Res> {
  _$TeacherStudentRosterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeacherStudentRoster
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? teacherUserId = null,
    Object? studentUserId = null,
    Object? isFavorite = null,
    Object? isBlocked = null,
    Object? totalSessions = null,
    Object? firstSessionAt = freezed,
    Object? lastSessionAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      teacherUserId: null == teacherUserId
          ? _value.teacherUserId
          : teacherUserId // ignore: cast_nullable_to_non_nullable
              as String,
      studentUserId: null == studentUserId
          ? _value.studentUserId
          : studentUserId // ignore: cast_nullable_to_non_nullable
              as String,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      isBlocked: null == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      totalSessions: null == totalSessions
          ? _value.totalSessions
          : totalSessions // ignore: cast_nullable_to_non_nullable
              as int,
      firstSessionAt: freezed == firstSessionAt
          ? _value.firstSessionAt
          : firstSessionAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSessionAt: freezed == lastSessionAt
          ? _value.lastSessionAt
          : lastSessionAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeacherStudentRosterImplCopyWith<$Res>
    implements $TeacherStudentRosterCopyWith<$Res> {
  factory _$$TeacherStudentRosterImplCopyWith(_$TeacherStudentRosterImpl value,
          $Res Function(_$TeacherStudentRosterImpl) then) =
      __$$TeacherStudentRosterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String teacherUserId,
      String studentUserId,
      bool isFavorite,
      bool isBlocked,
      int totalSessions,
      DateTime? firstSessionAt,
      DateTime? lastSessionAt});
}

/// @nodoc
class __$$TeacherStudentRosterImplCopyWithImpl<$Res>
    extends _$TeacherStudentRosterCopyWithImpl<$Res, _$TeacherStudentRosterImpl>
    implements _$$TeacherStudentRosterImplCopyWith<$Res> {
  __$$TeacherStudentRosterImplCopyWithImpl(_$TeacherStudentRosterImpl _value,
      $Res Function(_$TeacherStudentRosterImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeacherStudentRoster
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? teacherUserId = null,
    Object? studentUserId = null,
    Object? isFavorite = null,
    Object? isBlocked = null,
    Object? totalSessions = null,
    Object? firstSessionAt = freezed,
    Object? lastSessionAt = freezed,
  }) {
    return _then(_$TeacherStudentRosterImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      teacherUserId: null == teacherUserId
          ? _value.teacherUserId
          : teacherUserId // ignore: cast_nullable_to_non_nullable
              as String,
      studentUserId: null == studentUserId
          ? _value.studentUserId
          : studentUserId // ignore: cast_nullable_to_non_nullable
              as String,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      isBlocked: null == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      totalSessions: null == totalSessions
          ? _value.totalSessions
          : totalSessions // ignore: cast_nullable_to_non_nullable
              as int,
      firstSessionAt: freezed == firstSessionAt
          ? _value.firstSessionAt
          : firstSessionAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSessionAt: freezed == lastSessionAt
          ? _value.lastSessionAt
          : lastSessionAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherStudentRosterImpl implements _TeacherStudentRoster {
  const _$TeacherStudentRosterImpl(
      {required this.id,
      required this.teacherUserId,
      required this.studentUserId,
      required this.isFavorite,
      required this.isBlocked,
      required this.totalSessions,
      this.firstSessionAt,
      this.lastSessionAt});

  factory _$TeacherStudentRosterImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherStudentRosterImplFromJson(json);

  @override
  final String id;
  @override
  final String teacherUserId;
  @override
  final String studentUserId;
  @override
  final bool isFavorite;
  @override
  final bool isBlocked;
  @override
  final int totalSessions;
  @override
  final DateTime? firstSessionAt;
  @override
  final DateTime? lastSessionAt;

  @override
  String toString() {
    return 'TeacherStudentRoster(id: $id, teacherUserId: $teacherUserId, studentUserId: $studentUserId, isFavorite: $isFavorite, isBlocked: $isBlocked, totalSessions: $totalSessions, firstSessionAt: $firstSessionAt, lastSessionAt: $lastSessionAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherStudentRosterImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.teacherUserId, teacherUserId) ||
                other.teacherUserId == teacherUserId) &&
            (identical(other.studentUserId, studentUserId) ||
                other.studentUserId == studentUserId) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.isBlocked, isBlocked) ||
                other.isBlocked == isBlocked) &&
            (identical(other.totalSessions, totalSessions) ||
                other.totalSessions == totalSessions) &&
            (identical(other.firstSessionAt, firstSessionAt) ||
                other.firstSessionAt == firstSessionAt) &&
            (identical(other.lastSessionAt, lastSessionAt) ||
                other.lastSessionAt == lastSessionAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, teacherUserId, studentUserId,
      isFavorite, isBlocked, totalSessions, firstSessionAt, lastSessionAt);

  /// Create a copy of TeacherStudentRoster
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherStudentRosterImplCopyWith<_$TeacherStudentRosterImpl>
      get copyWith =>
          __$$TeacherStudentRosterImplCopyWithImpl<_$TeacherStudentRosterImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherStudentRosterImplToJson(
      this,
    );
  }
}

abstract class _TeacherStudentRoster implements TeacherStudentRoster {
  const factory _TeacherStudentRoster(
      {required final String id,
      required final String teacherUserId,
      required final String studentUserId,
      required final bool isFavorite,
      required final bool isBlocked,
      required final int totalSessions,
      final DateTime? firstSessionAt,
      final DateTime? lastSessionAt}) = _$TeacherStudentRosterImpl;

  factory _TeacherStudentRoster.fromJson(Map<String, dynamic> json) =
      _$TeacherStudentRosterImpl.fromJson;

  @override
  String get id;
  @override
  String get teacherUserId;
  @override
  String get studentUserId;
  @override
  bool get isFavorite;
  @override
  bool get isBlocked;
  @override
  int get totalSessions;
  @override
  DateTime? get firstSessionAt;
  @override
  DateTime? get lastSessionAt;

  /// Create a copy of TeacherStudentRoster
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherStudentRosterImplCopyWith<_$TeacherStudentRosterImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TeacherPayoutRequest _$TeacherPayoutRequestFromJson(Map<String, dynamic> json) {
  return _TeacherPayoutRequest.fromJson(json);
}

/// @nodoc
mixin _$TeacherPayoutRequest {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  int get amountCents => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonValue('status')
  PayoutStatus get status => throw _privateConstructorUsedError;
  String? get bankAccountId => throw _privateConstructorUsedError;
  String? get transactionRef => throw _privateConstructorUsedError;
  DateTime get requestedAt => throw _privateConstructorUsedError;
  DateTime? get processedAt => throw _privateConstructorUsedError;

  /// Serializes this TeacherPayoutRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeacherPayoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherPayoutRequestCopyWith<TeacherPayoutRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherPayoutRequestCopyWith<$Res> {
  factory $TeacherPayoutRequestCopyWith(TeacherPayoutRequest value,
          $Res Function(TeacherPayoutRequest) then) =
      _$TeacherPayoutRequestCopyWithImpl<$Res, TeacherPayoutRequest>;
  @useResult
  $Res call(
      {String id,
      String userId,
      int amountCents,
      String currency,
      @JsonValue('status') PayoutStatus status,
      String? bankAccountId,
      String? transactionRef,
      DateTime requestedAt,
      DateTime? processedAt});
}

/// @nodoc
class _$TeacherPayoutRequestCopyWithImpl<$Res,
        $Val extends TeacherPayoutRequest>
    implements $TeacherPayoutRequestCopyWith<$Res> {
  _$TeacherPayoutRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeacherPayoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? amountCents = null,
    Object? currency = null,
    Object? status = null,
    Object? bankAccountId = freezed,
    Object? transactionRef = freezed,
    Object? requestedAt = null,
    Object? processedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      amountCents: null == amountCents
          ? _value.amountCents
          : amountCents // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PayoutStatus,
      bankAccountId: freezed == bankAccountId
          ? _value.bankAccountId
          : bankAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionRef: freezed == transactionRef
          ? _value.transactionRef
          : transactionRef // ignore: cast_nullable_to_non_nullable
              as String?,
      requestedAt: null == requestedAt
          ? _value.requestedAt
          : requestedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      processedAt: freezed == processedAt
          ? _value.processedAt
          : processedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeacherPayoutRequestImplCopyWith<$Res>
    implements $TeacherPayoutRequestCopyWith<$Res> {
  factory _$$TeacherPayoutRequestImplCopyWith(_$TeacherPayoutRequestImpl value,
          $Res Function(_$TeacherPayoutRequestImpl) then) =
      __$$TeacherPayoutRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      int amountCents,
      String currency,
      @JsonValue('status') PayoutStatus status,
      String? bankAccountId,
      String? transactionRef,
      DateTime requestedAt,
      DateTime? processedAt});
}

/// @nodoc
class __$$TeacherPayoutRequestImplCopyWithImpl<$Res>
    extends _$TeacherPayoutRequestCopyWithImpl<$Res, _$TeacherPayoutRequestImpl>
    implements _$$TeacherPayoutRequestImplCopyWith<$Res> {
  __$$TeacherPayoutRequestImplCopyWithImpl(_$TeacherPayoutRequestImpl _value,
      $Res Function(_$TeacherPayoutRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeacherPayoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? amountCents = null,
    Object? currency = null,
    Object? status = null,
    Object? bankAccountId = freezed,
    Object? transactionRef = freezed,
    Object? requestedAt = null,
    Object? processedAt = freezed,
  }) {
    return _then(_$TeacherPayoutRequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      amountCents: null == amountCents
          ? _value.amountCents
          : amountCents // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PayoutStatus,
      bankAccountId: freezed == bankAccountId
          ? _value.bankAccountId
          : bankAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionRef: freezed == transactionRef
          ? _value.transactionRef
          : transactionRef // ignore: cast_nullable_to_non_nullable
              as String?,
      requestedAt: null == requestedAt
          ? _value.requestedAt
          : requestedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      processedAt: freezed == processedAt
          ? _value.processedAt
          : processedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherPayoutRequestImpl implements _TeacherPayoutRequest {
  const _$TeacherPayoutRequestImpl(
      {required this.id,
      required this.userId,
      required this.amountCents,
      required this.currency,
      @JsonValue('status') required this.status,
      this.bankAccountId,
      this.transactionRef,
      required this.requestedAt,
      this.processedAt});

  factory _$TeacherPayoutRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherPayoutRequestImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final int amountCents;
  @override
  final String currency;
  @override
  @JsonValue('status')
  final PayoutStatus status;
  @override
  final String? bankAccountId;
  @override
  final String? transactionRef;
  @override
  final DateTime requestedAt;
  @override
  final DateTime? processedAt;

  @override
  String toString() {
    return 'TeacherPayoutRequest(id: $id, userId: $userId, amountCents: $amountCents, currency: $currency, status: $status, bankAccountId: $bankAccountId, transactionRef: $transactionRef, requestedAt: $requestedAt, processedAt: $processedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherPayoutRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.amountCents, amountCents) ||
                other.amountCents == amountCents) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.bankAccountId, bankAccountId) ||
                other.bankAccountId == bankAccountId) &&
            (identical(other.transactionRef, transactionRef) ||
                other.transactionRef == transactionRef) &&
            (identical(other.requestedAt, requestedAt) ||
                other.requestedAt == requestedAt) &&
            (identical(other.processedAt, processedAt) ||
                other.processedAt == processedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      amountCents,
      currency,
      status,
      bankAccountId,
      transactionRef,
      requestedAt,
      processedAt);

  /// Create a copy of TeacherPayoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherPayoutRequestImplCopyWith<_$TeacherPayoutRequestImpl>
      get copyWith =>
          __$$TeacherPayoutRequestImplCopyWithImpl<_$TeacherPayoutRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherPayoutRequestImplToJson(
      this,
    );
  }
}

abstract class _TeacherPayoutRequest implements TeacherPayoutRequest {
  const factory _TeacherPayoutRequest(
      {required final String id,
      required final String userId,
      required final int amountCents,
      required final String currency,
      @JsonValue('status') required final PayoutStatus status,
      final String? bankAccountId,
      final String? transactionRef,
      required final DateTime requestedAt,
      final DateTime? processedAt}) = _$TeacherPayoutRequestImpl;

  factory _TeacherPayoutRequest.fromJson(Map<String, dynamic> json) =
      _$TeacherPayoutRequestImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  int get amountCents;
  @override
  String get currency;
  @override
  @JsonValue('status')
  PayoutStatus get status;
  @override
  String? get bankAccountId;
  @override
  String? get transactionRef;
  @override
  DateTime get requestedAt;
  @override
  DateTime? get processedAt;

  /// Create a copy of TeacherPayoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherPayoutRequestImplCopyWith<_$TeacherPayoutRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Course _$CourseFromJson(Map<String, dynamic> json) {
  return _Course.fromJson(json);
}

/// @nodoc
mixin _$Course {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get visibility => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  int get priceCents => throw _privateConstructorUsedError;

  /// Serializes this Course to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Course
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseCopyWith<Course> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseCopyWith<$Res> {
  factory $CourseCopyWith(Course value, $Res Function(Course) then) =
      _$CourseCopyWithImpl<$Res, Course>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String visibility,
      List<String> tags,
      String? thumbnailUrl,
      int priceCents});
}

/// @nodoc
class _$CourseCopyWithImpl<$Res, $Val extends Course>
    implements $CourseCopyWith<$Res> {
  _$CourseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Course
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? visibility = null,
    Object? tags = null,
    Object? thumbnailUrl = freezed,
    Object? priceCents = null,
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      priceCents: null == priceCents
          ? _value.priceCents
          : priceCents // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CourseImplCopyWith<$Res> implements $CourseCopyWith<$Res> {
  factory _$$CourseImplCopyWith(
          _$CourseImpl value, $Res Function(_$CourseImpl) then) =
      __$$CourseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String visibility,
      List<String> tags,
      String? thumbnailUrl,
      int priceCents});
}

/// @nodoc
class __$$CourseImplCopyWithImpl<$Res>
    extends _$CourseCopyWithImpl<$Res, _$CourseImpl>
    implements _$$CourseImplCopyWith<$Res> {
  __$$CourseImplCopyWithImpl(
      _$CourseImpl _value, $Res Function(_$CourseImpl) _then)
      : super(_value, _then);

  /// Create a copy of Course
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? visibility = null,
    Object? tags = null,
    Object? thumbnailUrl = freezed,
    Object? priceCents = null,
  }) {
    return _then(_$CourseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      priceCents: null == priceCents
          ? _value.priceCents
          : priceCents // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseImpl implements _Course {
  const _$CourseImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.visibility,
      required final List<String> tags,
      this.thumbnailUrl,
      required this.priceCents})
      : _tags = tags;

  factory _$CourseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String visibility;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String? thumbnailUrl;
  @override
  final int priceCents;

  @override
  String toString() {
    return 'Course(id: $id, title: $title, description: $description, visibility: $visibility, tags: $tags, thumbnailUrl: $thumbnailUrl, priceCents: $priceCents)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.priceCents, priceCents) ||
                other.priceCents == priceCents));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      visibility,
      const DeepCollectionEquality().hash(_tags),
      thumbnailUrl,
      priceCents);

  /// Create a copy of Course
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseImplCopyWith<_$CourseImpl> get copyWith =>
      __$$CourseImplCopyWithImpl<_$CourseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseImplToJson(
      this,
    );
  }
}

abstract class _Course implements Course {
  const factory _Course(
      {required final String id,
      required final String title,
      required final String description,
      required final String visibility,
      required final List<String> tags,
      final String? thumbnailUrl,
      required final int priceCents}) = _$CourseImpl;

  factory _Course.fromJson(Map<String, dynamic> json) = _$CourseImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get visibility;
  @override
  List<String> get tags;
  @override
  String? get thumbnailUrl;
  @override
  int get priceCents;

  /// Create a copy of Course
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseImplCopyWith<_$CourseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LearningEvent _$LearningEventFromJson(Map<String, dynamic> json) {
  return _LearningEvent.fromJson(json);
}

/// @nodoc
mixin _$LearningEvent {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get eventType => throw _privateConstructorUsedError;
  DateTime get scheduledStartAt => throw _privateConstructorUsedError;
  DateTime get scheduledEndAt => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;
  String? get meetingUrl => throw _privateConstructorUsedError;

  /// Serializes this LearningEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LearningEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LearningEventCopyWith<LearningEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningEventCopyWith<$Res> {
  factory $LearningEventCopyWith(
          LearningEvent value, $Res Function(LearningEvent) then) =
      _$LearningEventCopyWithImpl<$Res, LearningEvent>;
  @useResult
  $Res call(
      {String id,
      String title,
      String eventType,
      DateTime scheduledStartAt,
      DateTime scheduledEndAt,
      int capacity,
      String? meetingUrl});
}

/// @nodoc
class _$LearningEventCopyWithImpl<$Res, $Val extends LearningEvent>
    implements $LearningEventCopyWith<$Res> {
  _$LearningEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LearningEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? eventType = null,
    Object? scheduledStartAt = null,
    Object? scheduledEndAt = null,
    Object? capacity = null,
    Object? meetingUrl = freezed,
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
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledStartAt: null == scheduledStartAt
          ? _value.scheduledStartAt
          : scheduledStartAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledEndAt: null == scheduledEndAt
          ? _value.scheduledEndAt
          : scheduledEndAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      capacity: null == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int,
      meetingUrl: freezed == meetingUrl
          ? _value.meetingUrl
          : meetingUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LearningEventImplCopyWith<$Res>
    implements $LearningEventCopyWith<$Res> {
  factory _$$LearningEventImplCopyWith(
          _$LearningEventImpl value, $Res Function(_$LearningEventImpl) then) =
      __$$LearningEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String eventType,
      DateTime scheduledStartAt,
      DateTime scheduledEndAt,
      int capacity,
      String? meetingUrl});
}

/// @nodoc
class __$$LearningEventImplCopyWithImpl<$Res>
    extends _$LearningEventCopyWithImpl<$Res, _$LearningEventImpl>
    implements _$$LearningEventImplCopyWith<$Res> {
  __$$LearningEventImplCopyWithImpl(
      _$LearningEventImpl _value, $Res Function(_$LearningEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of LearningEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? eventType = null,
    Object? scheduledStartAt = null,
    Object? scheduledEndAt = null,
    Object? capacity = null,
    Object? meetingUrl = freezed,
  }) {
    return _then(_$LearningEventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledStartAt: null == scheduledStartAt
          ? _value.scheduledStartAt
          : scheduledStartAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledEndAt: null == scheduledEndAt
          ? _value.scheduledEndAt
          : scheduledEndAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      capacity: null == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int,
      meetingUrl: freezed == meetingUrl
          ? _value.meetingUrl
          : meetingUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LearningEventImpl implements _LearningEvent {
  const _$LearningEventImpl(
      {required this.id,
      required this.title,
      required this.eventType,
      required this.scheduledStartAt,
      required this.scheduledEndAt,
      required this.capacity,
      this.meetingUrl});

  factory _$LearningEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningEventImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String eventType;
  @override
  final DateTime scheduledStartAt;
  @override
  final DateTime scheduledEndAt;
  @override
  final int capacity;
  @override
  final String? meetingUrl;

  @override
  String toString() {
    return 'LearningEvent(id: $id, title: $title, eventType: $eventType, scheduledStartAt: $scheduledStartAt, scheduledEndAt: $scheduledEndAt, capacity: $capacity, meetingUrl: $meetingUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.scheduledStartAt, scheduledStartAt) ||
                other.scheduledStartAt == scheduledStartAt) &&
            (identical(other.scheduledEndAt, scheduledEndAt) ||
                other.scheduledEndAt == scheduledEndAt) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.meetingUrl, meetingUrl) ||
                other.meetingUrl == meetingUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, eventType,
      scheduledStartAt, scheduledEndAt, capacity, meetingUrl);

  /// Create a copy of LearningEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningEventImplCopyWith<_$LearningEventImpl> get copyWith =>
      __$$LearningEventImplCopyWithImpl<_$LearningEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LearningEventImplToJson(
      this,
    );
  }
}

abstract class _LearningEvent implements LearningEvent {
  const factory _LearningEvent(
      {required final String id,
      required final String title,
      required final String eventType,
      required final DateTime scheduledStartAt,
      required final DateTime scheduledEndAt,
      required final int capacity,
      final String? meetingUrl}) = _$LearningEventImpl;

  factory _LearningEvent.fromJson(Map<String, dynamic> json) =
      _$LearningEventImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get eventType;
  @override
  DateTime get scheduledStartAt;
  @override
  DateTime get scheduledEndAt;
  @override
  int get capacity;
  @override
  String? get meetingUrl;

  /// Create a copy of LearningEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LearningEventImplCopyWith<_$LearningEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeacherPublication _$TeacherPublicationFromJson(Map<String, dynamic> json) {
  return _TeacherPublication.fromJson(json);
}

/// @nodoc
mixin _$TeacherPublication {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get publicationType => throw _privateConstructorUsedError;
  String? get contentBody => throw _privateConstructorUsedError;
  String? get assetUrl => throw _privateConstructorUsedError;

  /// Serializes this TeacherPublication to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeacherPublication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherPublicationCopyWith<TeacherPublication> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherPublicationCopyWith<$Res> {
  factory $TeacherPublicationCopyWith(
          TeacherPublication value, $Res Function(TeacherPublication) then) =
      _$TeacherPublicationCopyWithImpl<$Res, TeacherPublication>;
  @useResult
  $Res call(
      {String id,
      String title,
      String publicationType,
      String? contentBody,
      String? assetUrl});
}

/// @nodoc
class _$TeacherPublicationCopyWithImpl<$Res, $Val extends TeacherPublication>
    implements $TeacherPublicationCopyWith<$Res> {
  _$TeacherPublicationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeacherPublication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? publicationType = null,
    Object? contentBody = freezed,
    Object? assetUrl = freezed,
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
      publicationType: null == publicationType
          ? _value.publicationType
          : publicationType // ignore: cast_nullable_to_non_nullable
              as String,
      contentBody: freezed == contentBody
          ? _value.contentBody
          : contentBody // ignore: cast_nullable_to_non_nullable
              as String?,
      assetUrl: freezed == assetUrl
          ? _value.assetUrl
          : assetUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeacherPublicationImplCopyWith<$Res>
    implements $TeacherPublicationCopyWith<$Res> {
  factory _$$TeacherPublicationImplCopyWith(_$TeacherPublicationImpl value,
          $Res Function(_$TeacherPublicationImpl) then) =
      __$$TeacherPublicationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String publicationType,
      String? contentBody,
      String? assetUrl});
}

/// @nodoc
class __$$TeacherPublicationImplCopyWithImpl<$Res>
    extends _$TeacherPublicationCopyWithImpl<$Res, _$TeacherPublicationImpl>
    implements _$$TeacherPublicationImplCopyWith<$Res> {
  __$$TeacherPublicationImplCopyWithImpl(_$TeacherPublicationImpl _value,
      $Res Function(_$TeacherPublicationImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeacherPublication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? publicationType = null,
    Object? contentBody = freezed,
    Object? assetUrl = freezed,
  }) {
    return _then(_$TeacherPublicationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      publicationType: null == publicationType
          ? _value.publicationType
          : publicationType // ignore: cast_nullable_to_non_nullable
              as String,
      contentBody: freezed == contentBody
          ? _value.contentBody
          : contentBody // ignore: cast_nullable_to_non_nullable
              as String?,
      assetUrl: freezed == assetUrl
          ? _value.assetUrl
          : assetUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherPublicationImpl implements _TeacherPublication {
  const _$TeacherPublicationImpl(
      {required this.id,
      required this.title,
      required this.publicationType,
      this.contentBody,
      this.assetUrl});

  factory _$TeacherPublicationImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherPublicationImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String publicationType;
  @override
  final String? contentBody;
  @override
  final String? assetUrl;

  @override
  String toString() {
    return 'TeacherPublication(id: $id, title: $title, publicationType: $publicationType, contentBody: $contentBody, assetUrl: $assetUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherPublicationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.publicationType, publicationType) ||
                other.publicationType == publicationType) &&
            (identical(other.contentBody, contentBody) ||
                other.contentBody == contentBody) &&
            (identical(other.assetUrl, assetUrl) ||
                other.assetUrl == assetUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, publicationType, contentBody, assetUrl);

  /// Create a copy of TeacherPublication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherPublicationImplCopyWith<_$TeacherPublicationImpl> get copyWith =>
      __$$TeacherPublicationImplCopyWithImpl<_$TeacherPublicationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherPublicationImplToJson(
      this,
    );
  }
}

abstract class _TeacherPublication implements TeacherPublication {
  const factory _TeacherPublication(
      {required final String id,
      required final String title,
      required final String publicationType,
      final String? contentBody,
      final String? assetUrl}) = _$TeacherPublicationImpl;

  factory _TeacherPublication.fromJson(Map<String, dynamic> json) =
      _$TeacherPublicationImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get publicationType;
  @override
  String? get contentBody;
  @override
  String? get assetUrl;

  /// Create a copy of TeacherPublication
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherPublicationImplCopyWith<_$TeacherPublicationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

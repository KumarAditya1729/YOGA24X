// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StudentProfile _$StudentProfileFromJson(Map<String, dynamic> json) {
  return _StudentProfile.fromJson(json);
}

/// @nodoc
mixin _$StudentProfile {
  String get userId => throw _privateConstructorUsedError;
  DateTime? get dateOfBirth => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  double? get heightCm => throw _privateConstructorUsedError;
  double? get weightKg => throw _privateConstructorUsedError;
  String? get experienceLevel => throw _privateConstructorUsedError;
  String? get ayurvedicDosha => throw _privateConstructorUsedError;
  List<String> get medicalConditions => throw _privateConstructorUsedError;
  String? get emergencyContactPhone => throw _privateConstructorUsedError;

  /// Serializes this StudentProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentProfileCopyWith<StudentProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentProfileCopyWith<$Res> {
  factory $StudentProfileCopyWith(
          StudentProfile value, $Res Function(StudentProfile) then) =
      _$StudentProfileCopyWithImpl<$Res, StudentProfile>;
  @useResult
  $Res call(
      {String userId,
      DateTime? dateOfBirth,
      String? gender,
      double? heightCm,
      double? weightKg,
      String? experienceLevel,
      String? ayurvedicDosha,
      List<String> medicalConditions,
      String? emergencyContactPhone});
}

/// @nodoc
class _$StudentProfileCopyWithImpl<$Res, $Val extends StudentProfile>
    implements $StudentProfileCopyWith<$Res> {
  _$StudentProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? dateOfBirth = freezed,
    Object? gender = freezed,
    Object? heightCm = freezed,
    Object? weightKg = freezed,
    Object? experienceLevel = freezed,
    Object? ayurvedicDosha = freezed,
    Object? medicalConditions = null,
    Object? emergencyContactPhone = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      heightCm: freezed == heightCm
          ? _value.heightCm
          : heightCm // ignore: cast_nullable_to_non_nullable
              as double?,
      weightKg: freezed == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double?,
      experienceLevel: freezed == experienceLevel
          ? _value.experienceLevel
          : experienceLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      ayurvedicDosha: freezed == ayurvedicDosha
          ? _value.ayurvedicDosha
          : ayurvedicDosha // ignore: cast_nullable_to_non_nullable
              as String?,
      medicalConditions: null == medicalConditions
          ? _value.medicalConditions
          : medicalConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      emergencyContactPhone: freezed == emergencyContactPhone
          ? _value.emergencyContactPhone
          : emergencyContactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StudentProfileImplCopyWith<$Res>
    implements $StudentProfileCopyWith<$Res> {
  factory _$$StudentProfileImplCopyWith(_$StudentProfileImpl value,
          $Res Function(_$StudentProfileImpl) then) =
      __$$StudentProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      DateTime? dateOfBirth,
      String? gender,
      double? heightCm,
      double? weightKg,
      String? experienceLevel,
      String? ayurvedicDosha,
      List<String> medicalConditions,
      String? emergencyContactPhone});
}

/// @nodoc
class __$$StudentProfileImplCopyWithImpl<$Res>
    extends _$StudentProfileCopyWithImpl<$Res, _$StudentProfileImpl>
    implements _$$StudentProfileImplCopyWith<$Res> {
  __$$StudentProfileImplCopyWithImpl(
      _$StudentProfileImpl _value, $Res Function(_$StudentProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of StudentProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? dateOfBirth = freezed,
    Object? gender = freezed,
    Object? heightCm = freezed,
    Object? weightKg = freezed,
    Object? experienceLevel = freezed,
    Object? ayurvedicDosha = freezed,
    Object? medicalConditions = null,
    Object? emergencyContactPhone = freezed,
  }) {
    return _then(_$StudentProfileImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      heightCm: freezed == heightCm
          ? _value.heightCm
          : heightCm // ignore: cast_nullable_to_non_nullable
              as double?,
      weightKg: freezed == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double?,
      experienceLevel: freezed == experienceLevel
          ? _value.experienceLevel
          : experienceLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      ayurvedicDosha: freezed == ayurvedicDosha
          ? _value.ayurvedicDosha
          : ayurvedicDosha // ignore: cast_nullable_to_non_nullable
              as String?,
      medicalConditions: null == medicalConditions
          ? _value._medicalConditions
          : medicalConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      emergencyContactPhone: freezed == emergencyContactPhone
          ? _value.emergencyContactPhone
          : emergencyContactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentProfileImpl implements _StudentProfile {
  const _$StudentProfileImpl(
      {required this.userId,
      this.dateOfBirth,
      this.gender,
      this.heightCm,
      this.weightKg,
      this.experienceLevel,
      this.ayurvedicDosha,
      final List<String> medicalConditions = const [],
      this.emergencyContactPhone})
      : _medicalConditions = medicalConditions;

  factory _$StudentProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentProfileImplFromJson(json);

  @override
  final String userId;
  @override
  final DateTime? dateOfBirth;
  @override
  final String? gender;
  @override
  final double? heightCm;
  @override
  final double? weightKg;
  @override
  final String? experienceLevel;
  @override
  final String? ayurvedicDosha;
  final List<String> _medicalConditions;
  @override
  @JsonKey()
  List<String> get medicalConditions {
    if (_medicalConditions is EqualUnmodifiableListView)
      return _medicalConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medicalConditions);
  }

  @override
  final String? emergencyContactPhone;

  @override
  String toString() {
    return 'StudentProfile(userId: $userId, dateOfBirth: $dateOfBirth, gender: $gender, heightCm: $heightCm, weightKg: $weightKg, experienceLevel: $experienceLevel, ayurvedicDosha: $ayurvedicDosha, medicalConditions: $medicalConditions, emergencyContactPhone: $emergencyContactPhone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentProfileImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.heightCm, heightCm) ||
                other.heightCm == heightCm) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.experienceLevel, experienceLevel) ||
                other.experienceLevel == experienceLevel) &&
            (identical(other.ayurvedicDosha, ayurvedicDosha) ||
                other.ayurvedicDosha == ayurvedicDosha) &&
            const DeepCollectionEquality()
                .equals(other._medicalConditions, _medicalConditions) &&
            (identical(other.emergencyContactPhone, emergencyContactPhone) ||
                other.emergencyContactPhone == emergencyContactPhone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      dateOfBirth,
      gender,
      heightCm,
      weightKg,
      experienceLevel,
      ayurvedicDosha,
      const DeepCollectionEquality().hash(_medicalConditions),
      emergencyContactPhone);

  /// Create a copy of StudentProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentProfileImplCopyWith<_$StudentProfileImpl> get copyWith =>
      __$$StudentProfileImplCopyWithImpl<_$StudentProfileImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentProfileImplToJson(
      this,
    );
  }
}

abstract class _StudentProfile implements StudentProfile {
  const factory _StudentProfile(
      {required final String userId,
      final DateTime? dateOfBirth,
      final String? gender,
      final double? heightCm,
      final double? weightKg,
      final String? experienceLevel,
      final String? ayurvedicDosha,
      final List<String> medicalConditions,
      final String? emergencyContactPhone}) = _$StudentProfileImpl;

  factory _StudentProfile.fromJson(Map<String, dynamic> json) =
      _$StudentProfileImpl.fromJson;

  @override
  String get userId;
  @override
  DateTime? get dateOfBirth;
  @override
  String? get gender;
  @override
  double? get heightCm;
  @override
  double? get weightKg;
  @override
  String? get experienceLevel;
  @override
  String? get ayurvedicDosha;
  @override
  List<String> get medicalConditions;
  @override
  String? get emergencyContactPhone;

  /// Create a copy of StudentProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentProfileImplCopyWith<_$StudentProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StudentAchievement _$StudentAchievementFromJson(Map<String, dynamic> json) {
  return _StudentAchievement.fromJson(json);
}

/// @nodoc
mixin _$StudentAchievement {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get achievementType => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get iconUrl => throw _privateConstructorUsedError;
  int get xpEarned => throw _privateConstructorUsedError;
  int? get levelReached => throw _privateConstructorUsedError;
  DateTime get awardedAt => throw _privateConstructorUsedError;

  /// Serializes this StudentAchievement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentAchievement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentAchievementCopyWith<StudentAchievement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentAchievementCopyWith<$Res> {
  factory $StudentAchievementCopyWith(
          StudentAchievement value, $Res Function(StudentAchievement) then) =
      _$StudentAchievementCopyWithImpl<$Res, StudentAchievement>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String achievementType,
      String title,
      String? description,
      String? iconUrl,
      int xpEarned,
      int? levelReached,
      DateTime awardedAt});
}

/// @nodoc
class _$StudentAchievementCopyWithImpl<$Res, $Val extends StudentAchievement>
    implements $StudentAchievementCopyWith<$Res> {
  _$StudentAchievementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentAchievement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? achievementType = null,
    Object? title = null,
    Object? description = freezed,
    Object? iconUrl = freezed,
    Object? xpEarned = null,
    Object? levelReached = freezed,
    Object? awardedAt = null,
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
      achievementType: null == achievementType
          ? _value.achievementType
          : achievementType // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      xpEarned: null == xpEarned
          ? _value.xpEarned
          : xpEarned // ignore: cast_nullable_to_non_nullable
              as int,
      levelReached: freezed == levelReached
          ? _value.levelReached
          : levelReached // ignore: cast_nullable_to_non_nullable
              as int?,
      awardedAt: null == awardedAt
          ? _value.awardedAt
          : awardedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StudentAchievementImplCopyWith<$Res>
    implements $StudentAchievementCopyWith<$Res> {
  factory _$$StudentAchievementImplCopyWith(_$StudentAchievementImpl value,
          $Res Function(_$StudentAchievementImpl) then) =
      __$$StudentAchievementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String achievementType,
      String title,
      String? description,
      String? iconUrl,
      int xpEarned,
      int? levelReached,
      DateTime awardedAt});
}

/// @nodoc
class __$$StudentAchievementImplCopyWithImpl<$Res>
    extends _$StudentAchievementCopyWithImpl<$Res, _$StudentAchievementImpl>
    implements _$$StudentAchievementImplCopyWith<$Res> {
  __$$StudentAchievementImplCopyWithImpl(_$StudentAchievementImpl _value,
      $Res Function(_$StudentAchievementImpl) _then)
      : super(_value, _then);

  /// Create a copy of StudentAchievement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? achievementType = null,
    Object? title = null,
    Object? description = freezed,
    Object? iconUrl = freezed,
    Object? xpEarned = null,
    Object? levelReached = freezed,
    Object? awardedAt = null,
  }) {
    return _then(_$StudentAchievementImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      achievementType: null == achievementType
          ? _value.achievementType
          : achievementType // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      xpEarned: null == xpEarned
          ? _value.xpEarned
          : xpEarned // ignore: cast_nullable_to_non_nullable
              as int,
      levelReached: freezed == levelReached
          ? _value.levelReached
          : levelReached // ignore: cast_nullable_to_non_nullable
              as int?,
      awardedAt: null == awardedAt
          ? _value.awardedAt
          : awardedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentAchievementImpl implements _StudentAchievement {
  const _$StudentAchievementImpl(
      {required this.id,
      required this.userId,
      required this.achievementType,
      required this.title,
      this.description,
      this.iconUrl,
      required this.xpEarned,
      this.levelReached,
      required this.awardedAt});

  factory _$StudentAchievementImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentAchievementImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String achievementType;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? iconUrl;
  @override
  final int xpEarned;
  @override
  final int? levelReached;
  @override
  final DateTime awardedAt;

  @override
  String toString() {
    return 'StudentAchievement(id: $id, userId: $userId, achievementType: $achievementType, title: $title, description: $description, iconUrl: $iconUrl, xpEarned: $xpEarned, levelReached: $levelReached, awardedAt: $awardedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentAchievementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.achievementType, achievementType) ||
                other.achievementType == achievementType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.xpEarned, xpEarned) ||
                other.xpEarned == xpEarned) &&
            (identical(other.levelReached, levelReached) ||
                other.levelReached == levelReached) &&
            (identical(other.awardedAt, awardedAt) ||
                other.awardedAt == awardedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, achievementType,
      title, description, iconUrl, xpEarned, levelReached, awardedAt);

  /// Create a copy of StudentAchievement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentAchievementImplCopyWith<_$StudentAchievementImpl> get copyWith =>
      __$$StudentAchievementImplCopyWithImpl<_$StudentAchievementImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentAchievementImplToJson(
      this,
    );
  }
}

abstract class _StudentAchievement implements StudentAchievement {
  const factory _StudentAchievement(
      {required final String id,
      required final String userId,
      required final String achievementType,
      required final String title,
      final String? description,
      final String? iconUrl,
      required final int xpEarned,
      final int? levelReached,
      required final DateTime awardedAt}) = _$StudentAchievementImpl;

  factory _StudentAchievement.fromJson(Map<String, dynamic> json) =
      _$StudentAchievementImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get achievementType;
  @override
  String get title;
  @override
  String? get description;
  @override
  String? get iconUrl;
  @override
  int get xpEarned;
  @override
  int? get levelReached;
  @override
  DateTime get awardedAt;

  /// Create a copy of StudentAchievement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentAchievementImplCopyWith<_$StudentAchievementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StudentDashboardData _$StudentDashboardDataFromJson(Map<String, dynamic> json) {
  return _StudentDashboardData.fromJson(json);
}

/// @nodoc
mixin _$StudentDashboardData {
  StudentProfile? get profile => throw _privateConstructorUsedError;
  List<StudentAchievement> get recentAchievements =>
      throw _privateConstructorUsedError;
  Map<String, dynamic>? get todaysWellness =>
      throw _privateConstructorUsedError;

  /// Serializes this StudentDashboardData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentDashboardDataCopyWith<StudentDashboardData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentDashboardDataCopyWith<$Res> {
  factory $StudentDashboardDataCopyWith(StudentDashboardData value,
          $Res Function(StudentDashboardData) then) =
      _$StudentDashboardDataCopyWithImpl<$Res, StudentDashboardData>;
  @useResult
  $Res call(
      {StudentProfile? profile,
      List<StudentAchievement> recentAchievements,
      Map<String, dynamic>? todaysWellness});

  $StudentProfileCopyWith<$Res>? get profile;
}

/// @nodoc
class _$StudentDashboardDataCopyWithImpl<$Res,
        $Val extends StudentDashboardData>
    implements $StudentDashboardDataCopyWith<$Res> {
  _$StudentDashboardDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = freezed,
    Object? recentAchievements = null,
    Object? todaysWellness = freezed,
  }) {
    return _then(_value.copyWith(
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as StudentProfile?,
      recentAchievements: null == recentAchievements
          ? _value.recentAchievements
          : recentAchievements // ignore: cast_nullable_to_non_nullable
              as List<StudentAchievement>,
      todaysWellness: freezed == todaysWellness
          ? _value.todaysWellness
          : todaysWellness // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  /// Create a copy of StudentDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StudentProfileCopyWith<$Res>? get profile {
    if (_value.profile == null) {
      return null;
    }

    return $StudentProfileCopyWith<$Res>(_value.profile!, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StudentDashboardDataImplCopyWith<$Res>
    implements $StudentDashboardDataCopyWith<$Res> {
  factory _$$StudentDashboardDataImplCopyWith(_$StudentDashboardDataImpl value,
          $Res Function(_$StudentDashboardDataImpl) then) =
      __$$StudentDashboardDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {StudentProfile? profile,
      List<StudentAchievement> recentAchievements,
      Map<String, dynamic>? todaysWellness});

  @override
  $StudentProfileCopyWith<$Res>? get profile;
}

/// @nodoc
class __$$StudentDashboardDataImplCopyWithImpl<$Res>
    extends _$StudentDashboardDataCopyWithImpl<$Res, _$StudentDashboardDataImpl>
    implements _$$StudentDashboardDataImplCopyWith<$Res> {
  __$$StudentDashboardDataImplCopyWithImpl(_$StudentDashboardDataImpl _value,
      $Res Function(_$StudentDashboardDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of StudentDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = freezed,
    Object? recentAchievements = null,
    Object? todaysWellness = freezed,
  }) {
    return _then(_$StudentDashboardDataImpl(
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as StudentProfile?,
      recentAchievements: null == recentAchievements
          ? _value._recentAchievements
          : recentAchievements // ignore: cast_nullable_to_non_nullable
              as List<StudentAchievement>,
      todaysWellness: freezed == todaysWellness
          ? _value._todaysWellness
          : todaysWellness // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentDashboardDataImpl implements _StudentDashboardData {
  const _$StudentDashboardDataImpl(
      {this.profile,
      final List<StudentAchievement> recentAchievements = const [],
      final Map<String, dynamic>? todaysWellness})
      : _recentAchievements = recentAchievements,
        _todaysWellness = todaysWellness;

  factory _$StudentDashboardDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentDashboardDataImplFromJson(json);

  @override
  final StudentProfile? profile;
  final List<StudentAchievement> _recentAchievements;
  @override
  @JsonKey()
  List<StudentAchievement> get recentAchievements {
    if (_recentAchievements is EqualUnmodifiableListView)
      return _recentAchievements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentAchievements);
  }

  final Map<String, dynamic>? _todaysWellness;
  @override
  Map<String, dynamic>? get todaysWellness {
    final value = _todaysWellness;
    if (value == null) return null;
    if (_todaysWellness is EqualUnmodifiableMapView) return _todaysWellness;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'StudentDashboardData(profile: $profile, recentAchievements: $recentAchievements, todaysWellness: $todaysWellness)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentDashboardDataImpl &&
            (identical(other.profile, profile) || other.profile == profile) &&
            const DeepCollectionEquality()
                .equals(other._recentAchievements, _recentAchievements) &&
            const DeepCollectionEquality()
                .equals(other._todaysWellness, _todaysWellness));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      profile,
      const DeepCollectionEquality().hash(_recentAchievements),
      const DeepCollectionEquality().hash(_todaysWellness));

  /// Create a copy of StudentDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentDashboardDataImplCopyWith<_$StudentDashboardDataImpl>
      get copyWith =>
          __$$StudentDashboardDataImplCopyWithImpl<_$StudentDashboardDataImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentDashboardDataImplToJson(
      this,
    );
  }
}

abstract class _StudentDashboardData implements StudentDashboardData {
  const factory _StudentDashboardData(
      {final StudentProfile? profile,
      final List<StudentAchievement> recentAchievements,
      final Map<String, dynamic>? todaysWellness}) = _$StudentDashboardDataImpl;

  factory _StudentDashboardData.fromJson(Map<String, dynamic> json) =
      _$StudentDashboardDataImpl.fromJson;

  @override
  StudentProfile? get profile;
  @override
  List<StudentAchievement> get recentAchievements;
  @override
  Map<String, dynamic>? get todaysWellness;

  /// Create a copy of StudentDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentDashboardDataImplCopyWith<_$StudentDashboardDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

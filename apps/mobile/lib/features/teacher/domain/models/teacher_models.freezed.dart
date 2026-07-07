// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TeacherProfile _$TeacherProfileFromJson(Map<String, dynamic> json) {
  return _TeacherProfile.fromJson(json);
}

/// @nodoc
mixin _$TeacherProfile {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get headline => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  String? get teachingPhilosophy => throw _privateConstructorUsedError;
  int get yearsExperience => throw _privateConstructorUsedError;
  List<String> get teachingLanguages => throw _privateConstructorUsedError;
  String? get nationality => throw _privateConstructorUsedError;
  String? get countryCode => throw _privateConstructorUsedError;
  String? get cityState => throw _privateConstructorUsedError;
  String? get timezone => throw _privateConstructorUsedError;
  String? get websiteUrl => throw _privateConstructorUsedError;
  String? get introVideoUrl => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;
  int get profileCompletion => throw _privateConstructorUsedError;
  String get verificationStatus => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Relationships
  List<TeacherCertification> get certifications =>
      throw _privateConstructorUsedError;
  List<TeacherSpecialization> get specializations =>
      throw _privateConstructorUsedError;
  TeacherTeachingPreference? get teachingPreference =>
      throw _privateConstructorUsedError;
  List<TeacherPortfolioItem> get portfolioItems =>
      throw _privateConstructorUsedError;
  List<TeacherSocialLink> get socialLinks => throw _privateConstructorUsedError;
  TeacherStats? get stats => throw _privateConstructorUsedError;

  /// Serializes this TeacherProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeacherProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherProfileCopyWith<TeacherProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherProfileCopyWith<$Res> {
  factory $TeacherProfileCopyWith(
          TeacherProfile value, $Res Function(TeacherProfile) then) =
      _$TeacherProfileCopyWithImpl<$Res, TeacherProfile>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String? headline,
      String? bio,
      String? teachingPhilosophy,
      int yearsExperience,
      List<String> teachingLanguages,
      String? nationality,
      String? countryCode,
      String? cityState,
      String? timezone,
      String? websiteUrl,
      String? introVideoUrl,
      bool isPublic,
      int profileCompletion,
      String verificationStatus,
      bool isFeatured,
      DateTime? createdAt,
      DateTime? updatedAt,
      List<TeacherCertification> certifications,
      List<TeacherSpecialization> specializations,
      TeacherTeachingPreference? teachingPreference,
      List<TeacherPortfolioItem> portfolioItems,
      List<TeacherSocialLink> socialLinks,
      TeacherStats? stats});

  $TeacherTeachingPreferenceCopyWith<$Res>? get teachingPreference;
  $TeacherStatsCopyWith<$Res>? get stats;
}

/// @nodoc
class _$TeacherProfileCopyWithImpl<$Res, $Val extends TeacherProfile>
    implements $TeacherProfileCopyWith<$Res> {
  _$TeacherProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeacherProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? headline = freezed,
    Object? bio = freezed,
    Object? teachingPhilosophy = freezed,
    Object? yearsExperience = null,
    Object? teachingLanguages = null,
    Object? nationality = freezed,
    Object? countryCode = freezed,
    Object? cityState = freezed,
    Object? timezone = freezed,
    Object? websiteUrl = freezed,
    Object? introVideoUrl = freezed,
    Object? isPublic = null,
    Object? profileCompletion = null,
    Object? verificationStatus = null,
    Object? isFeatured = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? certifications = null,
    Object? specializations = null,
    Object? teachingPreference = freezed,
    Object? portfolioItems = null,
    Object? socialLinks = null,
    Object? stats = freezed,
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
      headline: freezed == headline
          ? _value.headline
          : headline // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      teachingPhilosophy: freezed == teachingPhilosophy
          ? _value.teachingPhilosophy
          : teachingPhilosophy // ignore: cast_nullable_to_non_nullable
              as String?,
      yearsExperience: null == yearsExperience
          ? _value.yearsExperience
          : yearsExperience // ignore: cast_nullable_to_non_nullable
              as int,
      teachingLanguages: null == teachingLanguages
          ? _value.teachingLanguages
          : teachingLanguages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nationality: freezed == nationality
          ? _value.nationality
          : nationality // ignore: cast_nullable_to_non_nullable
              as String?,
      countryCode: freezed == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String?,
      cityState: freezed == cityState
          ? _value.cityState
          : cityState // ignore: cast_nullable_to_non_nullable
              as String?,
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      websiteUrl: freezed == websiteUrl
          ? _value.websiteUrl
          : websiteUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      introVideoUrl: freezed == introVideoUrl
          ? _value.introVideoUrl
          : introVideoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      profileCompletion: null == profileCompletion
          ? _value.profileCompletion
          : profileCompletion // ignore: cast_nullable_to_non_nullable
              as int,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      certifications: null == certifications
          ? _value.certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<TeacherCertification>,
      specializations: null == specializations
          ? _value.specializations
          : specializations // ignore: cast_nullable_to_non_nullable
              as List<TeacherSpecialization>,
      teachingPreference: freezed == teachingPreference
          ? _value.teachingPreference
          : teachingPreference // ignore: cast_nullable_to_non_nullable
              as TeacherTeachingPreference?,
      portfolioItems: null == portfolioItems
          ? _value.portfolioItems
          : portfolioItems // ignore: cast_nullable_to_non_nullable
              as List<TeacherPortfolioItem>,
      socialLinks: null == socialLinks
          ? _value.socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as List<TeacherSocialLink>,
      stats: freezed == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as TeacherStats?,
    ) as $Val);
  }

  /// Create a copy of TeacherProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeacherTeachingPreferenceCopyWith<$Res>? get teachingPreference {
    if (_value.teachingPreference == null) {
      return null;
    }

    return $TeacherTeachingPreferenceCopyWith<$Res>(_value.teachingPreference!,
        (value) {
      return _then(_value.copyWith(teachingPreference: value) as $Val);
    });
  }

  /// Create a copy of TeacherProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeacherStatsCopyWith<$Res>? get stats {
    if (_value.stats == null) {
      return null;
    }

    return $TeacherStatsCopyWith<$Res>(_value.stats!, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TeacherProfileImplCopyWith<$Res>
    implements $TeacherProfileCopyWith<$Res> {
  factory _$$TeacherProfileImplCopyWith(_$TeacherProfileImpl value,
          $Res Function(_$TeacherProfileImpl) then) =
      __$$TeacherProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String? headline,
      String? bio,
      String? teachingPhilosophy,
      int yearsExperience,
      List<String> teachingLanguages,
      String? nationality,
      String? countryCode,
      String? cityState,
      String? timezone,
      String? websiteUrl,
      String? introVideoUrl,
      bool isPublic,
      int profileCompletion,
      String verificationStatus,
      bool isFeatured,
      DateTime? createdAt,
      DateTime? updatedAt,
      List<TeacherCertification> certifications,
      List<TeacherSpecialization> specializations,
      TeacherTeachingPreference? teachingPreference,
      List<TeacherPortfolioItem> portfolioItems,
      List<TeacherSocialLink> socialLinks,
      TeacherStats? stats});

  @override
  $TeacherTeachingPreferenceCopyWith<$Res>? get teachingPreference;
  @override
  $TeacherStatsCopyWith<$Res>? get stats;
}

/// @nodoc
class __$$TeacherProfileImplCopyWithImpl<$Res>
    extends _$TeacherProfileCopyWithImpl<$Res, _$TeacherProfileImpl>
    implements _$$TeacherProfileImplCopyWith<$Res> {
  __$$TeacherProfileImplCopyWithImpl(
      _$TeacherProfileImpl _value, $Res Function(_$TeacherProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeacherProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? headline = freezed,
    Object? bio = freezed,
    Object? teachingPhilosophy = freezed,
    Object? yearsExperience = null,
    Object? teachingLanguages = null,
    Object? nationality = freezed,
    Object? countryCode = freezed,
    Object? cityState = freezed,
    Object? timezone = freezed,
    Object? websiteUrl = freezed,
    Object? introVideoUrl = freezed,
    Object? isPublic = null,
    Object? profileCompletion = null,
    Object? verificationStatus = null,
    Object? isFeatured = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? certifications = null,
    Object? specializations = null,
    Object? teachingPreference = freezed,
    Object? portfolioItems = null,
    Object? socialLinks = null,
    Object? stats = freezed,
  }) {
    return _then(_$TeacherProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      headline: freezed == headline
          ? _value.headline
          : headline // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      teachingPhilosophy: freezed == teachingPhilosophy
          ? _value.teachingPhilosophy
          : teachingPhilosophy // ignore: cast_nullable_to_non_nullable
              as String?,
      yearsExperience: null == yearsExperience
          ? _value.yearsExperience
          : yearsExperience // ignore: cast_nullable_to_non_nullable
              as int,
      teachingLanguages: null == teachingLanguages
          ? _value._teachingLanguages
          : teachingLanguages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nationality: freezed == nationality
          ? _value.nationality
          : nationality // ignore: cast_nullable_to_non_nullable
              as String?,
      countryCode: freezed == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String?,
      cityState: freezed == cityState
          ? _value.cityState
          : cityState // ignore: cast_nullable_to_non_nullable
              as String?,
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      websiteUrl: freezed == websiteUrl
          ? _value.websiteUrl
          : websiteUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      introVideoUrl: freezed == introVideoUrl
          ? _value.introVideoUrl
          : introVideoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      profileCompletion: null == profileCompletion
          ? _value.profileCompletion
          : profileCompletion // ignore: cast_nullable_to_non_nullable
              as int,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      certifications: null == certifications
          ? _value._certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<TeacherCertification>,
      specializations: null == specializations
          ? _value._specializations
          : specializations // ignore: cast_nullable_to_non_nullable
              as List<TeacherSpecialization>,
      teachingPreference: freezed == teachingPreference
          ? _value.teachingPreference
          : teachingPreference // ignore: cast_nullable_to_non_nullable
              as TeacherTeachingPreference?,
      portfolioItems: null == portfolioItems
          ? _value._portfolioItems
          : portfolioItems // ignore: cast_nullable_to_non_nullable
              as List<TeacherPortfolioItem>,
      socialLinks: null == socialLinks
          ? _value._socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as List<TeacherSocialLink>,
      stats: freezed == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as TeacherStats?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherProfileImpl implements _TeacherProfile {
  const _$TeacherProfileImpl(
      {required this.id,
      required this.userId,
      this.headline,
      this.bio,
      this.teachingPhilosophy,
      this.yearsExperience = 0,
      final List<String> teachingLanguages = const [],
      this.nationality,
      this.countryCode,
      this.cityState,
      this.timezone,
      this.websiteUrl,
      this.introVideoUrl,
      this.isPublic = false,
      this.profileCompletion = 0,
      this.verificationStatus = 'NOT_SUBMITTED',
      this.isFeatured = false,
      this.createdAt,
      this.updatedAt,
      final List<TeacherCertification> certifications = const [],
      final List<TeacherSpecialization> specializations = const [],
      this.teachingPreference,
      final List<TeacherPortfolioItem> portfolioItems = const [],
      final List<TeacherSocialLink> socialLinks = const [],
      this.stats})
      : _teachingLanguages = teachingLanguages,
        _certifications = certifications,
        _specializations = specializations,
        _portfolioItems = portfolioItems,
        _socialLinks = socialLinks;

  factory _$TeacherProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? headline;
  @override
  final String? bio;
  @override
  final String? teachingPhilosophy;
  @override
  @JsonKey()
  final int yearsExperience;
  final List<String> _teachingLanguages;
  @override
  @JsonKey()
  List<String> get teachingLanguages {
    if (_teachingLanguages is EqualUnmodifiableListView)
      return _teachingLanguages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_teachingLanguages);
  }

  @override
  final String? nationality;
  @override
  final String? countryCode;
  @override
  final String? cityState;
  @override
  final String? timezone;
  @override
  final String? websiteUrl;
  @override
  final String? introVideoUrl;
  @override
  @JsonKey()
  final bool isPublic;
  @override
  @JsonKey()
  final int profileCompletion;
  @override
  @JsonKey()
  final String verificationStatus;
  @override
  @JsonKey()
  final bool isFeatured;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
// Relationships
  final List<TeacherCertification> _certifications;
// Relationships
  @override
  @JsonKey()
  List<TeacherCertification> get certifications {
    if (_certifications is EqualUnmodifiableListView) return _certifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_certifications);
  }

  final List<TeacherSpecialization> _specializations;
  @override
  @JsonKey()
  List<TeacherSpecialization> get specializations {
    if (_specializations is EqualUnmodifiableListView) return _specializations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specializations);
  }

  @override
  final TeacherTeachingPreference? teachingPreference;
  final List<TeacherPortfolioItem> _portfolioItems;
  @override
  @JsonKey()
  List<TeacherPortfolioItem> get portfolioItems {
    if (_portfolioItems is EqualUnmodifiableListView) return _portfolioItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_portfolioItems);
  }

  final List<TeacherSocialLink> _socialLinks;
  @override
  @JsonKey()
  List<TeacherSocialLink> get socialLinks {
    if (_socialLinks is EqualUnmodifiableListView) return _socialLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_socialLinks);
  }

  @override
  final TeacherStats? stats;

  @override
  String toString() {
    return 'TeacherProfile(id: $id, userId: $userId, headline: $headline, bio: $bio, teachingPhilosophy: $teachingPhilosophy, yearsExperience: $yearsExperience, teachingLanguages: $teachingLanguages, nationality: $nationality, countryCode: $countryCode, cityState: $cityState, timezone: $timezone, websiteUrl: $websiteUrl, introVideoUrl: $introVideoUrl, isPublic: $isPublic, profileCompletion: $profileCompletion, verificationStatus: $verificationStatus, isFeatured: $isFeatured, createdAt: $createdAt, updatedAt: $updatedAt, certifications: $certifications, specializations: $specializations, teachingPreference: $teachingPreference, portfolioItems: $portfolioItems, socialLinks: $socialLinks, stats: $stats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.headline, headline) ||
                other.headline == headline) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.teachingPhilosophy, teachingPhilosophy) ||
                other.teachingPhilosophy == teachingPhilosophy) &&
            (identical(other.yearsExperience, yearsExperience) ||
                other.yearsExperience == yearsExperience) &&
            const DeepCollectionEquality()
                .equals(other._teachingLanguages, _teachingLanguages) &&
            (identical(other.nationality, nationality) ||
                other.nationality == nationality) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.cityState, cityState) ||
                other.cityState == cityState) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.websiteUrl, websiteUrl) ||
                other.websiteUrl == websiteUrl) &&
            (identical(other.introVideoUrl, introVideoUrl) ||
                other.introVideoUrl == introVideoUrl) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.profileCompletion, profileCompletion) ||
                other.profileCompletion == profileCompletion) &&
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._certifications, _certifications) &&
            const DeepCollectionEquality()
                .equals(other._specializations, _specializations) &&
            (identical(other.teachingPreference, teachingPreference) ||
                other.teachingPreference == teachingPreference) &&
            const DeepCollectionEquality()
                .equals(other._portfolioItems, _portfolioItems) &&
            const DeepCollectionEquality()
                .equals(other._socialLinks, _socialLinks) &&
            (identical(other.stats, stats) || other.stats == stats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        headline,
        bio,
        teachingPhilosophy,
        yearsExperience,
        const DeepCollectionEquality().hash(_teachingLanguages),
        nationality,
        countryCode,
        cityState,
        timezone,
        websiteUrl,
        introVideoUrl,
        isPublic,
        profileCompletion,
        verificationStatus,
        isFeatured,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(_certifications),
        const DeepCollectionEquality().hash(_specializations),
        teachingPreference,
        const DeepCollectionEquality().hash(_portfolioItems),
        const DeepCollectionEquality().hash(_socialLinks),
        stats
      ]);

  /// Create a copy of TeacherProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherProfileImplCopyWith<_$TeacherProfileImpl> get copyWith =>
      __$$TeacherProfileImplCopyWithImpl<_$TeacherProfileImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherProfileImplToJson(
      this,
    );
  }
}

abstract class _TeacherProfile implements TeacherProfile {
  const factory _TeacherProfile(
      {required final String id,
      required final String userId,
      final String? headline,
      final String? bio,
      final String? teachingPhilosophy,
      final int yearsExperience,
      final List<String> teachingLanguages,
      final String? nationality,
      final String? countryCode,
      final String? cityState,
      final String? timezone,
      final String? websiteUrl,
      final String? introVideoUrl,
      final bool isPublic,
      final int profileCompletion,
      final String verificationStatus,
      final bool isFeatured,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final List<TeacherCertification> certifications,
      final List<TeacherSpecialization> specializations,
      final TeacherTeachingPreference? teachingPreference,
      final List<TeacherPortfolioItem> portfolioItems,
      final List<TeacherSocialLink> socialLinks,
      final TeacherStats? stats}) = _$TeacherProfileImpl;

  factory _TeacherProfile.fromJson(Map<String, dynamic> json) =
      _$TeacherProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get headline;
  @override
  String? get bio;
  @override
  String? get teachingPhilosophy;
  @override
  int get yearsExperience;
  @override
  List<String> get teachingLanguages;
  @override
  String? get nationality;
  @override
  String? get countryCode;
  @override
  String? get cityState;
  @override
  String? get timezone;
  @override
  String? get websiteUrl;
  @override
  String? get introVideoUrl;
  @override
  bool get isPublic;
  @override
  int get profileCompletion;
  @override
  String get verificationStatus;
  @override
  bool get isFeatured;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // Relationships
  @override
  List<TeacherCertification> get certifications;
  @override
  List<TeacherSpecialization> get specializations;
  @override
  TeacherTeachingPreference? get teachingPreference;
  @override
  List<TeacherPortfolioItem> get portfolioItems;
  @override
  List<TeacherSocialLink> get socialLinks;
  @override
  TeacherStats? get stats;

  /// Create a copy of TeacherProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherProfileImplCopyWith<_$TeacherProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeacherSpecialization _$TeacherSpecializationFromJson(
    Map<String, dynamic> json) {
  return _TeacherSpecialization.fromJson(json);
}

/// @nodoc
mixin _$TeacherSpecialization {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get specialization => throw _privateConstructorUsedError;
  int get proficiencyYears => throw _privateConstructorUsedError;
  bool get isPrimary => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;

  /// Serializes this TeacherSpecialization to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeacherSpecialization
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherSpecializationCopyWith<TeacherSpecialization> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherSpecializationCopyWith<$Res> {
  factory $TeacherSpecializationCopyWith(TeacherSpecialization value,
          $Res Function(TeacherSpecialization) then) =
      _$TeacherSpecializationCopyWithImpl<$Res, TeacherSpecialization>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String specialization,
      int proficiencyYears,
      bool isPrimary,
      int displayOrder});
}

/// @nodoc
class _$TeacherSpecializationCopyWithImpl<$Res,
        $Val extends TeacherSpecialization>
    implements $TeacherSpecializationCopyWith<$Res> {
  _$TeacherSpecializationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeacherSpecialization
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? specialization = null,
    Object? proficiencyYears = null,
    Object? isPrimary = null,
    Object? displayOrder = null,
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
      specialization: null == specialization
          ? _value.specialization
          : specialization // ignore: cast_nullable_to_non_nullable
              as String,
      proficiencyYears: null == proficiencyYears
          ? _value.proficiencyYears
          : proficiencyYears // ignore: cast_nullable_to_non_nullable
              as int,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeacherSpecializationImplCopyWith<$Res>
    implements $TeacherSpecializationCopyWith<$Res> {
  factory _$$TeacherSpecializationImplCopyWith(
          _$TeacherSpecializationImpl value,
          $Res Function(_$TeacherSpecializationImpl) then) =
      __$$TeacherSpecializationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String specialization,
      int proficiencyYears,
      bool isPrimary,
      int displayOrder});
}

/// @nodoc
class __$$TeacherSpecializationImplCopyWithImpl<$Res>
    extends _$TeacherSpecializationCopyWithImpl<$Res,
        _$TeacherSpecializationImpl>
    implements _$$TeacherSpecializationImplCopyWith<$Res> {
  __$$TeacherSpecializationImplCopyWithImpl(_$TeacherSpecializationImpl _value,
      $Res Function(_$TeacherSpecializationImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeacherSpecialization
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? specialization = null,
    Object? proficiencyYears = null,
    Object? isPrimary = null,
    Object? displayOrder = null,
  }) {
    return _then(_$TeacherSpecializationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      specialization: null == specialization
          ? _value.specialization
          : specialization // ignore: cast_nullable_to_non_nullable
              as String,
      proficiencyYears: null == proficiencyYears
          ? _value.proficiencyYears
          : proficiencyYears // ignore: cast_nullable_to_non_nullable
              as int,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherSpecializationImpl implements _TeacherSpecialization {
  const _$TeacherSpecializationImpl(
      {required this.id,
      required this.userId,
      required this.specialization,
      this.proficiencyYears = 0,
      this.isPrimary = false,
      this.displayOrder = 0});

  factory _$TeacherSpecializationImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherSpecializationImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String specialization;
  @override
  @JsonKey()
  final int proficiencyYears;
  @override
  @JsonKey()
  final bool isPrimary;
  @override
  @JsonKey()
  final int displayOrder;

  @override
  String toString() {
    return 'TeacherSpecialization(id: $id, userId: $userId, specialization: $specialization, proficiencyYears: $proficiencyYears, isPrimary: $isPrimary, displayOrder: $displayOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherSpecializationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.specialization, specialization) ||
                other.specialization == specialization) &&
            (identical(other.proficiencyYears, proficiencyYears) ||
                other.proficiencyYears == proficiencyYears) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, specialization,
      proficiencyYears, isPrimary, displayOrder);

  /// Create a copy of TeacherSpecialization
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherSpecializationImplCopyWith<_$TeacherSpecializationImpl>
      get copyWith => __$$TeacherSpecializationImplCopyWithImpl<
          _$TeacherSpecializationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherSpecializationImplToJson(
      this,
    );
  }
}

abstract class _TeacherSpecialization implements TeacherSpecialization {
  const factory _TeacherSpecialization(
      {required final String id,
      required final String userId,
      required final String specialization,
      final int proficiencyYears,
      final bool isPrimary,
      final int displayOrder}) = _$TeacherSpecializationImpl;

  factory _TeacherSpecialization.fromJson(Map<String, dynamic> json) =
      _$TeacherSpecializationImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get specialization;
  @override
  int get proficiencyYears;
  @override
  bool get isPrimary;
  @override
  int get displayOrder;

  /// Create a copy of TeacherSpecialization
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherSpecializationImplCopyWith<_$TeacherSpecializationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TeacherCertification _$TeacherCertificationFromJson(Map<String, dynamic> json) {
  return _TeacherCertification.fromJson(json);
}

/// @nodoc
mixin _$TeacherCertification {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get certificationType => throw _privateConstructorUsedError;
  String get certificationName => throw _privateConstructorUsedError;
  String get issuingOrganization => throw _privateConstructorUsedError;
  String? get certificationNumber => throw _privateConstructorUsedError;
  DateTime? get issuedAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  String? get documentUrl => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;

  /// Serializes this TeacherCertification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeacherCertification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherCertificationCopyWith<TeacherCertification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherCertificationCopyWith<$Res> {
  factory $TeacherCertificationCopyWith(TeacherCertification value,
          $Res Function(TeacherCertification) then) =
      _$TeacherCertificationCopyWithImpl<$Res, TeacherCertification>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String certificationType,
      String certificationName,
      String issuingOrganization,
      String? certificationNumber,
      DateTime? issuedAt,
      DateTime? expiresAt,
      String? documentUrl,
      bool isVerified,
      bool isActive,
      int displayOrder});
}

/// @nodoc
class _$TeacherCertificationCopyWithImpl<$Res,
        $Val extends TeacherCertification>
    implements $TeacherCertificationCopyWith<$Res> {
  _$TeacherCertificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeacherCertification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? certificationType = null,
    Object? certificationName = null,
    Object? issuingOrganization = null,
    Object? certificationNumber = freezed,
    Object? issuedAt = freezed,
    Object? expiresAt = freezed,
    Object? documentUrl = freezed,
    Object? isVerified = null,
    Object? isActive = null,
    Object? displayOrder = null,
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
      certificationType: null == certificationType
          ? _value.certificationType
          : certificationType // ignore: cast_nullable_to_non_nullable
              as String,
      certificationName: null == certificationName
          ? _value.certificationName
          : certificationName // ignore: cast_nullable_to_non_nullable
              as String,
      issuingOrganization: null == issuingOrganization
          ? _value.issuingOrganization
          : issuingOrganization // ignore: cast_nullable_to_non_nullable
              as String,
      certificationNumber: freezed == certificationNumber
          ? _value.certificationNumber
          : certificationNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      issuedAt: freezed == issuedAt
          ? _value.issuedAt
          : issuedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      documentUrl: freezed == documentUrl
          ? _value.documentUrl
          : documentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeacherCertificationImplCopyWith<$Res>
    implements $TeacherCertificationCopyWith<$Res> {
  factory _$$TeacherCertificationImplCopyWith(_$TeacherCertificationImpl value,
          $Res Function(_$TeacherCertificationImpl) then) =
      __$$TeacherCertificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String certificationType,
      String certificationName,
      String issuingOrganization,
      String? certificationNumber,
      DateTime? issuedAt,
      DateTime? expiresAt,
      String? documentUrl,
      bool isVerified,
      bool isActive,
      int displayOrder});
}

/// @nodoc
class __$$TeacherCertificationImplCopyWithImpl<$Res>
    extends _$TeacherCertificationCopyWithImpl<$Res, _$TeacherCertificationImpl>
    implements _$$TeacherCertificationImplCopyWith<$Res> {
  __$$TeacherCertificationImplCopyWithImpl(_$TeacherCertificationImpl _value,
      $Res Function(_$TeacherCertificationImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeacherCertification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? certificationType = null,
    Object? certificationName = null,
    Object? issuingOrganization = null,
    Object? certificationNumber = freezed,
    Object? issuedAt = freezed,
    Object? expiresAt = freezed,
    Object? documentUrl = freezed,
    Object? isVerified = null,
    Object? isActive = null,
    Object? displayOrder = null,
  }) {
    return _then(_$TeacherCertificationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      certificationType: null == certificationType
          ? _value.certificationType
          : certificationType // ignore: cast_nullable_to_non_nullable
              as String,
      certificationName: null == certificationName
          ? _value.certificationName
          : certificationName // ignore: cast_nullable_to_non_nullable
              as String,
      issuingOrganization: null == issuingOrganization
          ? _value.issuingOrganization
          : issuingOrganization // ignore: cast_nullable_to_non_nullable
              as String,
      certificationNumber: freezed == certificationNumber
          ? _value.certificationNumber
          : certificationNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      issuedAt: freezed == issuedAt
          ? _value.issuedAt
          : issuedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      documentUrl: freezed == documentUrl
          ? _value.documentUrl
          : documentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherCertificationImpl implements _TeacherCertification {
  const _$TeacherCertificationImpl(
      {required this.id,
      required this.userId,
      required this.certificationType,
      required this.certificationName,
      required this.issuingOrganization,
      this.certificationNumber,
      this.issuedAt,
      this.expiresAt,
      this.documentUrl,
      this.isVerified = false,
      this.isActive = true,
      this.displayOrder = 0});

  factory _$TeacherCertificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherCertificationImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String certificationType;
  @override
  final String certificationName;
  @override
  final String issuingOrganization;
  @override
  final String? certificationNumber;
  @override
  final DateTime? issuedAt;
  @override
  final DateTime? expiresAt;
  @override
  final String? documentUrl;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final int displayOrder;

  @override
  String toString() {
    return 'TeacherCertification(id: $id, userId: $userId, certificationType: $certificationType, certificationName: $certificationName, issuingOrganization: $issuingOrganization, certificationNumber: $certificationNumber, issuedAt: $issuedAt, expiresAt: $expiresAt, documentUrl: $documentUrl, isVerified: $isVerified, isActive: $isActive, displayOrder: $displayOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherCertificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.certificationType, certificationType) ||
                other.certificationType == certificationType) &&
            (identical(other.certificationName, certificationName) ||
                other.certificationName == certificationName) &&
            (identical(other.issuingOrganization, issuingOrganization) ||
                other.issuingOrganization == issuingOrganization) &&
            (identical(other.certificationNumber, certificationNumber) ||
                other.certificationNumber == certificationNumber) &&
            (identical(other.issuedAt, issuedAt) ||
                other.issuedAt == issuedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.documentUrl, documentUrl) ||
                other.documentUrl == documentUrl) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      certificationType,
      certificationName,
      issuingOrganization,
      certificationNumber,
      issuedAt,
      expiresAt,
      documentUrl,
      isVerified,
      isActive,
      displayOrder);

  /// Create a copy of TeacherCertification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherCertificationImplCopyWith<_$TeacherCertificationImpl>
      get copyWith =>
          __$$TeacherCertificationImplCopyWithImpl<_$TeacherCertificationImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherCertificationImplToJson(
      this,
    );
  }
}

abstract class _TeacherCertification implements TeacherCertification {
  const factory _TeacherCertification(
      {required final String id,
      required final String userId,
      required final String certificationType,
      required final String certificationName,
      required final String issuingOrganization,
      final String? certificationNumber,
      final DateTime? issuedAt,
      final DateTime? expiresAt,
      final String? documentUrl,
      final bool isVerified,
      final bool isActive,
      final int displayOrder}) = _$TeacherCertificationImpl;

  factory _TeacherCertification.fromJson(Map<String, dynamic> json) =
      _$TeacherCertificationImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get certificationType;
  @override
  String get certificationName;
  @override
  String get issuingOrganization;
  @override
  String? get certificationNumber;
  @override
  DateTime? get issuedAt;
  @override
  DateTime? get expiresAt;
  @override
  String? get documentUrl;
  @override
  bool get isVerified;
  @override
  bool get isActive;
  @override
  int get displayOrder;

  /// Create a copy of TeacherCertification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherCertificationImplCopyWith<_$TeacherCertificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TeacherPortfolioItem _$TeacherPortfolioItemFromJson(Map<String, dynamic> json) {
  return _TeacherPortfolioItem.fromJson(json);
}

/// @nodoc
mixin _$TeacherPortfolioItem {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get itemType => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get mediaUrl => throw _privateConstructorUsedError;
  String? get externalUrl => throw _privateConstructorUsedError;
  DateTime? get issuedAt => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;

  /// Serializes this TeacherPortfolioItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeacherPortfolioItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherPortfolioItemCopyWith<TeacherPortfolioItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherPortfolioItemCopyWith<$Res> {
  factory $TeacherPortfolioItemCopyWith(TeacherPortfolioItem value,
          $Res Function(TeacherPortfolioItem) then) =
      _$TeacherPortfolioItemCopyWithImpl<$Res, TeacherPortfolioItem>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String itemType,
      String title,
      String? description,
      String? mediaUrl,
      String? externalUrl,
      DateTime? issuedAt,
      bool isFeatured,
      int displayOrder});
}

/// @nodoc
class _$TeacherPortfolioItemCopyWithImpl<$Res,
        $Val extends TeacherPortfolioItem>
    implements $TeacherPortfolioItemCopyWith<$Res> {
  _$TeacherPortfolioItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeacherPortfolioItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? itemType = null,
    Object? title = null,
    Object? description = freezed,
    Object? mediaUrl = freezed,
    Object? externalUrl = freezed,
    Object? issuedAt = freezed,
    Object? isFeatured = null,
    Object? displayOrder = null,
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
      itemType: null == itemType
          ? _value.itemType
          : itemType // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaUrl: freezed == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      externalUrl: freezed == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      issuedAt: freezed == issuedAt
          ? _value.issuedAt
          : issuedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeacherPortfolioItemImplCopyWith<$Res>
    implements $TeacherPortfolioItemCopyWith<$Res> {
  factory _$$TeacherPortfolioItemImplCopyWith(_$TeacherPortfolioItemImpl value,
          $Res Function(_$TeacherPortfolioItemImpl) then) =
      __$$TeacherPortfolioItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String itemType,
      String title,
      String? description,
      String? mediaUrl,
      String? externalUrl,
      DateTime? issuedAt,
      bool isFeatured,
      int displayOrder});
}

/// @nodoc
class __$$TeacherPortfolioItemImplCopyWithImpl<$Res>
    extends _$TeacherPortfolioItemCopyWithImpl<$Res, _$TeacherPortfolioItemImpl>
    implements _$$TeacherPortfolioItemImplCopyWith<$Res> {
  __$$TeacherPortfolioItemImplCopyWithImpl(_$TeacherPortfolioItemImpl _value,
      $Res Function(_$TeacherPortfolioItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeacherPortfolioItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? itemType = null,
    Object? title = null,
    Object? description = freezed,
    Object? mediaUrl = freezed,
    Object? externalUrl = freezed,
    Object? issuedAt = freezed,
    Object? isFeatured = null,
    Object? displayOrder = null,
  }) {
    return _then(_$TeacherPortfolioItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      itemType: null == itemType
          ? _value.itemType
          : itemType // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaUrl: freezed == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      externalUrl: freezed == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      issuedAt: freezed == issuedAt
          ? _value.issuedAt
          : issuedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherPortfolioItemImpl implements _TeacherPortfolioItem {
  const _$TeacherPortfolioItemImpl(
      {required this.id,
      required this.userId,
      required this.itemType,
      required this.title,
      this.description,
      this.mediaUrl,
      this.externalUrl,
      this.issuedAt,
      this.isFeatured = false,
      this.displayOrder = 0});

  factory _$TeacherPortfolioItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherPortfolioItemImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String itemType;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? mediaUrl;
  @override
  final String? externalUrl;
  @override
  final DateTime? issuedAt;
  @override
  @JsonKey()
  final bool isFeatured;
  @override
  @JsonKey()
  final int displayOrder;

  @override
  String toString() {
    return 'TeacherPortfolioItem(id: $id, userId: $userId, itemType: $itemType, title: $title, description: $description, mediaUrl: $mediaUrl, externalUrl: $externalUrl, issuedAt: $issuedAt, isFeatured: $isFeatured, displayOrder: $displayOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherPortfolioItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.itemType, itemType) ||
                other.itemType == itemType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.externalUrl, externalUrl) ||
                other.externalUrl == externalUrl) &&
            (identical(other.issuedAt, issuedAt) ||
                other.issuedAt == issuedAt) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, itemType, title,
      description, mediaUrl, externalUrl, issuedAt, isFeatured, displayOrder);

  /// Create a copy of TeacherPortfolioItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherPortfolioItemImplCopyWith<_$TeacherPortfolioItemImpl>
      get copyWith =>
          __$$TeacherPortfolioItemImplCopyWithImpl<_$TeacherPortfolioItemImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherPortfolioItemImplToJson(
      this,
    );
  }
}

abstract class _TeacherPortfolioItem implements TeacherPortfolioItem {
  const factory _TeacherPortfolioItem(
      {required final String id,
      required final String userId,
      required final String itemType,
      required final String title,
      final String? description,
      final String? mediaUrl,
      final String? externalUrl,
      final DateTime? issuedAt,
      final bool isFeatured,
      final int displayOrder}) = _$TeacherPortfolioItemImpl;

  factory _TeacherPortfolioItem.fromJson(Map<String, dynamic> json) =
      _$TeacherPortfolioItemImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get itemType;
  @override
  String get title;
  @override
  String? get description;
  @override
  String? get mediaUrl;
  @override
  String? get externalUrl;
  @override
  DateTime? get issuedAt;
  @override
  bool get isFeatured;
  @override
  int get displayOrder;

  /// Create a copy of TeacherPortfolioItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherPortfolioItemImplCopyWith<_$TeacherPortfolioItemImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TeacherSocialLink _$TeacherSocialLinkFromJson(Map<String, dynamic> json) {
  return _TeacherSocialLink.fromJson(json);
}

/// @nodoc
mixin _$TeacherSocialLink {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;

  /// Serializes this TeacherSocialLink to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeacherSocialLink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherSocialLinkCopyWith<TeacherSocialLink> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherSocialLinkCopyWith<$Res> {
  factory $TeacherSocialLinkCopyWith(
          TeacherSocialLink value, $Res Function(TeacherSocialLink) then) =
      _$TeacherSocialLinkCopyWithImpl<$Res, TeacherSocialLink>;
  @useResult
  $Res call(
      {String id, String userId, String platform, String url, bool isPublic});
}

/// @nodoc
class _$TeacherSocialLinkCopyWithImpl<$Res, $Val extends TeacherSocialLink>
    implements $TeacherSocialLinkCopyWith<$Res> {
  _$TeacherSocialLinkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeacherSocialLink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? platform = null,
    Object? url = null,
    Object? isPublic = null,
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
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeacherSocialLinkImplCopyWith<$Res>
    implements $TeacherSocialLinkCopyWith<$Res> {
  factory _$$TeacherSocialLinkImplCopyWith(_$TeacherSocialLinkImpl value,
          $Res Function(_$TeacherSocialLinkImpl) then) =
      __$$TeacherSocialLinkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String userId, String platform, String url, bool isPublic});
}

/// @nodoc
class __$$TeacherSocialLinkImplCopyWithImpl<$Res>
    extends _$TeacherSocialLinkCopyWithImpl<$Res, _$TeacherSocialLinkImpl>
    implements _$$TeacherSocialLinkImplCopyWith<$Res> {
  __$$TeacherSocialLinkImplCopyWithImpl(_$TeacherSocialLinkImpl _value,
      $Res Function(_$TeacherSocialLinkImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeacherSocialLink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? platform = null,
    Object? url = null,
    Object? isPublic = null,
  }) {
    return _then(_$TeacherSocialLinkImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherSocialLinkImpl implements _TeacherSocialLink {
  const _$TeacherSocialLinkImpl(
      {required this.id,
      required this.userId,
      required this.platform,
      required this.url,
      this.isPublic = true});

  factory _$TeacherSocialLinkImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherSocialLinkImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String platform;
  @override
  final String url;
  @override
  @JsonKey()
  final bool isPublic;

  @override
  String toString() {
    return 'TeacherSocialLink(id: $id, userId: $userId, platform: $platform, url: $url, isPublic: $isPublic)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherSocialLinkImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, platform, url, isPublic);

  /// Create a copy of TeacherSocialLink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherSocialLinkImplCopyWith<_$TeacherSocialLinkImpl> get copyWith =>
      __$$TeacherSocialLinkImplCopyWithImpl<_$TeacherSocialLinkImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherSocialLinkImplToJson(
      this,
    );
  }
}

abstract class _TeacherSocialLink implements TeacherSocialLink {
  const factory _TeacherSocialLink(
      {required final String id,
      required final String userId,
      required final String platform,
      required final String url,
      final bool isPublic}) = _$TeacherSocialLinkImpl;

  factory _TeacherSocialLink.fromJson(Map<String, dynamic> json) =
      _$TeacherSocialLinkImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get platform;
  @override
  String get url;
  @override
  bool get isPublic;

  /// Create a copy of TeacherSocialLink
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherSocialLinkImplCopyWith<_$TeacherSocialLinkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeacherTeachingPreference _$TeacherTeachingPreferenceFromJson(
    Map<String, dynamic> json) {
  return _TeacherTeachingPreference.fromJson(json);
}

/// @nodoc
mixin _$TeacherTeachingPreference {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  List<String> get teachingModes => throw _privateConstructorUsedError;
  List<String> get teachingFormats => throw _privateConstructorUsedError;
  List<String> get ageGroups => throw _privateConstructorUsedError;
  List<String> get skillLevels => throw _privateConstructorUsedError;
  int? get maxGroupSize => throw _privateConstructorUsedError;
  int? get minGroupSize => throw _privateConstructorUsedError;
  int? get travelRadius => throw _privateConstructorUsedError;
  bool get onlineOnly => throw _privateConstructorUsedError;
  List<int> get classDurationMins => throw _privateConstructorUsedError;
  List<String> get preferredLanguages => throw _privateConstructorUsedError;

  /// Serializes this TeacherTeachingPreference to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeacherTeachingPreference
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherTeachingPreferenceCopyWith<TeacherTeachingPreference> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherTeachingPreferenceCopyWith<$Res> {
  factory $TeacherTeachingPreferenceCopyWith(TeacherTeachingPreference value,
          $Res Function(TeacherTeachingPreference) then) =
      _$TeacherTeachingPreferenceCopyWithImpl<$Res, TeacherTeachingPreference>;
  @useResult
  $Res call(
      {String id,
      String userId,
      List<String> teachingModes,
      List<String> teachingFormats,
      List<String> ageGroups,
      List<String> skillLevels,
      int? maxGroupSize,
      int? minGroupSize,
      int? travelRadius,
      bool onlineOnly,
      List<int> classDurationMins,
      List<String> preferredLanguages});
}

/// @nodoc
class _$TeacherTeachingPreferenceCopyWithImpl<$Res,
        $Val extends TeacherTeachingPreference>
    implements $TeacherTeachingPreferenceCopyWith<$Res> {
  _$TeacherTeachingPreferenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeacherTeachingPreference
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? teachingModes = null,
    Object? teachingFormats = null,
    Object? ageGroups = null,
    Object? skillLevels = null,
    Object? maxGroupSize = freezed,
    Object? minGroupSize = freezed,
    Object? travelRadius = freezed,
    Object? onlineOnly = null,
    Object? classDurationMins = null,
    Object? preferredLanguages = null,
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
      teachingModes: null == teachingModes
          ? _value.teachingModes
          : teachingModes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      teachingFormats: null == teachingFormats
          ? _value.teachingFormats
          : teachingFormats // ignore: cast_nullable_to_non_nullable
              as List<String>,
      ageGroups: null == ageGroups
          ? _value.ageGroups
          : ageGroups // ignore: cast_nullable_to_non_nullable
              as List<String>,
      skillLevels: null == skillLevels
          ? _value.skillLevels
          : skillLevels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      maxGroupSize: freezed == maxGroupSize
          ? _value.maxGroupSize
          : maxGroupSize // ignore: cast_nullable_to_non_nullable
              as int?,
      minGroupSize: freezed == minGroupSize
          ? _value.minGroupSize
          : minGroupSize // ignore: cast_nullable_to_non_nullable
              as int?,
      travelRadius: freezed == travelRadius
          ? _value.travelRadius
          : travelRadius // ignore: cast_nullable_to_non_nullable
              as int?,
      onlineOnly: null == onlineOnly
          ? _value.onlineOnly
          : onlineOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      classDurationMins: null == classDurationMins
          ? _value.classDurationMins
          : classDurationMins // ignore: cast_nullable_to_non_nullable
              as List<int>,
      preferredLanguages: null == preferredLanguages
          ? _value.preferredLanguages
          : preferredLanguages // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeacherTeachingPreferenceImplCopyWith<$Res>
    implements $TeacherTeachingPreferenceCopyWith<$Res> {
  factory _$$TeacherTeachingPreferenceImplCopyWith(
          _$TeacherTeachingPreferenceImpl value,
          $Res Function(_$TeacherTeachingPreferenceImpl) then) =
      __$$TeacherTeachingPreferenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      List<String> teachingModes,
      List<String> teachingFormats,
      List<String> ageGroups,
      List<String> skillLevels,
      int? maxGroupSize,
      int? minGroupSize,
      int? travelRadius,
      bool onlineOnly,
      List<int> classDurationMins,
      List<String> preferredLanguages});
}

/// @nodoc
class __$$TeacherTeachingPreferenceImplCopyWithImpl<$Res>
    extends _$TeacherTeachingPreferenceCopyWithImpl<$Res,
        _$TeacherTeachingPreferenceImpl>
    implements _$$TeacherTeachingPreferenceImplCopyWith<$Res> {
  __$$TeacherTeachingPreferenceImplCopyWithImpl(
      _$TeacherTeachingPreferenceImpl _value,
      $Res Function(_$TeacherTeachingPreferenceImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeacherTeachingPreference
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? teachingModes = null,
    Object? teachingFormats = null,
    Object? ageGroups = null,
    Object? skillLevels = null,
    Object? maxGroupSize = freezed,
    Object? minGroupSize = freezed,
    Object? travelRadius = freezed,
    Object? onlineOnly = null,
    Object? classDurationMins = null,
    Object? preferredLanguages = null,
  }) {
    return _then(_$TeacherTeachingPreferenceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      teachingModes: null == teachingModes
          ? _value._teachingModes
          : teachingModes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      teachingFormats: null == teachingFormats
          ? _value._teachingFormats
          : teachingFormats // ignore: cast_nullable_to_non_nullable
              as List<String>,
      ageGroups: null == ageGroups
          ? _value._ageGroups
          : ageGroups // ignore: cast_nullable_to_non_nullable
              as List<String>,
      skillLevels: null == skillLevels
          ? _value._skillLevels
          : skillLevels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      maxGroupSize: freezed == maxGroupSize
          ? _value.maxGroupSize
          : maxGroupSize // ignore: cast_nullable_to_non_nullable
              as int?,
      minGroupSize: freezed == minGroupSize
          ? _value.minGroupSize
          : minGroupSize // ignore: cast_nullable_to_non_nullable
              as int?,
      travelRadius: freezed == travelRadius
          ? _value.travelRadius
          : travelRadius // ignore: cast_nullable_to_non_nullable
              as int?,
      onlineOnly: null == onlineOnly
          ? _value.onlineOnly
          : onlineOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      classDurationMins: null == classDurationMins
          ? _value._classDurationMins
          : classDurationMins // ignore: cast_nullable_to_non_nullable
              as List<int>,
      preferredLanguages: null == preferredLanguages
          ? _value._preferredLanguages
          : preferredLanguages // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherTeachingPreferenceImpl implements _TeacherTeachingPreference {
  const _$TeacherTeachingPreferenceImpl(
      {required this.id,
      required this.userId,
      final List<String> teachingModes = const [],
      final List<String> teachingFormats = const [],
      final List<String> ageGroups = const [],
      final List<String> skillLevels = const [],
      this.maxGroupSize,
      this.minGroupSize,
      this.travelRadius,
      this.onlineOnly = false,
      final List<int> classDurationMins = const [],
      final List<String> preferredLanguages = const []})
      : _teachingModes = teachingModes,
        _teachingFormats = teachingFormats,
        _ageGroups = ageGroups,
        _skillLevels = skillLevels,
        _classDurationMins = classDurationMins,
        _preferredLanguages = preferredLanguages;

  factory _$TeacherTeachingPreferenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherTeachingPreferenceImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  final List<String> _teachingModes;
  @override
  @JsonKey()
  List<String> get teachingModes {
    if (_teachingModes is EqualUnmodifiableListView) return _teachingModes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_teachingModes);
  }

  final List<String> _teachingFormats;
  @override
  @JsonKey()
  List<String> get teachingFormats {
    if (_teachingFormats is EqualUnmodifiableListView) return _teachingFormats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_teachingFormats);
  }

  final List<String> _ageGroups;
  @override
  @JsonKey()
  List<String> get ageGroups {
    if (_ageGroups is EqualUnmodifiableListView) return _ageGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ageGroups);
  }

  final List<String> _skillLevels;
  @override
  @JsonKey()
  List<String> get skillLevels {
    if (_skillLevels is EqualUnmodifiableListView) return _skillLevels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skillLevels);
  }

  @override
  final int? maxGroupSize;
  @override
  final int? minGroupSize;
  @override
  final int? travelRadius;
  @override
  @JsonKey()
  final bool onlineOnly;
  final List<int> _classDurationMins;
  @override
  @JsonKey()
  List<int> get classDurationMins {
    if (_classDurationMins is EqualUnmodifiableListView)
      return _classDurationMins;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_classDurationMins);
  }

  final List<String> _preferredLanguages;
  @override
  @JsonKey()
  List<String> get preferredLanguages {
    if (_preferredLanguages is EqualUnmodifiableListView)
      return _preferredLanguages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_preferredLanguages);
  }

  @override
  String toString() {
    return 'TeacherTeachingPreference(id: $id, userId: $userId, teachingModes: $teachingModes, teachingFormats: $teachingFormats, ageGroups: $ageGroups, skillLevels: $skillLevels, maxGroupSize: $maxGroupSize, minGroupSize: $minGroupSize, travelRadius: $travelRadius, onlineOnly: $onlineOnly, classDurationMins: $classDurationMins, preferredLanguages: $preferredLanguages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherTeachingPreferenceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality()
                .equals(other._teachingModes, _teachingModes) &&
            const DeepCollectionEquality()
                .equals(other._teachingFormats, _teachingFormats) &&
            const DeepCollectionEquality()
                .equals(other._ageGroups, _ageGroups) &&
            const DeepCollectionEquality()
                .equals(other._skillLevels, _skillLevels) &&
            (identical(other.maxGroupSize, maxGroupSize) ||
                other.maxGroupSize == maxGroupSize) &&
            (identical(other.minGroupSize, minGroupSize) ||
                other.minGroupSize == minGroupSize) &&
            (identical(other.travelRadius, travelRadius) ||
                other.travelRadius == travelRadius) &&
            (identical(other.onlineOnly, onlineOnly) ||
                other.onlineOnly == onlineOnly) &&
            const DeepCollectionEquality()
                .equals(other._classDurationMins, _classDurationMins) &&
            const DeepCollectionEquality()
                .equals(other._preferredLanguages, _preferredLanguages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      const DeepCollectionEquality().hash(_teachingModes),
      const DeepCollectionEquality().hash(_teachingFormats),
      const DeepCollectionEquality().hash(_ageGroups),
      const DeepCollectionEquality().hash(_skillLevels),
      maxGroupSize,
      minGroupSize,
      travelRadius,
      onlineOnly,
      const DeepCollectionEquality().hash(_classDurationMins),
      const DeepCollectionEquality().hash(_preferredLanguages));

  /// Create a copy of TeacherTeachingPreference
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherTeachingPreferenceImplCopyWith<_$TeacherTeachingPreferenceImpl>
      get copyWith => __$$TeacherTeachingPreferenceImplCopyWithImpl<
          _$TeacherTeachingPreferenceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherTeachingPreferenceImplToJson(
      this,
    );
  }
}

abstract class _TeacherTeachingPreference implements TeacherTeachingPreference {
  const factory _TeacherTeachingPreference(
      {required final String id,
      required final String userId,
      final List<String> teachingModes,
      final List<String> teachingFormats,
      final List<String> ageGroups,
      final List<String> skillLevels,
      final int? maxGroupSize,
      final int? minGroupSize,
      final int? travelRadius,
      final bool onlineOnly,
      final List<int> classDurationMins,
      final List<String> preferredLanguages}) = _$TeacherTeachingPreferenceImpl;

  factory _TeacherTeachingPreference.fromJson(Map<String, dynamic> json) =
      _$TeacherTeachingPreferenceImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  List<String> get teachingModes;
  @override
  List<String> get teachingFormats;
  @override
  List<String> get ageGroups;
  @override
  List<String> get skillLevels;
  @override
  int? get maxGroupSize;
  @override
  int? get minGroupSize;
  @override
  int? get travelRadius;
  @override
  bool get onlineOnly;
  @override
  List<int> get classDurationMins;
  @override
  List<String> get preferredLanguages;

  /// Create a copy of TeacherTeachingPreference
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherTeachingPreferenceImplCopyWith<_$TeacherTeachingPreferenceImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TeacherVerification _$TeacherVerificationFromJson(Map<String, dynamic> json) {
  return _TeacherVerification.fromJson(json);
}

/// @nodoc
mixin _$TeacherVerification {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get submissionCount => throw _privateConstructorUsedError;
  DateTime? get lastSubmittedAt => throw _privateConstructorUsedError;
  DateTime? get reviewedAt => throw _privateConstructorUsedError;
  String? get reviewNotes => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  bool get identityVerified => throw _privateConstructorUsedError;
  bool get certificateVerified => throw _privateConstructorUsedError;
  List<TeacherVerificationDocument> get documents =>
      throw _privateConstructorUsedError;

  /// Serializes this TeacherVerification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeacherVerification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherVerificationCopyWith<TeacherVerification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherVerificationCopyWith<$Res> {
  factory $TeacherVerificationCopyWith(
          TeacherVerification value, $Res Function(TeacherVerification) then) =
      _$TeacherVerificationCopyWithImpl<$Res, TeacherVerification>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String status,
      int submissionCount,
      DateTime? lastSubmittedAt,
      DateTime? reviewedAt,
      String? reviewNotes,
      String? rejectionReason,
      bool identityVerified,
      bool certificateVerified,
      List<TeacherVerificationDocument> documents});
}

/// @nodoc
class _$TeacherVerificationCopyWithImpl<$Res, $Val extends TeacherVerification>
    implements $TeacherVerificationCopyWith<$Res> {
  _$TeacherVerificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeacherVerification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? status = null,
    Object? submissionCount = null,
    Object? lastSubmittedAt = freezed,
    Object? reviewedAt = freezed,
    Object? reviewNotes = freezed,
    Object? rejectionReason = freezed,
    Object? identityVerified = null,
    Object? certificateVerified = null,
    Object? documents = null,
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      submissionCount: null == submissionCount
          ? _value.submissionCount
          : submissionCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastSubmittedAt: freezed == lastSubmittedAt
          ? _value.lastSubmittedAt
          : lastSubmittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reviewNotes: freezed == reviewNotes
          ? _value.reviewNotes
          : reviewNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      identityVerified: null == identityVerified
          ? _value.identityVerified
          : identityVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      certificateVerified: null == certificateVerified
          ? _value.certificateVerified
          : certificateVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      documents: null == documents
          ? _value.documents
          : documents // ignore: cast_nullable_to_non_nullable
              as List<TeacherVerificationDocument>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeacherVerificationImplCopyWith<$Res>
    implements $TeacherVerificationCopyWith<$Res> {
  factory _$$TeacherVerificationImplCopyWith(_$TeacherVerificationImpl value,
          $Res Function(_$TeacherVerificationImpl) then) =
      __$$TeacherVerificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String status,
      int submissionCount,
      DateTime? lastSubmittedAt,
      DateTime? reviewedAt,
      String? reviewNotes,
      String? rejectionReason,
      bool identityVerified,
      bool certificateVerified,
      List<TeacherVerificationDocument> documents});
}

/// @nodoc
class __$$TeacherVerificationImplCopyWithImpl<$Res>
    extends _$TeacherVerificationCopyWithImpl<$Res, _$TeacherVerificationImpl>
    implements _$$TeacherVerificationImplCopyWith<$Res> {
  __$$TeacherVerificationImplCopyWithImpl(_$TeacherVerificationImpl _value,
      $Res Function(_$TeacherVerificationImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeacherVerification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? status = null,
    Object? submissionCount = null,
    Object? lastSubmittedAt = freezed,
    Object? reviewedAt = freezed,
    Object? reviewNotes = freezed,
    Object? rejectionReason = freezed,
    Object? identityVerified = null,
    Object? certificateVerified = null,
    Object? documents = null,
  }) {
    return _then(_$TeacherVerificationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      submissionCount: null == submissionCount
          ? _value.submissionCount
          : submissionCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastSubmittedAt: freezed == lastSubmittedAt
          ? _value.lastSubmittedAt
          : lastSubmittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reviewNotes: freezed == reviewNotes
          ? _value.reviewNotes
          : reviewNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      identityVerified: null == identityVerified
          ? _value.identityVerified
          : identityVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      certificateVerified: null == certificateVerified
          ? _value.certificateVerified
          : certificateVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      documents: null == documents
          ? _value._documents
          : documents // ignore: cast_nullable_to_non_nullable
              as List<TeacherVerificationDocument>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherVerificationImpl implements _TeacherVerification {
  const _$TeacherVerificationImpl(
      {required this.id,
      required this.userId,
      required this.status,
      this.submissionCount = 1,
      this.lastSubmittedAt,
      this.reviewedAt,
      this.reviewNotes,
      this.rejectionReason,
      this.identityVerified = false,
      this.certificateVerified = false,
      final List<TeacherVerificationDocument> documents = const []})
      : _documents = documents;

  factory _$TeacherVerificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherVerificationImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String status;
  @override
  @JsonKey()
  final int submissionCount;
  @override
  final DateTime? lastSubmittedAt;
  @override
  final DateTime? reviewedAt;
  @override
  final String? reviewNotes;
  @override
  final String? rejectionReason;
  @override
  @JsonKey()
  final bool identityVerified;
  @override
  @JsonKey()
  final bool certificateVerified;
  final List<TeacherVerificationDocument> _documents;
  @override
  @JsonKey()
  List<TeacherVerificationDocument> get documents {
    if (_documents is EqualUnmodifiableListView) return _documents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_documents);
  }

  @override
  String toString() {
    return 'TeacherVerification(id: $id, userId: $userId, status: $status, submissionCount: $submissionCount, lastSubmittedAt: $lastSubmittedAt, reviewedAt: $reviewedAt, reviewNotes: $reviewNotes, rejectionReason: $rejectionReason, identityVerified: $identityVerified, certificateVerified: $certificateVerified, documents: $documents)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherVerificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.submissionCount, submissionCount) ||
                other.submissionCount == submissionCount) &&
            (identical(other.lastSubmittedAt, lastSubmittedAt) ||
                other.lastSubmittedAt == lastSubmittedAt) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            (identical(other.reviewNotes, reviewNotes) ||
                other.reviewNotes == reviewNotes) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.identityVerified, identityVerified) ||
                other.identityVerified == identityVerified) &&
            (identical(other.certificateVerified, certificateVerified) ||
                other.certificateVerified == certificateVerified) &&
            const DeepCollectionEquality()
                .equals(other._documents, _documents));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      status,
      submissionCount,
      lastSubmittedAt,
      reviewedAt,
      reviewNotes,
      rejectionReason,
      identityVerified,
      certificateVerified,
      const DeepCollectionEquality().hash(_documents));

  /// Create a copy of TeacherVerification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherVerificationImplCopyWith<_$TeacherVerificationImpl> get copyWith =>
      __$$TeacherVerificationImplCopyWithImpl<_$TeacherVerificationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherVerificationImplToJson(
      this,
    );
  }
}

abstract class _TeacherVerification implements TeacherVerification {
  const factory _TeacherVerification(
          {required final String id,
          required final String userId,
          required final String status,
          final int submissionCount,
          final DateTime? lastSubmittedAt,
          final DateTime? reviewedAt,
          final String? reviewNotes,
          final String? rejectionReason,
          final bool identityVerified,
          final bool certificateVerified,
          final List<TeacherVerificationDocument> documents}) =
      _$TeacherVerificationImpl;

  factory _TeacherVerification.fromJson(Map<String, dynamic> json) =
      _$TeacherVerificationImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get status;
  @override
  int get submissionCount;
  @override
  DateTime? get lastSubmittedAt;
  @override
  DateTime? get reviewedAt;
  @override
  String? get reviewNotes;
  @override
  String? get rejectionReason;
  @override
  bool get identityVerified;
  @override
  bool get certificateVerified;
  @override
  List<TeacherVerificationDocument> get documents;

  /// Create a copy of TeacherVerification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherVerificationImplCopyWith<_$TeacherVerificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeacherVerificationDocument _$TeacherVerificationDocumentFromJson(
    Map<String, dynamic> json) {
  return _TeacherVerificationDocument.fromJson(json);
}

/// @nodoc
mixin _$TeacherVerificationDocument {
  String get id => throw _privateConstructorUsedError;
  String get verificationId => throw _privateConstructorUsedError;
  String get documentType => throw _privateConstructorUsedError;
  String get documentUrl => throw _privateConstructorUsedError;
  DateTime? get uploadedAt => throw _privateConstructorUsedError;

  /// Serializes this TeacherVerificationDocument to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeacherVerificationDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherVerificationDocumentCopyWith<TeacherVerificationDocument>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherVerificationDocumentCopyWith<$Res> {
  factory $TeacherVerificationDocumentCopyWith(
          TeacherVerificationDocument value,
          $Res Function(TeacherVerificationDocument) then) =
      _$TeacherVerificationDocumentCopyWithImpl<$Res,
          TeacherVerificationDocument>;
  @useResult
  $Res call(
      {String id,
      String verificationId,
      String documentType,
      String documentUrl,
      DateTime? uploadedAt});
}

/// @nodoc
class _$TeacherVerificationDocumentCopyWithImpl<$Res,
        $Val extends TeacherVerificationDocument>
    implements $TeacherVerificationDocumentCopyWith<$Res> {
  _$TeacherVerificationDocumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeacherVerificationDocument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? verificationId = null,
    Object? documentType = null,
    Object? documentUrl = null,
    Object? uploadedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      verificationId: null == verificationId
          ? _value.verificationId
          : verificationId // ignore: cast_nullable_to_non_nullable
              as String,
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      documentUrl: null == documentUrl
          ? _value.documentUrl
          : documentUrl // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedAt: freezed == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeacherVerificationDocumentImplCopyWith<$Res>
    implements $TeacherVerificationDocumentCopyWith<$Res> {
  factory _$$TeacherVerificationDocumentImplCopyWith(
          _$TeacherVerificationDocumentImpl value,
          $Res Function(_$TeacherVerificationDocumentImpl) then) =
      __$$TeacherVerificationDocumentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String verificationId,
      String documentType,
      String documentUrl,
      DateTime? uploadedAt});
}

/// @nodoc
class __$$TeacherVerificationDocumentImplCopyWithImpl<$Res>
    extends _$TeacherVerificationDocumentCopyWithImpl<$Res,
        _$TeacherVerificationDocumentImpl>
    implements _$$TeacherVerificationDocumentImplCopyWith<$Res> {
  __$$TeacherVerificationDocumentImplCopyWithImpl(
      _$TeacherVerificationDocumentImpl _value,
      $Res Function(_$TeacherVerificationDocumentImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeacherVerificationDocument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? verificationId = null,
    Object? documentType = null,
    Object? documentUrl = null,
    Object? uploadedAt = freezed,
  }) {
    return _then(_$TeacherVerificationDocumentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      verificationId: null == verificationId
          ? _value.verificationId
          : verificationId // ignore: cast_nullable_to_non_nullable
              as String,
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      documentUrl: null == documentUrl
          ? _value.documentUrl
          : documentUrl // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedAt: freezed == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherVerificationDocumentImpl
    implements _TeacherVerificationDocument {
  const _$TeacherVerificationDocumentImpl(
      {required this.id,
      required this.verificationId,
      required this.documentType,
      required this.documentUrl,
      this.uploadedAt});

  factory _$TeacherVerificationDocumentImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$TeacherVerificationDocumentImplFromJson(json);

  @override
  final String id;
  @override
  final String verificationId;
  @override
  final String documentType;
  @override
  final String documentUrl;
  @override
  final DateTime? uploadedAt;

  @override
  String toString() {
    return 'TeacherVerificationDocument(id: $id, verificationId: $verificationId, documentType: $documentType, documentUrl: $documentUrl, uploadedAt: $uploadedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherVerificationDocumentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.verificationId, verificationId) ||
                other.verificationId == verificationId) &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.documentUrl, documentUrl) ||
                other.documentUrl == documentUrl) &&
            (identical(other.uploadedAt, uploadedAt) ||
                other.uploadedAt == uploadedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, verificationId, documentType, documentUrl, uploadedAt);

  /// Create a copy of TeacherVerificationDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherVerificationDocumentImplCopyWith<_$TeacherVerificationDocumentImpl>
      get copyWith => __$$TeacherVerificationDocumentImplCopyWithImpl<
          _$TeacherVerificationDocumentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherVerificationDocumentImplToJson(
      this,
    );
  }
}

abstract class _TeacherVerificationDocument
    implements TeacherVerificationDocument {
  const factory _TeacherVerificationDocument(
      {required final String id,
      required final String verificationId,
      required final String documentType,
      required final String documentUrl,
      final DateTime? uploadedAt}) = _$TeacherVerificationDocumentImpl;

  factory _TeacherVerificationDocument.fromJson(Map<String, dynamic> json) =
      _$TeacherVerificationDocumentImpl.fromJson;

  @override
  String get id;
  @override
  String get verificationId;
  @override
  String get documentType;
  @override
  String get documentUrl;
  @override
  DateTime? get uploadedAt;

  /// Create a copy of TeacherVerificationDocument
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherVerificationDocumentImplCopyWith<_$TeacherVerificationDocumentImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TeacherStats _$TeacherStatsFromJson(Map<String, dynamic> json) {
  return _TeacherStats.fromJson(json);
}

/// @nodoc
mixin _$TeacherStats {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  int get totalStudents => throw _privateConstructorUsedError;
  int get totalClasses => throw _privateConstructorUsedError;
  int get totalReviews => throw _privateConstructorUsedError;
  double get averageRating => throw _privateConstructorUsedError;
  int get profileViewsTotal => throw _privateConstructorUsedError;
  int get profileViewsThisMonth => throw _privateConstructorUsedError;

  /// Serializes this TeacherStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeacherStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherStatsCopyWith<TeacherStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherStatsCopyWith<$Res> {
  factory $TeacherStatsCopyWith(
          TeacherStats value, $Res Function(TeacherStats) then) =
      _$TeacherStatsCopyWithImpl<$Res, TeacherStats>;
  @useResult
  $Res call(
      {String id,
      String userId,
      int totalStudents,
      int totalClasses,
      int totalReviews,
      double averageRating,
      int profileViewsTotal,
      int profileViewsThisMonth});
}

/// @nodoc
class _$TeacherStatsCopyWithImpl<$Res, $Val extends TeacherStats>
    implements $TeacherStatsCopyWith<$Res> {
  _$TeacherStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeacherStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? totalStudents = null,
    Object? totalClasses = null,
    Object? totalReviews = null,
    Object? averageRating = null,
    Object? profileViewsTotal = null,
    Object? profileViewsThisMonth = null,
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
      totalStudents: null == totalStudents
          ? _value.totalStudents
          : totalStudents // ignore: cast_nullable_to_non_nullable
              as int,
      totalClasses: null == totalClasses
          ? _value.totalClasses
          : totalClasses // ignore: cast_nullable_to_non_nullable
              as int,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      profileViewsTotal: null == profileViewsTotal
          ? _value.profileViewsTotal
          : profileViewsTotal // ignore: cast_nullable_to_non_nullable
              as int,
      profileViewsThisMonth: null == profileViewsThisMonth
          ? _value.profileViewsThisMonth
          : profileViewsThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeacherStatsImplCopyWith<$Res>
    implements $TeacherStatsCopyWith<$Res> {
  factory _$$TeacherStatsImplCopyWith(
          _$TeacherStatsImpl value, $Res Function(_$TeacherStatsImpl) then) =
      __$$TeacherStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      int totalStudents,
      int totalClasses,
      int totalReviews,
      double averageRating,
      int profileViewsTotal,
      int profileViewsThisMonth});
}

/// @nodoc
class __$$TeacherStatsImplCopyWithImpl<$Res>
    extends _$TeacherStatsCopyWithImpl<$Res, _$TeacherStatsImpl>
    implements _$$TeacherStatsImplCopyWith<$Res> {
  __$$TeacherStatsImplCopyWithImpl(
      _$TeacherStatsImpl _value, $Res Function(_$TeacherStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeacherStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? totalStudents = null,
    Object? totalClasses = null,
    Object? totalReviews = null,
    Object? averageRating = null,
    Object? profileViewsTotal = null,
    Object? profileViewsThisMonth = null,
  }) {
    return _then(_$TeacherStatsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      totalStudents: null == totalStudents
          ? _value.totalStudents
          : totalStudents // ignore: cast_nullable_to_non_nullable
              as int,
      totalClasses: null == totalClasses
          ? _value.totalClasses
          : totalClasses // ignore: cast_nullable_to_non_nullable
              as int,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      profileViewsTotal: null == profileViewsTotal
          ? _value.profileViewsTotal
          : profileViewsTotal // ignore: cast_nullable_to_non_nullable
              as int,
      profileViewsThisMonth: null == profileViewsThisMonth
          ? _value.profileViewsThisMonth
          : profileViewsThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherStatsImpl implements _TeacherStats {
  const _$TeacherStatsImpl(
      {required this.id,
      required this.userId,
      this.totalStudents = 0,
      this.totalClasses = 0,
      this.totalReviews = 0,
      this.averageRating = 0.0,
      this.profileViewsTotal = 0,
      this.profileViewsThisMonth = 0});

  factory _$TeacherStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherStatsImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  @JsonKey()
  final int totalStudents;
  @override
  @JsonKey()
  final int totalClasses;
  @override
  @JsonKey()
  final int totalReviews;
  @override
  @JsonKey()
  final double averageRating;
  @override
  @JsonKey()
  final int profileViewsTotal;
  @override
  @JsonKey()
  final int profileViewsThisMonth;

  @override
  String toString() {
    return 'TeacherStats(id: $id, userId: $userId, totalStudents: $totalStudents, totalClasses: $totalClasses, totalReviews: $totalReviews, averageRating: $averageRating, profileViewsTotal: $profileViewsTotal, profileViewsThisMonth: $profileViewsThisMonth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherStatsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.totalStudents, totalStudents) ||
                other.totalStudents == totalStudents) &&
            (identical(other.totalClasses, totalClasses) ||
                other.totalClasses == totalClasses) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.profileViewsTotal, profileViewsTotal) ||
                other.profileViewsTotal == profileViewsTotal) &&
            (identical(other.profileViewsThisMonth, profileViewsThisMonth) ||
                other.profileViewsThisMonth == profileViewsThisMonth));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      totalStudents,
      totalClasses,
      totalReviews,
      averageRating,
      profileViewsTotal,
      profileViewsThisMonth);

  /// Create a copy of TeacherStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherStatsImplCopyWith<_$TeacherStatsImpl> get copyWith =>
      __$$TeacherStatsImplCopyWithImpl<_$TeacherStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherStatsImplToJson(
      this,
    );
  }
}

abstract class _TeacherStats implements TeacherStats {
  const factory _TeacherStats(
      {required final String id,
      required final String userId,
      final int totalStudents,
      final int totalClasses,
      final int totalReviews,
      final double averageRating,
      final int profileViewsTotal,
      final int profileViewsThisMonth}) = _$TeacherStatsImpl;

  factory _TeacherStats.fromJson(Map<String, dynamic> json) =
      _$TeacherStatsImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  int get totalStudents;
  @override
  int get totalClasses;
  @override
  int get totalReviews;
  @override
  double get averageRating;
  @override
  int get profileViewsTotal;
  @override
  int get profileViewsThisMonth;

  /// Create a copy of TeacherStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherStatsImplCopyWith<_$TeacherStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudentProfileImpl _$$StudentProfileImplFromJson(Map<String, dynamic> json) =>
    _$StudentProfileImpl(
      userId: json['userId'] as String,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String?,
      heightCm: (json['heightCm'] as num?)?.toDouble(),
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      experienceLevel: json['experienceLevel'] as String?,
      ayurvedicDosha: json['ayurvedicDosha'] as String?,
      medicalConditions: (json['medicalConditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      emergencyContactPhone: json['emergencyContactPhone'] as String?,
    );

Map<String, dynamic> _$$StudentProfileImplToJson(
        _$StudentProfileImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'gender': instance.gender,
      'heightCm': instance.heightCm,
      'weightKg': instance.weightKg,
      'experienceLevel': instance.experienceLevel,
      'ayurvedicDosha': instance.ayurvedicDosha,
      'medicalConditions': instance.medicalConditions,
      'emergencyContactPhone': instance.emergencyContactPhone,
    };

_$StudentAchievementImpl _$$StudentAchievementImplFromJson(
        Map<String, dynamic> json) =>
    _$StudentAchievementImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      achievementType: json['achievementType'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      iconUrl: json['iconUrl'] as String?,
      xpEarned: (json['xpEarned'] as num).toInt(),
      levelReached: (json['levelReached'] as num?)?.toInt(),
      awardedAt: DateTime.parse(json['awardedAt'] as String),
    );

Map<String, dynamic> _$$StudentAchievementImplToJson(
        _$StudentAchievementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'achievementType': instance.achievementType,
      'title': instance.title,
      'description': instance.description,
      'iconUrl': instance.iconUrl,
      'xpEarned': instance.xpEarned,
      'levelReached': instance.levelReached,
      'awardedAt': instance.awardedAt.toIso8601String(),
    };

_$StudentDashboardDataImpl _$$StudentDashboardDataImplFromJson(
        Map<String, dynamic> json) =>
    _$StudentDashboardDataImpl(
      profile: json['profile'] == null
          ? null
          : StudentProfile.fromJson(json['profile'] as Map<String, dynamic>),
      recentAchievements: (json['recentAchievements'] as List<dynamic>?)
              ?.map(
                  (e) => StudentAchievement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      todaysWellness: json['todaysWellness'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$StudentDashboardDataImplToJson(
        _$StudentDashboardDataImpl instance) =>
    <String, dynamic>{
      'profile': instance.profile,
      'recentAchievements': instance.recentAchievements,
      'todaysWellness': instance.todaysWellness,
    };

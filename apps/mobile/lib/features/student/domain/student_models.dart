import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_models.freezed.dart';
part 'student_models.g.dart';

@freezed
class StudentProfile with _$StudentProfile {
  const factory StudentProfile({
    required String userId,
    DateTime? dateOfBirth,
    String? gender,
    double? heightCm,
    double? weightKg,
    String? experienceLevel,
    String? ayurvedicDosha,
    @Default([]) List<String> medicalConditions,
    String? emergencyContactPhone,
  }) = _StudentProfile;

  factory StudentProfile.fromJson(Map<String, dynamic> json) => _$StudentProfileFromJson(json);
}

@freezed
class StudentAchievement with _$StudentAchievement {
  const factory StudentAchievement({
    required String id,
    required String userId,
    required String achievementType,
    required String title,
    String? description,
    String? iconUrl,
    required int xpEarned,
    int? levelReached,
    required DateTime awardedAt,
  }) = _StudentAchievement;

  factory StudentAchievement.fromJson(Map<String, dynamic> json) => _$StudentAchievementFromJson(json);
}

@freezed
class StudentDashboardData with _$StudentDashboardData {
  const factory StudentDashboardData({
    StudentProfile? profile,
    @Default([]) List<StudentAchievement> recentAchievements,
    Map<String, dynamic>? todaysWellness,
  }) = _StudentDashboardData;

  factory StudentDashboardData.fromJson(Map<String, dynamic> json) => _$StudentDashboardDataFromJson(json);
}

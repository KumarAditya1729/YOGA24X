import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher_models.freezed.dart';
part 'teacher_models.g.dart';

@freezed
class TeacherProfile with _$TeacherProfile {
  const factory TeacherProfile({
    required String id,
    required String userId,
    String? headline,
    String? bio,
    String? teachingPhilosophy,
    @Default(0) int yearsExperience,
    @Default([]) List<String> teachingLanguages,
    String? nationality,
    String? countryCode,
    String? cityState,
    String? timezone,
    String? websiteUrl,
    String? introVideoUrl,
    @Default(false) bool isPublic,
    @Default(0) int profileCompletion,
    @Default('NOT_SUBMITTED') String verificationStatus,
    @Default(false) bool isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
    // Relationships
    @Default([]) List<TeacherCertification> certifications,
    @Default([]) List<TeacherSpecialization> specializations,
    TeacherTeachingPreference? teachingPreference,
    @Default([]) List<TeacherPortfolioItem> portfolioItems,
    @Default([]) List<TeacherSocialLink> socialLinks,
    TeacherStats? stats,
  }) = _TeacherProfile;

  factory TeacherProfile.fromJson(Map<String, dynamic> json) => _$TeacherProfileFromJson(json);
}

@freezed
class TeacherSpecialization with _$TeacherSpecialization {
  const factory TeacherSpecialization({
    required String id,
    required String userId,
    required String specialization,
    @Default(0) int proficiencyYears,
    @Default(false) bool isPrimary,
    @Default(0) int displayOrder,
  }) = _TeacherSpecialization;

  factory TeacherSpecialization.fromJson(Map<String, dynamic> json) => _$TeacherSpecializationFromJson(json);
}

@freezed
class TeacherCertification with _$TeacherCertification {
  const factory TeacherCertification({
    required String id,
    required String userId,
    required String certificationType,
    required String certificationName,
    required String issuingOrganization,
    String? certificationNumber,
    DateTime? issuedAt,
    DateTime? expiresAt,
    String? documentUrl,
    @Default(false) bool isVerified,
    @Default(true) bool isActive,
    @Default(0) int displayOrder,
  }) = _TeacherCertification;

  factory TeacherCertification.fromJson(Map<String, dynamic> json) => _$TeacherCertificationFromJson(json);
}

@freezed
class TeacherPortfolioItem with _$TeacherPortfolioItem {
  const factory TeacherPortfolioItem({
    required String id,
    required String userId,
    required String itemType,
    required String title,
    String? description,
    String? mediaUrl,
    String? externalUrl,
    DateTime? issuedAt,
    @Default(false) bool isFeatured,
    @Default(0) int displayOrder,
  }) = _TeacherPortfolioItem;

  factory TeacherPortfolioItem.fromJson(Map<String, dynamic> json) => _$TeacherPortfolioItemFromJson(json);
}

@freezed
class TeacherSocialLink with _$TeacherSocialLink {
  const factory TeacherSocialLink({
    required String id,
    required String userId,
    required String platform,
    required String url,
    @Default(true) bool isPublic,
  }) = _TeacherSocialLink;

  factory TeacherSocialLink.fromJson(Map<String, dynamic> json) => _$TeacherSocialLinkFromJson(json);
}

@freezed
class TeacherTeachingPreference with _$TeacherTeachingPreference {
  const factory TeacherTeachingPreference({
    required String id,
    required String userId,
    @Default([]) List<String> teachingModes,
    @Default([]) List<String> teachingFormats,
    @Default([]) List<String> ageGroups,
    @Default([]) List<String> skillLevels,
    int? maxGroupSize,
    int? minGroupSize,
    int? travelRadius,
    @Default(false) bool onlineOnly,
    @Default([]) List<int> classDurationMins,
    @Default([]) List<String> preferredLanguages,
  }) = _TeacherTeachingPreference;

  factory TeacherTeachingPreference.fromJson(Map<String, dynamic> json) => _$TeacherTeachingPreferenceFromJson(json);
}

@freezed
class TeacherVerification with _$TeacherVerification {
  const factory TeacherVerification({
    required String id,
    required String userId,
    required String status,
    @Default(1) int submissionCount,
    DateTime? lastSubmittedAt,
    DateTime? reviewedAt,
    String? reviewNotes,
    String? rejectionReason,
    @Default(false) bool identityVerified,
    @Default(false) bool certificateVerified,
    @Default([]) List<TeacherVerificationDocument> documents,
  }) = _TeacherVerification;

  factory TeacherVerification.fromJson(Map<String, dynamic> json) => _$TeacherVerificationFromJson(json);
}

@freezed
class TeacherVerificationDocument with _$TeacherVerificationDocument {
  const factory TeacherVerificationDocument({
    required String id,
    required String verificationId,
    required String documentType,
    required String documentUrl,
    DateTime? uploadedAt,
  }) = _TeacherVerificationDocument;

  factory TeacherVerificationDocument.fromJson(Map<String, dynamic> json) => _$TeacherVerificationDocumentFromJson(json);
}

@freezed
class TeacherStats with _$TeacherStats {
  const factory TeacherStats({
    required String id,
    required String userId,
    @Default(0) int totalStudents,
    @Default(0) int totalClasses,
    @Default(0) int totalReviews,
    @Default(0.0) double averageRating,
    @Default(0) int profileViewsTotal,
    @Default(0) int profileViewsThisMonth,
  }) = _TeacherStats;

  factory TeacherStats.fromJson(Map<String, dynamic> json) => _$TeacherStatsFromJson(json);
}

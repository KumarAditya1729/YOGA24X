// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeacherProfileImpl _$$TeacherProfileImplFromJson(Map<String, dynamic> json) =>
    _$TeacherProfileImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      headline: json['headline'] as String?,
      bio: json['bio'] as String?,
      teachingPhilosophy: json['teachingPhilosophy'] as String?,
      yearsExperience: (json['yearsExperience'] as num?)?.toInt() ?? 0,
      teachingLanguages: (json['teachingLanguages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nationality: json['nationality'] as String?,
      countryCode: json['countryCode'] as String?,
      cityState: json['cityState'] as String?,
      timezone: json['timezone'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      introVideoUrl: json['introVideoUrl'] as String?,
      isPublic: json['isPublic'] as bool? ?? false,
      profileCompletion: (json['profileCompletion'] as num?)?.toInt() ?? 0,
      verificationStatus:
          json['verificationStatus'] as String? ?? 'NOT_SUBMITTED',
      isFeatured: json['isFeatured'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((e) =>
                  TeacherCertification.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      specializations: (json['specializations'] as List<dynamic>?)
              ?.map((e) =>
                  TeacherSpecialization.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      teachingPreference: json['teachingPreference'] == null
          ? null
          : TeacherTeachingPreference.fromJson(
              json['teachingPreference'] as Map<String, dynamic>),
      portfolioItems: (json['portfolioItems'] as List<dynamic>?)
              ?.map((e) =>
                  TeacherPortfolioItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      socialLinks: (json['socialLinks'] as List<dynamic>?)
              ?.map(
                  (e) => TeacherSocialLink.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      stats: json['stats'] == null
          ? null
          : TeacherStats.fromJson(json['stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TeacherProfileImplToJson(
        _$TeacherProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'headline': instance.headline,
      'bio': instance.bio,
      'teachingPhilosophy': instance.teachingPhilosophy,
      'yearsExperience': instance.yearsExperience,
      'teachingLanguages': instance.teachingLanguages,
      'nationality': instance.nationality,
      'countryCode': instance.countryCode,
      'cityState': instance.cityState,
      'timezone': instance.timezone,
      'websiteUrl': instance.websiteUrl,
      'introVideoUrl': instance.introVideoUrl,
      'isPublic': instance.isPublic,
      'profileCompletion': instance.profileCompletion,
      'verificationStatus': instance.verificationStatus,
      'isFeatured': instance.isFeatured,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'certifications': instance.certifications,
      'specializations': instance.specializations,
      'teachingPreference': instance.teachingPreference,
      'portfolioItems': instance.portfolioItems,
      'socialLinks': instance.socialLinks,
      'stats': instance.stats,
    };

_$TeacherSpecializationImpl _$$TeacherSpecializationImplFromJson(
        Map<String, dynamic> json) =>
    _$TeacherSpecializationImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      specialization: json['specialization'] as String,
      proficiencyYears: (json['proficiencyYears'] as num?)?.toInt() ?? 0,
      isPrimary: json['isPrimary'] as bool? ?? false,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TeacherSpecializationImplToJson(
        _$TeacherSpecializationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'specialization': instance.specialization,
      'proficiencyYears': instance.proficiencyYears,
      'isPrimary': instance.isPrimary,
      'displayOrder': instance.displayOrder,
    };

_$TeacherCertificationImpl _$$TeacherCertificationImplFromJson(
        Map<String, dynamic> json) =>
    _$TeacherCertificationImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      certificationType: json['certificationType'] as String,
      certificationName: json['certificationName'] as String,
      issuingOrganization: json['issuingOrganization'] as String,
      certificationNumber: json['certificationNumber'] as String?,
      issuedAt: json['issuedAt'] == null
          ? null
          : DateTime.parse(json['issuedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      documentUrl: json['documentUrl'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TeacherCertificationImplToJson(
        _$TeacherCertificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'certificationType': instance.certificationType,
      'certificationName': instance.certificationName,
      'issuingOrganization': instance.issuingOrganization,
      'certificationNumber': instance.certificationNumber,
      'issuedAt': instance.issuedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'documentUrl': instance.documentUrl,
      'isVerified': instance.isVerified,
      'isActive': instance.isActive,
      'displayOrder': instance.displayOrder,
    };

_$TeacherPortfolioItemImpl _$$TeacherPortfolioItemImplFromJson(
        Map<String, dynamic> json) =>
    _$TeacherPortfolioItemImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      itemType: json['itemType'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      externalUrl: json['externalUrl'] as String?,
      issuedAt: json['issuedAt'] == null
          ? null
          : DateTime.parse(json['issuedAt'] as String),
      isFeatured: json['isFeatured'] as bool? ?? false,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TeacherPortfolioItemImplToJson(
        _$TeacherPortfolioItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'itemType': instance.itemType,
      'title': instance.title,
      'description': instance.description,
      'mediaUrl': instance.mediaUrl,
      'externalUrl': instance.externalUrl,
      'issuedAt': instance.issuedAt?.toIso8601String(),
      'isFeatured': instance.isFeatured,
      'displayOrder': instance.displayOrder,
    };

_$TeacherSocialLinkImpl _$$TeacherSocialLinkImplFromJson(
        Map<String, dynamic> json) =>
    _$TeacherSocialLinkImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      platform: json['platform'] as String,
      url: json['url'] as String,
      isPublic: json['isPublic'] as bool? ?? true,
    );

Map<String, dynamic> _$$TeacherSocialLinkImplToJson(
        _$TeacherSocialLinkImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'platform': instance.platform,
      'url': instance.url,
      'isPublic': instance.isPublic,
    };

_$TeacherTeachingPreferenceImpl _$$TeacherTeachingPreferenceImplFromJson(
        Map<String, dynamic> json) =>
    _$TeacherTeachingPreferenceImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      teachingModes: (json['teachingModes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      teachingFormats: (json['teachingFormats'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      ageGroups: (json['ageGroups'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      skillLevels: (json['skillLevels'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      maxGroupSize: (json['maxGroupSize'] as num?)?.toInt(),
      minGroupSize: (json['minGroupSize'] as num?)?.toInt(),
      travelRadius: (json['travelRadius'] as num?)?.toInt(),
      onlineOnly: json['onlineOnly'] as bool? ?? false,
      classDurationMins: (json['classDurationMins'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      preferredLanguages: (json['preferredLanguages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TeacherTeachingPreferenceImplToJson(
        _$TeacherTeachingPreferenceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'teachingModes': instance.teachingModes,
      'teachingFormats': instance.teachingFormats,
      'ageGroups': instance.ageGroups,
      'skillLevels': instance.skillLevels,
      'maxGroupSize': instance.maxGroupSize,
      'minGroupSize': instance.minGroupSize,
      'travelRadius': instance.travelRadius,
      'onlineOnly': instance.onlineOnly,
      'classDurationMins': instance.classDurationMins,
      'preferredLanguages': instance.preferredLanguages,
    };

_$TeacherVerificationImpl _$$TeacherVerificationImplFromJson(
        Map<String, dynamic> json) =>
    _$TeacherVerificationImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      status: json['status'] as String,
      submissionCount: (json['submissionCount'] as num?)?.toInt() ?? 1,
      lastSubmittedAt: json['lastSubmittedAt'] == null
          ? null
          : DateTime.parse(json['lastSubmittedAt'] as String),
      reviewedAt: json['reviewedAt'] == null
          ? null
          : DateTime.parse(json['reviewedAt'] as String),
      reviewNotes: json['reviewNotes'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      identityVerified: json['identityVerified'] as bool? ?? false,
      certificateVerified: json['certificateVerified'] as bool? ?? false,
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) => TeacherVerificationDocument.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TeacherVerificationImplToJson(
        _$TeacherVerificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'status': instance.status,
      'submissionCount': instance.submissionCount,
      'lastSubmittedAt': instance.lastSubmittedAt?.toIso8601String(),
      'reviewedAt': instance.reviewedAt?.toIso8601String(),
      'reviewNotes': instance.reviewNotes,
      'rejectionReason': instance.rejectionReason,
      'identityVerified': instance.identityVerified,
      'certificateVerified': instance.certificateVerified,
      'documents': instance.documents,
    };

_$TeacherVerificationDocumentImpl _$$TeacherVerificationDocumentImplFromJson(
        Map<String, dynamic> json) =>
    _$TeacherVerificationDocumentImpl(
      id: json['id'] as String,
      verificationId: json['verificationId'] as String,
      documentType: json['documentType'] as String,
      documentUrl: json['documentUrl'] as String,
      uploadedAt: json['uploadedAt'] == null
          ? null
          : DateTime.parse(json['uploadedAt'] as String),
    );

Map<String, dynamic> _$$TeacherVerificationDocumentImplToJson(
        _$TeacherVerificationDocumentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'verificationId': instance.verificationId,
      'documentType': instance.documentType,
      'documentUrl': instance.documentUrl,
      'uploadedAt': instance.uploadedAt?.toIso8601String(),
    };

_$TeacherStatsImpl _$$TeacherStatsImplFromJson(Map<String, dynamic> json) =>
    _$TeacherStatsImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      totalStudents: (json['totalStudents'] as num?)?.toInt() ?? 0,
      totalClasses: (json['totalClasses'] as num?)?.toInt() ?? 0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      profileViewsTotal: (json['profileViewsTotal'] as num?)?.toInt() ?? 0,
      profileViewsThisMonth:
          (json['profileViewsThisMonth'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TeacherStatsImplToJson(_$TeacherStatsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'totalStudents': instance.totalStudents,
      'totalClasses': instance.totalClasses,
      'totalReviews': instance.totalReviews,
      'averageRating': instance.averageRating,
      'profileViewsTotal': instance.profileViewsTotal,
      'profileViewsThisMonth': instance.profileViewsThisMonth,
    };

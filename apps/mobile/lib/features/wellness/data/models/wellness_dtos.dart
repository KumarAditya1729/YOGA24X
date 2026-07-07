// ==============================================================================
// Yoga24X AI Engineering OS — Enterprise Wellness DTOs & Serialization
// Data Transfer Objects mapping backend JSON to Flutter Domain Models
// ==============================================================================

import '../../domain/models/wellness_models.dart';

class WellnessDtoMapper {
  // 1. HealthProfile
  static HealthProfile healthProfileFromJson(Map<String, dynamic> json) {
    return HealthProfile(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      bloodGroup: json['bloodGroup']?.toString() ?? 'UNKNOWN',
      emergencyContactName: json['emergencyContactName']?.toString(),
      emergencyContactPhone: json['emergencyContactPhone']?.toString(),
      emergencyContactRelation: json['emergencyContactRelation']?.toString(),
      pregnancyStatus: json['pregnancyStatus']?.toString() ?? 'NOT_PREGNANT',
      medicalHistory: _parseConditionList(json['medicalHistory']),
      currentConditions: _parseConditionList(json['currentConditions']),
      pastConditions: _parseConditionList(json['pastConditions']),
      surgeries: _parseSurgeryList(json['surgeries']),
      medications: _parseMedicationList(json['medications']),
      allergies: _parseAllergyList(json['allergies']),
      physicalLimitations: _parseLimitationList(json['physicalLimitations']),
      lifestyle: _parseLifestyle(json['lifestyle']),
      isVerifiedByDoctor: json['isVerifiedByDoctor'] == true,
      verifiedByDoctorId: json['verifiedByDoctorId']?.toString(),
      verificationNotes: json['verificationNotes']?.toString(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  static Map<String, dynamic> healthProfileToJson(HealthProfile profile) {
    return {
      'id': profile.id,
      'userId': profile.userId,
      'bloodGroup': profile.bloodGroup,
      'emergencyContactName': profile.emergencyContactName,
      'emergencyContactPhone': profile.emergencyContactPhone,
      'emergencyContactRelation': profile.emergencyContactRelation,
      'pregnancyStatus': profile.pregnancyStatus,
      'medicalHistory': profile.medicalHistory
          .map((c) => {
                'condition': c.condition,
                'diagnosedYear': c.diagnosedYear,
                'status': c.status,
                'notes': c.notes,
              })
          .toList(),
      'currentConditions': profile.currentConditions
          .map((c) => {
                'condition': c.condition,
                'diagnosedYear': c.diagnosedYear,
                'status': c.status,
                'notes': c.notes,
              })
          .toList(),
      'pastConditions': profile.pastConditions
          .map((c) => {
                'condition': c.condition,
                'diagnosedYear': c.diagnosedYear,
                'status': c.status,
                'notes': c.notes,
              })
          .toList(),
      'surgeries': profile.surgeries
          .map((s) => {
                'procedure': s.procedure,
                'year': s.year,
                'surgeonOrHospital': s.surgeonOrHospital,
                'recoveryNotes': s.recoveryNotes,
              })
          .toList(),
      'medications': profile.medications
          .map((m) => {
                'name': m.name,
                'dosage': m.dosage,
                'frequency': m.frequency,
                'reason': m.reason,
              })
          .toList(),
      'allergies': profile.allergies
          .map((a) => {
                'allergen': a.allergen,
                'type': a.type,
                'severity': a.severity,
                'reaction': a.reaction,
              })
          .toList(),
      'physicalLimitations': profile.physicalLimitations
          .map((l) => {
                'bodyPart': l.bodyPart,
                'issue': l.issue,
                'severity': l.severity,
                'restrictedMovements': l.restrictedMovements,
              })
          .toList(),
      'lifestyle': {
        'isSmoker': profile.lifestyle.isSmoker,
        'alcoholConsumption': profile.lifestyle.alcoholConsumption,
        'workNature': profile.lifestyle.workNature,
        'averageScreenTimeHours': profile.lifestyle.averageScreenTimeHours,
        'dietPreference': profile.lifestyle.dietPreference,
      },
    };
  }

  // 2. WellnessAssessment
  static WellnessAssessment wellnessAssessmentFromJson(Map<String, dynamic> json) {
    return WellnessAssessment(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      stressLevel: (json['stressLevel'] as num?)?.toInt() ?? 5,
      sleepQuality: (json['sleepQuality'] as num?)?.toInt() ?? 5,
      energyLevel: (json['energyLevel'] as num?)?.toInt() ?? 5,
      hydrationScore: (json['hydrationScore'] as num?)?.toInt() ?? 5,
      flexibilityScore: (json['flexibilityScore'] as num?)?.toInt() ?? 5,
      strengthScore: (json['strengthScore'] as num?)?.toInt() ?? 5,
      mobilityScore: (json['mobilityScore'] as num?)?.toInt() ?? 5,
      bodyFatPercentage: (json['bodyFatPercentage'] as num?)?.toDouble(),
      bmi: (json['bmi'] as num?)?.toDouble(),
      restingHeartRate: (json['restingHeartRate'] as num?)?.toInt(),
      breathingPattern: json['breathingPattern']?.toString() ?? 'NORMAL',
      dailyActivityLevel: json['dailyActivityLevel']?.toString() ?? 'MODERATE',
      assessedAt: json['assessedAt'] != null
          ? DateTime.tryParse(json['assessedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  static Map<String, dynamic> wellnessAssessmentToJson(WellnessAssessment assessment) {
    return {
      'stressLevel': assessment.stressLevel,
      'sleepQuality': assessment.sleepQuality,
      'energyLevel': assessment.energyLevel,
      'hydrationScore': assessment.hydrationScore,
      'flexibilityScore': assessment.flexibilityScore,
      'strengthScore': assessment.strengthScore,
      'mobilityScore': assessment.mobilityScore,
      'bodyFatPercentage': assessment.bodyFatPercentage,
      'bmi': assessment.bmi,
      'restingHeartRate': assessment.restingHeartRate,
      'breathingPattern': assessment.breathingPattern,
      'dailyActivityLevel': assessment.dailyActivityLevel,
    };
  }

  // 3. YogaAssessment
  static YogaAssessment yogaAssessmentFromJson(Map<String, dynamic> json) {
    return YogaAssessment(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      experienceLevel: json['experienceLevel']?.toString() ?? 'BEGINNER',
      yogaGoals: _parseStringList(json['yogaGoals']),
      preferredYogaStyle: json['preferredYogaStyle']?.toString() ?? 'HATHA',
      preferredSessionLengthMin: (json['preferredSessionLengthMin'] as num?)?.toInt() ?? 30,
      preferredInstructorGender: json['preferredInstructorGender']?.toString() ?? 'ANY',
      practiceFrequencyPerWeek: (json['practiceFrequencyPerWeek'] as num?)?.toInt() ?? 3,
      favoriteTeachers: _parseStringList(json['favoriteTeachers']),
      favoriteCourses: _parseStringList(json['favoriteCourses']),
      favoriteMusic: _parseStringList(json['favoriteMusic']),
      preferredPracticeTime: json['preferredPracticeTime']?.toString() ?? 'MORNING',
    );
  }

  static Map<String, dynamic> yogaAssessmentToJson(YogaAssessment assessment) {
    return {
      'experienceLevel': assessment.experienceLevel,
      'yogaGoals': assessment.yogaGoals,
      'preferredYogaStyle': assessment.preferredYogaStyle,
      'preferredSessionLengthMin': assessment.preferredSessionLengthMin,
      'preferredInstructorGender': assessment.preferredInstructorGender,
      'practiceFrequencyPerWeek': assessment.practiceFrequencyPerWeek,
      'favoriteTeachers': assessment.favoriteTeachers,
      'favoriteCourses': assessment.favoriteCourses,
      'favoriteMusic': assessment.favoriteMusic,
      'preferredPracticeTime': assessment.preferredPracticeTime,
    };
  }

  // 4. NutritionProfile
  static NutritionProfile nutritionProfileFromJson(Map<String, dynamic> json) {
    return NutritionProfile(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      dietType: json['dietType']?.toString() ?? 'VEGETARIAN',
      dailyCaloriesGoal: (json['dailyCaloriesGoal'] as num?)?.toInt() ?? 2000,
      dailyProteinGoalGrams: (json['dailyProteinGoalGrams'] as num?)?.toInt() ?? 60,
      dailyWaterGoalMl: (json['dailyWaterGoalMl'] as num?)?.toInt() ?? 2500,
      foodAllergies: _parseStringList(json['foodAllergies']),
      foodPreferences: _parseStringList(json['foodPreferences']),
      mealTiming: _parseStringMap(json['mealTiming']),
      supplements: _parseStringList(json['supplements']),
    );
  }

  static Map<String, dynamic> nutritionProfileToJson(NutritionProfile profile) {
    return {
      'dietType': profile.dietType,
      'dailyCaloriesGoal': profile.dailyCaloriesGoal,
      'dailyProteinGoalGrams': profile.dailyProteinGoalGrams,
      'dailyWaterGoalMl': profile.dailyWaterGoalMl,
      'foodAllergies': profile.foodAllergies,
      'foodPreferences': profile.foodPreferences,
      'mealTiming': profile.mealTiming,
      'supplements': profile.supplements,
    };
  }

  // 5. MeditationProfile
  static MeditationProfile meditationProfileFromJson(Map<String, dynamic> json) {
    return MeditationProfile(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      meditationExperience: json['meditationExperience']?.toString() ?? 'BEGINNER',
      preferredDurationMin: (json['preferredDurationMin'] as num?)?.toInt() ?? 15,
      preferredVoice: json['preferredVoice']?.toString() ?? 'CALM_FEMALE',
      preferredMusic: json['preferredMusic']?.toString() ?? 'NATURE_SOUNDS',
      focusArea: json['focusArea']?.toString() ?? 'STRESS_RELIEF',
      mindfulnessGoals: _parseStringList(json['mindfulnessGoals']),
    );
  }

  static Map<String, dynamic> meditationProfileToJson(MeditationProfile profile) {
    return {
      'meditationExperience': profile.meditationExperience,
      'preferredDurationMin': profile.preferredDurationMin,
      'preferredVoice': profile.preferredVoice,
      'preferredMusic': profile.preferredMusic,
      'focusArea': profile.focusArea,
      'mindfulnessGoals': profile.mindfulnessGoals,
    };
  }

  // 6. AiPersonalizationProfile
  static AiPersonalizationProfile aiPersonalizationFromJson(Map<String, dynamic> json) {
    return AiPersonalizationProfile(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      coachingStyle: json['coachingStyle']?.toString() ?? 'GENTLE_GUIDE',
      motivationStyle: json['motivationStyle']?.toString() ?? 'ENCOURAGING',
      reminderStyle: json['reminderStyle']?.toString() ?? 'DAILY_MORNING',
      communicationTone: json['communicationTone']?.toString() ?? 'WARM',
      preferredLanguage: json['preferredLanguage']?.toString() ?? 'en',
      difficultyProgression: json['difficultyProgression']?.toString() ?? 'ADAPTIVE',
      learningStyle: json['learningStyle']?.toString() ?? 'VISUAL_DEMO',
      voicePreference: json['voicePreference']?.toString() ?? 'SARA_WARM',
      notificationBehaviour: json['notificationBehaviour']?.toString() ?? 'SMART_OPTIMIZED',
      recommendationPreferences: json['recommendationPreferences'] is Map<String, dynamic>
          ? json['recommendationPreferences'] as Map<String, dynamic>
          : {},
    );
  }

  static Map<String, dynamic> aiPersonalizationToJson(AiPersonalizationProfile profile) {
    return {
      'coachingStyle': profile.coachingStyle,
      'motivationStyle': profile.motivationStyle,
      'reminderStyle': profile.reminderStyle,
      'communicationTone': profile.communicationTone,
      'preferredLanguage': profile.preferredLanguage,
      'difficultyProgression': profile.difficultyProgression,
      'learningStyle': profile.learningStyle,
      'voicePreference': profile.voicePreference,
      'notificationBehaviour': profile.notificationBehaviour,
      'recommendationPreferences': profile.recommendationPreferences,
    };
  }

  // 7. WellnessTimelineLog
  static WellnessTimelineLog timelineLogFromJson(Map<String, dynamic> json) {
    return WellnessTimelineLog(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      logDate: json['logDate']?.toString() ?? DateTime.now().toIso8601String().substring(0, 10),
      dailyMood: json['dailyMood']?.toString() ?? 'CALM',
      painLevel: (json['painLevel'] as num?)?.toInt() ?? 0,
      stressScore: (json['stressScore'] as num?)?.toInt() ?? 3,
      sleepHours: (json['sleepHours'] as num?)?.toDouble() ?? 7.5,
      waterIntakeMl: (json['waterIntakeMl'] as num?)?.toInt() ?? 2000,
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      yogaMinutes: (json['yogaMinutes'] as num?)?.toInt() ?? 0,
      meditationMinutes: (json['meditationMinutes'] as num?)?.toInt() ?? 0,
      caloriesBurned: (json['caloriesBurned'] as num?)?.toInt() ?? 0,
      journalEntry: json['journalEntry']?.toString(),
      energyScore: (json['energyScore'] as num?)?.toInt() ?? 7,
    );
  }

  static Map<String, dynamic> timelineLogToJson(WellnessTimelineLog log) {
    return {
      'logDate': log.logDate,
      'dailyMood': log.dailyMood,
      'painLevel': log.painLevel,
      'stressScore': log.stressScore,
      'sleepHours': log.sleepHours,
      'waterIntakeMl': log.waterIntakeMl,
      'weightKg': log.weightKg,
      'yogaMinutes': log.yogaMinutes,
      'meditationMinutes': log.meditationMinutes,
      'caloriesBurned': log.caloriesBurned,
      'journalEntry': log.journalEntry,
      'energyScore': log.energyScore,
    };
  }

  // 8. UserGoal
  static UserGoal userGoalFromJson(Map<String, dynamic> json) {
    return UserGoal(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      goalType: json['goalType']?.toString() ?? 'FLEXIBILITY',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      targetValue: (json['targetValue'] as num?)?.toDouble() ?? 100.0,
      currentValue: (json['currentValue'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit']?.toString(),
      status: json['status']?.toString() ?? 'ACTIVE',
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
      targetDate: json['targetDate'] != null
          ? DateTime.tryParse(json['targetDate'].toString())
          : null,
      milestones: _parseMilestoneList(json['milestones']),
      achievements: _parseStringList(json['achievements']),
    );
  }

  static Map<String, dynamic> userGoalToJson(UserGoal goal) {
    return {
      'goalType': goal.goalType,
      'title': goal.title,
      'description': goal.description,
      'targetValue': goal.targetValue,
      'currentValue': goal.currentValue,
      'unit': goal.unit,
      'status': goal.status,
      'startDate': goal.startDate.toIso8601String(),
      'targetDate': goal.targetDate?.toIso8601String(),
      'milestones': goal.milestones
          .map((m) => {
                'title': m.title,
                'targetValue': m.targetValue,
                'isCompleted': m.isCompleted,
                'completedAt': m.completedAt,
              })
          .toList(),
      'achievements': goal.achievements,
    };
  }

  // 9. MedicalSafetyFlag
  static MedicalSafetyFlag safetyFlagFromJson(Map<String, dynamic> json) {
    return MedicalSafetyFlag(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      flagType: json['flagType']?.toString() ?? 'CONTRAINDICATION',
      severity: json['severity']?.toString() ?? 'MEDIUM',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      restrictedPoses: _parseStringList(json['restrictedPoses']),
      recommendedBy: json['recommendedBy']?.toString(),
      isActive: json['isActive'] != false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  static Map<String, dynamic> safetyFlagToJson(MedicalSafetyFlag flag) {
    return {
      'flagType': flag.flagType,
      'severity': flag.severity,
      'title': flag.title,
      'description': flag.description,
      'restrictedPoses': flag.restrictedPoses,
      'recommendedBy': flag.recommendedBy,
      'isActive': flag.isActive,
    };
  }

  // Helper Parsers
  static List<String> _parseStringList(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) {
      return raw.map((e) => e.toString()).toList();
    }
    return [];
  }

  static Map<String, String> _parseStringMap(dynamic raw) {
    if (raw == null || raw is! Map) return {};
    final result = <String, String>{};
    raw.forEach((k, v) {
      result[k.toString()] = v.toString();
    });
    return result;
  }

  static List<MedicalConditionItem> _parseConditionList(dynamic raw) {
    if (raw == null || raw is! List) return [];
    return raw.map((item) {
      final map = item is Map ? item : {};
      return MedicalConditionItem(
        condition: map['condition']?.toString() ?? 'Unknown',
        diagnosedYear: (map['diagnosedYear'] as num?)?.toInt(),
        status: map['status']?.toString() ?? 'ACTIVE',
        notes: map['notes']?.toString(),
      );
    }).toList();
  }

  static List<SurgeryItem> _parseSurgeryList(dynamic raw) {
    if (raw == null || raw is! List) return [];
    return raw.map((item) {
      final map = item is Map ? item : {};
      return SurgeryItem(
        procedure: map['procedure']?.toString() ?? 'Procedure',
        year: (map['year'] as num?)?.toInt() ?? DateTime.now().year,
        surgeonOrHospital: map['surgeonOrHospital']?.toString(),
        recoveryNotes: map['recoveryNotes']?.toString(),
      );
    }).toList();
  }

  static List<MedicationItem> _parseMedicationList(dynamic raw) {
    if (raw == null || raw is! List) return [];
    return raw.map((item) {
      final map = item is Map ? item : {};
      return MedicationItem(
        name: map['name']?.toString() ?? 'Medication',
        dosage: map['dosage']?.toString() ?? 'As prescribed',
        frequency: map['frequency']?.toString() ?? 'Daily',
        reason: map['reason']?.toString(),
      );
    }).toList();
  }

  static List<AllergyItem> _parseAllergyList(dynamic raw) {
    if (raw == null || raw is! List) return [];
    return raw.map((item) {
      final map = item is Map ? item : {};
      return AllergyItem(
        allergen: map['allergen']?.toString() ?? 'Allergen',
        type: map['type']?.toString() ?? 'GENERAL',
        severity: map['severity']?.toString() ?? 'MILD',
        reaction: map['reaction']?.toString(),
      );
    }).toList();
  }

  static List<PhysicalLimitationItem> _parseLimitationList(dynamic raw) {
    if (raw == null || raw is! List) return [];
    return raw.map((item) {
      if (item is String) {
        return PhysicalLimitationItem(
          bodyPart: 'General',
          issue: item,
          severity: 'LOW',
          restrictedMovements: const [],
        );
      }
      final map = item is Map ? item : {};
      return PhysicalLimitationItem(
        bodyPart: map['bodyPart']?.toString() ?? 'Body Part',
        issue: map['issue']?.toString() ?? 'Limitation',
        severity: map['severity']?.toString() ?? 'LOW',
        restrictedMovements: _parseStringList(map['restrictedMovements']),
      );
    }).toList();
  }

  static LifestyleProfile _parseLifestyle(dynamic raw) {
    final map = raw is Map ? raw : {};
    return LifestyleProfile(
      isSmoker: map['isSmoker'] == true,
      alcoholConsumption: map['alcoholConsumption']?.toString() ?? 'NONE',
      workNature: map['workNature']?.toString() ?? 'SEDENTARY',
      averageScreenTimeHours: (map['averageScreenTimeHours'] as num?)?.toDouble() ?? 4.0,
      dietPreference: map['dietPreference']?.toString() ?? 'VEGETARIAN',
    );
  }

  static List<GoalMilestone> _parseMilestoneList(dynamic raw) {
    if (raw == null || raw is! List) return [];
    return raw.map((item) {
      final map = item is Map ? item : {};
      return GoalMilestone(
        title: map['title']?.toString() ?? 'Milestone',
        targetValue: (map['targetValue'] as num?)?.toDouble(),
        isCompleted: map['isCompleted'] == true,
        completedAt: map['completedAt']?.toString(),
      );
    }).toList();
  }
}

class HealthProfileDto {
  final HealthProfile _domain;
  const HealthProfileDto._(this._domain);
  factory HealthProfileDto.fromJson(Map<String, dynamic> json) => HealthProfileDto._(WellnessDtoMapper.healthProfileFromJson(json));
  factory HealthProfileDto.fromDomain(HealthProfile domain) => HealthProfileDto._(domain);
  HealthProfile toDomain() => _domain;
  Map<String, dynamic> toJson() => WellnessDtoMapper.healthProfileToJson(_domain);
}

class WellnessAssessmentDto {
  final WellnessAssessment _domain;
  const WellnessAssessmentDto._(this._domain);
  factory WellnessAssessmentDto.fromJson(Map<String, dynamic> json) => WellnessAssessmentDto._(WellnessDtoMapper.wellnessAssessmentFromJson(json));
  factory WellnessAssessmentDto.fromDomain(WellnessAssessment domain) => WellnessAssessmentDto._(domain);
  WellnessAssessment toDomain() => _domain;
  Map<String, dynamic> toJson() => WellnessDtoMapper.wellnessAssessmentToJson(_domain);
}

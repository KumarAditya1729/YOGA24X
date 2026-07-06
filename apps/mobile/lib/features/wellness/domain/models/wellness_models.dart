// ==============================================================================
// Yoga24X AI Engineering OS — Enterprise Wellness Domain Models
// Immutable Domain Models for Health, Assessments, Goals, and Safety Flags
// ==============================================================================

import 'package:equatable/equatable.dart';

class MedicalConditionItem extends Equatable {
  final String condition;
  final int? diagnosedYear;
  final String status; // ACTIVE, RESOLVED, MANAGED
  final String? notes;

  const MedicalConditionItem({
    required this.condition,
    this.diagnosedYear,
    required this.status,
    this.notes,
  });

  @override
  List<Object?> get props => [condition, diagnosedYear, status, notes];
}

class SurgeryItem extends Equatable {
  final String procedure;
  final int year;
  final String? surgeonOrHospital;
  final String? recoveryNotes;

  const SurgeryItem({
    required this.procedure,
    required this.year,
    this.surgeonOrHospital,
    this.recoveryNotes,
  });

  @override
  List<Object?> get props => [procedure, year, surgeonOrHospital, recoveryNotes];
}

class MedicationItem extends Equatable {
  final String name;
  final String dosage;
  final String frequency;
  final String? reason;

  const MedicationItem({
    required this.name,
    required this.dosage,
    required this.frequency,
    this.reason,
  });

  @override
  List<Object?> get props => [name, dosage, frequency, reason];
}

class AllergyItem extends Equatable {
  final String allergen;
  final String type; // FOOD, MEDICINE, ENVIRONMENTAL
  final String severity; // MILD, MODERATE, SEVERE
  final String? reaction;

  const AllergyItem({
    required this.allergen,
    required this.type,
    required this.severity,
    this.reaction,
  });

  @override
  List<Object?> get props => [allergen, type, severity, reaction];
}

class PhysicalLimitationItem extends Equatable {
  final String bodyPart;
  final String issue;
  final String severity; // LOW, MEDIUM, HIGH
  final List<String> restrictedMovements;

  const PhysicalLimitationItem({
    required this.bodyPart,
    required this.issue,
    required this.severity,
    required this.restrictedMovements,
  });

  @override
  List<Object?> get props => [bodyPart, issue, severity, restrictedMovements];
}

class LifestyleProfile extends Equatable {
  final bool isSmoker;
  final String alcoholConsumption; // NONE, OCCASIONAL, MODERATE, HEAVY
  final String workNature; // SEDENTARY, STANDING, PHYSICAL, MIXED
  final double averageScreenTimeHours;
  final String? dietPreference;

  const LifestyleProfile({
    required this.isSmoker,
    required this.alcoholConsumption,
    required this.workNature,
    required this.averageScreenTimeHours,
    this.dietPreference,
  });

  @override
  List<Object?> get props => [isSmoker, alcoholConsumption, workNature, averageScreenTimeHours, dietPreference];
}

class HealthProfile extends Equatable {
  final String id;
  final String userId;
  final String bloodGroup;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? emergencyContactRelation;
  final String pregnancyStatus;
  final List<MedicalConditionItem> medicalHistory;
  final List<MedicalConditionItem> currentConditions;
  final List<MedicalConditionItem> pastConditions;
  final List<SurgeryItem> surgeries;
  final List<MedicationItem> medications;
  final List<AllergyItem> allergies;
  final List<PhysicalLimitationItem> physicalLimitations;
  final LifestyleProfile lifestyle;
  final bool isVerifiedByDoctor;
  final String? verifiedByDoctorId;
  final String? verificationNotes;
  final DateTime updatedAt;

  const HealthProfile({
    required this.id,
    required this.userId,
    required this.bloodGroup,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactRelation,
    required this.pregnancyStatus,
    required this.medicalHistory,
    required this.currentConditions,
    required this.pastConditions,
    required this.surgeries,
    required this.medications,
    required this.allergies,
    required this.physicalLimitations,
    required this.lifestyle,
    required this.isVerifiedByDoctor,
    this.verifiedByDoctorId,
    this.verificationNotes,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        bloodGroup,
        emergencyContactName,
        emergencyContactPhone,
        emergencyContactRelation,
        pregnancyStatus,
        medicalHistory,
        currentConditions,
        pastConditions,
        surgeries,
        medications,
        allergies,
        physicalLimitations,
        lifestyle,
        isVerifiedByDoctor,
        verifiedByDoctorId,
        verificationNotes,
        updatedAt,
      ];
}

class WellnessAssessment extends Equatable {
  final String id;
  final String userId;
  final int stressLevel; // 1-10
  final int sleepQuality; // 1-10
  final int energyLevel; // 1-10
  final int hydrationScore; // 1-10
  final int flexibilityScore; // 1-10
  final int strengthScore; // 1-10
  final int mobilityScore; // 1-10
  final double? bodyFatPercentage;
  final double? bmi;
  final int? restingHeartRate;
  final String breathingPattern;
  final String dailyActivityLevel;
  final DateTime assessedAt;

  const WellnessAssessment({
    required this.id,
    required this.userId,
    required this.stressLevel,
    required this.sleepQuality,
    required this.energyLevel,
    required this.hydrationScore,
    required this.flexibilityScore,
    required this.strengthScore,
    required this.mobilityScore,
    this.bodyFatPercentage,
    this.bmi,
    this.restingHeartRate,
    required this.breathingPattern,
    required this.dailyActivityLevel,
    required this.assessedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        stressLevel,
        sleepQuality,
        energyLevel,
        hydrationScore,
        flexibilityScore,
        strengthScore,
        mobilityScore,
        bodyFatPercentage,
        bmi,
        restingHeartRate,
        breathingPattern,
        dailyActivityLevel,
        assessedAt,
      ];
}

class YogaAssessment extends Equatable {
  final String id;
  final String userId;
  final String experienceLevel;
  final List<String> yogaGoals;
  final String preferredYogaStyle;
  final int preferredSessionLengthMin;
  final String preferredInstructorGender;
  final int practiceFrequencyPerWeek;
  final List<String> favoriteTeachers;
  final List<String> favoriteCourses;
  final List<String> favoriteMusic;
  final String preferredPracticeTime;

  const YogaAssessment({
    required this.id,
    required this.userId,
    required this.experienceLevel,
    required this.yogaGoals,
    required this.preferredYogaStyle,
    required this.preferredSessionLengthMin,
    required this.preferredInstructorGender,
    required this.practiceFrequencyPerWeek,
    required this.favoriteTeachers,
    required this.favoriteCourses,
    required this.favoriteMusic,
    required this.preferredPracticeTime,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        experienceLevel,
        yogaGoals,
        preferredYogaStyle,
        preferredSessionLengthMin,
        preferredInstructorGender,
        practiceFrequencyPerWeek,
        favoriteTeachers,
        favoriteCourses,
        favoriteMusic,
        preferredPracticeTime,
      ];
}

class NutritionProfile extends Equatable {
  final String id;
  final String userId;
  final String dietType;
  final int dailyCaloriesGoal;
  final int dailyProteinGoalGrams;
  final int dailyWaterGoalMl;
  final List<String> foodAllergies;
  final List<String> foodPreferences;
  final Map<String, String> mealTiming;
  final List<String> supplements;

  const NutritionProfile({
    required this.id,
    required this.userId,
    required this.dietType,
    required this.dailyCaloriesGoal,
    required this.dailyProteinGoalGrams,
    required this.dailyWaterGoalMl,
    required this.foodAllergies,
    required this.foodPreferences,
    required this.mealTiming,
    required this.supplements,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        dietType,
        dailyCaloriesGoal,
        dailyProteinGoalGrams,
        dailyWaterGoalMl,
        foodAllergies,
        foodPreferences,
        mealTiming,
        supplements,
      ];
}

class MeditationProfile extends Equatable {
  final String id;
  final String userId;
  final String meditationExperience;
  final int preferredDurationMin;
  final String preferredVoice;
  final String preferredMusic;
  final String focusArea;
  final List<String> mindfulnessGoals;

  const MeditationProfile({
    required this.id,
    required this.userId,
    required this.meditationExperience,
    required this.preferredDurationMin,
    required this.preferredVoice,
    required this.preferredMusic,
    required this.focusArea,
    required this.mindfulnessGoals,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        meditationExperience,
        preferredDurationMin,
        preferredVoice,
        preferredMusic,
        focusArea,
        mindfulnessGoals,
      ];
}

class AiPersonalizationProfile extends Equatable {
  final String id;
  final String userId;
  final String coachingStyle;
  final String motivationStyle;
  final String reminderStyle;
  final String communicationTone;
  final String preferredLanguage;
  final String difficultyProgression;
  final String learningStyle;
  final String voicePreference;
  final String notificationBehaviour;
  final Map<String, dynamic> recommendationPreferences;

  const AiPersonalizationProfile({
    required this.id,
    required this.userId,
    required this.coachingStyle,
    required this.motivationStyle,
    required this.reminderStyle,
    required this.communicationTone,
    required this.preferredLanguage,
    required this.difficultyProgression,
    required this.learningStyle,
    required this.voicePreference,
    required this.notificationBehaviour,
    required this.recommendationPreferences,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        coachingStyle,
        motivationStyle,
        reminderStyle,
        communicationTone,
        preferredLanguage,
        difficultyProgression,
        learningStyle,
        voicePreference,
        notificationBehaviour,
        recommendationPreferences,
      ];
}

class WellnessTimelineLog extends Equatable {
  final String id;
  final String userId;
  final String logDate; // YYYY-MM-DD
  final String dailyMood;
  final int painLevel;
  final int stressScore;
  final double sleepHours;
  final int waterIntakeMl;
  final double? weightKg;
  final int yogaMinutes;
  final int meditationMinutes;
  final int caloriesBurned;
  final String? journalEntry;
  final int energyScore;

  const WellnessTimelineLog({
    required this.id,
    required this.userId,
    required this.logDate,
    required this.dailyMood,
    required this.painLevel,
    required this.stressScore,
    required this.sleepHours,
    required this.waterIntakeMl,
    this.weightKg,
    required this.yogaMinutes,
    required this.meditationMinutes,
    required this.caloriesBurned,
    this.journalEntry,
    required this.energyScore,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        logDate,
        dailyMood,
        painLevel,
        stressScore,
        sleepHours,
        waterIntakeMl,
        weightKg,
        yogaMinutes,
        meditationMinutes,
        caloriesBurned,
        journalEntry,
        energyScore,
      ];
}

class GoalMilestone extends Equatable {
  final String title;
  final double? targetValue;
  final bool isCompleted;
  final String? completedAt;

  const GoalMilestone({
    required this.title,
    this.targetValue,
    required this.isCompleted,
    this.completedAt,
  });

  @override
  List<Object?> get props => [title, targetValue, isCompleted, completedAt];
}

class UserGoal extends Equatable {
  final String id;
  final String userId;
  final String goalType;
  final String title;
  final String? description;
  final double? targetValue;
  final double currentValue;
  final String? unit;
  final String status; // ACTIVE, COMPLETED, ABANDONED, PAUSED
  final DateTime startDate;
  final DateTime? targetDate;
  final List<GoalMilestone> milestones;
  final List<String> achievements;

  const UserGoal({
    required this.id,
    required this.userId,
    required this.goalType,
    required this.title,
    this.description,
    this.targetValue,
    required this.currentValue,
    this.unit,
    required this.status,
    required this.startDate,
    this.targetDate,
    required this.milestones,
    required this.achievements,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        goalType,
        title,
        description,
        targetValue,
        currentValue,
        unit,
        status,
        startDate,
        targetDate,
        milestones,
        achievements,
      ];
}

class MedicalSafetyFlag extends Equatable {
  final String id;
  final String userId;
  final String flagType;
  final String severity; // LOW, MEDIUM, HIGH, CRITICAL
  final String title;
  final String description;
  final List<String> restrictedPoses;
  final String? recommendedBy;
  final bool isActive;
  final DateTime createdAt;

  const MedicalSafetyFlag({
    required this.id,
    required this.userId,
    required this.flagType,
    required this.severity,
    required this.title,
    required this.description,
    required this.restrictedPoses,
    this.recommendedBy,
    required this.isActive,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        flagType,
        severity,
        title,
        description,
        restrictedPoses,
        recommendedBy,
        isActive,
        createdAt,
      ];
}

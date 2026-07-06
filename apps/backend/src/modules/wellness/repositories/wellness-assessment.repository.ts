// ==============================================================================
// Yoga24X AI Engineering OS — Wellness Assessment Repository
// Handles Wellness, Yoga, Nutrition, Meditation & AI Personalization Profiles
// ==============================================================================

import { Injectable } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import {
  SubmitWellnessAssessmentDto,
  UpdateYogaAssessmentDto,
  UpdateNutritionProfileDto,
  UpdateMeditationProfileDto,
  UpdateAiPersonalizationDto,
} from "@yoga24x/shared-types";

@Injectable()
export class WellnessAssessmentRepository {
  constructor(private readonly prisma: PrismaService) {}

  // 1. Wellness Assessment History & Latest
  async createWellnessAssessment(
    userId: string,
    dto: SubmitWellnessAssessmentDto,
  ): Promise<any> {
    // Calculate BMI if height/weight or values available
    return this.prisma.wellnessAssessment.create({
      data: {
        userId,
        stressLevel: dto.stressLevel,
        sleepQuality: dto.sleepQuality,
        energyLevel: dto.energyLevel,
        hydrationScore: dto.hydrationScore,
        flexibilityScore: dto.flexibilityScore,
        strengthScore: dto.strengthScore,
        mobilityScore: dto.mobilityScore,
        bodyFatPercentage: dto.bodyFatPercentage,
        bmi: dto.bmi,
        restingHeartRate: dto.restingHeartRate,
        breathingPattern: dto.breathingPattern || "DIAPHRAGMATIC",
        dailyActivityLevel: dto.dailyActivityLevel,
      },
    });
  }

  async getLatestWellnessAssessment(userId: string): Promise<any | null> {
    return this.prisma.wellnessAssessment.findFirst({
      where: { userId },
      orderBy: { assessedAt: "desc" },
    });
  }

  async getAssessmentHistory(
    userId: string,
    limit: number = 30,
  ): Promise<any[]> {
    return this.prisma.wellnessAssessment.findMany({
      where: { userId },
      orderBy: { assessedAt: "desc" },
      take: limit,
    });
  }

  // 2. Yoga Assessment
  async getYogaAssessment(userId: string): Promise<any | null> {
    return this.prisma.yogaAssessment.findUnique({ where: { userId } });
  }

  async upsertYogaAssessment(
    userId: string,
    dto: UpdateYogaAssessmentDto,
  ): Promise<any> {
    const data: any = {};
    if (dto.experienceLevel !== undefined)
      data.experienceLevel = dto.experienceLevel;
    if (dto.yogaGoals !== undefined) data.yogaGoalsJson = dto.yogaGoals;
    if (dto.preferredYogaStyle !== undefined)
      data.preferredYogaStyle = dto.preferredYogaStyle;
    if (dto.preferredSessionLengthMin !== undefined)
      data.preferredSessionLengthMin = dto.preferredSessionLengthMin;
    if (dto.preferredInstructorGender !== undefined)
      data.preferredInstructorGender = dto.preferredInstructorGender;
    if (dto.practiceFrequencyPerWeek !== undefined)
      data.practiceFrequencyPerWeek = dto.practiceFrequencyPerWeek;
    if (dto.favoriteTeachers !== undefined)
      data.favoriteTeachersJson = dto.favoriteTeachers;
    if (dto.favoriteCourses !== undefined)
      data.favoriteCoursesJson = dto.favoriteCourses;
    if (dto.favoriteMusic !== undefined)
      data.favoriteMusicJson = dto.favoriteMusic;
    if (dto.preferredPracticeTime !== undefined)
      data.preferredPracticeTime = dto.preferredPracticeTime;

    return this.prisma.yogaAssessment.upsert({
      where: { userId },
      update: data,
      create: {
        userId,
        experienceLevel: dto.experienceLevel || "BEGINNER",
        yogaGoalsJson: dto.yogaGoals || ["STRESS_RELIEF", "FLEXIBILITY"],
        preferredYogaStyle: dto.preferredYogaStyle || "HATHA",
        preferredSessionLengthMin: dto.preferredSessionLengthMin || 30,
        preferredInstructorGender: dto.preferredInstructorGender || "ANY",
        practiceFrequencyPerWeek: dto.practiceFrequencyPerWeek || 3,
        favoriteTeachersJson: dto.favoriteTeachers || [],
        favoriteCoursesJson: dto.favoriteCourses || [],
        favoriteMusicJson: dto.favoriteMusic || ["FLUTE", "NATURE_SOUNDS"],
        preferredPracticeTime: dto.preferredPracticeTime || "MORNING",
      },
    });
  }

  // 3. Nutrition Profile
  async getNutritionProfile(userId: string): Promise<any | null> {
    return this.prisma.nutritionProfile.findUnique({ where: { userId } });
  }

  async upsertNutritionProfile(
    userId: string,
    dto: UpdateNutritionProfileDto,
  ): Promise<any> {
    const data: any = {};
    if (dto.dietType !== undefined) data.dietType = dto.dietType;
    if (dto.dailyCaloriesGoal !== undefined)
      data.dailyCaloriesGoal = dto.dailyCaloriesGoal;
    if (dto.dailyProteinGoalGrams !== undefined)
      data.dailyProteinGoalGrams = dto.dailyProteinGoalGrams;
    if (dto.dailyWaterGoalMl !== undefined)
      data.dailyWaterGoalMl = dto.dailyWaterGoalMl;
    if (dto.foodAllergies !== undefined)
      data.foodAllergiesJson = dto.foodAllergies;
    if (dto.foodPreferences !== undefined)
      data.foodPreferencesJson = dto.foodPreferences;
    if (dto.mealTiming !== undefined) data.mealTimingJson = dto.mealTiming;
    if (dto.supplements !== undefined) data.supplementsJson = dto.supplements;

    return this.prisma.nutritionProfile.upsert({
      where: { userId },
      update: data,
      create: {
        userId,
        dietType: dto.dietType || "VEGETARIAN",
        dailyCaloriesGoal: dto.dailyCaloriesGoal || 2000,
        dailyProteinGoalGrams: dto.dailyProteinGoalGrams || 60,
        dailyWaterGoalMl: dto.dailyWaterGoalMl || 3000,
        foodAllergiesJson: dto.foodAllergies || [],
        foodPreferencesJson: dto.foodPreferences || [],
        mealTimingJson: dto.mealTiming || {
          breakfast: "08:00",
          lunch: "13:00",
          dinner: "19:00",
        },
        supplementsJson: dto.supplements || [],
      },
    });
  }

  // 4. Meditation Profile
  async getMeditationProfile(userId: string): Promise<any | null> {
    return this.prisma.meditationProfile.findUnique({ where: { userId } });
  }

  async upsertMeditationProfile(
    userId: string,
    dto: UpdateMeditationProfileDto,
  ): Promise<any> {
    const data: any = {};
    if (dto.meditationExperience !== undefined)
      data.meditationExperience = dto.meditationExperience;
    if (dto.preferredDurationMin !== undefined)
      data.preferredDurationMin = dto.preferredDurationMin;
    if (dto.preferredVoice !== undefined)
      data.preferredVoice = dto.preferredVoice;
    if (dto.preferredMusic !== undefined)
      data.preferredMusic = dto.preferredMusic;
    if (dto.focusArea !== undefined) data.focusArea = dto.focusArea;
    if (dto.mindfulnessGoals !== undefined)
      data.mindfulnessGoalsJson = dto.mindfulnessGoals;

    return this.prisma.meditationProfile.upsert({
      where: { userId },
      update: data,
      create: {
        userId,
        meditationExperience: dto.meditationExperience || "BEGINNER",
        preferredDurationMin: dto.preferredDurationMin || 15,
        preferredVoice: dto.preferredVoice || "NEUTRAL",
        preferredMusic: dto.preferredMusic || "AMBIENT",
        focusArea: dto.focusArea || "MINDFULNESS",
        mindfulnessGoalsJson: dto.mindfulnessGoals || [
          "STRESS_REDUCTION",
          "BETTER_FOCUS",
        ],
      },
    });
  }

  // 5. AI Personalization Profile
  async getAiPersonalization(userId: string): Promise<any | null> {
    return this.prisma.aiPersonalizationProfile.findUnique({
      where: { userId },
    });
  }

  async upsertAiPersonalization(
    userId: string,
    dto: UpdateAiPersonalizationDto,
  ): Promise<any> {
    const data: any = {};
    if (dto.coachingStyle !== undefined) data.coachingStyle = dto.coachingStyle;
    if (dto.motivationStyle !== undefined)
      data.motivationStyle = dto.motivationStyle;
    if (dto.reminderStyle !== undefined) data.reminderStyle = dto.reminderStyle;
    if (dto.communicationTone !== undefined)
      data.communicationTone = dto.communicationTone;
    if (dto.preferredLanguage !== undefined)
      data.preferredLanguage = dto.preferredLanguage;
    if (dto.difficultyProgression !== undefined)
      data.difficultyProgression = dto.difficultyProgression;
    if (dto.learningStyle !== undefined) data.learningStyle = dto.learningStyle;
    if (dto.voicePreference !== undefined)
      data.voicePreference = dto.voicePreference;
    if (dto.notificationBehaviour !== undefined)
      data.notificationBehaviour = dto.notificationBehaviour;
    if (dto.recommendationPreferences !== undefined)
      data.recommendationPreferencesJson = dto.recommendationPreferences;

    return this.prisma.aiPersonalizationProfile.upsert({
      where: { userId },
      update: data,
      create: {
        userId,
        coachingStyle: dto.coachingStyle || "ENCOURAGING",
        motivationStyle: dto.motivationStyle || "POSITIVE_REINFORCEMENT",
        reminderStyle: dto.reminderStyle || "REGULAR",
        communicationTone: dto.communicationTone || "WARM_AND_EMPATHETIC",
        preferredLanguage: dto.preferredLanguage || "en",
        difficultyProgression: dto.difficultyProgression || "MODERATE",
        learningStyle: dto.learningStyle || "VISUAL",
        voicePreference: dto.voicePreference || "WARM_FEMALE_EN_IN",
        notificationBehaviour: dto.notificationBehaviour || "SMART_ADAPTIVE",
        recommendationPreferencesJson: dto.recommendationPreferences || {
          poseCorrectionSensitivity: "HIGH",
          pacingPreference: "MODERATE",
        },
      },
    });
  }
}

// ==============================================================================
// Yoga24X AI Engineering OS — Wellness Assessment Service
// Business Logic for Wellness, Yoga, Nutrition, Meditation & AI Personalization
// ==============================================================================

import { Injectable } from '@nestjs/common';
import { WellnessAssessmentRepository } from '../repositories/wellness-assessment.repository';
import {
  SubmitWellnessAssessmentDto,
  UpdateYogaAssessmentDto,
  UpdateNutritionProfileDto,
  UpdateMeditationProfileDto,
  UpdateAiPersonalizationDto,
} from '@yoga24x/shared-types';

@Injectable()
export class AssessmentService {
  constructor(private readonly assessRepo: WellnessAssessmentRepository) {}

  // 1. Wellness Assessment
  async submitWellnessAssessment(userId: string, dto: SubmitWellnessAssessmentDto): Promise<any> {
    return this.assessRepo.createWellnessAssessment(userId, dto);
  }

  async getLatestWellnessAssessment(userId: string): Promise<any> {
    const latest = await this.assessRepo.getLatestWellnessAssessment(userId);
    if (!latest) {
      return {
        userId,
        stressLevel: 5,
        sleepQuality: 5,
        energyLevel: 5,
        hydrationScore: 5,
        flexibilityScore: 5,
        strengthScore: 5,
        mobilityScore: 5,
        breathingPattern: 'DIAPHRAGMATIC',
        dailyActivityLevel: 'MODERATELY_ACTIVE',
        assessedAt: new Date().toISOString(),
      };
    }
    return latest;
  }

  async getAssessmentHistory(userId: string, limit: number = 30): Promise<any[]> {
    return this.assessRepo.getAssessmentHistory(userId, limit);
  }

  // 2. Yoga Assessment
  async getYogaAssessment(userId: string): Promise<any> {
    const assessment = await this.assessRepo.getYogaAssessment(userId);
    if (!assessment) {
      return {
        userId,
        experienceLevel: 'BEGINNER',
        yogaGoals: ['STRESS_RELIEF', 'FLEXIBILITY'],
        preferredYogaStyle: 'HATHA',
        preferredSessionLengthMin: 30,
        preferredInstructorGender: 'ANY',
        practiceFrequencyPerWeek: 3,
        favoriteTeachers: [],
        favoriteCourses: [],
        favoriteMusic: ['FLUTE', 'NATURE_SOUNDS'],
        preferredPracticeTime: 'MORNING',
      };
    }
    return assessment;
  }

  async updateYogaAssessment(userId: string, dto: UpdateYogaAssessmentDto): Promise<any> {
    return this.assessRepo.upsertYogaAssessment(userId, dto);
  }

  // 3. Nutrition Profile
  async getNutritionProfile(userId: string): Promise<any> {
    const profile = await this.assessRepo.getNutritionProfile(userId);
    if (!profile) {
      return {
        userId,
        dietType: 'VEGETARIAN',
        dailyCaloriesGoal: 2000,
        dailyProteinGoalGrams: 60,
        dailyWaterGoalMl: 3000,
        foodAllergies: [],
        foodPreferences: [],
        mealTiming: { breakfast: '08:00', lunch: '13:00', dinner: '19:00' },
        supplements: [],
      };
    }
    return profile;
  }

  async updateNutritionProfile(userId: string, dto: UpdateNutritionProfileDto): Promise<any> {
    return this.assessRepo.upsertNutritionProfile(userId, dto);
  }

  // 4. Meditation Profile
  async getMeditationProfile(userId: string): Promise<any> {
    const profile = await this.assessRepo.getMeditationProfile(userId);
    if (!profile) {
      return {
        userId,
        meditationExperience: 'BEGINNER',
        preferredDurationMin: 15,
        preferredVoice: 'NEUTRAL',
        preferredMusic: 'AMBIENT',
        focusArea: 'MINDFULNESS',
        mindfulnessGoals: ['STRESS_REDUCTION', 'BETTER_FOCUS'],
      };
    }
    return profile;
  }

  async updateMeditationProfile(userId: string, dto: UpdateMeditationProfileDto): Promise<any> {
    return this.assessRepo.upsertMeditationProfile(userId, dto);
  }

  // 5. AI Personalization Profile
  async getAiPersonalization(userId: string): Promise<any> {
    const profile = await this.assessRepo.getAiPersonalization(userId);
    if (!profile) {
      return {
        userId,
        coachingStyle: 'ENCOURAGING',
        motivationStyle: 'POSITIVE_REINFORCEMENT',
        reminderStyle: 'REGULAR',
        communicationTone: 'WARM_AND_EMPATHETIC',
        preferredLanguage: 'en',
        difficultyProgression: 'MODERATE',
        learningStyle: 'VISUAL',
        voicePreference: 'WARM_FEMALE_EN_IN',
        notificationBehaviour: 'SMART_ADAPTIVE',
        recommendationPreferences: { poseCorrectionSensitivity: 'HIGH', pacingPreference: 'MODERATE' },
      };
    }
    return profile;
  }

  async updateAiPersonalization(userId: string, dto: UpdateAiPersonalizationDto): Promise<any> {
    return this.assessRepo.upsertAiPersonalization(userId, dto);
  }
}

// ==============================================================================
// Yoga24X AI Engineering OS — Enterprise Wellness DTOs & Zod Schemas
// Robust Zod Schemas for Health, Assessments, Goals, and AI Personalization
// ==============================================================================

import { z } from "zod";
import { WELLNESS_CONSTANTS } from "./wellness.constants";

export const MedicalConditionItemSchema = z.object({
  condition: z.string().min(1, "Condition name required"),
  diagnosedYear: z.number().int().min(1900).max(2100).optional(),
  status: z.enum(["ACTIVE", "RESOLVED", "MANAGED"]),
  notes: z.string().optional(),
});

export const SurgeryItemSchema = z.object({
  procedure: z.string().min(1, "Procedure name required"),
  year: z.number().int().min(1900).max(2100),
  surgeonOrHospital: z.string().optional(),
  recoveryNotes: z.string().optional(),
});

export const MedicationItemSchema = z.object({
  name: z.string().min(1, "Medication name required"),
  dosage: z.string().min(1, "Dosage required"),
  frequency: z.string().min(1, "Frequency required"),
  reason: z.string().optional(),
});

export const AllergyItemSchema = z.object({
  allergen: z.string().min(1, "Allergen required"),
  type: z.enum(["FOOD", "MEDICINE", "ENVIRONMENTAL"]),
  severity: z.enum(["MILD", "MODERATE", "SEVERE"]),
  reaction: z.string().optional(),
});

export const PhysicalLimitationItemSchema = z.object({
  bodyPart: z.string().min(1, "Body part required"),
  issue: z.string().min(1, "Issue required"),
  severity: z.enum(["LOW", "MEDIUM", "HIGH"]),
  restrictedMovements: z.array(z.string()).optional(),
});

export const LifestyleProfileSchema = z.object({
  isSmoker: z.boolean().optional(),
  alcoholConsumption: z
    .enum(["NONE", "OCCASIONAL", "MODERATE", "HEAVY"])
    .optional(),
  workNature: z.enum(["SEDENTARY", "STANDING", "PHYSICAL", "MIXED"]).optional(),
  averageScreenTimeHours: z.number().min(0).max(24).optional(),
  dietPreference: z.string().optional(),
});

export const UpdateHealthProfileSchema = z.object({
  bloodGroup: z.enum(WELLNESS_CONSTANTS.BLOOD_GROUPS).optional(),
  emergencyContactName: z.string().max(100).optional(),
  emergencyContactPhone: z.string().max(20).optional(),
  emergencyContactRelation: z.string().max(50).optional(),
  pregnancyStatus: z.enum(WELLNESS_CONSTANTS.PREGNANCY_STATUSES).optional(),
  medicalHistory: z.array(MedicalConditionItemSchema).optional(),
  currentConditions: z.array(MedicalConditionItemSchema).optional(),
  pastConditions: z.array(MedicalConditionItemSchema).optional(),
  surgeries: z.array(SurgeryItemSchema).optional(),
  medications: z.array(MedicationItemSchema).optional(),
  allergies: z.array(AllergyItemSchema).optional(),
  physicalLimitations: z.array(PhysicalLimitationItemSchema).optional(),
  lifestyle: LifestyleProfileSchema.optional(),
});
export type UpdateHealthProfileDto = z.infer<typeof UpdateHealthProfileSchema>;

export const SubmitWellnessAssessmentSchema = z.object({
  stressLevel: z.number().int().min(1).max(10),
  sleepQuality: z.number().int().min(1).max(10),
  energyLevel: z.number().int().min(1).max(10),
  hydrationScore: z.number().int().min(1).max(10),
  flexibilityScore: z.number().int().min(1).max(10),
  strengthScore: z.number().int().min(1).max(10),
  mobilityScore: z.number().int().min(1).max(10),
  bodyFatPercentage: z.number().min(1).max(70).optional(),
  bmi: z.number().min(10).max(60).optional(),
  restingHeartRate: z.number().int().min(30).max(220).optional(),
  breathingPattern: z.enum(WELLNESS_CONSTANTS.BREATHING_PATTERNS).optional(),
  dailyActivityLevel: z.enum(WELLNESS_CONSTANTS.ACTIVITY_LEVELS),
});
export type SubmitWellnessAssessmentDto = z.infer<
  typeof SubmitWellnessAssessmentSchema
>;

export const UpdateYogaAssessmentSchema = z.object({
  experienceLevel: z.enum(WELLNESS_CONSTANTS.YOGA_EXPERIENCE_LEVELS).optional(),
  yogaGoals: z.array(z.string()).optional(),
  preferredYogaStyle: z.enum(WELLNESS_CONSTANTS.YOGA_STYLES).optional(),
  preferredSessionLengthMin: z.number().int().min(5).max(180).optional(),
  preferredInstructorGender: z
    .enum(WELLNESS_CONSTANTS.INSTRUCTOR_GENDER_PREFS)
    .optional(),
  practiceFrequencyPerWeek: z.number().int().min(1).max(14).optional(),
  favoriteTeachers: z.array(z.string()).optional(),
  favoriteCourses: z.array(z.string()).optional(),
  favoriteMusic: z.array(z.string()).optional(),
  preferredPracticeTime: z.enum(WELLNESS_CONSTANTS.PRACTICE_TIMES).optional(),
});
export type UpdateYogaAssessmentDto = z.infer<
  typeof UpdateYogaAssessmentSchema
>;

export const UpdateNutritionProfileSchema = z.object({
  dietType: z.enum(WELLNESS_CONSTANTS.DIET_TYPES).optional(),
  dailyCaloriesGoal: z.number().int().min(500).max(8000).optional(),
  dailyProteinGoalGrams: z.number().int().min(10).max(400).optional(),
  dailyWaterGoalMl: z.number().int().min(500).max(10000).optional(),
  foodAllergies: z.array(z.string()).optional(),
  foodPreferences: z.array(z.string()).optional(),
  mealTiming: z
    .object({
      breakfast: z.string().optional(),
      lunch: z.string().optional(),
      dinner: z.string().optional(),
      snacks: z.string().optional(),
    })
    .optional(),
  supplements: z.array(z.string()).optional(),
});
export type UpdateNutritionProfileDto = z.infer<
  typeof UpdateNutritionProfileSchema
>;

export const UpdateMeditationProfileSchema = z.object({
  meditationExperience: z
    .enum(WELLNESS_CONSTANTS.MEDITATION_EXPERIENCE)
    .optional(),
  preferredDurationMin: z.number().int().min(5).max(180).optional(),
  preferredVoice: z.string().optional(),
  preferredMusic: z.enum(WELLNESS_CONSTANTS.MEDITATION_MUSIC).optional(),
  focusArea: z.enum(WELLNESS_CONSTANTS.MEDITATION_FOCUS).optional(),
  mindfulnessGoals: z.array(z.string()).optional(),
});
export type UpdateMeditationProfileDto = z.infer<
  typeof UpdateMeditationProfileSchema
>;

export const UpdateAiPersonalizationSchema = z.object({
  coachingStyle: z.enum(WELLNESS_CONSTANTS.AI_COACHING_STYLES).optional(),
  motivationStyle: z.enum(WELLNESS_CONSTANTS.AI_MOTIVATION_STYLES).optional(),
  reminderStyle: z.enum(WELLNESS_CONSTANTS.AI_REMINDER_STYLES).optional(),
  communicationTone: z
    .enum(WELLNESS_CONSTANTS.AI_COMMUNICATION_TONES)
    .optional(),
  preferredLanguage: z.string().max(10).optional(),
  difficultyProgression: z
    .enum(WELLNESS_CONSTANTS.AI_DIFFICULTY_PROGRESSIONS)
    .optional(),
  learningStyle: z.enum(WELLNESS_CONSTANTS.AI_LEARNING_STYLES).optional(),
  voicePreference: z.string().max(50).optional(),
  notificationBehaviour: z
    .enum(WELLNESS_CONSTANTS.AI_NOTIFICATION_BEHAVIOURS)
    .optional(),
  recommendationPreferences: z.record(z.any()).optional(),
});
export type UpdateAiPersonalizationDto = z.infer<
  typeof UpdateAiPersonalizationSchema
>;

export const LogTimelineSchema = z.object({
  logDate: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, "Must be YYYY-MM-DD"),
  dailyMood: z.enum(WELLNESS_CONSTANTS.TIMELINE_MOODS).optional(),
  painLevel: z.number().int().min(0).max(10).optional(),
  stressScore: z.number().int().min(1).max(10).optional(),
  sleepHours: z.number().min(0).max(24).optional(),
  waterIntakeMl: z.number().int().min(0).max(15000).optional(),
  weightKg: z.number().min(20).max(300).optional(),
  yogaMinutes: z.number().int().min(0).max(1440).optional(),
  meditationMinutes: z.number().int().min(0).max(1440).optional(),
  caloriesBurned: z.number().int().min(0).max(10000).optional(),
  journalEntry: z.string().max(5000).optional(),
  energyScore: z.number().int().min(1).max(10).optional(),
});
export type LogTimelineDto = z.infer<typeof LogTimelineSchema>;

export const GoalMilestoneSchema = z.object({
  title: z.string().min(1),
  targetValue: z.number().optional(),
  isCompleted: z.boolean().default(false),
  completedAt: z.string().optional(),
});

export const CreateUserGoalSchema = z.object({
  goalType: z.enum(WELLNESS_CONSTANTS.GOAL_TYPES),
  title: z.string().min(3).max(200),
  description: z.string().max(1000).optional(),
  targetValue: z.number().optional(),
  currentValue: z.number().default(0).optional(),
  unit: z.string().max(30).optional(),
  targetDate: z.string().optional(),
  milestones: z.array(GoalMilestoneSchema).optional(),
});
export type CreateUserGoalDto = z.infer<typeof CreateUserGoalSchema>;

export const UpdateUserGoalSchema = z.object({
  title: z.string().min(3).max(200).optional(),
  description: z.string().max(1000).optional(),
  targetValue: z.number().optional(),
  currentValue: z.number().optional(),
  status: z.enum(WELLNESS_CONSTANTS.GOAL_STATUSES).optional(),
  targetDate: z.string().optional(),
  milestones: z.array(GoalMilestoneSchema).optional(),
  achievements: z.array(z.string()).optional(),
});
export type UpdateUserGoalDto = z.infer<typeof UpdateUserGoalSchema>;

export const CreateMedicalSafetyFlagSchema = z.object({
  userId: z.string().uuid(),
  flagType: z.enum(WELLNESS_CONSTANTS.SAFETY_FLAG_TYPES),
  severity: z.enum(WELLNESS_CONSTANTS.SEVERITY_LEVELS),
  title: z.string().min(3).max(200),
  description: z.string().min(5),
  restrictedPoses: z.array(z.string()).optional(),
  recommendedBy: z.string().max(100).optional(),
  isActive: z.boolean().default(true),
});
export type CreateMedicalSafetyFlagDto = z.infer<
  typeof CreateMedicalSafetyFlagSchema
>;

export const DoctorVerifyHealthProfileSchema = z.object({
  userId: z.string().uuid(),
  verificationNotes: z.string().min(5),
});
export type DoctorVerifyHealthProfileDto = z.infer<
  typeof DoctorVerifyHealthProfileSchema
>;

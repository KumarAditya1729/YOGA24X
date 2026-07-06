// ==============================================================================
// Yoga24X AI Engineering OS — Enterprise Wellness Types
// TypeScript Interfaces for Health Profiles, Assessments, AI Personalization & Safety
// ==============================================================================

export interface MedicalConditionItem {
  condition: string;
  diagnosedYear?: number;
  status: 'ACTIVE' | 'RESOLVED' | 'MANAGED';
  notes?: string;
}

export interface SurgeryItem {
  procedure: string;
  year: number;
  surgeonOrHospital?: string;
  recoveryNotes?: string;
}

export interface MedicationItem {
  name: string;
  dosage: string;
  frequency: string;
  reason?: string;
}

export interface AllergyItem {
  allergen: string;
  type: 'FOOD' | 'MEDICINE' | 'ENVIRONMENTAL';
  severity: 'MILD' | 'MODERATE' | 'SEVERE';
  reaction?: string;
}

export interface PhysicalLimitationItem {
  bodyPart: string;
  issue: string; // e.g. "HERNIATED_DISC", "ACL_TEAR", "STIFFNESS"
  severity: 'LOW' | 'MEDIUM' | 'HIGH';
  restrictedMovements?: string[];
}

export interface LifestyleProfile {
  isSmoker?: boolean;
  alcoholConsumption?: 'NONE' | 'OCCASIONAL' | 'MODERATE' | 'HEAVY';
  workNature?: 'SEDENTARY' | 'STANDING' | 'PHYSICAL' | 'MIXED';
  averageScreenTimeHours?: number;
  dietPreference?: string;
}

export interface HealthProfileOverview {
  id: string;
  userId: string;
  bloodGroup: string;
  emergencyContactName?: string;
  emergencyContactPhone?: string;
  emergencyContactRelation?: string;
  pregnancyStatus: string;
  medicalHistory: MedicalConditionItem[];
  currentConditions: MedicalConditionItem[];
  pastConditions: MedicalConditionItem[];
  surgeries: SurgeryItem[];
  medications: MedicationItem[];
  allergies: AllergyItem[];
  physicalLimitations: PhysicalLimitationItem[];
  lifestyle: LifestyleProfile;
  isVerifiedByDoctor: boolean;
  verifiedByDoctorId?: string;
  verificationNotes?: string;
  createdAt: string;
  updatedAt: string;
}

export interface WellnessAssessmentOverview {
  id: string;
  userId: string;
  stressLevel: number; // 1-10
  sleepQuality: number; // 1-10
  energyLevel: number; // 1-10
  hydrationScore: number; // 1-10
  flexibilityScore: number; // 1-10
  strengthScore: number; // 1-10
  mobilityScore: number; // 1-10
  bodyFatPercentage?: number;
  bmi?: number;
  restingHeartRate?: number;
  breathingPattern?: string;
  dailyActivityLevel: string;
  assessedAt: string;
}

export interface YogaAssessmentOverview {
  id: string;
  userId: string;
  experienceLevel: string;
  yogaGoals: string[];
  preferredYogaStyle: string;
  preferredSessionLengthMin: number;
  preferredInstructorGender: string;
  practiceFrequencyPerWeek: number;
  favoriteTeachers: string[];
  favoriteCourses: string[];
  favoriteMusic: string[];
  preferredPracticeTime: string;
  updatedAt: string;
}

export interface NutritionProfileOverview {
  id: string;
  userId: string;
  dietType: string;
  dailyCaloriesGoal: number;
  dailyProteinGoalGrams: number;
  dailyWaterGoalMl: number;
  foodAllergies: string[];
  foodPreferences: string[];
  mealTiming: {
    breakfast?: string;
    lunch?: string;
    dinner?: string;
    snacks?: string;
  };
  supplements: string[];
  updatedAt: string;
}

export interface MeditationProfileOverview {
  id: string;
  userId: string;
  meditationExperience: string;
  preferredDurationMin: number;
  preferredVoice: string;
  preferredMusic: string;
  focusArea: string;
  mindfulnessGoals: string[];
  updatedAt: string;
}

export interface AiPersonalizationOverview {
  id: string;
  userId: string;
  coachingStyle: string;
  motivationStyle: string;
  reminderStyle: string;
  communicationTone: string;
  preferredLanguage: string;
  difficultyProgression: string;
  learningStyle: string;
  voicePreference: string;
  notificationBehaviour: string;
  recommendationPreferences: Record<string, any>;
  updatedAt: string;
}

export interface WellnessTimelineLogOverview {
  id: string;
  userId: string;
  logDate: string; // YYYY-MM-DD
  dailyMood?: string;
  painLevel?: number; // 0-10
  stressScore?: number; // 1-10
  sleepHours?: number;
  waterIntakeMl?: number;
  weightKg?: number;
  yogaMinutes: number;
  meditationMinutes: number;
  caloriesBurned: number;
  journalEntry?: string;
  energyScore?: number; // 1-10
  createdAt: string;
  updatedAt: string;
}

export interface GoalMilestone {
  title: string;
  targetValue?: number;
  isCompleted: boolean;
  completedAt?: string;
}

export interface UserGoalOverview {
  id: string;
  userId: string;
  goalType: string;
  title: string;
  description?: string;
  targetValue?: number;
  currentValue?: number;
  unit?: string;
  status: string;
  startDate: string;
  targetDate?: string;
  milestones: GoalMilestone[];
  achievements: string[];
  completedAt?: string;
  createdAt: string;
  updatedAt: string;
}

export interface MedicalSafetyFlagOverview {
  id: string;
  userId: string;
  flagType: string;
  severity: string; // LOW, MEDIUM, HIGH, CRITICAL
  title: string;
  description: string;
  restrictedPoses: string[];
  recommendedBy?: string;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface CompleteWellnessIdentity {
  healthProfile: HealthProfileOverview | null;
  latestAssessment: WellnessAssessmentOverview | null;
  yogaAssessment: YogaAssessmentOverview | null;
  nutritionProfile: NutritionProfileOverview | null;
  meditationProfile: MeditationProfileOverview | null;
  aiPersonalization: AiPersonalizationOverview | null;
  activeGoals: UserGoalOverview[];
  safetyFlags: MedicalSafetyFlagOverview[];
}

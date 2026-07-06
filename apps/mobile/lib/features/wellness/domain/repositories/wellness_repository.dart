// ==============================================================================
// Yoga24X AI Engineering OS — Enterprise Wellness Repository Interface
// Domain Contract for Health Identity, Assessments, Goals, and Medical Safety
// ==============================================================================

import '../models/wellness_models.dart';

abstract class WellnessRepository {
  // 1. Health Profile
  Future<HealthProfile> getHealthProfile();
  Future<HealthProfile> updateHealthProfile(Map<String, dynamic> data);

  // 2. Wellness Assessment
  Future<WellnessAssessment> submitWellnessAssessment(Map<String, dynamic> data);
  Future<WellnessAssessment?> getLatestWellnessAssessment();
  Future<List<WellnessAssessment>> getAssessmentHistory({int limit = 30});

  // 3. Yoga Assessment
  Future<YogaAssessment> getYogaAssessment();
  Future<YogaAssessment> updateYogaAssessment(Map<String, dynamic> data);

  // 4. Nutrition Profile
  Future<NutritionProfile> getNutritionProfile();
  Future<NutritionProfile> updateNutritionProfile(Map<String, dynamic> data);

  // 5. Meditation Profile
  Future<MeditationProfile> getMeditationProfile();
  Future<MeditationProfile> updateMeditationProfile(Map<String, dynamic> data);

  // 6. AI Personalization Profile
  Future<AiPersonalizationProfile> getAiPersonalization();
  Future<AiPersonalizationProfile> updateAiPersonalization(Map<String, dynamic> data);

  // 7. Daily Timeline
  Future<WellnessTimelineLog> logDailyTimeline(Map<String, dynamic> data);
  Future<List<WellnessTimelineLog>> getTimelineLogs({String? startDate, String? endDate});

  // 8. User Goals
  Future<UserGoal> createGoal(Map<String, dynamic> data);
  Future<List<UserGoal>> getGoals({String? status});
  Future<UserGoal> updateGoal(String goalId, Map<String, dynamic> data);
  Future<void> deleteGoal(String goalId);

  // 9. Medical Safety Flags
  Future<List<MedicalSafetyFlag>> getActiveSafetyFlags();
  Future<List<MedicalSafetyFlag>> getAllSafetyFlags();
  Future<MedicalSafetyFlag> createSafetyFlag(Map<String, dynamic> data);
  Future<MedicalSafetyFlag> deactivateSafetyFlag(String flagId);
  Future<Map<String, dynamic>> checkPoseSafety(List<String> poseNames);
}

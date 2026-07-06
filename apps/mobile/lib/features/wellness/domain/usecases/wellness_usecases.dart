// ==============================================================================
// Yoga24X AI Engineering OS — Enterprise Wellness Use Cases
// Clean Architecture Use Case Layer Encapsulating Domain Logic
// ==============================================================================

import '../models/wellness_models.dart';
import '../repositories/wellness_repository.dart';

class GetHealthProfileUseCase {
  final WellnessRepository repository;
  GetHealthProfileUseCase(this.repository);

  Future<HealthProfile> call() => repository.getHealthProfile();
}

class UpdateHealthProfileUseCase {
  final WellnessRepository repository;
  UpdateHealthProfileUseCase(this.repository);

  Future<HealthProfile> call(Map<String, dynamic> data) => repository.updateHealthProfile(data);
}

class SubmitWellnessAssessmentUseCase {
  final WellnessRepository repository;
  SubmitWellnessAssessmentUseCase(this.repository);

  Future<WellnessAssessment> call(Map<String, dynamic> data) => repository.submitWellnessAssessment(data);
}

class GetLatestAssessmentUseCase {
  final WellnessRepository repository;
  GetLatestAssessmentUseCase(this.repository);

  Future<WellnessAssessment?> call() => repository.getLatestWellnessAssessment();
}

class GetAssessmentHistoryUseCase {
  final WellnessRepository repository;
  GetAssessmentHistoryUseCase(this.repository);

  Future<List<WellnessAssessment>> call({int limit = 30}) => repository.getAssessmentHistory(limit: limit);
}

class GetYogaAssessmentUseCase {
  final WellnessRepository repository;
  GetYogaAssessmentUseCase(this.repository);

  Future<YogaAssessment> call() => repository.getYogaAssessment();
}

class UpdateYogaAssessmentUseCase {
  final WellnessRepository repository;
  UpdateYogaAssessmentUseCase(this.repository);

  Future<YogaAssessment> call(Map<String, dynamic> data) => repository.updateYogaAssessment(data);
}

class GetNutritionProfileUseCase {
  final WellnessRepository repository;
  GetNutritionProfileUseCase(this.repository);

  Future<NutritionProfile> call() => repository.getNutritionProfile();
}

class UpdateNutritionProfileUseCase {
  final WellnessRepository repository;
  UpdateNutritionProfileUseCase(this.repository);

  Future<NutritionProfile> call(Map<String, dynamic> data) => repository.updateNutritionProfile(data);
}

class GetMeditationProfileUseCase {
  final WellnessRepository repository;
  GetMeditationProfileUseCase(this.repository);

  Future<MeditationProfile> call() => repository.getMeditationProfile();
}

class UpdateMeditationProfileUseCase {
  final WellnessRepository repository;
  UpdateMeditationProfileUseCase(this.repository);

  Future<MeditationProfile> call(Map<String, dynamic> data) => repository.updateMeditationProfile(data);
}

class GetAiPersonalizationUseCase {
  final WellnessRepository repository;
  GetAiPersonalizationUseCase(this.repository);

  Future<AiPersonalizationProfile> call() => repository.getAiPersonalization();
}

class UpdateAiPersonalizationUseCase {
  final WellnessRepository repository;
  UpdateAiPersonalizationUseCase(this.repository);

  Future<AiPersonalizationProfile> call(Map<String, dynamic> data) => repository.updateAiPersonalization(data);
}

class LogDailyTimelineUseCase {
  final WellnessRepository repository;
  LogDailyTimelineUseCase(this.repository);

  Future<WellnessTimelineLog> call(Map<String, dynamic> data) => repository.logDailyTimeline(data);
}

class GetTimelineLogsUseCase {
  final WellnessRepository repository;
  GetTimelineLogsUseCase(this.repository);

  Future<List<WellnessTimelineLog>> call({String? startDate, String? endDate}) =>
      repository.getTimelineLogs(startDate: startDate, endDate: endDate);
}

class CreateUserGoalUseCase {
  final WellnessRepository repository;
  CreateUserGoalUseCase(this.repository);

  Future<UserGoal> call(Map<String, dynamic> data) => repository.createGoal(data);
}

class GetGoalsUseCase {
  final WellnessRepository repository;
  GetGoalsUseCase(this.repository);

  Future<List<UserGoal>> call({String? status}) => repository.getGoals(status: status);
}

class UpdateGoalUseCase {
  final WellnessRepository repository;
  UpdateGoalUseCase(this.repository);

  Future<UserGoal> call(String goalId, Map<String, dynamic> data) => repository.updateGoal(goalId, data);
}

class DeleteGoalUseCase {
  final WellnessRepository repository;
  DeleteGoalUseCase(this.repository);

  Future<void> call(String goalId) => repository.deleteGoal(goalId);
}

class GetActiveSafetyFlagsUseCase {
  final WellnessRepository repository;
  GetActiveSafetyFlagsUseCase(this.repository);

  Future<List<MedicalSafetyFlag>> call() => repository.getActiveSafetyFlags();
}

class GetAllSafetyFlagsUseCase {
  final WellnessRepository repository;
  GetAllSafetyFlagsUseCase(this.repository);

  Future<List<MedicalSafetyFlag>> call() => repository.getAllSafetyFlags();
}

class CreateSafetyFlagUseCase {
  final WellnessRepository repository;
  CreateSafetyFlagUseCase(this.repository);

  Future<MedicalSafetyFlag> call(Map<String, dynamic> data) => repository.createSafetyFlag(data);
}

class DeactivateSafetyFlagUseCase {
  final WellnessRepository repository;
  DeactivateSafetyFlagUseCase(this.repository);

  Future<MedicalSafetyFlag> call(String flagId) => repository.deactivateSafetyFlag(flagId);
}

class CheckPoseSafetyUseCase {
  final WellnessRepository repository;
  CheckPoseSafetyUseCase(this.repository);

  Future<Map<String, dynamic>> call(List<String> poseNames) => repository.checkPoseSafety(poseNames);
}

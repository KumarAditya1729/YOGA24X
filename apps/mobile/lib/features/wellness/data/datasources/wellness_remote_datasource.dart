// ==============================================================================
// Yoga24X AI Engineering OS — Enterprise Wellness Remote Datasource
// Dio REST API Client communicating with NestJS Backend
// ==============================================================================

import 'package:dio/dio.dart';
import '../models/wellness_dtos.dart';
import '../../domain/models/wellness_models.dart';

abstract class WellnessRemoteDataSource {
  Future<HealthProfile> getHealthProfile();
  Future<HealthProfile> updateHealthProfile(Map<String, dynamic> data);

  Future<WellnessAssessment> submitWellnessAssessment(Map<String, dynamic> data);
  Future<WellnessAssessment?> getLatestWellnessAssessment();
  Future<List<WellnessAssessment>> getAssessmentHistory(int limit);

  Future<YogaAssessment> getYogaAssessment();
  Future<YogaAssessment> updateYogaAssessment(Map<String, dynamic> data);

  Future<NutritionProfile> getNutritionProfile();
  Future<NutritionProfile> updateNutritionProfile(Map<String, dynamic> data);

  Future<MeditationProfile> getMeditationProfile();
  Future<MeditationProfile> updateMeditationProfile(Map<String, dynamic> data);

  Future<AiPersonalizationProfile> getAiPersonalization();
  Future<AiPersonalizationProfile> updateAiPersonalization(Map<String, dynamic> data);

  Future<WellnessTimelineLog> logDailyTimeline(Map<String, dynamic> data);
  Future<List<WellnessTimelineLog>> getTimelineLogs(String? startDate, String? endDate);

  Future<UserGoal> createGoal(Map<String, dynamic> data);
  Future<List<UserGoal>> getGoals(String? status);
  Future<UserGoal> updateGoal(String goalId, Map<String, dynamic> data);
  Future<void> deleteGoal(String goalId);

  Future<List<MedicalSafetyFlag>> getActiveSafetyFlags();
  Future<List<MedicalSafetyFlag>> getAllSafetyFlags();
  Future<MedicalSafetyFlag> createSafetyFlag(Map<String, dynamic> data);
  Future<MedicalSafetyFlag> deactivateSafetyFlag(String flagId);
  Future<Map<String, dynamic>> checkPoseSafety(List<String> poseNames);
}

class WellnessRemoteDataSourceImpl implements WellnessRemoteDataSource {
  final Dio dio;

  WellnessRemoteDataSourceImpl({required this.dio});

  @override
  Future<HealthProfile> getHealthProfile() async {
    final response = await dio.get('/api/v1/wellness/health-profile');
    return WellnessDtoMapper.healthProfileFromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<HealthProfile> updateHealthProfile(Map<String, dynamic> data) async {
    final response = await dio.put('/api/v1/wellness/health-profile', data: data);
    return WellnessDtoMapper.healthProfileFromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<WellnessAssessment> submitWellnessAssessment(Map<String, dynamic> data) async {
    final response = await dio.post('/api/v1/wellness/assessment/general', data: data);
    return WellnessDtoMapper.wellnessAssessmentFromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<WellnessAssessment?> getLatestWellnessAssessment() async {
    try {
      final response = await dio.get('/api/v1/wellness/assessment/general/latest');
      if (response.data == null || response.data.isEmpty) return null;
      return WellnessDtoMapper.wellnessAssessmentFromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  @override
  Future<List<WellnessAssessment>> getAssessmentHistory(int limit) async {
    final response = await dio.get('/api/v1/wellness/assessment/general/history', queryParameters: {'limit': limit});
    final list = response.data as List;
    return list.map((e) => WellnessDtoMapper.wellnessAssessmentFromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<YogaAssessment> getYogaAssessment() async {
    final response = await dio.get('/api/v1/wellness/assessment/yoga');
    return WellnessDtoMapper.yogaAssessmentFromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<YogaAssessment> updateYogaAssessment(Map<String, dynamic> data) async {
    final response = await dio.put('/api/v1/wellness/assessment/yoga', data: data);
    return WellnessDtoMapper.yogaAssessmentFromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<NutritionProfile> getNutritionProfile() async {
    final response = await dio.get('/api/v1/wellness/assessment/nutrition');
    return WellnessDtoMapper.nutritionProfileFromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<NutritionProfile> updateNutritionProfile(Map<String, dynamic> data) async {
    final response = await dio.put('/api/v1/wellness/assessment/nutrition', data: data);
    return WellnessDtoMapper.nutritionProfileFromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<MeditationProfile> getMeditationProfile() async {
    final response = await dio.get('/api/v1/wellness/assessment/meditation');
    return WellnessDtoMapper.meditationProfileFromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<MeditationProfile> updateMeditationProfile(Map<String, dynamic> data) async {
    final response = await dio.put('/api/v1/wellness/assessment/meditation', data: data);
    return WellnessDtoMapper.meditationProfileFromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AiPersonalizationProfile> getAiPersonalization() async {
    final response = await dio.get('/api/v1/wellness/assessment/ai-personalization');
    return WellnessDtoMapper.aiPersonalizationFromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AiPersonalizationProfile> updateAiPersonalization(Map<String, dynamic> data) async {
    final response = await dio.put('/api/v1/wellness/assessment/ai-personalization', data: data);
    return WellnessDtoMapper.aiPersonalizationFromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<WellnessTimelineLog> logDailyTimeline(Map<String, dynamic> data) async {
    final response = await dio.post('/api/v1/wellness/timeline', data: data);
    return WellnessDtoMapper.timelineLogFromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<WellnessTimelineLog>> getTimelineLogs(String? startDate, String? endDate) async {
    final query = <String, dynamic>{};
    if (startDate != null) query['startDate'] = startDate;
    if (endDate != null) query['endDate'] = endDate;
    final response = await dio.get('/api/v1/wellness/timeline', queryParameters: query);
    final list = response.data as List;
    return list.map((e) => WellnessDtoMapper.timelineLogFromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<UserGoal> createGoal(Map<String, dynamic> data) async {
    final response = await dio.post('/api/v1/wellness/goals', data: data);
    return WellnessDtoMapper.userGoalFromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<UserGoal>> getGoals(String? status) async {
    final query = <String, dynamic>{};
    if (status != null) query['status'] = status;
    final response = await dio.get('/api/v1/wellness/goals', queryParameters: query);
    final list = response.data as List;
    return list.map((e) => WellnessDtoMapper.userGoalFromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<UserGoal> updateGoal(String goalId, Map<String, dynamic> data) async {
    final response = await dio.put('/api/v1/wellness/goals/$goalId', data: data);
    return WellnessDtoMapper.userGoalFromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteGoal(String goalId) async {
    await dio.delete('/api/v1/wellness/goals/$goalId');
  }

  @override
  Future<List<MedicalSafetyFlag>> getActiveSafetyFlags() async {
    final response = await dio.get('/api/v1/wellness/safety-flags/active');
    final list = response.data as List;
    return list.map((e) => WellnessDtoMapper.safetyFlagFromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<MedicalSafetyFlag>> getAllSafetyFlags() async {
    final response = await dio.get('/api/v1/wellness/safety-flags/all');
    final list = response.data as List;
    return list.map((e) => WellnessDtoMapper.safetyFlagFromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<MedicalSafetyFlag> createSafetyFlag(Map<String, dynamic> data) async {
    final response = await dio.post('/api/v1/wellness/safety-flags', data: data);
    return WellnessDtoMapper.safetyFlagFromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<MedicalSafetyFlag> deactivateSafetyFlag(String flagId) async {
    final response = await dio.delete('/api/v1/wellness/safety-flags/$flagId');
    return WellnessDtoMapper.safetyFlagFromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<Map<String, dynamic>> checkPoseSafety(List<String> poseNames) async {
    final response = await dio.post('/api/v1/wellness/safety-flags/check-pose', data: {'poseNames': poseNames});
    return response.data as Map<String, dynamic>;
  }
}

// ==============================================================================
// Yoga24X AI Engineering OS — Enterprise Wellness Local Datasource (Cache)
// Offline-First Storage using Secure Storage and Memory Caching
// ==============================================================================

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/wellness_dtos.dart';
import '../../domain/models/wellness_models.dart';

abstract class WellnessLocalDataSource {
  Future<void> cacheHealthProfile(HealthProfile profile);
  Future<HealthProfile?> getCachedHealthProfile();

  Future<void> cacheWellnessAssessment(WellnessAssessment assessment);
  Future<WellnessAssessment?> getCachedWellnessAssessment();

  Future<void> cacheYogaAssessment(YogaAssessment assessment);
  Future<YogaAssessment?> getCachedYogaAssessment();

  Future<void> cacheNutritionProfile(NutritionProfile profile);
  Future<NutritionProfile?> getCachedNutritionProfile();

  Future<void> cacheMeditationProfile(MeditationProfile profile);
  Future<MeditationProfile?> getCachedMeditationProfile();

  Future<void> cacheAiPersonalization(AiPersonalizationProfile profile);
  Future<AiPersonalizationProfile?> getCachedAiPersonalization();

  Future<void> cacheGoals(List<UserGoal> goals);
  Future<List<UserGoal>> getCachedGoals();

  Future<void> cacheSafetyFlags(List<MedicalSafetyFlag> flags);
  Future<List<MedicalSafetyFlag>> getCachedSafetyFlags();

  Future<void> clearCache();
}

class WellnessLocalDataSourceImpl implements WellnessLocalDataSource {
  final FlutterSecureStorage secureStorage;

  static const _keyHealthProfile = 'wellness_health_profile';
  static const _keyWellnessAssessment = 'wellness_assessment_latest';
  static const _keyYogaAssessment = 'wellness_yoga_assessment';
  static const _keyNutritionProfile = 'wellness_nutrition_profile';
  static const _keyMeditationProfile = 'wellness_meditation_profile';
  static const _keyAiPersonalization = 'wellness_ai_personalization';
  static const _keyGoals = 'wellness_user_goals';
  static const _keySafetyFlags = 'wellness_safety_flags';

  WellnessLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> cacheHealthProfile(HealthProfile profile) async {
    final jsonStr = jsonEncode(WellnessDtoMapper.healthProfileToJson(profile));
    await secureStorage.write(key: _keyHealthProfile, value: jsonStr);
  }

  @override
  Future<HealthProfile?> getCachedHealthProfile() async {
    final data = await secureStorage.read(key: _keyHealthProfile);
    if (data == null) return null;
    try {
      return WellnessDtoMapper.healthProfileFromJson(jsonDecode(data));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheWellnessAssessment(WellnessAssessment assessment) async {
    final jsonStr = jsonEncode(WellnessDtoMapper.wellnessAssessmentToJson(assessment));
    await secureStorage.write(key: _keyWellnessAssessment, value: jsonStr);
  }

  @override
  Future<WellnessAssessment?> getCachedWellnessAssessment() async {
    final data = await secureStorage.read(key: _keyWellnessAssessment);
    if (data == null) return null;
    try {
      return WellnessDtoMapper.wellnessAssessmentFromJson(jsonDecode(data));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheYogaAssessment(YogaAssessment assessment) async {
    final jsonStr = jsonEncode(WellnessDtoMapper.yogaAssessmentToJson(assessment));
    await secureStorage.write(key: _keyYogaAssessment, value: jsonStr);
  }

  @override
  Future<YogaAssessment?> getCachedYogaAssessment() async {
    final data = await secureStorage.read(key: _keyYogaAssessment);
    if (data == null) return null;
    try {
      return WellnessDtoMapper.yogaAssessmentFromJson(jsonDecode(data));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheNutritionProfile(NutritionProfile profile) async {
    final jsonStr = jsonEncode(WellnessDtoMapper.nutritionProfileToJson(profile));
    await secureStorage.write(key: _keyNutritionProfile, value: jsonStr);
  }

  @override
  Future<NutritionProfile?> getCachedNutritionProfile() async {
    final data = await secureStorage.read(key: _keyNutritionProfile);
    if (data == null) return null;
    try {
      return WellnessDtoMapper.nutritionProfileFromJson(jsonDecode(data));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheMeditationProfile(MeditationProfile profile) async {
    final jsonStr = jsonEncode(WellnessDtoMapper.meditationProfileToJson(profile));
    await secureStorage.write(key: _keyMeditationProfile, value: jsonStr);
  }

  @override
  Future<MeditationProfile?> getCachedMeditationProfile() async {
    final data = await secureStorage.read(key: _keyMeditationProfile);
    if (data == null) return null;
    try {
      return WellnessDtoMapper.meditationProfileFromJson(jsonDecode(data));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheAiPersonalization(AiPersonalizationProfile profile) async {
    final jsonStr = jsonEncode(WellnessDtoMapper.aiPersonalizationToJson(profile));
    await secureStorage.write(key: _keyAiPersonalization, value: jsonStr);
  }

  @override
  Future<AiPersonalizationProfile?> getCachedAiPersonalization() async {
    final data = await secureStorage.read(key: _keyAiPersonalization);
    if (data == null) return null;
    try {
      return WellnessDtoMapper.aiPersonalizationFromJson(jsonDecode(data));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheGoals(List<UserGoal> goals) async {
    final list = goals.map((g) => WellnessDtoMapper.userGoalToJson(g)).toList();
    await secureStorage.write(key: _keyGoals, value: jsonEncode(list));
  }

  @override
  Future<List<UserGoal>> getCachedGoals() async {
    final data = await secureStorage.read(key: _keyGoals);
    if (data == null) return [];
    try {
      final list = jsonDecode(data) as List;
      return list.map((e) => WellnessDtoMapper.userGoalFromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> cacheSafetyFlags(List<MedicalSafetyFlag> flags) async {
    final list = flags.map((f) => WellnessDtoMapper.safetyFlagToJson(f)).toList();
    await secureStorage.write(key: _keySafetyFlags, value: jsonEncode(list));
  }

  @override
  Future<List<MedicalSafetyFlag>> getCachedSafetyFlags() async {
    final data = await secureStorage.read(key: _keySafetyFlags);
    if (data == null) return [];
    try {
      final list = jsonDecode(data) as List;
      return list.map((e) => WellnessDtoMapper.safetyFlagFromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> clearCache() async {
    await secureStorage.delete(key: _keyHealthProfile);
    await secureStorage.delete(key: _keyWellnessAssessment);
    await secureStorage.delete(key: _keyYogaAssessment);
    await secureStorage.delete(key: _keyNutritionProfile);
    await secureStorage.delete(key: _keyMeditationProfile);
    await secureStorage.delete(key: _keyAiPersonalization);
    await secureStorage.delete(key: _keyGoals);
    await secureStorage.delete(key: _keySafetyFlags);
  }
}

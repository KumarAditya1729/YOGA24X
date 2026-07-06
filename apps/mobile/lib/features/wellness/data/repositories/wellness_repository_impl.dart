// ==============================================================================
// Yoga24X AI Engineering OS — Enterprise Wellness Repository Implementation
// Combines Remote API and Offline Local Cache with Error Handling & Fallbacks
// ==============================================================================

import 'dart:io';
import 'package:dio/dio.dart';
import '../../domain/models/wellness_models.dart';
import '../../domain/repositories/wellness_repository.dart';
import '../datasources/wellness_local_datasource.dart';
import '../datasources/wellness_remote_datasource.dart';

class WellnessRepositoryImpl implements WellnessRepository {
  final WellnessRemoteDataSource remoteDataSource;
  final WellnessLocalDataSource localDataSource;

  WellnessRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<HealthProfile> getHealthProfile() async {
    try {
      final remoteProfile = await remoteDataSource.getHealthProfile();
      await localDataSource.cacheHealthProfile(remoteProfile);
      return remoteProfile;
    } catch (e) {
      final cached = await localDataSource.getCachedHealthProfile();
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<HealthProfile> updateHealthProfile(Map<String, dynamic> data) async {
    final remoteProfile = await remoteDataSource.updateHealthProfile(data);
    await localDataSource.cacheHealthProfile(remoteProfile);
    return remoteProfile;
  }

  @override
  Future<WellnessAssessment> submitWellnessAssessment(Map<String, dynamic> data) async {
    final remoteAssessment = await remoteDataSource.submitWellnessAssessment(data);
    await localDataSource.cacheWellnessAssessment(remoteAssessment);
    return remoteAssessment;
  }

  @override
  Future<WellnessAssessment?> getLatestWellnessAssessment() async {
    try {
      final remoteAssessment = await remoteDataSource.getLatestWellnessAssessment();
      if (remoteAssessment != null) {
        await localDataSource.cacheWellnessAssessment(remoteAssessment);
      }
      return remoteAssessment;
    } catch (e) {
      return await localDataSource.getCachedWellnessAssessment();
    }
  }

  @override
  Future<List<WellnessAssessment>> getAssessmentHistory({int limit = 30}) async {
    try {
      return await remoteDataSource.getAssessmentHistory(limit);
    } catch (e) {
      final latest = await localDataSource.getCachedWellnessAssessment();
      return latest != null ? [latest] : [];
    }
  }

  @override
  Future<YogaAssessment> getYogaAssessment() async {
    try {
      final remote = await remoteDataSource.getYogaAssessment();
      await localDataSource.cacheYogaAssessment(remote);
      return remote;
    } catch (e) {
      final cached = await localDataSource.getCachedYogaAssessment();
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<YogaAssessment> updateYogaAssessment(Map<String, dynamic> data) async {
    final remote = await remoteDataSource.updateYogaAssessment(data);
    await localDataSource.cacheYogaAssessment(remote);
    return remote;
  }

  @override
  Future<NutritionProfile> getNutritionProfile() async {
    try {
      final remote = await remoteDataSource.getNutritionProfile();
      await localDataSource.cacheNutritionProfile(remote);
      return remote;
    } catch (e) {
      final cached = await localDataSource.getCachedNutritionProfile();
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<NutritionProfile> updateNutritionProfile(Map<String, dynamic> data) async {
    final remote = await remoteDataSource.updateNutritionProfile(data);
    await localDataSource.cacheNutritionProfile(remote);
    return remote;
  }

  @override
  Future<MeditationProfile> getMeditationProfile() async {
    try {
      final remote = await remoteDataSource.getMeditationProfile();
      await localDataSource.cacheMeditationProfile(remote);
      return remote;
    } catch (e) {
      final cached = await localDataSource.getCachedMeditationProfile();
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<MeditationProfile> updateMeditationProfile(Map<String, dynamic> data) async {
    final remote = await remoteDataSource.updateMeditationProfile(data);
    await localDataSource.cacheMeditationProfile(remote);
    return remote;
  }

  @override
  Future<AiPersonalizationProfile> getAiPersonalization() async {
    try {
      final remote = await remoteDataSource.getAiPersonalization();
      await localDataSource.cacheAiPersonalization(remote);
      return remote;
    } catch (e) {
      final cached = await localDataSource.getCachedAiPersonalization();
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<AiPersonalizationProfile> updateAiPersonalization(Map<String, dynamic> data) async {
    final remote = await remoteDataSource.updateAiPersonalization(data);
    await localDataSource.cacheAiPersonalization(remote);
    return remote;
  }

  @override
  Future<WellnessTimelineLog> logDailyTimeline(Map<String, dynamic> data) async {
    return await remoteDataSource.logDailyTimeline(data);
  }

  @override
  Future<List<WellnessTimelineLog>> getTimelineLogs({String? startDate, String? endDate}) async {
    try {
      return await remoteDataSource.getTimelineLogs(startDate, endDate);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<UserGoal> createGoal(Map<String, dynamic> data) async {
    final res = await remoteDataSource.createGoal(data);
    final current = await localDataSource.getCachedGoals();
    await localDataSource.cacheGoals([res, ...current]);
    return res;
  }

  @override
  Future<List<UserGoal>> getGoals({String? status}) async {
    try {
      final remote = await remoteDataSource.getGoals(status);
      await localDataSource.cacheGoals(remote);
      return remote;
    } catch (e) {
      return await localDataSource.getCachedGoals();
    }
  }

  @override
  Future<UserGoal> updateGoal(String goalId, Map<String, dynamic> data) async {
    final res = await remoteDataSource.updateGoal(goalId, data);
    final current = await localDataSource.getCachedGoals();
    final index = current.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      current[index] = res;
    } else {
      current.add(res);
    }
    await localDataSource.cacheGoals(current);
    return res;
  }

  @override
  Future<void> deleteGoal(String goalId) async {
    await remoteDataSource.deleteGoal(goalId);
    final current = await localDataSource.getCachedGoals();
    current.removeWhere((g) => g.id == goalId);
    await localDataSource.cacheGoals(current);
  }

  @override
  Future<List<MedicalSafetyFlag>> getActiveSafetyFlags() async {
    try {
      final remote = await remoteDataSource.getActiveSafetyFlags();
      await localDataSource.cacheSafetyFlags(remote);
      return remote;
    } catch (e) {
      return await localDataSource.getCachedSafetyFlags();
    }
  }

  @override
  Future<List<MedicalSafetyFlag>> getAllSafetyFlags() async {
    try {
      final remote = await remoteDataSource.getAllSafetyFlags();
      await localDataSource.cacheSafetyFlags(remote);
      return remote;
    } catch (e) {
      return await localDataSource.getCachedSafetyFlags();
    }
  }

  @override
  Future<MedicalSafetyFlag> createSafetyFlag(Map<String, dynamic> data) async {
    final res = await remoteDataSource.createSafetyFlag(data);
    final current = await localDataSource.getCachedSafetyFlags();
    await localDataSource.cacheSafetyFlags([res, ...current]);
    return res;
  }

  @override
  Future<MedicalSafetyFlag> deactivateSafetyFlag(String flagId) async {
    final res = await remoteDataSource.deactivateSafetyFlag(flagId);
    final current = await localDataSource.getCachedSafetyFlags();
    final index = current.indexWhere((f) => f.id == flagId);
    if (index != -1) {
      current[index] = res;
      await localDataSource.cacheSafetyFlags(current);
    }
    return res;
  }

  @override
  Future<Map<String, dynamic>> checkPoseSafety(List<String> poseNames) async {
    try {
      return await remoteDataSource.checkPoseSafety(poseNames);
    } catch (e) {
      // Local fallback safety evaluation against cached flags
      final cachedFlags = await localDataSource.getCachedSafetyFlags();
      final activeFlags = cachedFlags.where((f) => f.isActive).toList();
      final restrictedFound = <String, List<String>>{};
      for (final pose in poseNames) {
        for (final flag in activeFlags) {
          if (flag.restrictedPoses.any((r) => r.toLowerCase() == pose.toLowerCase())) {
            restrictedFound.putIfAbsent(pose, () => []).add('${flag.title} (${flag.severity})');
          }
        }
      }
      return {
        'safe': restrictedFound.isEmpty,
        'restrictedPoses': restrictedFound,
        'offlineFallback': true,
      };
    }
  }
}

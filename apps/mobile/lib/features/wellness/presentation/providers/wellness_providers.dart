// ==============================================================================
// Yoga24X AI Engineering OS — Enterprise Wellness Dependency Injection Providers
// Riverpod Providers for Datasources, Repositories, and Use Cases
// ==============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/wellness_local_datasource.dart';
import '../../data/datasources/wellness_remote_datasource.dart';
import '../../data/repositories/wellness_repository_impl.dart';
import '../../domain/repositories/wellness_repository.dart';
import '../../domain/usecases/wellness_usecases.dart';

// ------------------------------------------------------------------------------
// Datasources & Repository Providers
// ------------------------------------------------------------------------------

final wellnessLocalDataSourceProvider = Provider<WellnessLocalDataSource>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return WellnessLocalDataSourceImpl(secureStorage: storage);
});

final wellnessRemoteDataSourceProvider = Provider<WellnessRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return WellnessRemoteDataSourceImpl(dio: dio);
});

final wellnessRepositoryProvider = Provider<WellnessRepository>((ref) {
  final remote = ref.watch(wellnessRemoteDataSourceProvider);
  final local = ref.watch(wellnessLocalDataSourceProvider);
  return WellnessRepositoryImpl(remoteDataSource: remote, localDataSource: local);
});

// ------------------------------------------------------------------------------
// Use Case Providers
// ------------------------------------------------------------------------------

final getHealthProfileUseCaseProvider = Provider<GetHealthProfileUseCase>((ref) {
  return GetHealthProfileUseCase(ref.watch(wellnessRepositoryProvider));
});

final updateHealthProfileUseCaseProvider = Provider<UpdateHealthProfileUseCase>((ref) {
  return UpdateHealthProfileUseCase(ref.watch(wellnessRepositoryProvider));
});

final submitWellnessAssessmentUseCaseProvider = Provider<SubmitWellnessAssessmentUseCase>((ref) {
  return SubmitWellnessAssessmentUseCase(ref.watch(wellnessRepositoryProvider));
});

final getLatestAssessmentUseCaseProvider = Provider<GetLatestAssessmentUseCase>((ref) {
  return GetLatestAssessmentUseCase(ref.watch(wellnessRepositoryProvider));
});

final getAssessmentHistoryUseCaseProvider = Provider<GetAssessmentHistoryUseCase>((ref) {
  return GetAssessmentHistoryUseCase(ref.watch(wellnessRepositoryProvider));
});

final getYogaAssessmentUseCaseProvider = Provider<GetYogaAssessmentUseCase>((ref) {
  return GetYogaAssessmentUseCase(ref.watch(wellnessRepositoryProvider));
});

final updateYogaAssessmentUseCaseProvider = Provider<UpdateYogaAssessmentUseCase>((ref) {
  return UpdateYogaAssessmentUseCase(ref.watch(wellnessRepositoryProvider));
});

final getNutritionProfileUseCaseProvider = Provider<GetNutritionProfileUseCase>((ref) {
  return GetNutritionProfileUseCase(ref.watch(wellnessRepositoryProvider));
});

final updateNutritionProfileUseCaseProvider = Provider<UpdateNutritionProfileUseCase>((ref) {
  return UpdateNutritionProfileUseCase(ref.watch(wellnessRepositoryProvider));
});

final getMeditationProfileUseCaseProvider = Provider<GetMeditationProfileUseCase>((ref) {
  return GetMeditationProfileUseCase(ref.watch(wellnessRepositoryProvider));
});

final updateMeditationProfileUseCaseProvider = Provider<UpdateMeditationProfileUseCase>((ref) {
  return UpdateMeditationProfileUseCase(ref.watch(wellnessRepositoryProvider));
});

final getAiPersonalizationUseCaseProvider = Provider<GetAiPersonalizationUseCase>((ref) {
  return GetAiPersonalizationUseCase(ref.watch(wellnessRepositoryProvider));
});

final updateAiPersonalizationUseCaseProvider = Provider<UpdateAiPersonalizationUseCase>((ref) {
  return UpdateAiPersonalizationUseCase(ref.watch(wellnessRepositoryProvider));
});

final logDailyTimelineUseCaseProvider = Provider<LogDailyTimelineUseCase>((ref) {
  return LogDailyTimelineUseCase(ref.watch(wellnessRepositoryProvider));
});

final getTimelineLogsUseCaseProvider = Provider<GetTimelineLogsUseCase>((ref) {
  return GetTimelineLogsUseCase(ref.watch(wellnessRepositoryProvider));
});

final createUserGoalUseCaseProvider = Provider<CreateUserGoalUseCase>((ref) {
  return CreateUserGoalUseCase(ref.watch(wellnessRepositoryProvider));
});

final getGoalsUseCaseProvider = Provider<GetGoalsUseCase>((ref) {
  return GetGoalsUseCase(ref.watch(wellnessRepositoryProvider));
});

final updateGoalUseCaseProvider = Provider<UpdateGoalUseCase>((ref) {
  return UpdateGoalUseCase(ref.watch(wellnessRepositoryProvider));
});

final deleteGoalUseCaseProvider = Provider<DeleteGoalUseCase>((ref) {
  return DeleteGoalUseCase(ref.watch(wellnessRepositoryProvider));
});

final getActiveSafetyFlagsUseCaseProvider = Provider<GetActiveSafetyFlagsUseCase>((ref) {
  return GetActiveSafetyFlagsUseCase(ref.watch(wellnessRepositoryProvider));
});

final getAllSafetyFlagsUseCaseProvider = Provider<GetAllSafetyFlagsUseCase>((ref) {
  return GetAllSafetyFlagsUseCase(ref.watch(wellnessRepositoryProvider));
});

final createSafetyFlagUseCaseProvider = Provider<CreateSafetyFlagUseCase>((ref) {
  return CreateSafetyFlagUseCase(ref.watch(wellnessRepositoryProvider));
});

final deactivateSafetyFlagUseCaseProvider = Provider<DeactivateSafetyFlagUseCase>((ref) {
  return DeactivateSafetyFlagUseCase(ref.watch(wellnessRepositoryProvider));
});

final checkPoseSafetyUseCaseProvider = Provider<CheckPoseSafetyUseCase>((ref) {
  return CheckPoseSafetyUseCase(ref.watch(wellnessRepositoryProvider));
});

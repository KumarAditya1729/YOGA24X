// ==============================================================================
// Yoga24X AI Engineering OS — Assessments & AI Personalization State Provider
// Manages General Wellness, Yoga, Nutrition, Meditation, and AI Coaching Profiles
// ==============================================================================

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/wellness_models.dart';
import '../../domain/usecases/wellness_usecases.dart';
import 'wellness_providers.dart';

enum AssessmentStatus { initial, loading, loaded, empty, error }

class AssessmentState extends Equatable {
  final AssessmentStatus status;
  final WellnessAssessment? latestGeneralAssessment;
  final List<WellnessAssessment> assessmentHistory;
  final YogaAssessment? yogaAssessment;
  final NutritionProfile? nutritionProfile;
  final MeditationProfile? meditationProfile;
  final AiPersonalizationProfile? aiPersonalization;
  final String? errorMessage;
  final bool isSubmitting;

  const AssessmentState({
    required this.status,
    this.latestGeneralAssessment,
    this.assessmentHistory = const [],
    this.yogaAssessment,
    this.nutritionProfile,
    this.meditationProfile,
    this.aiPersonalization,
    this.errorMessage,
    this.isSubmitting = false,
  });

  factory AssessmentState.initial() => const AssessmentState(status: AssessmentStatus.initial);

  AssessmentState copyWith({
    AssessmentStatus? status,
    WellnessAssessment? latestGeneralAssessment,
    List<WellnessAssessment>? assessmentHistory,
    YogaAssessment? yogaAssessment,
    NutritionProfile? nutritionProfile,
    MeditationProfile? meditationProfile,
    AiPersonalizationProfile? aiPersonalization,
    String? errorMessage,
    bool? isSubmitting,
  }) {
    return AssessmentState(
      status: status ?? this.status,
      latestGeneralAssessment: latestGeneralAssessment ?? this.latestGeneralAssessment,
      assessmentHistory: assessmentHistory ?? this.assessmentHistory,
      yogaAssessment: yogaAssessment ?? this.yogaAssessment,
      nutritionProfile: nutritionProfile ?? this.nutritionProfile,
      meditationProfile: meditationProfile ?? this.meditationProfile,
      aiPersonalization: aiPersonalization ?? this.aiPersonalization,
      errorMessage: errorMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [
        status,
        latestGeneralAssessment,
        assessmentHistory,
        yogaAssessment,
        nutritionProfile,
        meditationProfile,
        aiPersonalization,
        errorMessage,
        isSubmitting,
      ];
}

class AssessmentNotifier extends StateNotifier<AssessmentState> {
  final SubmitWellnessAssessmentUseCase submitGeneral;
  final GetLatestAssessmentUseCase getLatestGeneral;
  final GetAssessmentHistoryUseCase getHistory;
  final GetYogaAssessmentUseCase getYoga;
  final UpdateYogaAssessmentUseCase updateYoga;
  final GetNutritionProfileUseCase getNutrition;
  final UpdateNutritionProfileUseCase updateNutrition;
  final GetMeditationProfileUseCase getMeditation;
  final UpdateMeditationProfileUseCase updateMeditation;
  final GetAiPersonalizationUseCase getAi;
  final UpdateAiPersonalizationUseCase updateAi;

  AssessmentNotifier({
    required this.submitGeneral,
    required this.getLatestGeneral,
    required this.getHistory,
    required this.getYoga,
    required this.updateYoga,
    required this.getNutrition,
    required this.updateNutrition,
    required this.getMeditation,
    required this.updateMeditation,
    required this.getAi,
    required this.updateAi,
  }) : super(AssessmentState.initial()) {
    fetchAllAssessments();
  }

  Future<void> fetchAllAssessments() async {
    state = state.copyWith(status: AssessmentStatus.loading, errorMessage: null);
    try {
      final latest = await getLatestGeneral();
      final history = await getHistory(limit: 30);
      final yoga = await getYoga();
      final nutrition = await getNutrition();
      final meditation = await getMeditation();
      final ai = await getAi();

      state = state.copyWith(
        status: AssessmentStatus.loaded,
        latestGeneralAssessment: latest,
        assessmentHistory: history,
        yogaAssessment: yoga,
        nutritionProfile: nutrition,
        meditationProfile: meditation,
        aiPersonalization: ai,
      );
    } catch (e) {
      state = state.copyWith(
        status: AssessmentStatus.error,
        errorMessage: 'Failed to load assessments: ${e.toString()}',
      );
    }
  }

  Future<bool> submitGeneralAssessment(Map<String, dynamic> data) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final res = await submitGeneral(data);
      final history = [res, ...state.assessmentHistory];
      state = state.copyWith(
        status: AssessmentStatus.loaded,
        latestGeneralAssessment: res,
        assessmentHistory: history,
        isSubmitting: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> saveYogaAssessment(Map<String, dynamic> data) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final res = await updateYoga(data);
      state = state.copyWith(yogaAssessment: res, isSubmitting: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> saveNutritionProfile(Map<String, dynamic> data) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final res = await updateNutrition(data);
      state = state.copyWith(nutritionProfile: res, isSubmitting: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> saveMeditationProfile(Map<String, dynamic> data) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final res = await updateMeditation(data);
      state = state.copyWith(meditationProfile: res, isSubmitting: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> saveAiPersonalization(Map<String, dynamic> data) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final res = await updateAi(data);
      state = state.copyWith(aiPersonalization: res, isSubmitting: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      return false;
    }
  }
}

final assessmentNotifierProvider = StateNotifierProvider<AssessmentNotifier, AssessmentState>((ref) {
  return AssessmentNotifier(
    submitGeneral: ref.watch(submitWellnessAssessmentUseCaseProvider),
    getLatestGeneral: ref.watch(getLatestAssessmentUseCaseProvider),
    getHistory: ref.watch(getAssessmentHistoryUseCaseProvider),
    getYoga: ref.watch(getYogaAssessmentUseCaseProvider),
    updateYoga: ref.watch(updateYogaAssessmentUseCaseProvider),
    getNutrition: ref.watch(getNutritionProfileUseCaseProvider),
    updateNutrition: ref.watch(updateNutritionProfileUseCaseProvider),
    getMeditation: ref.watch(getMeditationProfileUseCaseProvider),
    updateMeditation: ref.watch(updateMeditationProfileUseCaseProvider),
    getAi: ref.watch(getAiPersonalizationUseCaseProvider),
    updateAi: ref.watch(updateAiPersonalizationUseCaseProvider),
  );
});

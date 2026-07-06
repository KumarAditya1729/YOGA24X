// ==============================================================================
// Yoga24X AI Engineering OS — Medical Safety & Contraindication State Provider
// Manages Warnings, Restricted Poses, Doctor Advice, and Real-Time Safety Checks
// ==============================================================================

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/wellness_models.dart';
import '../../domain/usecases/wellness_usecases.dart';
import 'wellness_providers.dart';

enum SafetyStatus { initial, loading, loaded, empty, error }

class SafetyState extends Equatable {
  final SafetyStatus status;
  final List<MedicalSafetyFlag> activeFlags;
  final List<MedicalSafetyFlag> allFlags;
  final String? errorMessage;
  final bool isCheckingPose;
  final Map<String, dynamic>? lastPoseCheckResult;

  const SafetyState({
    required this.status,
    this.activeFlags = const [],
    this.allFlags = const [],
    this.errorMessage,
    this.isCheckingPose = false,
    this.lastPoseCheckResult,
  });

  factory SafetyState.initial() => const SafetyState(status: SafetyStatus.initial);

  SafetyState copyWith({
    SafetyStatus? status,
    List<MedicalSafetyFlag>? activeFlags,
    List<MedicalSafetyFlag>? allFlags,
    String? errorMessage,
    bool? isCheckingPose,
    Map<String, dynamic>? lastPoseCheckResult,
  }) {
    return SafetyState(
      status: status ?? this.status,
      activeFlags: activeFlags ?? this.activeFlags,
      allFlags: allFlags ?? this.allFlags,
      errorMessage: errorMessage,
      isCheckingPose: isCheckingPose ?? this.isCheckingPose,
      lastPoseCheckResult: lastPoseCheckResult ?? this.lastPoseCheckResult,
    );
  }

  @override
  List<Object?> get props => [status, activeFlags, allFlags, errorMessage, isCheckingPose, lastPoseCheckResult];
}

class SafetyNotifier extends StateNotifier<SafetyState> {
  final GetActiveSafetyFlagsUseCase getActive;
  final GetAllSafetyFlagsUseCase getAll;
  final CreateSafetyFlagUseCase createFlag;
  final DeactivateSafetyFlagUseCase deactivateFlag;
  final CheckPoseSafetyUseCase checkPose;

  SafetyNotifier({
    required this.getActive,
    required this.getAll,
    required this.createFlag,
    required this.deactivateFlag,
    required this.checkPose,
  }) : super(SafetyState.initial()) {
    fetchSafetyFlags();
  }

  Future<void> fetchSafetyFlags() async {
    state = state.copyWith(status: SafetyStatus.loading, errorMessage: null);
    try {
      final active = await getActive();
      final all = await getAll();
      state = state.copyWith(
        status: active.isEmpty && all.isEmpty ? SafetyStatus.empty : SafetyStatus.loaded,
        activeFlags: active,
        allFlags: all,
      );
    } catch (e) {
      state = state.copyWith(
        status: SafetyStatus.error,
        errorMessage: 'Failed to load safety flags: ${e.toString()}',
      );
    }
  }

  Future<bool> addSafetyFlag(Map<String, dynamic> data) async {
    try {
      final res = await createFlag(data);
      final active = [res, ...state.activeFlags];
      final all = [res, ...state.allFlags];
      state = state.copyWith(status: SafetyStatus.loaded, activeFlags: active, allFlags: all);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> dismissOrDeactivateFlag(String flagId) async {
    try {
      final res = await deactivateFlag(flagId);
      final active = state.activeFlags.where((f) => f.id != flagId).toList();
      final all = state.allFlags.map((f) => f.id == flagId ? res : f).toList();
      state = state.copyWith(activeFlags: active, allFlags: all);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<Map<String, dynamic>> verifyPoses(List<String> poseNames) async {
    state = state.copyWith(isCheckingPose: true);
    try {
      final result = await checkPose(poseNames);
      state = state.copyWith(isCheckingPose: false, lastPoseCheckResult: result);
      return result;
    } catch (e) {
      state = state.copyWith(isCheckingPose: false, errorMessage: e.toString());
      return {'safe': false, 'error': e.toString()};
    }
  }
}

final safetyNotifierProvider = StateNotifierProvider<SafetyNotifier, SafetyState>((ref) {
  return SafetyNotifier(
    getActive: ref.watch(getActiveSafetyFlagsUseCaseProvider),
    getAll: ref.watch(getAllSafetyFlagsUseCaseProvider),
    createFlag: ref.watch(createSafetyFlagUseCaseProvider),
    deactivateFlag: ref.watch(deactivateSafetyFlagUseCaseProvider),
    checkPose: ref.watch(checkPoseSafetyUseCaseProvider),
  );
});

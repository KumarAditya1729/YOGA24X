// ==============================================================================
// Yoga24X AI Engineering OS — Health Profile State Management Provider
// Riverpod StateNotifier managing Loading, Empty, Error, and Success States
// ==============================================================================

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/wellness_models.dart';
import '../../domain/usecases/wellness_usecases.dart';
import 'wellness_providers.dart';

enum HealthProfileStatus { initial, loading, loaded, empty, error }

class HealthProfileState extends Equatable {
  final HealthProfileStatus status;
  final HealthProfile? profile;
  final String? errorMessage;
  final bool isUpdating;

  const HealthProfileState({
    required this.status,
    this.profile,
    this.errorMessage,
    this.isUpdating = false,
  });

  factory HealthProfileState.initial() => const HealthProfileState(status: HealthProfileStatus.initial);

  HealthProfileState copyWith({
    HealthProfileStatus? status,
    HealthProfile? profile,
    String? errorMessage,
    bool? isUpdating,
  }) {
    return HealthProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage, isUpdating];
}

class HealthProfileNotifier extends StateNotifier<HealthProfileState> {
  final GetHealthProfileUseCase getHealthProfileUseCase;
  final UpdateHealthProfileUseCase updateHealthProfileUseCase;

  HealthProfileNotifier({
    required this.getHealthProfileUseCase,
    required this.updateHealthProfileUseCase,
  }) : super(HealthProfileState.initial()) {
    fetchHealthProfile();
  }

  Future<void> fetchHealthProfile() async {
    state = state.copyWith(status: HealthProfileStatus.loading, errorMessage: null);
    try {
      final profile = await getHealthProfileUseCase();
      state = state.copyWith(status: HealthProfileStatus.loaded, profile: profile);
    } catch (e) {
      state = state.copyWith(
        status: HealthProfileStatus.error,
        errorMessage: 'Failed to load health profile: ${e.toString()}',
      );
    }
  }

  Future<bool> updateProfileSection(Map<String, dynamic> updateData) async {
    state = state.copyWith(isUpdating: true, errorMessage: null);
    try {
      final updated = await updateHealthProfileUseCase(updateData);
      state = state.copyWith(status: HealthProfileStatus.loaded, profile: updated, isUpdating: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        errorMessage: 'Failed to update profile: ${e.toString()}',
      );
      return false;
    }
  }
}

final healthProfileNotifierProvider = StateNotifierProvider<HealthProfileNotifier, HealthProfileState>((ref) {
  return HealthProfileNotifier(
    getHealthProfileUseCase: ref.watch(getHealthProfileUseCaseProvider),
    updateHealthProfileUseCase: ref.watch(updateHealthProfileUseCaseProvider),
  );
});

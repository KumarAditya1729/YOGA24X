// ==============================================================================
// Yoga24X AI Engineering OS — Goal Management & Achievements State Provider
// Manages User Goals, Progress Tracking, Milestones, and Badges
// ==============================================================================

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/wellness_models.dart';
import '../../domain/usecases/wellness_usecases.dart';
import 'wellness_providers.dart';

enum GoalsStatus { initial, loading, loaded, empty, error }

class GoalsState extends Equatable {
  final GoalsStatus status;
  final List<UserGoal> goals;
  final String? errorMessage;
  final bool isMutating;

  const GoalsState({
    required this.status,
    this.goals = const [],
    this.errorMessage,
    this.isMutating = false,
  });

  factory GoalsState.initial() => const GoalsState(status: GoalsStatus.initial);

  GoalsState copyWith({
    GoalsStatus? status,
    List<UserGoal>? goals,
    String? errorMessage,
    bool? isMutating,
  }) {
    return GoalsState(
      status: status ?? this.status,
      goals: goals ?? this.goals,
      errorMessage: errorMessage,
      isMutating: isMutating ?? this.isMutating,
    );
  }

  @override
  List<Object?> get props => [status, goals, errorMessage, isMutating];
}

class GoalsNotifier extends StateNotifier<GoalsState> {
  final CreateUserGoalUseCase createGoalUseCase;
  final GetGoalsUseCase getGoalsUseCase;
  final UpdateGoalUseCase updateGoalUseCase;
  final DeleteGoalUseCase deleteGoalUseCase;

  GoalsNotifier({
    required this.createGoalUseCase,
    required this.getGoalsUseCase,
    required this.updateGoalUseCase,
    required this.deleteGoalUseCase,
  }) : super(GoalsState.initial()) {
    fetchGoals();
  }

  Future<void> fetchGoals({String? status}) async {
    state = state.copyWith(status: GoalsStatus.loading, errorMessage: null);
    try {
      final goals = await getGoalsUseCase(status: status);
      state = state.copyWith(
        status: goals.isEmpty ? GoalsStatus.empty : GoalsStatus.loaded,
        goals: goals,
      );
    } catch (e) {
      state = state.copyWith(
        status: GoalsStatus.error,
        errorMessage: 'Failed to load goals: ${e.toString()}',
      );
    }
  }

  Future<bool> createGoal(Map<String, dynamic> data) async {
    state = state.copyWith(isMutating: true, errorMessage: null);
    try {
      final newGoal = await createGoalUseCase(data);
      final list = [newGoal, ...state.goals];
      state = state.copyWith(status: GoalsStatus.loaded, goals: list, isMutating: false);
      return true;
    } catch (e) {
      state = state.copyWith(isMutating: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> updateGoalProgress(String goalId, Map<String, dynamic> data) async {
    state = state.copyWith(isMutating: true, errorMessage: null);
    try {
      final updated = await updateGoalUseCase(goalId, data);
      final list = state.goals.map((g) => g.id == goalId ? updated : g).toList();
      state = state.copyWith(status: GoalsStatus.loaded, goals: list, isMutating: false);
      return true;
    } catch (e) {
      state = state.copyWith(isMutating: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deleteGoal(String goalId) async {
    state = state.copyWith(isMutating: true, errorMessage: null);
    try {
      await deleteGoalUseCase(goalId);
      final list = state.goals.where((g) => g.id != goalId).toList();
      state = state.copyWith(
        status: list.isEmpty ? GoalsStatus.empty : GoalsStatus.loaded,
        goals: list,
        isMutating: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isMutating: false, errorMessage: e.toString());
      return false;
    }
  }
}

final goalsNotifierProvider = StateNotifierProvider<GoalsNotifier, GoalsState>((ref) {
  return GoalsNotifier(
    createGoalUseCase: ref.watch(createUserGoalUseCaseProvider),
    getGoalsUseCase: ref.watch(getGoalsUseCaseProvider),
    updateGoalUseCase: ref.watch(updateGoalUseCaseProvider),
    deleteGoalUseCase: ref.watch(deleteGoalUseCaseProvider),
  );
});

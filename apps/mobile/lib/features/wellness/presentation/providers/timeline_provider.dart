// ==============================================================================
// Yoga24X AI Engineering OS — Daily Wellness Timeline State Provider
// Riverpod StateNotifier managing daily mood, pain, stress, yoga & sleep logs
// ==============================================================================

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/wellness_models.dart';
import '../../domain/usecases/wellness_usecases.dart';
import 'wellness_providers.dart';

enum TimelineStatus { initial, loading, loaded, empty, error }

class TimelineState extends Equatable {
  final TimelineStatus status;
  final List<WellnessTimelineLog> logs;
  final String? errorMessage;
  final bool isLogging;

  const TimelineState({
    required this.status,
    this.logs = const [],
    this.errorMessage,
    this.isLogging = false,
  });

  factory TimelineState.initial() => const TimelineState(status: TimelineStatus.initial);

  TimelineState copyWith({
    TimelineStatus? status,
    List<WellnessTimelineLog>? logs,
    String? errorMessage,
    bool? isLogging,
  }) {
    return TimelineState(
      status: status ?? this.status,
      logs: logs ?? this.logs,
      errorMessage: errorMessage,
      isLogging: isLogging ?? this.isLogging,
    );
  }

  @override
  List<Object?> get props => [status, logs, errorMessage, isLogging];
}

class TimelineNotifier extends StateNotifier<TimelineState> {
  final LogDailyTimelineUseCase logTimelineUseCase;
  final GetTimelineLogsUseCase getTimelineLogsUseCase;

  TimelineNotifier({
    required this.logTimelineUseCase,
    required this.getTimelineLogsUseCase,
  }) : super(TimelineState.initial()) {
    fetchLogs();
  }

  Future<void> fetchLogs({String? startDate, String? endDate}) async {
    state = state.copyWith(status: TimelineStatus.loading, errorMessage: null);
    try {
      final logs = await getTimelineLogsUseCase(startDate: startDate, endDate: endDate);
      state = state.copyWith(
        status: logs.isEmpty ? TimelineStatus.empty : TimelineStatus.loaded,
        logs: logs,
      );
    } catch (e) {
      state = state.copyWith(
        status: TimelineStatus.error,
        errorMessage: 'Failed to fetch timeline logs: ${e.toString()}',
      );
    }
  }

  Future<bool> logDailyEntry(Map<String, dynamic> data) async {
    state = state.copyWith(isLogging: true, errorMessage: null);
    try {
      final newLog = await logTimelineUseCase(data);
      final updatedList = [newLog, ...state.logs];
      state = state.copyWith(
        status: TimelineStatus.loaded,
        logs: updatedList,
        isLogging: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLogging: false,
        errorMessage: 'Failed to save daily log: ${e.toString()}',
      );
      return false;
    }
  }
}

final timelineNotifierProvider = StateNotifierProvider<TimelineNotifier, TimelineState>((ref) {
  return TimelineNotifier(
    logTimelineUseCase: ref.watch(logDailyTimelineUseCaseProvider),
    getTimelineLogsUseCase: ref.watch(getTimelineLogsUseCaseProvider),
  );
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/teacher_operations_repository.dart';
import '../../domain/models/teacher_operations_models.dart';

// ── Repository Provider ──────────────────────────────────────────────────────

final teacherOperationsRepositoryProvider = Provider<TeacherOperationsRepository>((ref) {
  return TeacherOperationsRepository(ref.watch(dioProvider));
});

// ── Availability Providers ───────────────────────────────────────────────────

final teacherBookingRuleProvider = FutureProvider<TeacherBookingRule>((ref) {
  final repo = ref.watch(teacherOperationsRepositoryProvider);
  return repo.getBookingRule();
});

final teacherHolidaysProvider = FutureProvider<List<TeacherHoliday>>((ref) {
  final repo = ref.watch(teacherOperationsRepositoryProvider);
  return repo.getHolidays();
});

// ── Session Types Providers ──────────────────────────────────────────────────

final teacherSessionTypesProvider = FutureProvider<List<TeacherSessionType>>((ref) {
  final repo = ref.watch(teacherOperationsRepositoryProvider);
  return repo.getSessionTypes();
});

final teacherPricingRulesProvider = FutureProvider<List<TeacherPricingRule>>((ref) {
  final repo = ref.watch(teacherOperationsRepositoryProvider);
  return repo.getPricingRules();
});

// ── Calendar Providers ───────────────────────────────────────────────────────

final teacherCalendarParamsProvider = StateProvider<Map<String, String?>>((ref) => {
  'from': null,
  'to': null,
});

final teacherCalendarSessionsProvider = FutureProvider<List<TeacherSession>>((ref) {
  final repo = ref.watch(teacherOperationsRepositoryProvider);
  final params = ref.watch(teacherCalendarParamsProvider);
  return repo.getSessions(from: params['from'], to: params['to']);
});

// ── Roster Providers ─────────────────────────────────────────────────────────

final teacherRosterProvider = FutureProvider<List<TeacherStudentRoster>>((ref) {
  final repo = ref.watch(teacherOperationsRepositoryProvider);
  return repo.getRoster();
});

final teacherRosterDetailProvider = FutureProvider.family<TeacherStudentRoster, String>((ref, studentId) {
  final repo = ref.watch(teacherOperationsRepositoryProvider);
  return repo.getRosterDetail(studentId);
});

// ── Earnings Providers ───────────────────────────────────────────────────────

final teacherWalletBalanceProvider = FutureProvider<Map<String, dynamic>>((ref) {
  final repo = ref.watch(teacherOperationsRepositoryProvider);
  return repo.getWalletBalance();
});

final teacherPayoutsProvider = FutureProvider<List<TeacherPayoutRequest>>((ref) {
  final repo = ref.watch(teacherOperationsRepositoryProvider);
  return repo.getPayouts();
});

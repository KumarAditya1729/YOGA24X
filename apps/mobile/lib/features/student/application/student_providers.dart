import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/student_repository.dart';
import '../domain/student_models.dart';

final studentDashboardProvider = FutureProvider.autoDispose<StudentDashboardData>((ref) async {
  final repository = ref.watch(studentRepositoryProvider);
  return repository.getDashboardData();
});

final studentProfileProvider = FutureProvider.autoDispose<StudentProfile>((ref) async {
  final repository = ref.watch(studentRepositoryProvider);
  return repository.getProfile();
});

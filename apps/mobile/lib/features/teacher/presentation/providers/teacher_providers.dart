import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/teacher_models.dart';
import '../../data/repositories/teacher_repository.dart';

// ── Profile Provider ────────────────────────────────────────────────────────

final teacherProfileProvider = FutureProvider<TeacherProfile?>((ref) async {
  final repo = ref.watch(teacherRepositoryProvider);
  try {
    return await repo.getOwnProfile();
  } catch (e) {
    // If profile doesn't exist, it usually returns 404
    return null;
  }
});

// ── Verification Status Provider ────────────────────────────────────────────

final teacherVerificationProvider = FutureProvider<TeacherVerification?>((ref) async {
  final repo = ref.watch(teacherRepositoryProvider);
  try {
    return await repo.getVerificationStatus();
  } catch (e) {
    return null;
  }
});

// ── Controller for Mutating Profile ──────────────────────────────────────────

class TeacherProfileNotifier extends StateNotifier<AsyncValue<TeacherProfile?>> {
  final TeacherRepository _repo;

  TeacherProfileNotifier(this._repo) : super(const AsyncValue.loading()) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _repo.getOwnProfile();
      state = AsyncValue.data(profile);
    } catch (e) {
      // 404 means no profile created yet
      state = const AsyncValue.data(null);
    }
  }

  Future<void> createProfile(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final profile = await _repo.createProfile(data);
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final current = state.valueOrNull;
    if (current == null) return;
    
    // Optimistic or loading
    state = const AsyncValue.loading();
    try {
      final updated = await _repo.updateProfile(data);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final teacherProfileControllerProvider = StateNotifierProvider<TeacherProfileNotifier, AsyncValue<TeacherProfile?>>((ref) {
  final repo = ref.watch(teacherRepositoryProvider);
  return TeacherProfileNotifier(repo);
});

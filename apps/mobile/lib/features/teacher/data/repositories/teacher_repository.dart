import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../domain/models/teacher_models.dart';

final teacherRepositoryProvider = Provider<TeacherRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TeacherRepository(dio);
});

class TeacherRepository {
  final Dio _dio;

  TeacherRepository(this._dio);

  // ── Profile ─────────────────────────────────────────────────────────────

  Future<TeacherProfile> getOwnProfile() async {
    final response = await _dio.get('/api/v1/teachers/me/profile');
    return TeacherProfile.fromJson(response.data);
  }

  Future<TeacherProfile> createProfile(Map<String, dynamic> data) async {
    final response = await _dio.post('/api/v1/teachers/me/profile', data: data);
    return TeacherProfile.fromJson(response.data);
  }

  Future<TeacherProfile> updateProfile(Map<String, dynamic> data) async {
    final response = await _dio.put('/api/v1/teachers/me/profile', data: data);
    return TeacherProfile.fromJson(response.data);
  }

  Future<TeacherProfile> getPublicProfile(String userId) async {
    final response = await _dio.get('/api/v1/teachers/$userId');
    return TeacherProfile.fromJson(response.data);
  }

  // ── Certifications ────────────────────────────────────────────────────────

  Future<List<TeacherCertification>> getCertifications() async {
    final response = await _dio.get('/api/v1/teachers/me/certifications');
    return (response.data as List).map((x) => TeacherCertification.fromJson(x)).toList();
  }

  Future<TeacherCertification> addCertification(Map<String, dynamic> data) async {
    final response = await _dio.post('/api/v1/teachers/me/certifications', data: data);
    return TeacherCertification.fromJson(response.data);
  }

  Future<void> removeCertification(String id) async {
    await _dio.delete('/api/v1/teachers/me/certifications/$id');
  }

  // ── Specializations ───────────────────────────────────────────────────────

  Future<void> upsertSpecialization(Map<String, dynamic> data) async {
    await _dio.post('/api/v1/teachers/me/specializations', data: data);
  }

  Future<void> removeSpecialization(String specialization) async {
    await _dio.delete('/api/v1/teachers/me/specializations/$specialization');
  }

  // ── Preferences ───────────────────────────────────────────────────────────

  Future<void> updatePreferences(Map<String, dynamic> data) async {
    await _dio.put('/api/v1/teachers/me/teaching-preferences', data: data);
  }

  // ── Portfolio ─────────────────────────────────────────────────────────────

  Future<List<TeacherPortfolioItem>> getPortfolioItems({String? type}) async {
    final response = await _dio.get(
      '/api/v1/teachers/me/portfolio',
      queryParameters: type != null ? {'type': type} : null,
    );
    return (response.data as List).map((x) => TeacherPortfolioItem.fromJson(x)).toList();
  }

  Future<TeacherPortfolioItem> addPortfolioItem(Map<String, dynamic> data) async {
    final response = await _dio.post('/api/v1/teachers/me/portfolio', data: data);
    return TeacherPortfolioItem.fromJson(response.data);
  }

  Future<void> removePortfolioItem(String id) async {
    await _dio.delete('/api/v1/teachers/me/portfolio/$id');
  }

  Future<void> toggleFeaturedPortfolio(String id) async {
    await _dio.put('/api/v1/teachers/me/portfolio/$id/toggle-featured');
  }

  // ── Verification ──────────────────────────────────────────────────────────

  Future<TeacherVerification> submitVerification(Map<String, dynamic> data) async {
    final response = await _dio.post('/api/v1/teachers/me/verification', data: data);
    return TeacherVerification.fromJson(response.data);
  }

  Future<TeacherVerification> getVerificationStatus() async {
    final response = await _dio.get('/api/v1/teachers/me/verification');
    return TeacherVerification.fromJson(response.data);
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/student_models.dart';
import '../../auth/presentation/providers/auth_providers.dart';

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  final dio = ref.watch(dioProvider); // Assuming dioProvider exists in the core network module
  return StudentRepository(dio);
});

class StudentRepository {
  final Dio _dio;

  StudentRepository(this._dio);

  Future<StudentDashboardData> getDashboardData() async {
    try {
      final response = await _dio.get('/api/v1/students/me/dashboard');
      return StudentDashboardData.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load dashboard data: $e');
    }
  }

  Future<StudentProfile> getProfile() async {
    try {
      final response = await _dio.get('/api/v1/students/me/profile');
      return StudentProfile.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      await _dio.put('/api/v1/students/me/profile', data: data);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> submitDailyWellnessCheckin(Map<String, dynamic> data) async {
    try {
      await _dio.post('/api/v1/students/me/health/timeline', data: data);
    } catch (e) {
      throw Exception('Failed to submit wellness checkin: $e');
    }
  }
}

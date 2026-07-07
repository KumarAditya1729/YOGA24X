import 'package:dio/dio.dart';
import '../domain/models/teacher_operations_models.dart';

class TeacherOperationsRepository {
  final Dio _dio;

  TeacherOperationsRepository(this._dio);

  // ── Availability ─────────────────────────────────────────────────────────────
  
  Future<TeacherBookingRule> getBookingRule() async {
    final response = await _dio.get('/api/v1/teacher/operations/availability/rules');
    return TeacherBookingRule.fromJson(response.data);
  }

  Future<TeacherBookingRule> updateBookingRule(Map<String, dynamic> data) async {
    final response = await _dio.put('/api/v1/teacher/operations/availability/rules', data: data);
    return TeacherBookingRule.fromJson(response.data);
  }

  Future<List<TeacherHoliday>> getHolidays() async {
    final response = await _dio.get('/api/v1/teacher/operations/availability/holidays');
    return (response.data as List).map((x) => TeacherHoliday.fromJson(x)).toList();
  }

  Future<TeacherHoliday> createHoliday(Map<String, dynamic> data) async {
    final response = await _dio.post('/api/v1/teacher/operations/availability/holidays', data: data);
    return TeacherHoliday.fromJson(response.data);
  }

  Future<void> deleteHoliday(String id) async {
    await _dio.delete('/api/v1/teacher/operations/availability/holidays/$id');
  }

  // ── Session Types & Pricing ──────────────────────────────────────────────────
  
  Future<List<TeacherSessionType>> getSessionTypes() async {
    final response = await _dio.get('/api/v1/teacher/operations/sessions/types');
    return (response.data as List).map((x) => TeacherSessionType.fromJson(x)).toList();
  }

  Future<TeacherSessionType> createSessionType(Map<String, dynamic> data) async {
    final response = await _dio.post('/api/v1/teacher/operations/sessions/types', data: data);
    return TeacherSessionType.fromJson(response.data);
  }

  Future<TeacherSessionType> updateSessionType(String id, Map<String, dynamic> data) async {
    final response = await _dio.put('/api/v1/teacher/operations/sessions/types/$id', data: data);
    return TeacherSessionType.fromJson(response.data);
  }

  Future<void> deleteSessionType(String id) async {
    await _dio.delete('/api/v1/teacher/operations/sessions/types/$id');
  }

  Future<List<TeacherPricingRule>> getPricingRules() async {
    final response = await _dio.get('/api/v1/teacher/operations/sessions/pricing-rules');
    return (response.data as List).map((x) => TeacherPricingRule.fromJson(x)).toList();
  }

  // ── Scheduling (Calendar) ────────────────────────────────────────────────────
  
  Future<List<TeacherSession>> getSessions({String? from, String? to}) async {
    final response = await _dio.get(
      '/api/v1/teacher/operations/sessions/calendar',
      queryParameters: {'from': from, 'to': to},
    );
    return (response.data as List).map((x) => TeacherSession.fromJson(x)).toList();
  }

  Future<TeacherSession> createSession(Map<String, dynamic> data) async {
    final response = await _dio.post('/api/v1/teacher/operations/sessions/calendar', data: data);
    return TeacherSession.fromJson(response.data);
  }

  // ── Roster ───────────────────────────────────────────────────────────────────
  
  Future<List<TeacherStudentRoster>> getRoster() async {
    final response = await _dio.get('/api/v1/teacher/operations/students');
    return (response.data as List).map((x) => TeacherStudentRoster.fromJson(x)).toList();
  }

  Future<TeacherStudentRoster> getRosterDetail(String studentId) async {
    final response = await _dio.get('/api/v1/teacher/operations/students/$studentId');
    return TeacherStudentRoster.fromJson(response.data);
  }

  Future<TeacherStudentRoster> updateRosterFlags(String studentId, Map<String, dynamic> data) async {
    final response = await _dio.put('/api/v1/teacher/operations/students/$studentId', data: data);
    return TeacherStudentRoster.fromJson(response.data);
  }

  // ── Earnings & Wallet ────────────────────────────────────────────────────────
  
  Future<Map<String, dynamic>> getWalletBalance() async {
    final response = await _dio.get('/api/v1/teacher/operations/earnings/balance');
    return response.data as Map<String, dynamic>;
  }

  Future<List<TeacherPayoutRequest>> getPayouts() async {
    final response = await _dio.get('/api/v1/teacher/operations/earnings/payouts');
    return (response.data as List).map((x) => TeacherPayoutRequest.fromJson(x)).toList();
  }

  Future<TeacherPayoutRequest> requestPayout(Map<String, dynamic> data) async {
    final response = await _dio.post('/api/v1/teacher/operations/earnings/payouts', data: data);
    return TeacherPayoutRequest.fromJson(response.data);
  }
}

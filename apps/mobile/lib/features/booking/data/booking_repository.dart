// ==============================================================================
// Yoga24X AI Engineering OS — Booking Repository (Flutter, Prompt 7)
// ==============================================================================

import 'package:dio/dio.dart';
import '../domain/models/booking_models.dart';

class BookingRepository {
  final Dio _dio;
  BookingRepository(this._dio);

  // ─── Bookings ──────────────────────────────────────────────────────────────

  Future<BookingItem> createBooking({
    required String sessionId,
    String? bookingNotes,
  }) async {
    final response = await _dio.post('/api/v1/bookings', data: {
      'sessionId': sessionId,
      if (bookingNotes != null) 'bookingNotes': bookingNotes,
    });
    return BookingItem.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<BookingItem>> getMyBookings({
    String? status,
    String? fromDate,
    String? toDate,
  }) async {
    final response = await _dio.get('/api/v1/bookings', queryParameters: {
      if (status != null) 'status': status,
      if (fromDate != null) 'fromDate': fromDate,
      if (toDate != null) 'toDate': toDate,
    });
    return (response.data as List)
        .map((e) => BookingItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<BookingItem> rescheduleBooking({
    required String bookingId,
    required String newSessionId,
    String? reason,
  }) async {
    final response = await _dio.post('/api/v1/bookings/reschedule', data: {
      'bookingId': bookingId,
      'newSessionId': newSessionId,
      if (reason != null) 'reason': reason,
    });
    return BookingItem.fromJson(response.data as Map<String, dynamic>);
  }

  Future<BookingItem> cancelBooking({
    required String bookingId,
    required String reason,
  }) async {
    final response = await _dio.post('/api/v1/bookings/cancel', data: {
      'bookingId': bookingId,
      'reason': reason,
    });
    return BookingItem.fromJson(response.data as Map<String, dynamic>);
  }

  // ─── Schedule & Calendar ───────────────────────────────────────────────────

  Future<Map<String, dynamic>> getStudentCalendar({
    required String from,
    required String to,
  }) async {
    final response = await _dio.get('/api/v1/schedule/student/calendar',
        queryParameters: {'from': from, 'to': to});
    return response.data as Map<String, dynamic>;
  }

  Future<List<AvailableSlot>> getAvailableSlots({
    required String teacherUserId,
    required String from,
    required String to,
  }) async {
    final response = await _dio.get(
      '/api/v1/schedule/teacher/$teacherUserId/slots',
      queryParameters: {'from': from, 'to': to},
    );
    return (response.data as List)
        .map((e) => AvailableSlot.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ─── Attendance ────────────────────────────────────────────────────────────

  Future<AttendanceRecord> checkIn({
    required String bookingId,
    required String method,
    String? token,
    double? geoLat,
    double? geoLng,
  }) async {
    final response = await _dio.post('/api/v1/attendance/check-in', data: {
      'bookingId': bookingId,
      'method': method,
      if (token != null) 'token': token,
      if (geoLat != null) 'geoLat': geoLat,
      if (geoLng != null) 'geoLng': geoLng,
    });
    return AttendanceRecord.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> getCheckInToken(String bookingId) async {
    final response = await _dio.post('/api/v1/attendance/check-in-token/$bookingId');
    return response.data as Map<String, dynamic>;
  }

  // ─── Waitlist ──────────────────────────────────────────────────────────────

  Future<WaitlistEntry> joinWaitlist({String? sessionId, String? eventId}) async {
    final response = await _dio.post('/api/v1/waitlist/join', data: {
      if (sessionId != null) 'sessionId': sessionId,
      if (eventId != null) 'eventId': eventId,
    });
    return WaitlistEntry.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> leaveWaitlist(String entryId) async {
    await _dio.delete('/api/v1/waitlist/$entryId');
  }

  Future<List<WaitlistEntry>> getMyWaitlist() async {
    final response = await _dio.get('/api/v1/waitlist');
    return (response.data as List)
        .map((e) => WaitlistEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ─── Enrollments ───────────────────────────────────────────────────────────

  Future<void> enrollInCourse(String courseId) async {
    await _dio.post('/api/v1/enrollments/courses', data: {'courseId': courseId});
  }

  Future<void> registerForEvent(String eventId) async {
    await _dio.post('/api/v1/enrollments/events', data: {'eventId': eventId});
  }
}

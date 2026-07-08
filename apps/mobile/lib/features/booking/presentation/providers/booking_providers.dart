// ==============================================================================
// Yoga24X AI Engineering OS — Booking Providers (Riverpod, Prompt 7)
// ==============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/booking_repository.dart';
import '../../domain/models/booking_models.dart';

// ─── Repository Provider ──────────────────────────────────────────────────────
final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository(
    ref.watch(dioProvider),
  );
});

// ─── My Bookings ──────────────────────────────────────────────────────────────
final myBookingsProvider = FutureProvider.family<List<BookingItem>, String?>(
  (ref, status) => ref.watch(bookingRepositoryProvider).getMyBookings(status: status),
);

// ─── Upcoming Bookings ────────────────────────────────────────────────────────
final upcomingBookingsProvider = FutureProvider<List<BookingItem>>((ref) {
  final repo = ref.watch(bookingRepositoryProvider);
  final now = DateTime.now();
  return repo.getMyBookings(
    status: 'CONFIRMED',
    fromDate: now.toIso8601String(),
  );
});

// ─── Past Bookings ─────────────────────────────────────────────────────────────
final pastBookingsProvider = FutureProvider<List<BookingItem>>((ref) {
  final repo = ref.watch(bookingRepositoryProvider);
  final now = DateTime.now();
  return repo.getMyBookings(
    status: 'COMPLETED',
    toDate: now.toIso8601String(),
  );
});

// ─── Student Calendar ─────────────────────────────────────────────────────────
class CalendarRange {
  final String from;
  final String to;
  const CalendarRange(this.from, this.to);
}

final studentCalendarProvider =
    FutureProvider.family<Map<String, dynamic>, CalendarRange>(
  (ref, range) => ref
      .watch(bookingRepositoryProvider)
      .getStudentCalendar(from: range.from, to: range.to),
);

// ─── Available Slots ───────────────────────────────────────────────────────────
class SlotQuery {
  final String teacherUserId;
  final String from;
  final String to;
  const SlotQuery(this.teacherUserId, this.from, this.to);
}

final availableSlotsProvider =
    FutureProvider.family<List<AvailableSlot>, SlotQuery>(
  (ref, q) => ref
      .watch(bookingRepositoryProvider)
      .getAvailableSlots(teacherUserId: q.teacherUserId, from: q.from, to: q.to),
);

// ─── My Waitlist ───────────────────────────────────────────────────────────────
final myWaitlistProvider = FutureProvider<List<WaitlistEntry>>(
  (ref) => ref.watch(bookingRepositoryProvider).getMyWaitlist(),
);

// ─── Booking Notifier (create/cancel/reschedule) ──────────────────────────────
class BookingNotifier extends StateNotifier<AsyncValue<BookingItem?>> {
  final BookingRepository _repo;
  BookingNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> createBooking(String sessionId, {String? notes}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repo.createBooking(sessionId: sessionId, bookingNotes: notes),
    );
  }

  Future<void> reschedule(
      String bookingId, String newSessionId, String reason) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repo.rescheduleBooking(
        bookingId: bookingId,
        newSessionId: newSessionId,
        reason: reason,
      ),
    );
  }

  Future<void> cancel(String bookingId, String reason) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repo.cancelBooking(bookingId: bookingId, reason: reason),
    );
  }
}

final bookingNotifierProvider =
    StateNotifierProvider<BookingNotifier, AsyncValue<BookingItem?>>((ref) {
  return BookingNotifier(ref.watch(bookingRepositoryProvider));
});

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/booking_providers.dart';
import '../../domain/models/booking_models.dart';

class UnifiedCalendarScreen extends ConsumerStatefulWidget {
  const UnifiedCalendarScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UnifiedCalendarScreen> createState() => _UnifiedCalendarScreenState();
}

class _UnifiedCalendarScreenState extends ConsumerState<UnifiedCalendarScreen> {
  DateTime _focusedDate = DateTime.now();

  static const _months = [
    'Jan','Feb','Mar','Apr','May','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec'
  ];

  String get _from =>
      DateTime(_focusedDate.year, _focusedDate.month, 1).toIso8601String();
  String get _to =>
      DateTime(_focusedDate.year, _focusedDate.month + 1, 0).toIso8601String();

  @override
  Widget build(BuildContext context) {
    final calendarAsync =
        ref.watch(studentCalendarProvider(CalendarRange(_from, _to)));

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('My Calendar',
            style: TextStyle(color: Colors.white, fontFamily: 'Inter')),
      ),
      body: calendarAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF7C3AED))),
        error: (e, _) =>
            Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
        data: (data) {
          final bookings = (data['bookings'] as List?)
                  ?.map((e) =>
                      BookingItem.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [];
          return Column(children: [
            _CalendarHeader(
              focusedDate: _focusedDate,
              months: _months,
              onPrev: () => setState(() =>
                  _focusedDate =
                      DateTime(_focusedDate.year, _focusedDate.month - 1)),
              onNext: () => setState(() =>
                  _focusedDate =
                      DateTime(_focusedDate.year, _focusedDate.month + 1)),
            ),
            Expanded(
              child: bookings.isEmpty
                  ? const _EmptyCalendar()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: bookings.length,
                      itemBuilder: (ctx, i) =>
                          _BookingCalendarTile(booking: bookings[i]),
                    ),
            ),
          ]);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/booking/flow'),
        backgroundColor: const Color(0xFF7C3AED),
        icon: const Icon(Icons.add),
        label: const Text('Book Session'),
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDate;
  final List<String> months;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  const _CalendarHeader(
      {required this.focusedDate,
      required this.months,
      required this.onPrev,
      required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF161B22),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.white),
              onPressed: onPrev),
          Text(
            '${months[focusedDate.month - 1]} ${focusedDate.year}',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.white),
              onPressed: onNext),
        ],
      ),
    );
  }
}

class _BookingCalendarTile extends StatelessWidget {
  final BookingItem booking;
  const _BookingCalendarTile({required this.booking});

  Color get _statusColor {
    switch (booking.status) {
      case BookingStatus.confirmed:
        return const Color(0xFF10B981);
      case BookingStatus.cancelled:
        return const Color(0xFFEF4444);
      case BookingStatus.completed:
        return const Color(0xFF6B7280);
      case BookingStatus.checkedIn:
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFFF59E0B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = booking.session;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2732),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: _statusColor, width: 4)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(session?.title ?? 'Session',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        if (session != null)
          Text(
            '${session.startTime.hour}:${session.startTime.minute.toString().padLeft(2, '0')} – '
            '${session.endTime.hour}:${session.endTime.minute.toString().padLeft(2, '0')}',
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        const SizedBox(height: 8),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6)),
          child: Text(booking.status.name.toUpperCase(),
              style: TextStyle(
                  color: _statusColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),
        ),
      ]),
    );
  }
}

class _EmptyCalendar extends StatelessWidget {
  const _EmptyCalendar();
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today_outlined,
                  color: Color(0xFF7C3AED), size: 64),
              const SizedBox(height: 16),
              Text('No sessions this month',
                  style: TextStyle(color: Colors.grey[400], fontSize: 16)),
            ]),
      );
}

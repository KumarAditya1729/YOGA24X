// ==============================================================================
// Yoga24X AI Engineering OS — Sattvic Luxury Sanctuary Schedule
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/booking_providers.dart';
import '../../domain/models/booking_models.dart';

class UnifiedCalendarScreen extends ConsumerStatefulWidget {
  const UnifiedCalendarScreen({super.key});

  @override
  ConsumerState<UnifiedCalendarScreen> createState() => _UnifiedCalendarScreenState();
}

class _UnifiedCalendarScreenState extends ConsumerState<UnifiedCalendarScreen> {
  DateTime _focusedDate = DateTime.now();

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
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
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildLuxuryHeader(),
            const SizedBox(height: 12),
            _buildMonthSelector(),
            const SizedBox(height: 16),
            Expanded(
              child: calendarAsync.when(
                loading: () => const _LuxuryEmptySchedule(),
                error: (e, _) => const _LuxuryEmptySchedule(),
                data: (data) {
                  final bookings = (data['bookings'] as List?)
                          ?.map((e) =>
                              BookingItem.fromJson(e as Map<String, dynamic>))
                          .toList() ??
                      [];
                  if (bookings.isEmpty) {
                    return const _LuxuryEmptySchedule();
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    itemCount: bookings.length,
                    itemBuilder: (ctx, i) =>
                        _LuxuryBookingTile(booking: bookings[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/booking/flow'),
        backgroundColor: AppTheme.primary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
        label: const Text(
          'Reserve Session',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _buildLuxuryHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Sanctuary Schedule',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Reserved time for breath, movement, and stillness',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: const Icon(Icons.calendar_month_outlined,
                color: AppTheme.secondary, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded,
                  color: Colors.white70, size: 24),
              onPressed: () => setState(() => _focusedDate =
                  DateTime(_focusedDate.year, _focusedDate.month - 1)),
            ),
            Row(
              children: [
                const Icon(Icons.auto_awesome_rounded,
                    color: AppTheme.secondary, size: 14),
                const SizedBox(width: 8),
                Text(
                  '${_months[_focusedDate.month - 1]} ${_focusedDate.year}',
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded,
                  color: Colors.white70, size: 24),
              onPressed: () => setState(() => _focusedDate =
                  DateTime(_focusedDate.year, _focusedDate.month + 1)),
            ),
          ],
        ),
      ),
    );
  }

}

class _LuxuryBookingTile extends StatelessWidget {
  final BookingItem booking;
  const _LuxuryBookingTile({required this.booking});

  Color get _statusColor {
    switch (booking.status) {
      case BookingStatus.confirmed:
        return AppTheme.primary;
      case BookingStatus.cancelled:
        return const Color(0xFFE57373);
      case BookingStatus.completed:
        return AppTheme.secondary;
      case BookingStatus.checkedIn:
        return const Color(0xFF6ECBF5);
      default:
        return AppTheme.secondary;
    }
  }

  String get _statusLabel {
    switch (booking.status) {
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.checkedIn:
        return 'Checked In';
      default:
        return 'Reserved';
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = booking.session;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: _statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _statusLabel,
                      style: TextStyle(
                        color: _statusColor,
                        fontFamily: 'Outfit',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white24, size: 14),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            session?.title ?? 'Prana Sanctuary Masterclass',
            style: const TextStyle(
              fontFamily: 'Outfit',
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          if (session != null)
            Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    color: AppTheme.secondary, size: 16),
                const SizedBox(width: 6),
                Text(
                  '${session.startTime.hour}:${session.startTime.minute.toString().padLeft(2, '0')} – '
                  '${session.endTime.hour}:${session.endTime.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _LuxuryEmptySchedule extends StatelessWidget {
  const _LuxuryEmptySchedule();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppTheme.secondary.withValues(alpha: 0.2), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.secondary.withValues(alpha: 0.05),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.self_improvement_rounded,
                color: AppTheme.secondary,
                size: 56,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Your schedule is clear.',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Allow space for spontaneous stillness today, or reserve an upcoming sanctuary session to guide your prana and nervous system harmony.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.6),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/booking/flow'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.surfaceDark,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                  side: BorderSide(
                      color: AppTheme.primary.withValues(alpha: 0.4), width: 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              ),
              icon: const Icon(Icons.calendar_today_rounded,
                  color: AppTheme.primary, size: 18),
              label: const Text(
                'Browse Session Schedule',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

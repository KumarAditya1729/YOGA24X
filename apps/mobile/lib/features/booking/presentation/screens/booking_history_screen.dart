import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/booking_providers.dart';
import '../../domain/models/booking_models.dart';

class BookingHistoryScreen extends ConsumerStatefulWidget {
  const BookingHistoryScreen({super.key});
  @override
  ConsumerState<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends ConsumerState<BookingHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('My Bookings', style: TextStyle(color: Colors.white)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF7C3AED),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF7C3AED),
          tabs: const [Tab(text: 'Upcoming'), Tab(text: 'Past')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _BookingList(asyncBookings: upcomingBookingsProvider),
          _BookingList(asyncBookings: pastBookingsProvider),
        ],
      ),
    );
  }
}

class _BookingList extends ConsumerWidget {
  final ProviderListenable<AsyncValue<List<BookingItem>>> asyncBookings;
  const _BookingList({required this.asyncBookings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(asyncBookings);
    return asyncData.when(
      loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED))),
      error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
      data: (bookings) => bookings.isEmpty
          ? Center(
              child: Text('No bookings found',
                  style: TextStyle(color: Colors.grey[400], fontSize: 16)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (ctx, i) => _BookingCard(booking: bookings[i]),
            ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingItem booking;
  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final session = booking.session;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2732),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(session?.title ?? 'Session',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 4),
        if (session != null)
          Text(session.startTime.toLocal().toString().split('.')[0],
              style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        const SizedBox(height: 12),
        if (booking.status == BookingStatus.confirmed)
          Row(children: [
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/booking/reschedule',
                  arguments: booking.id),
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF7C3AED))),
              child: const Text('Reschedule',
                  style: TextStyle(color: Color(0xFF7C3AED))),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/booking/cancel',
                  arguments: booking.id),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
          ]),
      ]),
    );
  }
}

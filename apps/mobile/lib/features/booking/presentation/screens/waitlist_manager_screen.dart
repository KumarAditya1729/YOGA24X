import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/booking_providers.dart';
import '../../domain/models/booking_models.dart';

class WaitlistManagerScreen extends ConsumerWidget {
  const WaitlistManagerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waitlistAsync = ref.watch(myWaitlistProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('My Waitlist', style: TextStyle(color: Colors.white)),
      ),
      body: waitlistAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF7C3AED))),
        error: (e, _) =>
            Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
        data: (entries) => entries.isEmpty
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.queue,
                          color: Color(0xFF7C3AED), size: 64),
                      const SizedBox(height: 16),
                      Text('No waitlist entries',
                          style: TextStyle(color: Colors.grey[400], fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('When sessions are full, join the waitlist to get auto-promoted.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    ]))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: entries.length,
                itemBuilder: (ctx, i) =>
                    _WaitlistTile(entry: entries[i], ref: ref),
              ),
      ),
    );
  }
}

class _WaitlistTile extends StatelessWidget {
  final WaitlistEntry entry;
  final WidgetRef ref;
  const _WaitlistTile({required this.entry, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2732),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        CircleAvatar(
          backgroundColor: const Color(0xFF7C3AED),
          child: Text('#${entry.priority}',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(entry.session?.title ?? 'Session',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              if (entry.expiresAt != null)
                Text(
                    'Expires: ${entry.expiresAt!.toLocal().toString().split('.')[0]}',
                    style: TextStyle(color: Colors.orange[300], fontSize: 12)),
            ])),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.red),
          onPressed: () async {
            await ref
                .read(bookingRepositoryProvider)
                .leaveWaitlist(entry.id);
            ref.invalidate(myWaitlistProvider);
          },
        ),
      ]),
    );
  }
}

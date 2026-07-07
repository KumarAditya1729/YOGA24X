import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/booking_providers.dart';

class RescheduleFlowScreen extends ConsumerStatefulWidget {
  final String bookingId;
  const RescheduleFlowScreen({super.key, required this.bookingId});
  @override
  ConsumerState<RescheduleFlowScreen> createState() =>
      _RescheduleFlowScreenState();
}

class _RescheduleFlowScreenState
    extends ConsumerState<RescheduleFlowScreen> {
  final _reasonController = TextEditingController();
  String? _selectedNewSessionId;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('Reschedule Booking',
            style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Select New Session',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
              'Contact your teacher to get a new session ID, or browse available slots.',
              style: TextStyle(color: Colors.grey[400], fontSize: 13)),
          const SizedBox(height: 24),
          const Text('Reason for Rescheduling',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _reasonController,
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Why are you rescheduling?',
              hintStyle: TextStyle(color: Colors.grey[600]),
              filled: true,
              fillColor: const Color(0xFF1E2732),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
            ),
          ),
          const Spacer(),
          if (state.isLoading)
            const Center(
                child: CircularProgressIndicator(color: Color(0xFF7C3AED)))
          else
            ElevatedButton(
              onPressed: _selectedNewSessionId == null
                  ? null
                  : () async {
                      await ref
                          .read(bookingNotifierProvider.notifier)
                          .reschedule(widget.bookingId,
                              _selectedNewSessionId!, _reasonController.text);
                      if (context.mounted) Navigator.pop(context);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Confirm Reschedule',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
        ]),
      ),
    );
  }
}

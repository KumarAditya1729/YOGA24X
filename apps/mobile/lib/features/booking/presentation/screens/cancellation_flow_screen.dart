// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/booking_providers.dart';

class CancellationFlowScreen extends ConsumerStatefulWidget {
  final String bookingId;
  const CancellationFlowScreen({super.key, required this.bookingId});
  @override
  ConsumerState<CancellationFlowScreen> createState() =>
      _CancellationFlowScreenState();
}

class _CancellationFlowScreenState
    extends ConsumerState<CancellationFlowScreen> {
  final _reasonController = TextEditingController();
  String? _selectedReason;

  static const _reasons = [
    'Schedule conflict',
    'Personal emergency',
    'Found another session',
    'Feeling unwell',
    'Teacher request',
    'Other',
  ];

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
        title: const Text('Cancel Booking',
            style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Why are you cancelling?',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(children: [
              ..._reasons.map(
                (r) => RadioListTile<String>(
                  value: r,
                  groupValue: _selectedReason,
                  activeColor: const Color(0xFF7C3AED),
                  title:
                      Text(r, style: const TextStyle(color: Colors.white)),
                  onChanged: (v) => setState(() => _selectedReason = v),
                ),
              ),
              if (_selectedReason == 'Other') ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _reasonController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Please describe your reason...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: const Color(0xFF1E2732),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                  ),
                ),
              ],
            ]),
          ),
          const SizedBox(height: 16),
          if (state.isLoading)
            const Center(
                child: CircularProgressIndicator(color: Color(0xFF7C3AED)))
          else
            ElevatedButton(
              onPressed: _selectedReason == null
                  ? null
                  : () async {
                      final reason = _selectedReason == 'Other'
                          ? _reasonController.text
                          : _selectedReason!;
                      await ref
                          .read(bookingNotifierProvider.notifier)
                          .cancel(widget.bookingId, reason);
                      if (context.mounted) Navigator.pop(context);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Confirm Cancellation',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
        ]),
      ),
    );
  }
}

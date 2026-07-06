import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/booking_providers.dart';
import '../../domain/models/booking_models.dart';

class BookingFlowScreen extends ConsumerStatefulWidget {
  final String? teacherUserId;
  const BookingFlowScreen({Key? key, this.teacherUserId}) : super(key: key);
  @override
  ConsumerState<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends ConsumerState<BookingFlowScreen> {
  int _step = 0;
  AvailableSlot? _selectedSlot;
  final _notesController = TextEditingController();
  @override
  void dispose() { _notesController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingNotifierProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: Text('Book Session – Step ${_step + 1}/3',
            style: const TextStyle(color: Colors.white)),
      ),
      body: IndexedStack(
        index: _step,
        children: [
          _SlotSelectorStep(
            teacherUserId: widget.teacherUserId ?? '',
            onSlotSelected: (slot) => setState(() { _selectedSlot = slot; _step = 1; }),
          ),
          _ConfirmDetailsStep(slot: _selectedSlot, notesController: _notesController),
          _CompletionStep(bookingState: bookingState),
        ],
      ),
      bottomNavigationBar: _step == 1
          ? _BookNowBar(
              slot: _selectedSlot,
              onBook: (slot) async {
                await ref.read(bookingNotifierProvider.notifier)
                    .createBooking(slot.sessionId, notes: _notesController.text);
                setState(() => _step = 2);
              },
            )
          : null,
    );
  }
}

class _SlotSelectorStep extends ConsumerWidget {
  final String teacherUserId;
  final ValueChanged<AvailableSlot> onSlotSelected;
  const _SlotSelectorStep({required this.teacherUserId, required this.onSlotSelected});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final q = SlotQuery(teacherUserId, now.toIso8601String(),
        now.add(const Duration(days: 30)).toIso8601String());
    final slotsAsync = ref.watch(availableSlotsProvider(q));
    return slotsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED))),
      error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
      data: (slots) => slots.isEmpty
          ? const Center(child: Text('No available slots', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: slots.length,
              itemBuilder: (ctx, i) => _SlotCard(slot: slots[i], onTap: () => onSlotSelected(slots[i])),
            ),
    );
  }
}

class _SlotCard extends StatelessWidget {
  final AvailableSlot slot;
  final VoidCallback onTap;
  const _SlotCard({required this.slot, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final isFull = slot.availableSpots <= 0;
    return GestureDetector(
      onTap: isFull ? null : onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2732),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isFull ? Colors.grey : const Color(0xFF7C3AED), width: 1),
        ),
        child: Row(children: [
          Icon(Icons.access_time, color: isFull ? Colors.grey : const Color(0xFF7C3AED)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(slot.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            Text(slot.startTime.toLocal().toString().split('.')[0],
                style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          ])),
          Text(isFull ? 'Full' : '${slot.availableSpots} left',
              style: TextStyle(
                  color: isFull ? Colors.red : const Color(0xFF10B981),
                  fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}

class _ConfirmDetailsStep extends StatelessWidget {
  final AvailableSlot? slot;
  final TextEditingController notesController;
  const _ConfirmDetailsStep({this.slot, required this.notesController});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (slot != null) ...[
        Text(slot!.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Starts: ${slot!.startTime.toLocal().toString().split(".")[0]}',
            style: TextStyle(color: Colors.grey[400])),
        Text('Spots remaining: ${slot!.availableSpots}',
            style: const TextStyle(color: Color(0xFF10B981))),
        const SizedBox(height: 24),
      ],
      TextField(
        controller: notesController,
        maxLines: 3,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Add notes (optional)...',
          hintStyle: TextStyle(color: Colors.grey[600]),
          filled: true, fillColor: const Color(0xFF1E2732),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        ),
      ),
    ]),
  );
}

class _CompletionStep extends StatelessWidget {
  final AsyncValue<dynamic> bookingState;
  const _CompletionStep({required this.bookingState});
  @override
  Widget build(BuildContext context) => bookingState.when(
    loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED))),
    error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
    data: (b) => b != null
        ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.check_circle, color: Color(0xFF10B981), size: 80),
            SizedBox(height: 16),
            Text('Booking Confirmed!', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          ]))
        : const SizedBox.shrink(),
  );
}

class _BookNowBar extends StatelessWidget {
  final AvailableSlot? slot;
  final Function(AvailableSlot) onBook;
  const _BookNowBar({this.slot, required this.onBook});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    color: const Color(0xFF161B22),
    child: ElevatedButton(
      onPressed: slot != null ? () => onBook(slot!) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7C3AED),
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text('Confirm & Book', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    ),
  );
}
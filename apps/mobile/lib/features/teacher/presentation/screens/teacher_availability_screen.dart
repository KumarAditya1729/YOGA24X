import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/teacher_operations_providers.dart';

class TeacherAvailabilityManagerScreen extends ConsumerWidget {
  const TeacherAvailabilityManagerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rulesAsync = ref.watch(teacherBookingRuleProvider);
    final holidaysAsync = ref.watch(teacherHolidaysProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Availability & Booking Rules'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'General Booking Rules',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: rulesAsync.when(
              data: (rule) => _buildRuleCard(context, rule),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Time Off & Holidays',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // Add new holiday
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Time Off'),
                  ),
                ],
              ),
            ),
          ),
          holidaysAsync.when(
            data: (holidays) {
              if (holidays.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No upcoming time off scheduled.'),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final holiday = holidays[index];
                    return ListTile(
                      leading: Icon(
                        holiday.isEmergency ? Icons.warning_amber_rounded : Icons.beach_access,
                        color: holiday.isEmergency ? Colors.orange : Colors.blue,
                      ),
                      title: Text(holiday.reason ?? 'Time Off'),
                      subtitle: Text(
                        '${holiday.startDate.toLocal().toString().split(' ')[0]} - ${holiday.endDate.toLocal().toString().split(' ')[0]}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          // Delete Holiday
                        },
                      ),
                    );
                  },
                  childCount: holidays.length,
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
            error: (e, s) => SliverToBoxAdapter(child: Center(child: Text('Error: $e'))),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard(BuildContext context, dynamic rule) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Advance Booking Window'),
              trailing: Text('${rule.advanceBookingDays} days'),
            ),
            ListTile(
              title: const Text('Minimum Notice'),
              trailing: Text('${rule.minimumNoticeHours} hours'),
            ),
            ListTile(
              title: const Text('Cancellation Window'),
              trailing: Text('${rule.cancellationWindowHours} hours'),
            ),
            SwitchListTile(
              title: const Text('Allow Waitlist'),
              value: rule.allowWaitlist,
              onChanged: (val) {
                // Update waitlist preference
              },
            ),
            SwitchListTile(
              title: const Text('Prevent Overbooking'),
              value: rule.preventOverbooking,
              onChanged: (val) {
                // Update overbooking preference
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Edit rules modal
              },
              child: const Text('Edit Rules'),
            )
          ],
        ),
      ),
    );
  }
}

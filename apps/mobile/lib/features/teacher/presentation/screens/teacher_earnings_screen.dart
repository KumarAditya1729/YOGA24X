import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/teacher_operations_providers.dart';

class TeacherEarningsDashboardScreen extends ConsumerWidget {
  const TeacherEarningsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(teacherWalletBalanceProvider);
    final payoutsAsync = ref.watch(teacherPayoutsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Earnings & Payouts'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: balanceAsync.when(
              data: (balanceData) {
                final balance = balanceData['balanceCents'] as int;
                final currency = balanceData['currency'] as String;
                return Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.green.shade800,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Available Balance',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(balance / 100).toStringAsFixed(2)} $currency',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green.shade800,
                        ),
                        onPressed: balance > 0
                            ? () {
                                // Request payout
                              }
                            : null,
                        child: const Text('Request Payout'),
                      )
                    ],
                  ),
                );
              },
              loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Payout History',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          payoutsAsync.when(
            data: (payouts) {
              if (payouts.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No payouts requested yet.'),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final payout = payouts[index];
                    return ListTile(
                      leading: Icon(
                        payout.status.name == 'PAID' ? Icons.check_circle : Icons.schedule,
                        color: payout.status.name == 'PAID' ? Colors.green : Colors.orange,
                      ),
                      title: Text('${(payout.amountCents / 100).toStringAsFixed(2)} ${payout.currency}'),
                      subtitle: Text(payout.requestedAt.toLocal().toString().split(' ')[0]),
                      trailing: Text(
                        payout.status.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                  childCount: payouts.length,
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
}

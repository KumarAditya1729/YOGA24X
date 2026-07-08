import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentHistoryScreen extends ConsumerWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payments = [
      {
        'title': 'Sattvic Sanctuary VIP Annual Membership',
        'date': 'July 8, 2026 • 11:30 AM',
        'amount': '₹14,999',
        'status': 'SUCCESS',
        'method': 'Apple Pay / UPI',
      },
      {
        'title': '1-on-1 Kundalini Masterclass - Acharya Vidyadhar',
        'date': 'July 2, 2026 • 06:00 PM',
        'amount': '₹2,500',
        'status': 'SUCCESS',
        'method': 'HDFC Credit Card',
      },
      {
        'title': 'Sattvic AI Voice Coach Pro Upgrade',
        'date': 'June 15, 2026 • 09:15 AM',
        'amount': '₹1,200',
        'status': 'SUCCESS',
        'method': 'Google Pay',
      },
      {
        'title': 'Himalayan Retreat Booking Deposit',
        'date': 'May 28, 2026 • 04:45 PM',
        'amount': '₹5,000',
        'status': 'SUCCESS',
        'method': 'UPI / PhonePe',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('Payment History', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: payments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final p = payments[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, color: Colors.greenAccent, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p['title']!,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${p['date']} • ${p['method']}',
                        style: const TextStyle(color: Colors.white54, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      p['amount']!,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      p['status']!,
                      style: const TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

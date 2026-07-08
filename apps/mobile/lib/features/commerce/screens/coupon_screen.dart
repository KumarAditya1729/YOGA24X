import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

class CouponScreen extends ConsumerWidget {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coupons = [
      {
        'code': 'SATTVIC24X',
        'discount': '25% OFF',
        'desc': 'Applicable on all Himalayan Yoga Retreat bookings and Studio Masterclasses.',
        'expires': 'Valid till Dec 31, 2026',
      },
      {
        'code': 'VIPYOGA1000',
        'discount': '₹1,000 OFF',
        'desc': 'Flat discount on 1-on-1 Kundalini & Pranayama private sessions.',
        'expires': 'Valid till Oct 15, 2026',
      },
      {
        'code': 'AIVOICE50',
        'discount': '50% OFF',
        'desc': 'First 3 months of Sattvic AI Voice Coach Pro subscription.',
        'expires': 'Valid till Aug 30, 2026',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('My Coupons & Promos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: coupons.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final c = coupons[index];
          return Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.pinkAccent.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.pinkAccent),
                      ),
                      child: Text(
                        c['discount']!,
                        style: const TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Text(
                      c['expires']!,
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  c['desc']!,
                  style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1117),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        c['code']!,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.5),
                      ),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white10,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: c['code']!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Coupon code ${c['code']} copied to clipboard!')),
                          );
                        },
                        icon: const Icon(Icons.copy, size: 14),
                        label: const Text('Copy', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

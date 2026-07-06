import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CouponScreen extends ConsumerWidget {
  const CouponScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Coupons')),
      body: const Center(
        child: Text('Coupons and Promos coming soon!'),
      ),
    );
  }
}

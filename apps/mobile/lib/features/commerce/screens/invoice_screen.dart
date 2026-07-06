import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvoiceScreen extends ConsumerWidget {
  const InvoiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Invoices')),
      body: const Center(
        child: Text('Invoice history and downloads coming soon!'),
      ),
    );
  }
}

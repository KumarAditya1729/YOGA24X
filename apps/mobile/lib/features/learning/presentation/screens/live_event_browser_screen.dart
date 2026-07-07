
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LiveEventBrowserScreen extends ConsumerWidget {
  const LiveEventBrowserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('LiveEventBrowserScreen')),
      body: const Center(child: Text('LiveEventBrowserScreen UI goes here')),
    );
  }
}

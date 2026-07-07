
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizEngineScreen extends ConsumerWidget {
  const QuizEngineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('QuizEngineScreen')),
      body: const Center(child: Text('QuizEngineScreen UI goes here')),
    );
  }
}

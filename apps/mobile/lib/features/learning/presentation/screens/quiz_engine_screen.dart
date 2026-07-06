
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizEngineScreen extends ConsumerWidget {
  const QuizEngineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('QuizEngineScreen')),
      body: const Center(child: Text('QuizEngineScreen UI goes here')),
    );
  }
}

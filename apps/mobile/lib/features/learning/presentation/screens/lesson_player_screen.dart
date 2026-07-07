
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LessonPlayerScreen extends ConsumerWidget {
  const LessonPlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('LessonPlayerScreen')),
      body: const Center(child: Text('LessonPlayerScreen UI goes here')),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentProgressDashboard extends ConsumerWidget {
  const StudentProgressDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('StudentProgressDashboard')),
      body: const Center(child: Text('StudentProgressDashboard UI goes here')),
    );
  }
}

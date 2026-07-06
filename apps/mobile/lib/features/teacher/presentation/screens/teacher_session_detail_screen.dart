import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherSessionDetailScreen extends ConsumerWidget {
  final String sessionId;
  const TeacherSessionDetailScreen({Key? key, required this.sessionId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Details'),
      ),
      body: const Center(
        child: Text('Session specific details and attendee management goes here.'),
      ),
    );
  }
}

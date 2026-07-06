import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/teacher_operations_providers.dart';

class TeacherStudentRosterScreen extends ConsumerWidget {
  const TeacherStudentRosterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rosterAsync = ref.watch(teacherRosterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Students'),
      ),
      body: rosterAsync.when(
        data: (roster) {
          if (roster.isEmpty) {
            return const Center(child: Text('You have no students in your roster yet.'));
          }
          return ListView.builder(
            itemCount: roster.length,
            itemBuilder: (context, index) {
              final student = roster[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text('Student ID: ${student.studentUserId}'), // Replace with actual name in production
                  subtitle: Text('Total Sessions: ${student.totalSessions}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          student.isFavorite ? Icons.star : Icons.star_border,
                          color: student.isFavorite ? Colors.amber : null,
                        ),
                        onPressed: () {
                          // Toggle favorite
                        },
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () {
                    // Navigate to student details
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

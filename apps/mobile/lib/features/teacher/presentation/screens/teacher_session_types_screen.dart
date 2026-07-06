import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/teacher_operations_providers.dart';

class TeacherSessionTypesManagerScreen extends ConsumerWidget {
  const TeacherSessionTypesManagerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionTypesAsync = ref.watch(teacherSessionTypesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Types'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add session type modal
            },
          ),
        ],
      ),
      body: sessionTypesAsync.when(
        data: (types) {
          if (types.isEmpty) {
            return const Center(child: Text('No session types created yet.'));
          }
          return ListView.builder(
            itemCount: types.length,
            itemBuilder: (context, index) {
              final type = types[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.class_, color: Colors.blueAccent),
                  title: Text(type.title),
                  subtitle: Text(
                    '${type.durationMinutes} mins • ${(type.basePriceCents / 100).toStringAsFixed(2)} ${type.currency} • ${type.format.name}',
                  ),
                  trailing: Switch(
                    value: type.isActive,
                    onChanged: (val) {
                      // Toggle active status
                    },
                  ),
                  onTap: () {
                    // Edit Session Type
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/social_providers.dart';

class GroupsScreen extends ConsumerWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsState = ref.watch(communityGroupsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Groups'),
      ),
      body: groupsState.when(
        data: (groups) {
          if (groups.isEmpty) {
            return const Center(child: Text('No groups available'));
          }
          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.group)),
                title: Text(group.name),
                subtitle: Text('${group.memberCount} members · ${group.groupType}'),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Join group logic
                  },
                  child: const Text('Join'),
                ),
                onTap: () {
                  // Navigate to group detail feed
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

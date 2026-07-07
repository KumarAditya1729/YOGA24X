import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/social_providers.dart';

class CommunityFeedScreen extends ConsumerWidget {
  const CommunityFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(globalFeedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group),
            onPressed: () {
              // Navigate to groups
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to post composer
            },
          ),
        ],
      ),
      body: feedState.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(child: Text('No posts yet!'));
          }
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(child: Icon(Icons.person)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('User ${post.authorId}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(post.createdAt.toString(), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ),
                          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (post.title != null) Text(post.title!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      if (post.contentText != null) ...[
                        const SizedBox(height: 8),
                        Text(post.contentText!),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          IconButton(icon: const Icon(Icons.thumb_up_alt_outlined), onPressed: () {}),
                          Text('${post.likesCount}'),
                          const SizedBox(width: 16),
                          IconButton(icon: const Icon(Icons.comment_outlined), onPressed: () {}),
                          Text('${post.commentsCount}'),
                        ],
                      )
                    ],
                  ),
                ),
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

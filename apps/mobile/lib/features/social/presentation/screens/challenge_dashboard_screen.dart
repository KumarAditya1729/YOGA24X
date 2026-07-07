import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/social_providers.dart';

class ChallengeDashboardScreen extends ConsumerWidget {
  const ChallengeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengesState = ref.watch(activeChallengesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenges & Leaderboards'),
      ),
      body: challengesState.when(
        data: (challenges) {
          if (challenges.isEmpty) {
            return const Center(child: Text('No active challenges'));
          }
          return ListView.builder(
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              final challenge = challenges[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(challenge.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Type: ${challenge.challengeType}'),
                      if (challenge.description != null) ...[
                        const SizedBox(height: 8),
                        Text(challenge.description!),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Reward: ${challenge.rewardsXp} XP', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          ElevatedButton(
                            onPressed: () {
                              // Join challenge
                            },
                            child: const Text('Join Challenge'),
                          )
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

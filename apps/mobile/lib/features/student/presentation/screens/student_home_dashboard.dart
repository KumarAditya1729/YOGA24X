import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/student_providers.dart';

class StudentHomeDashboard extends ConsumerWidget {
  const StudentHomeDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(studentDashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Navigate to profile
            },
          ),
        ],
      ),
      body: dashboardState.when(
        data: (data) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text('Welcome back!', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Today's Wellness", style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      if (data.todaysWellness == null)
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to health timeline checkin
                          },
                          child: const Text('Log Daily Check-in'),
                        )
                      else
                        const Text('You have already logged your wellness today!'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Recent Achievements', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      if (data.recentAchievements.isEmpty)
                        const Text('Complete classes to earn achievements.')
                      else
                        ...data.recentAchievements.map((achievement) => ListTile(
                          leading: const Icon(Icons.star, color: Colors.amber),
                          title: Text(achievement.title),
                          subtitle: Text('XP: ${achievement.xpEarned}'),
                        )),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

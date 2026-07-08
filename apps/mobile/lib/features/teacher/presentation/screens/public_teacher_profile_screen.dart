import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/teacher_providers.dart';
import '../../../../features/booking/presentation/screens/booking_flow_screen.dart';

class PublicTeacherProfileScreen extends ConsumerWidget {
  final String userId;

  const PublicTeacherProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(publicTeacherProfileProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing link copied!')),
              );
            },
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading profile: $err')),
        data: (profile) {
          const name = 'Acharya Vidyadhar';
          final headline = profile.headline ?? 'RYT 500 Yoga Specialist';
          final rating = profile.stats?.averageRating ?? 4.98;
          final reviews = profile.stats?.totalReviews ?? 342;
          final location = profile.cityState ?? 'Rishikesh, India';
          final bio = profile.bio ?? 'Experienced yoga instructor dedicated to holistic wellness, alignment, and mindfulness.';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.self_improvement, size: 80, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (profile.verificationStatus == 'VERIFIED')
                            const Icon(Icons.verified, color: Colors.blue, size: 28),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        headline,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 22),
                          const SizedBox(width: 4),
                          Text('$rating ($reviews reviews)', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 20),
                          const Icon(Icons.location_on, size: 20, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(location),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text('About Instructor', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        bio,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BookingFlowScreen(teacherUserId: userId),
                              ),
                            );
                          },
                          icon: const Icon(Icons.calendar_month),
                          label: const Text('Book a Class', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

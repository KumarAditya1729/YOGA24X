import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Note: In a real app, you'd fetch the profile by ID. 
// For this stub, we just accept a userId and show a placeholder UI.
class PublicTeacherProfileScreen extends ConsumerWidget {
  final String userId;

  const PublicTeacherProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Image/Video Placeholder
            Container(
              height: 200,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: const Center(
                child: Icon(Icons.play_circle_outline, size: 64, color: Colors.white),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'John Doe',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const Icon(Icons.verified, color: Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'RYT 500 Vinyasa Specialist',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Stats Row
                  const Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 4),
                      Text('4.9 (120 reviews)'),
                      SizedBox(width: 16),
                      Icon(Icons.location_on, size: 20),
                      SizedBox(width: 4),
                      Text('New York, USA'),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  Text('About Me', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  const Text(
                    'I have been practicing and teaching yoga for over 10 years. My classes focus on alignment, breath, and mindfulness. I believe yoga is for everyone and strive to make my classes accessible to all levels.',
                  ),
                  
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Booking Flow Coming Soon')),
                        );
                      },
                      child: const Text('Book a Class'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: unused_field
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HealthWellnessTimelineScreen extends ConsumerStatefulWidget {
  const HealthWellnessTimelineScreen({super.key});

  @override
  ConsumerState<HealthWellnessTimelineScreen> createState() => _HealthWellnessTimelineScreenState();
}

class _HealthWellnessTimelineScreenState extends ConsumerState<HealthWellnessTimelineScreen> {
  double _moodScore = 5;
  double _painLevel = 1;
  double _sleepHours = 7;
  final double _waterIntake = 2000;
  double _energyScore = 5;

  void _submitCheckin() {
    // Send data to repository provider
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Wellness logged successfully!')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Wellness Check-in'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How are you feeling today?', style: Theme.of(context).textTheme.titleLarge),
            Slider(
              value: _moodScore,
              min: 1,
              max: 10,
              divisions: 9,
              label: _moodScore.round().toString(),
              onChanged: (val) => setState(() => _moodScore = val),
            ),
            const SizedBox(height: 20),
            Text('Energy Level (1-10)', style: Theme.of(context).textTheme.titleLarge),
            Slider(
              value: _energyScore,
              min: 1,
              max: 10,
              divisions: 9,
              label: _energyScore.round().toString(),
              onChanged: (val) => setState(() => _energyScore = val),
            ),
            const SizedBox(height: 20),
            Text('Pain Level (1-10)', style: Theme.of(context).textTheme.titleLarge),
            Slider(
              value: _painLevel,
              min: 1,
              max: 10,
              divisions: 9,
              label: _painLevel.round().toString(),
              onChanged: (val) => setState(() => _painLevel = val),
            ),
            const SizedBox(height: 20),
            Text('Hours of Sleep', style: Theme.of(context).textTheme.titleLarge),
            Slider(
              value: _sleepHours,
              min: 0,
              max: 12,
              divisions: 12,
              label: _sleepHours.round().toString(),
              onChanged: (val) => setState(() => _sleepHours = val),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _submitCheckin,
                child: const Text('Save Check-in'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

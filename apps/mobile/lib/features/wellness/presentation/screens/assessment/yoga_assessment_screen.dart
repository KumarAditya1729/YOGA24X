// ==============================================================================
// Yoga24X AI Engineering OS — Yoga Assessment Screen
// Customizes Goals, Experience Level, Preferred Styles, Practice Time & Teachers
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/assessment_provider.dart';

class YogaAssessmentScreen extends ConsumerStatefulWidget {
  const YogaAssessmentScreen({super.key});

  @override
  ConsumerState<YogaAssessmentScreen> createState() => _YogaAssessmentScreenState();
}

class _YogaAssessmentScreenState extends ConsumerState<YogaAssessmentScreen> {
  String _experienceLevel = 'INTERMEDIATE';
  String _preferredStyle = 'HATHA';
  String _practiceTime = 'MORNING';
  String _instructorGender = 'ANY';
  double _sessionLength = 45.0;
  double _frequencyPerWeek = 4.0;

  final List<String> _selectedGoals = ['Flexibility', 'Spinal Relief', 'Mindfulness'];
  final List<String> _allGoals = [
    'Flexibility',
    'Strength',
    'Spinal Relief',
    'Weight Loss',
    'Mindfulness',
    'Chakra Balance',
    'Core Power',
    'Stress Reduction'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSubmitting = ref.watch(assessmentNotifierProvider).isSubmitting;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yoga Practice Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('1. Experience & Proficiency', Icons.self_improvement),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: ['BEGINNER', 'INTERMEDIATE', 'ADVANCED', 'GURU'].map((lvl) {
                final isSelected = _experienceLevel == lvl;
                return ChoiceChip(
                  label: Text(lvl),
                  selected: isSelected,
                  selectedColor: theme.colorScheme.primaryContainer,
                  onSelected: (val) => setState(() => _experienceLevel = lvl),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('2. Practice Goals (Select up to 4)', Icons.flag_outlined),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _allGoals.map((goal) {
                final isSelected = _selectedGoals.contains(goal);
                return FilterChip(
                  label: Text(goal),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected && _selectedGoals.length < 4) {
                        _selectedGoals.add(goal);
                      } else {
                        _selectedGoals.remove(goal);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('3. Preferred Yoga Lineage & Style', Icons.spa_outlined),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _preferredStyle,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'HATHA', child: Text('Hatha Yoga (Traditional & Classical)')),
                DropdownMenuItem(value: 'VINYASA', child: Text('Vinyasa Flow (Dynamic & Continuous)')),
                DropdownMenuItem(value: 'ASHTANGA', child: Text('Ashtanga Vinyasa (Rigorous & Athletic)')),
                DropdownMenuItem(value: 'YIN', child: Text('Yin Yoga (Deep Fascial Stretch)')),
                DropdownMenuItem(value: 'KUNDALINI', child: Text('Kundalini (Energy & Breathwork)')),
                DropdownMenuItem(value: 'POWER', child: Text('Power Yoga (Fitness Focused)')),
              ],
              onChanged: (v) => setState(() => _preferredStyle = v ?? 'HATHA'),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('4. Scheduling & Duration Preferences', Icons.schedule),
            const SizedBox(height: 12),
            Text('Preferred Session Length: ${_sessionLength.toInt()} Minutes', style: const TextStyle(fontWeight: FontWeight.w600)),
            Slider(
              value: _sessionLength,
              min: 15,
              max: 90,
              divisions: 5,
              label: '${_sessionLength.toInt()} min',
              onChanged: (v) => setState(() => _sessionLength = v),
            ),
            const SizedBox(height: 8),
            Text('Practice Frequency: ${_frequencyPerWeek.toInt()} Days / Week', style: const TextStyle(fontWeight: FontWeight.w600)),
            Slider(
              value: _frequencyPerWeek,
              min: 1,
              max: 7,
              divisions: 6,
              label: '${_frequencyPerWeek.toInt()} days',
              onChanged: (v) => setState(() => _frequencyPerWeek = v),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _practiceTime,
              decoration: const InputDecoration(labelText: 'Ideal Time of Day', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'MORNING', child: Text('Brahma Muhurta / Morning (5 AM - 8 AM)')),
                DropdownMenuItem(value: 'AFTERNOON', child: Text('Mid-Day Recharge (12 PM - 2 PM)')),
                DropdownMenuItem(value: 'EVENING', child: Text('Sunset / Evening Flow (5 PM - 8 PM)')),
                DropdownMenuItem(value: 'NIGHT', child: Text('Wind-down / Nidra (9 PM - 11 PM)')),
              ],
              onChanged: (v) => setState(() => _practiceTime = v ?? 'MORNING'),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('5. Teacher Preferences', Icons.person_outline),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _instructorGender,
              decoration: const InputDecoration(labelText: 'Preferred Instructor Voice/Gender', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'ANY', child: Text('No Preference / Mixed')),
                DropdownMenuItem(value: 'FEMALE', child: Text('Female Instructors Only')),
                DropdownMenuItem(value: 'MALE', child: Text('Male Instructors Only')),
              ],
              onChanged: (v) => setState(() => _instructorGender = v ?? 'ANY'),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isSubmitting ? null : _saveYogaProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.check),
                label: const Text('Save Yoga Preferences', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6750A4)),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _saveYogaProfile() async {
    final success = await ref.read(assessmentNotifierProvider.notifier).saveYogaAssessment({
      'experienceLevel': _experienceLevel,
      'yogaGoals': _selectedGoals,
      'preferredYogaStyle': _preferredStyle,
      'preferredSessionLengthMin': _sessionLength.toInt(),
      'preferredInstructorGender': _instructorGender,
      'practiceFrequencyPerWeek': _frequencyPerWeek.toInt(),
      'favoriteTeachers': ['Acharya Vidyasagar', 'Dr. Ananya Vaidya'],
      'favoriteCourses': ['Hatha Foundation', 'Spinal Decompression Mastery'],
      'favoriteMusic': ['Ambient Drone', 'Sitar & Tabla Classical'],
      'preferredPracticeTime': _practiceTime,
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Yoga practice preferences updated successfully!')));
      Navigator.pop(context);
    }
  }
}

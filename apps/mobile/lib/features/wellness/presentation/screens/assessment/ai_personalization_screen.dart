// ==============================================================================
// Yoga24X AI Engineering OS — AI Coaching & Personalization Profile Screen
// Customizes Coaching Persona, Reminder Tone, Language, and Difficulty Progression
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/assessment_provider.dart';

class AiPersonalizationScreen extends ConsumerStatefulWidget {
  const AiPersonalizationScreen({super.key});

  @override
  ConsumerState<AiPersonalizationScreen> createState() => _AiPersonalizationScreenState();
}

class _AiPersonalizationScreenState extends ConsumerState<AiPersonalizationScreen> {
  String _coachingStyle = 'GENTLE_GUIDE';
  String _reminderStyle = 'SMART_ADAPTIVE';
  String _motivationStyle = 'PHILOSOPHICAL';
  String _preferredLanguage = 'en';
  String _difficultyProgression = 'ADAPTIVE';
  String _learningStyle = 'VISUAL_DEMO';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSubmitting = ref.watch(assessmentNotifierProvider).isSubmitting;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Coach Customization', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('1. AI Coaching Persona', Icons.auto_awesome),
            const SizedBox(height: 12),
            _buildRadioTile('GENTLE_GUIDE', 'Gentle & Nurturing Guide', 'Emphasizes self-love, patience, and restorative breathwork.'),
            _buildRadioTile('DISCIPLINED_YOGI', 'Disciplined Traditional Yogi', 'Strict adherence to alignment, hold times, and classical tapas.'),
            _buildRadioTile('SPIRITUAL_MENTOR', 'Spiritual & Philosophical Mentor', 'Integrates Sutras, Chakras, and deeper yogic wisdom into practice.'),
            _buildRadioTile('SCIENTIFIC_COACH', 'Biomechanics & Science Coach', 'Focuses on anatomy, neurology, heart-rate variability, and physiology.'),
            const SizedBox(height: 24),
            _buildSectionHeader('2. Motivation & Feedback Tone', Icons.psychology),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _motivationStyle,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'ENCOURAGING', child: Text('Encouraging & Positive Reinforcement')),
                DropdownMenuItem(value: 'GOAL_DRIVEN', child: Text('Goal-Driven & Milestone Focused')),
                DropdownMenuItem(value: 'PHILOSOPHICAL', child: Text('Philosophical & Mindful Reflection')),
                DropdownMenuItem(value: 'ENERGETIC', child: Text('High Energy & Dynamic Cheerleading')),
              ],
              onChanged: (v) => setState(() => _motivationStyle = v ?? 'PHILOSOPHICAL'),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('3. Smart Reminder & Nudge Strategy', Icons.notifications_active_outlined),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _reminderStyle,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'SMART_ADAPTIVE', child: Text('Smart Adaptive (Learns your habits)')),
                DropdownMenuItem(value: 'DAILY_MORNING', child: Text('Daily Morning Nudge (6:00 AM)')),
                DropdownMenuItem(value: 'EVENING_REFLECTION', child: Text('Evening Reflection & Wind-down')),
                DropdownMenuItem(value: 'GENTLE_NUDGE', child: Text('Gentle Low-Frequency Nudges')),
              ],
              onChanged: (v) => setState(() => _reminderStyle = v ?? 'SMART_ADAPTIVE'),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('4. Practice Progression & Learning', Icons.trending_up),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _difficultyProgression,
              decoration: const InputDecoration(labelText: 'Difficulty Progression Rate', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'ADAPTIVE', child: Text('AI Adaptive (Based on daily readiness score)')),
                DropdownMenuItem(value: 'CONSERVATIVE', child: Text('Conservative (Slow & steady progression)')),
                DropdownMenuItem(value: 'CHALLENGING', child: Text('Challenging (Push physical boundaries)')),
              ],
              onChanged: (v) => setState(() => _difficultyProgression = v ?? 'ADAPTIVE'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _learningStyle,
              decoration: const InputDecoration(labelText: 'Primary Learning Preference', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'VISUAL_DEMO', child: Text('Visual 3D Demo & Video Cues')),
                DropdownMenuItem(value: 'VERBAL_CUE_HEAVY', child: Text('Detailed Verbal Alignment Cues')),
                DropdownMenuItem(value: 'ANATOMICAL_FOCUS', child: Text('Anatomical Muscle Engagement Focus')),
              ],
              onChanged: (v) => setState(() => _learningStyle = v ?? 'VISUAL_DEMO'),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('5. Preferred Language', Icons.language),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _preferredLanguage,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English (US / Global)')),
                DropdownMenuItem(value: 'hi', child: Text('Hindi (हिन्दी)')),
                DropdownMenuItem(value: 'sa', child: Text('Sanskrit Terminology Focus (संस्कृतम्)')),
                DropdownMenuItem(value: 'es', child: Text('Spanish (Español)')),
              ],
              onChanged: (v) => setState(() => _preferredLanguage = v ?? 'en'),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isSubmitting ? null : _saveAiProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6750A4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.check),
                label: const Text('Save AI Customization', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6750A4)),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildRadioTile(String value, String title, String subtitle) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: _coachingStyle == value ? BorderSide(color: const Color(0xFF6750A4), width: 2) : BorderSide.none,
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: _coachingStyle,
        activeColor: const Color(0xFF6750A4),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        onChanged: (val) => setState(() => _coachingStyle = val!),
      ),
    );
  }

  void _saveAiProfile() async {
    final success = await ref.read(assessmentNotifierProvider.notifier).saveAiPersonalization({
      'coachingStyle': _coachingStyle,
      'reminderStyle': _reminderStyle,
      'motivationStyle': _motivationStyle,
      'preferredLanguage': _preferredLanguage,
      'preferredVoiceName': 'Aria_Calm_V2',
      'difficultyProgression': _difficultyProgression,
      'learningStyle': _learningStyle,
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('AI Coach profile customized successfully!')));
      Navigator.pop(context);
    }
  }
}

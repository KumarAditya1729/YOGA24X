// ==============================================================================
// Yoga24X AI Engineering OS — Meditation & Breathwork Profile Screen
// Configures Experience Level, Voice Preferences, Music & Practice Focus
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/assessment_provider.dart';

class MeditationProfileScreen extends ConsumerStatefulWidget {
  const MeditationProfileScreen({super.key});

  @override
  ConsumerState<MeditationProfileScreen> createState() => _MeditationProfileScreenState();
}

class _MeditationProfileScreenState extends ConsumerState<MeditationProfileScreen> {
  String _experienceLevel = 'INTERMEDIATE';
  String _voicePreference = 'CALM_FEMALE';
  String _musicPreference = 'TIBETAN_SINGING_BOWLS';
  double _sessionDuration = 20.0;

  final List<String> _selectedFocus = ['Stress Reduction', 'Deep Concentration', 'Better Sleep'];
  final List<String> _allFocusOptions = [
    'Stress Reduction',
    'Anxiety Relief',
    'Better Sleep',
    'Deep Concentration',
    'Chakra Balancing',
    'Emotional Healing',
    'Gratitude & Joy',
    'Pain Management'
  ];

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(assessmentNotifierProvider).isSubmitting;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation & Breathwork', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('1. Meditation Experience', Icons.self_improvement),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: ['BEGINNER', 'INTERMEDIATE', 'ADVANCED', 'ZEN_MASTER'].map((lvl) {
                final isSelected = _experienceLevel == lvl;
                return ChoiceChip(
                  label: Text(lvl.replaceAll('_', ' ')),
                  selected: isSelected,
                  selectedColor: Colors.indigo.shade100,
                  onSelected: (val) => setState(() => _experienceLevel = lvl),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('2. Primary Meditation Focus', Icons.psychology_outlined),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allFocusOptions.map((focus) {
                final isSelected = _selectedFocus.contains(focus);
                return FilterChip(
                  label: Text(focus),
                  selected: isSelected,
                  selectedColor: Colors.indigo.shade100,
                  checkmarkColor: Colors.indigo.shade800,
                  onSelected: (selected) {
                    setState(() {
                      if (selected && _selectedFocus.length < 5) {
                        _selectedFocus.add(focus);
                      } else {
                        _selectedFocus.remove(focus);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('3. Guided Voice Preference', Icons.record_voice_over_outlined),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _voicePreference,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'CALM_FEMALE', child: Text('Calm & Serene Female Voice')),
                DropdownMenuItem(value: 'DEEP_MALE', child: Text('Deep & Grounded Male Voice')),
                DropdownMenuItem(value: 'WARM_NEUTRAL', child: Text('Warm & Neutral Guide')),
                DropdownMenuItem(value: 'SOFT_WHISPER', child: Text('Soft Whisper ASMR Style')),
                DropdownMenuItem(value: 'NO_VOICE_INSTRUMENTAL', child: Text('No Voice / Instrumental Only')),
              ],
              onChanged: (v) => setState(() => _voicePreference = v ?? 'CALM_FEMALE'),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('4. Background Soundscapes & Music', Icons.music_note_outlined),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _musicPreference,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'TIBETAN_SINGING_BOWLS', child: Text('Tibetan Singing Bowls & Bells')),
                DropdownMenuItem(value: 'NATURE_SOUNDS', child: Text('Rain forest, Ocean Waves & Birds')),
                DropdownMenuItem(value: 'AMBIENT_DRONE', child: Text('432Hz Ambient Cosmic Drone')),
                DropdownMenuItem(value: 'CLASSICAL_INDIAN_RAGA', child: Text('Classical Indian Bansuri & Tanpura')),
                DropdownMenuItem(value: 'SILENCE', child: Text('Pure Silence / No Background Music')),
              ],
              onChanged: (v) => setState(() => _musicPreference = v ?? 'TIBETAN_SINGING_BOWLS'),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('5. Ideal Session Length', Icons.timer_outlined),
            const SizedBox(height: 12),
            Text('Duration: ${_sessionDuration.toInt()} Minutes', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            Slider(
              value: _sessionDuration,
              min: 5,
              max: 60,
              divisions: 11,
              activeColor: Colors.indigo,
              label: '${_sessionDuration.toInt()} min',
              onChanged: (v) => setState(() => _sessionDuration = v),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isSubmitting ? null : _saveMeditationProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.check),
                label: const Text('Save Meditation Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        Icon(icon, color: Colors.indigo),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _saveMeditationProfile() async {
    final success = await ref.read(assessmentNotifierProvider.notifier).saveMeditationProfile({
      'experienceLevel': _experienceLevel,
      'preferredVoice': _voicePreference,
      'preferredMusic': _musicPreference,
      'preferredDurationMin': _sessionDuration.toInt(),
      'focusAreas': _selectedFocus,
      'meditationGoals': ['Calm Mind', 'Deep Breathwork Mastery', 'Chakra Awakening'],
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Meditation profile updated successfully!')));
      Navigator.pop(context);
    }
  }
}

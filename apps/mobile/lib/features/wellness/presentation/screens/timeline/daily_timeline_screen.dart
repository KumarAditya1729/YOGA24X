// ==============================================================================
// Yoga24X AI Engineering OS — Daily Wellness Timeline Screen
// Tracks Mood, Pain, Stress, Weight, Water Intake, Practice Minutes & AI Sentiment
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoga24x_mobile/features/wellness/domain/models/wellness_models.dart';
import '../../providers/timeline_provider.dart';

class DailyTimelineScreen extends ConsumerStatefulWidget {
  const DailyTimelineScreen({super.key});

  @override
  ConsumerState<DailyTimelineScreen> createState() => _DailyTimelineScreenState();
}

class _DailyTimelineScreenState extends ConsumerState<DailyTimelineScreen> {
  String _selectedMood = 'CALM';
  double _painScore = 2.0;
  double _stressScore = 3.0;
  final double _weightKg = 68.0;
  int _waterIntakeMl = 1750;
  final int _yogaMinutes = 45;
  final int _meditationMinutes = 20;
  final int _sleepMinutes = 450; // 7.5 hours
  final TextEditingController _journalController = TextEditingController();

  final List<Map<String, dynamic>> _moods = [
    {'id': 'CALM', 'label': 'Calm', 'icon': Icons.spa, 'color': Colors.teal},
    {'id': 'ENERGETIC', 'label': 'Energetic', 'icon': Icons.bolt, 'color': Colors.amber},
    {'id': 'PEACEFUL', 'label': 'Peaceful', 'icon': Icons.self_improvement, 'color': Colors.indigo},
    {'id': 'ANXIOUS', 'label': 'Anxious', 'icon': Icons.waves, 'color': Colors.orange},
    {'id': 'FATIGUED', 'label': 'Fatigued', 'icon': Icons.battery_alert, 'color': Colors.red},
    {'id': 'FOCUSED', 'label': 'Focused', 'icon': Icons.center_focus_strong, 'color': Colors.blue},
  ];

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(timelineNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Wellness Timeline', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: state.status == TimelineStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuickLogCard(theme, state.isLogging),
                  const SizedBox(height: 24),
                  const Text('Recent Timeline Logs', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (state.logs.isEmpty)
                    _buildEmptyLogs()
                  else
                    ...state.logs.map((log) => _buildLogItemCard(log, theme)),
                ],
              ),
            ),
    );
  }

  Widget _buildQuickLogCard(ThemeData theme, bool isLogging) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.edit_calendar, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                const Text('Log Today\'s Check-in', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            const Text('How is your mood right now?', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _moods.map((m) {
                  final isSelected = _selectedMood == m['id'];
                  final color = m['color'] as Color;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      avatar: Icon(m['icon'] as IconData, color: isSelected ? Colors.white : color, size: 18),
                      label: Text(m['label'] as String),
                      selected: isSelected,
                      selectedColor: color,
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
                      onSelected: (val) => setState(() => _selectedMood = m['id'] as String),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            _buildSliderRow('Physical Pain Score', _painScore, 1, 10, (v) => setState(() => _painScore = v), Colors.red),
            _buildSliderRow('Mental Stress Score', _stressScore, 1, 10, (v) => setState(() => _stressScore = v), Colors.orange),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Water Intake Today:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.blue),
                      onPressed: () => setState(() => _waterIntakeMl = (_waterIntakeMl - 250).clamp(0, 5000)),
                    ),
                    Text('$_waterIntakeMl ml', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.blue),
                      onPressed: () => setState(() => _waterIntakeMl = (_waterIntakeMl + 250).clamp(0, 5000)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Yoga: $_yogaMinutes min', style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('Meditation: $_meditationMinutes min', style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('Sleep: ${(_sleepMinutes / 60).toStringAsFixed(1)} hrs', style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _journalController,
              decoration: const InputDecoration(
                labelText: 'Daily Reflection / Journal Note',
                hintText: 'How did your practice feel today?',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.book_outlined),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: isLogging ? null : _submitLog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: isLogging ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.check),
                label: const Text('Save Daily Check-in', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderRow(String label, double val, double min, double max, ValueChanged<double> onChanged, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14)),
            Text(val.toInt().toString(), style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
          ],
        ),
        Slider(
          value: val,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          activeColor: color,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildLogItemCard(WellnessTimelineLog log, ThemeData theme) {
    final dateStr = '${log.date.year}-${log.date.month.toString().padLeft(2, "0")}-${log.date.day.toString().padLeft(2, "0")}';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(Icons.calendar_today, color: theme.colorScheme.primary, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Text(dateStr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                Chip(
                  label: Text(log.mood ?? 'CALM', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  backgroundColor: Colors.teal.shade50,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatBadge(Icons.self_improvement, '${log.yogaMinutesLogged}m Yoga'),
                _buildStatBadge(Icons.spa, '${log.meditationMinutesLogged}m Medit'),
                _buildStatBadge(Icons.water_drop, '${log.waterIntakeMl} ml'),
                _buildStatBadge(Icons.bedtime, '${(log.sleepMinutes / 60).toStringAsFixed(1)}h Sleep'),
              ],
            ),
            if (log.journalNote != null && log.journalNote!.isNotEmpty) ...[
              const Divider(height: 24),
              Text('"${log.journalNote}"', style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black87)),
              if (log.aiSentimentTag != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.auto_awesome, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('AI Sentiment: ${log.aiSentimentTag}', style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade700),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildEmptyLogs() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.history_toggle_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text('No Timeline Logs Found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Text('Log your first check-in above to start tracking your daily progress!', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  void _submitLog() async {
    final success = await ref.read(timelineNotifierProvider.notifier).logDailyEntry({
      'date': DateTime.now().toIso8601String(),
      'mood': _selectedMood,
      'painScore': _painScore.toInt(),
      'stressScore': _stressScore.toInt(),
      'weightKg': _weightKg,
      'waterIntakeMl': _waterIntakeMl,
      'yogaMinutesLogged': _yogaMinutes,
      'meditationMinutesLogged': _meditationMinutes,
      'sleepMinutes': _sleepMinutes,
      'journalNote': _journalController.text,
      'aiSentimentTag': 'POSITIVE_GROWTH',
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Daily wellness check-in logged!')));
      _journalController.clear();
    }
  }
}

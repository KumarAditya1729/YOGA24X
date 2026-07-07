import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/teacher_providers.dart';

class PreferencesSettingsScreen extends ConsumerStatefulWidget {
  const PreferencesSettingsScreen({super.key});

  @override
  ConsumerState<PreferencesSettingsScreen> createState() => _PreferencesSettingsScreenState();
}

class _PreferencesSettingsScreenState extends ConsumerState<PreferencesSettingsScreen> {
  final List<String> _selectedModes = [];
  bool _onlineOnly = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(teacherProfileControllerProvider).valueOrNull;
    if (profile?.teachingPreference != null) {
      _selectedModes.addAll(profile!.teachingPreference!.teachingModes);
      _onlineOnly = profile.teachingPreference!.onlineOnly;
    }
  }

  void _toggleMode(String mode) {
    setState(() {
      if (_selectedModes.contains(mode)) {
        _selectedModes.remove(mode);
      } else {
        _selectedModes.add(mode);
      }
    });
  }

  void _savePreferences() {
    // Save logic stubbed
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferences saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teaching Preferences'),
        actions: [
          TextButton(
            onPressed: _savePreferences,
            child: const Text('SAVE'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('Teaching Modes', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildModeChip('IN_PERSON_STUDIO', 'Studio'),
              _buildModeChip('IN_PERSON_PRIVATE', 'Private (In-Person)'),
              _buildModeChip('ONLINE_LIVE', 'Online Live'),
              _buildModeChip('RETREAT', 'Retreat'),
            ],
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: const Text('Online Only'),
            subtitle: const Text('Only accept online students'),
            value: _onlineOnly,
            onChanged: (val) => setState(() => _onlineOnly = val),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _savePreferences,
              child: const Text('Save Preferences'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeChip(String value, String label) {
    final selected = _selectedModes.contains(value);
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => _toggleMode(value),
    );
  }
}

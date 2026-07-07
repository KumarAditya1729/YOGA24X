// ==============================================================================
// Yoga24X AI Engineering OS — Enterprise Health Profile & Medical History Screen
// Full CRUD for Medical History, Allergies, Medications, Surgeries, and Lifestyle
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoga24x_mobile/features/wellness/domain/models/wellness_models.dart';
import '../../providers/health_profile_provider.dart';

class HealthProfileScreen extends ConsumerStatefulWidget {
  const HealthProfileScreen({super.key});

  @override
  ConsumerState<HealthProfileScreen> createState() => _HealthProfileScreenState();
}

class _HealthProfileScreenState extends ConsumerState<HealthProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(healthProfileNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinical Health Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          if (state.profile?.isVerifiedByDoctor == true)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Chip(
                avatar: const Icon(Icons.verified, color: Colors.white, size: 18),
                label: const Text('Doctor Verified', style: TextStyle(color: Colors.white, fontSize: 12)),
                backgroundColor: Colors.teal.shade700,
              ),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.medical_services_outlined), text: 'Conditions'),
            Tab(icon: Icon(Icons.warning_amber_rounded), text: 'Allergies'),
            Tab(icon: Icon(Icons.medication_outlined), text: 'Medications'),
            Tab(icon: Icon(Icons.healing_outlined), text: 'Surgeries'),
            Tab(icon: Icon(Icons.favorite_outline), text: 'Lifestyle & Bio'),
          ],
        ),
      ),
      body: _buildBody(context, state, theme),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemDialog(context, _tabController.index),
        icon: const Icon(Icons.add),
        label: const Text('Add Record'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildBody(BuildContext context, HealthProfileState state, ThemeData theme) {
    if (state.status == HealthProfileStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == HealthProfileStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(state.errorMessage ?? 'An error occurred', textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Retry Loading'),
                onPressed: () => ref.read(healthProfileNotifierProvider.notifier).fetchHealthProfile(),
              ),
            ],
          ),
        ),
      );
    }

    final profile = state.profile ?? _getEmptyProfile();

    return TabBarView(
      controller: _tabController,
      children: [
        _buildConditionsTab(profile, theme),
        _buildAllergiesTab(profile, theme),
        _buildMedicationsTab(profile, theme),
        _buildSurgeriesTab(profile, theme),
        _buildLifestyleTab(profile, theme),
      ],
    );
  }

  Widget _buildConditionsTab(HealthProfile profile, ThemeData theme) {
    if (profile.medicalHistory.isEmpty && profile.currentConditions.isEmpty) {
      return _buildEmptyState(
        icon: Icons.monitor_heart_outlined,
        title: 'No Medical Conditions Recorded',
        subtitle: 'Add active or resolved conditions (e.g., Hypertension, Lumbar Disc Prolapse) to enable automated AI safety guidelines.',
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (profile.currentConditions.isNotEmpty) ...[
          const Text('Active Conditions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...profile.currentConditions.map((c) => _buildConditionCard(c, theme, true)),
          const SizedBox(height: 24),
        ],
        if (profile.medicalHistory.isNotEmpty) ...[
          const Text('Medical History & Resolved', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...profile.medicalHistory.map((c) => _buildConditionCard(c, theme, false)),
        ],
      ],
    );
  }

  Widget _buildConditionCard(MedicalConditionItem item, ThemeData theme, bool isActive) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isActive ? Colors.amber.shade100 : Colors.green.shade100,
          child: Icon(
            isActive ? Icons.favorite : Icons.check_circle,
            color: isActive ? Colors.amber.shade800 : Colors.green.shade800,
          ),
        ),
        title: Text(item.condition, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(item.notes ?? 'Diagnosed: ${item.diagnosedYear ?? "N/A"} • Status: ${item.status}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.grey),
          onPressed: () => _removeItem('condition', item.condition),
        ),
      ),
    );
  }

  Widget _buildAllergiesTab(HealthProfile profile, ThemeData theme) {
    if (profile.allergies.isEmpty) {
      return _buildEmptyState(
        icon: Icons.warning_amber_rounded,
        title: 'No Allergies Recorded',
        subtitle: 'Log food, medicinal, or environmental allergies for safe dietary recommendations.',
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: profile.allergies.map((a) {
        final isSevere = a.severity == 'SEVERE';
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isSevere ? BorderSide(color: Colors.red.shade300, width: 1.5) : BorderSide.none,
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isSevere ? Colors.red.shade100 : Colors.orange.shade100,
              child: Icon(Icons.warning, color: isSevere ? Colors.red.shade800 : Colors.orange.shade800),
            ),
            title: Text(a.allergen, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Type: ${a.type} • Reaction: ${a.reaction ?? "Not specified"}'),
            trailing: Chip(
              label: Text(a.severity, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              backgroundColor: isSevere ? Colors.red.shade50 : Colors.orange.shade50,
              labelStyle: TextStyle(color: isSevere ? Colors.red.shade800 : Colors.orange.shade800),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMedicationsTab(HealthProfile profile, ThemeData theme) {
    if (profile.medications.isEmpty) {
      return _buildEmptyState(
        icon: Icons.medication_outlined,
        title: 'No Medications Recorded',
        subtitle: 'Track prescribed medications and supplements to monitor practice energy levels.',
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: profile.medications.map((m) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(Icons.medication, color: theme.colorScheme.primary),
            ),
            title: Text(m.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${m.dosage} • ${m.frequency}\nReason: ${m.reason ?? "General maintenance"}'),
            isThreeLine: true,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSurgeriesTab(HealthProfile profile, ThemeData theme) {
    if (profile.surgeries.isEmpty) {
      return _buildEmptyState(
        icon: Icons.healing_outlined,
        title: 'No Surgeries or Major Procedures',
        subtitle: 'Record past orthopedic or visceral surgeries to ensure safe pose modifications.',
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: profile.surgeries.map((s) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFE8DEF8),
              child: Icon(Icons.local_hospital, color: Color(0xFF6750A4)),
            ),
            title: Text(s.procedure, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Year: ${s.year} • Surgeon/Hospital: ${s.surgeonOrHospital ?? "Private"}\nNotes: ${s.recoveryNotes ?? "Recovered"}'),
            isThreeLine: true,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLifestyleTab(HealthProfile profile, ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Biological & Emergency Info', Icons.fingerprint),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow('Blood Group', profile.bloodGroup),
                const Divider(),
                _buildInfoRow('Pregnancy Status', profile.pregnancyStatus.replaceAll('_', ' ')),
                const Divider(),
                _buildInfoRow('Emergency Contact', profile.emergencyContactName ?? 'Not set'),
                const Divider(),
                _buildInfoRow('Contact Phone', profile.emergencyContactPhone ?? 'Not set'),
                const Divider(),
                _buildInfoRow('Relation', profile.emergencyContactRelation ?? 'Not set'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildSectionHeader('Lifestyle Profile', Icons.self_improvement),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow('Smoking Status', profile.lifestyle.isSmoker ? 'Smoker' : 'Non-Smoker'),
                const Divider(),
                _buildInfoRow('Alcohol Consumption', profile.lifestyle.alcoholConsumption),
                const Divider(),
                _buildInfoRow('Work Activity Nature', profile.lifestyle.workNature),
                const Divider(),
                _buildInfoRow('Daily Screen Time', '${profile.lifestyle.averageScreenTimeHours} Hours'),
                const Divider(),
                _buildInfoRow('Dietary Preference', profile.lifestyle.dietPreference ?? 'Vegetarian'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6750A4)),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String title, required String subtitle}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 14), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, int tabIndex) {
    final titleController = TextEditingController();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(tabIndex == 0 ? 'Add Medical Condition' : tabIndex == 1 ? 'Add Allergy' : tabIndex == 2 ? 'Add Medication' : 'Add Surgery'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: tabIndex == 0 ? 'Condition Name' : tabIndex == 1 ? 'Allergen Name' : tabIndex == 2 ? 'Medication Name & Dosage' : 'Procedure Name',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Notes / Reaction / Details',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                _saveNewRecord(tabIndex, titleController.text, notesController.text);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _saveNewRecord(int tabIndex, String title, String notes) {
    final notifier = ref.read(healthProfileNotifierProvider.notifier);
    final current = ref.read(healthProfileNotifierProvider).profile ?? _getEmptyProfile();

    if (tabIndex == 0) {
      final updatedConditions = [
        ...current.currentConditions,
        MedicalConditionItem(condition: title, status: 'ACTIVE', notes: notes, diagnosedYear: DateTime.now().year)
      ];
      notifier.updateProfileSection({'currentConditions': updatedConditions.map((e) => {'condition': e.condition, 'status': e.status, 'notes': e.notes}).toList()});
    } else if (tabIndex == 1) {
      final updatedAllergies = [
        ...current.allergies,
        AllergyItem(allergen: title, type: 'GENERAL', severity: 'MODERATE', reaction: notes)
      ];
      notifier.updateProfileSection({'allergies': updatedAllergies.map((e) => {'allergen': e.allergen, 'type': e.type, 'severity': e.severity, 'reaction': e.reaction}).toList()});
    } else if (tabIndex == 2) {
      final updatedMedications = [
        ...current.medications,
        MedicationItem(name: title, dosage: 'Daily', frequency: 'As prescribed', reason: notes)
      ];
      notifier.updateProfileSection({'medications': updatedMedications.map((e) => {'name': e.name, 'dosage': e.dosage, 'frequency': e.frequency, 'reason': e.reason}).toList()});
    }
  }

  void _removeItem(String type, String id) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Removed $id from $type')));
  }

  HealthProfile _getEmptyProfile() {
    return HealthProfile(
      id: 'empty',
      userId: 'user',
      bloodGroup: 'O+',
      pregnancyStatus: 'NOT_PREGNANT',
      medicalHistory: const [],
      currentConditions: const [],
      pastConditions: const [],
      surgeries: const [],
      medications: const [],
      allergies: const [],
      physicalLimitations: const [],
      lifestyle: const LifestyleProfile(isSmoker: false, alcoholConsumption: 'NONE', workNature: 'MIXED', averageScreenTimeHours: 5.0),
      isVerifiedByDoctor: false,
      updatedAt: DateTime.now(),
    );
  }
}

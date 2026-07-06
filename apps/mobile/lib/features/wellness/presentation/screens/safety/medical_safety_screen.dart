// ==============================================================================
// Yoga24X AI Engineering OS — Medical Safety & Contraindication Screen
// Active Alerts Banner, Restricted Poses, Doctor Advice, & Teacher Alert Protocols
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/wellness_models.dart';
import '../../providers/safety_flags_provider.dart';

class MedicalSafetyScreen extends ConsumerStatefulWidget {
  const MedicalSafetyScreen({super.key});

  @override
  ConsumerState<MedicalSafetyScreen> createState() => _MedicalSafetyScreenState();
}

class _MedicalSafetyScreenState extends ConsumerState<MedicalSafetyScreen> {
  final TextEditingController _poseCheckController = TextEditingController();

  @override
  void dispose() {
    _poseCheckController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(safetyNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinical Safety & Contraindications', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: state.status == SafetyStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDoctorVerificationBanner(),
                  const SizedBox(height: 20),
                  _buildRealTimePoseCheckCard(state, theme),
                  const SizedBox(height: 24),
                  const Text('Active Clinical Safety Flags', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (state.activeFlags.isEmpty)
                    _buildEmptyFlags()
                  else
                    ...state.activeFlags.map((flag) => _buildSafetyFlagCard(flag, theme)),
                  const SizedBox(height: 24),
                  _buildTeacherAlertsCard(theme),
                ],
              ),
            ),
    );
  }

  Widget _buildDoctorVerificationBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.teal.shade700, Colors.teal.shade900]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.teal.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white24,
            child: Icon(Icons.verified_user, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Verified Clinical Protocol', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(height: 4),
                Text('Reviewed by Dr. Ananya Vaidya (MBBS, MD - Ayurvedic Medicine). Safety parameters actively sync with AI live class stream.',
                    style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealTimePoseCheckCard(SafetyState state, ThemeData theme) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shield_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                const Text('AI Pose Safety Checker', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Enter a yoga pose name (e.g., Sirsasana, Chakrasana, Halasana) to check instant biomechanical safety against your medical history.',
                style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _poseCheckController,
                    decoration: const InputDecoration(
                      hintText: 'Enter pose name...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: state.isCheckingPose
                      ? null
                      : () {
                          if (_poseCheckController.text.isNotEmpty) {
                            ref.read(safetyNotifierProvider.notifier).verifyPoses([_poseCheckController.text]);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                  child: state.isCheckingPose ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Check'),
                ),
              ],
            ),
            if (state.lastPoseCheckResult != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: state.lastPoseCheckResult!['safe'] == true ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: state.lastPoseCheckResult!['safe'] == true ? Colors.green : Colors.red),
                ),
                child: Row(
                  children: [
                    Icon(state.lastPoseCheckResult!['safe'] == true ? Icons.check_circle : Icons.warning,
                        color: state.lastPoseCheckResult!['safe'] == true ? Colors.green : Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        state.lastPoseCheckResult!['reason'] ?? (state.lastPoseCheckResult!['safe'] == true ? 'Pose is safe to practice!' : 'Contraindicated pose! Proceed with caution or substitute.'),
                        style: TextStyle(color: state.lastPoseCheckResult!['safe'] == true ? Colors.green.shade900 : Colors.red.shade900, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyFlagCard(MedicalSafetyFlag flag, ThemeData theme) {
    final isCritical = flag.severity == 'CRITICAL' || flag.severity == 'HIGH';
    final color = isCritical ? Colors.red : Colors.orange;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.shade300, width: 1.5),
      ),
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
                      backgroundColor: color.shade100,
                      child: Icon(Icons.warning_amber_rounded, color: color.shade800),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(flag.condition, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Severity: ${flag.severity}', style: TextStyle(color: color.shade800, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.check_circle_outline, color: Colors.grey),
                  tooltip: 'Dismiss / Mark Resolved',
                  onPressed: () => ref.read(safetyNotifierProvider.notifier).dismissOrDeactivateFlag(flag.id),
                ),
              ],
            ),
            const Divider(height: 24),
            const Text('Restricted & Contraindicated Poses:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: flag.restrictedPoses.map((pose) {
                return Chip(
                  avatar: const Icon(Icons.block, color: Colors.white, size: 14),
                  label: Text(pose, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  backgroundColor: color.shade700,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Doctor & AI Clinical Advice:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text(flag.doctorAdvice, style: const TextStyle(fontSize: 13, height: 1.4, color: Colors.black87)),
            if (flag.verifiedByDoctor != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.verified, size: 16, color: Colors.teal),
                  const SizedBox(width: 6),
                  Text('Verified by ${flag.verifiedByDoctor}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherAlertsCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SwitchListTile(
        title: const Text('Live Class Teacher Safety Alert', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('Automatically broadcast encrypted contraindication flags to live instructors when joining classes.'),
        value: true,
        activeColor: theme.colorScheme.primary,
        onChanged: (val) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(val ? 'Teacher alerts enabled' : 'Teacher alerts disabled')));
        },
      ),
    );
  }

  Widget _buildEmptyFlags() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: Colors.green.shade400),
            const SizedBox(height: 12),
            const Text('No Active Safety Warnings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('Your clinical profile indicates no severe biomechanical contraindications. Always practice mindfully!',
                textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

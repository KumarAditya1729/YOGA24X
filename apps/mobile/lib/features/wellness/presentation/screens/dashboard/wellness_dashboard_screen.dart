// ==============================================================================
// Yoga24X AI Engineering OS — Enterprise Wellness Dashboard Hub Screen
// Central Hub Connecting Health Profile, Assessments, Timeline, Goals & Safety
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/assessment_provider.dart';
import '../../providers/health_profile_provider.dart';
import '../../providers/safety_flags_provider.dart';
import '../assessment/ai_personalization_screen.dart';
import '../assessment/meditation_profile_screen.dart';
import '../assessment/nutrition_profile_screen.dart';
import '../assessment/wellness_assessment_wizard_screen.dart';
import '../assessment/yoga_assessment_screen.dart';
import '../charts/wellness_charts_screen.dart';
import '../goals/goal_management_screen.dart';
import '../health_profile/health_profile_screen.dart';
import '../safety/medical_safety_screen.dart';
import '../timeline/daily_timeline_screen.dart';

class WellnessDashboardScreen extends ConsumerStatefulWidget {
  const WellnessDashboardScreen({super.key});

  @override
  ConsumerState<WellnessDashboardScreen> createState() => _WellnessDashboardScreenState();
}

class _WellnessDashboardScreenState extends ConsumerState<WellnessDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final assessmentState = ref.watch(assessmentNotifierProvider);
    final safetyState = ref.watch(safetyNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness & Health Hub', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'View Analytics Charts',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WellnessChartsScreen())),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(healthProfileNotifierProvider.notifier).fetchHealthProfile();
          ref.read(assessmentNotifierProvider.notifier).fetchAllAssessments();
          ref.read(safetyNotifierProvider.notifier).fetchSafetyFlags();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSafetyAlertTicker(safetyState, theme),
              const SizedBox(height: 16),
              _buildAiStatusCard(assessmentState, theme),
              const SizedBox(height: 24),
              const Text('Core Clinical & Health Modules', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildGridMenu(context, theme),
              const SizedBox(height: 24),
              const Text('Personalized Practice Customization', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildCustomizationList(context, theme),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WellnessAssessmentWizardScreen())),
        icon: const Icon(Icons.auto_awesome),
        label: const Text('AI Assessment'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildSafetyAlertTicker(SafetyState state, ThemeData theme) {
    if (state.activeFlags.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade800),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Clinical Safety: All biomechanical parameters normal. Safe for standard Hatha & Vinyasa practice.',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
            ),
          ],
        ),
      );
    }

    final topFlag = state.activeFlags.first;
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicalSafetyScreen())),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade300, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red.shade800, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Active Contraindication: ${topFlag.condition}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade900)),
                  Text('Restricted: ${topFlag.restrictedPoses.join(", ")}', style: TextStyle(fontSize: 12, color: Colors.red.shade800)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildAiStatusCard(AssessmentState state, ThemeData theme) {
    final general = state.latestGeneralAssessment;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [theme.colorScheme.primary, const Color(0xFF4A148C)]),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.amber, size: 28),
                    SizedBox(width: 10),
                    Text('Yoga24X AI Engine Active', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                Chip(
                  label: Text('Live Sync', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  backgroundColor: Colors.white24,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (general == null)
              const Text('Take your initial AI Wellness Assessment to unlock personalized flows, nutrition plans, and chakra balancing.',
                  style: TextStyle(color: Colors.white70, height: 1.4))
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWhiteStat('Stress Score', '${general.stressLevel}/10'),
                  _buildWhiteStat('Sleep Quality', '${general.sleepQuality}/10'),
                  _buildWhiteStat('Flexibility', '${general.flexibilityScore}/10'),
                ],
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WellnessAssessmentWizardScreen())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.refresh),
                label: const Text('Update AI Wellness Assessment', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhiteStat(String label, String val) {
    return Column(
      children: [
        Text(val, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildGridMenu(BuildContext context, ThemeData theme) {
    final items = [
      {'title': 'Clinical Profile', 'sub': 'Medical history & allergies', 'icon': Icons.medical_services_outlined, 'screen': const HealthProfileScreen(), 'color': Colors.red},
      {'title': 'Daily Timeline', 'sub': 'Mood, pain & sleep log', 'icon': Icons.calendar_month, 'screen': const DailyTimelineScreen(), 'color': Colors.blue},
      {'title': 'Goals & Badges', 'sub': 'Milestones & achievements', 'icon': Icons.emoji_events_outlined, 'screen': const GoalManagementScreen(), 'color': Colors.amber.shade800},
      {'title': 'Medical Safety', 'sub': 'Contraindications & advice', 'icon': Icons.shield_outlined, 'screen': const MedicalSafetyScreen(), 'color': Colors.teal},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final color = item['color'] as Color;

        return InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => item['screen'] as Widget)),
          borderRadius: BorderRadius.circular(16),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: color.withValues(alpha: 0.15),
                    child: Icon(item['icon'] as IconData, color: color),
                  ),
                  const SizedBox(height: 10),
                  Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(item['sub'] as String, style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomizationList(BuildContext context, ThemeData theme) {
    final tiles = [
      {'title': 'Yoga Practice Preferences', 'sub': 'Goals, lineage, instructor gender & duration', 'icon': Icons.self_improvement, 'screen': const YogaAssessmentScreen()},
      {'title': 'Ayurvedic & Nutrition Profile', 'sub': 'Sattvic diet, calories, water target & supplements', 'icon': Icons.restaurant_menu, 'screen': const NutritionProfileScreen()},
      {'title': 'Meditation & Breathwork', 'sub': 'Voice guides, 432Hz soundscapes & focus areas', 'icon': Icons.spa_outlined, 'screen': const MeditationProfileScreen()},
      {'title': 'AI Coach Customization', 'sub': 'Coaching persona, reminders, voice & language', 'icon': Icons.psychology_outlined, 'screen': const AiPersonalizationScreen()},
      {'title': 'Analytics & Progress Charts', 'sub': 'Custom stress vs energy curves & sleep trends', 'icon': Icons.analytics_outlined, 'screen': const WellnessChartsScreen()},
    ];

    return Column(
      children: tiles.map((t) {
        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(t['icon'] as IconData, color: theme.colorScheme.primary),
            ),
            title: Text(t['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(t['sub'] as String, style: const TextStyle(fontSize: 12)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => t['screen'] as Widget)),
          ),
        );
      }).toList(),
    );
  }
}

// ==============================================================================
// Yoga24X AI Engineering OS — 2026 Luxury Telemetry & Clinical Health Hub
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
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1311) : const Color(0xFFF4F7F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'CLINICAL TELEMETRY HUB',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w800,
            fontSize: 18,
            letterSpacing: 2.0,
            color: isDark ? Colors.white : const Color(0xFF1B5E57),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined, color: Color(0xFFC5A059)),
            tooltip: 'View Analytics Charts',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WellnessChartsScreen())),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFFC5A059),
        onRefresh: () async {
          ref.read(healthProfileNotifierProvider.notifier).fetchHealthProfile();
          ref.read(assessmentNotifierProvider.notifier).fetchAllAssessments();
          ref.read(safetyNotifierProvider.notifier).fetchSafetyFlags();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSafetyAlertTicker(safetyState, isDark),
              const SizedBox(height: 20),
              _buildAiStatusCard(assessmentState, isDark, theme),
              const SizedBox(height: 28),
              Text(
                'CORE CLINICAL MODULES',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 14),
              _buildGridMenu(context, isDark),
              const SizedBox(height: 28),
              Text(
                'PERSONALIZED PRACTICE CUSTOMIZATION',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 14),
              _buildCustomizationList(context, isDark),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 74),
        child: FloatingActionButton.extended(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WellnessAssessmentWizardScreen())),
          icon: const Icon(Icons.auto_awesome, color: Color(0xFFC5A059)),
          label: const Text('AI Assessment', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w700)),
          backgroundColor: const Color(0xFF1B5E57),
          foregroundColor: Colors.white,
          elevation: 8,
        ),
      ),
    );
  }

  Widget _buildSafetyAlertTicker(SafetyState state, bool isDark) {
    if (state.activeFlags.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1B5E57).withValues(alpha: 0.25), const Color(0xFF385E4D).withValues(alpha: 0.15)]
                : [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF4ADE80).withValues(alpha: 0.4), width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4ADE80).withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.verified_user_rounded, color: Color(0xFF4ADE80), size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'Clinical Safety: All biomechanical parameters normal. Safe for standard Hatha & Vinyasa practice.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF1B5E57),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final topFlag = state.activeFlags.first;
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicalSafetyScreen())),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.redAccent.withValues(alpha: 0.2), Colors.red.withValues(alpha: 0.1)]
                : [Colors.red.shade50, Colors.red.shade100],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active Contraindication: ${topFlag.condition}',
                    style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w800, fontSize: 14, color: isDark ? Colors.white : Colors.red.shade900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Restricted: ${topFlag.restrictedPoses.join(", ")}',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isDark ? Colors.redAccent.shade100 : Colors.red.shade800),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.redAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildAiStatusCard(AssessmentState state, bool isDark, ThemeData theme) {
    final general = state.latestGeneralAssessment;
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E57), Color(0xFF2A1B4E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFC5A059).withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5E57).withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC5A059).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.auto_awesome, color: Color(0xFFC5A059), size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'AI Telemetry Engine',
                    style: TextStyle(fontFamily: 'Outfit', color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: const Text('LIVE SYNC', style: TextStyle(fontFamily: 'Outfit', color: Color(0xFF4ADE80), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.0)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (general == null)
            const Text(
              'Take your initial AI Wellness Assessment to unlock personalized flows, nutrition plans, and chakra balancing.',
              style: TextStyle(fontFamily: 'Inter', color: Colors.white70, height: 1.5, fontSize: 13),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWhiteStat('Stress Score', '${general.stressLevel}/10'),
                _buildWhiteStat('Sleep Quality', '${general.sleepQuality}/10'),
                _buildWhiteStat('Flexibility', '${general.flexibilityScore}/10'),
              ],
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WellnessAssessmentWizardScreen())),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1B5E57),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text('Update AI Wellness Assessment', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w800, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteStat(String label, String val) {
    return Column(
      children: [
        Text(val, style: const TextStyle(fontFamily: 'Outfit', color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontFamily: 'Inter', color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildGridMenu(BuildContext context, bool isDark) {
    final items = [
      {'title': 'Clinical Profile', 'sub': 'Medical history & allergies', 'icon': Icons.medical_services_outlined, 'screen': const HealthProfileScreen(), 'color': const Color(0xFFEF4444)},
      {'title': 'Daily Timeline', 'sub': 'Mood, pain & sleep log', 'icon': Icons.calendar_month_outlined, 'screen': const DailyTimelineScreen(), 'color': const Color(0xFF3B82F6)},
      {'title': 'Goals & Badges', 'sub': 'Milestones & achievements', 'icon': Icons.emoji_events_outlined, 'screen': const GoalManagementScreen(), 'color': const Color(0xFFF59E0B)},
      {'title': 'Medical Safety', 'sub': 'Contraindications & advice', 'icon': Icons.shield_outlined, 'screen': const MedicalSafetyScreen(), 'color': const Color(0xFF10B981)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.25,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final color = item['color'] as Color;

        return InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => item['screen'] as Widget)),
          borderRadius: BorderRadius.circular(22),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: color.withValues(alpha: 0.3), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: isDark ? 0.05 : 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(item['icon'] as IconData, color: color, size: 24),
                ),
                const Spacer(),
                Text(
                  item['title'] as String,
                  style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w800, fontSize: 15, color: isDark ? Colors.white : Colors.black87),
                ),
                const SizedBox(height: 2),
                Text(
                  item['sub'] as String,
                  style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: isDark ? Colors.grey[400] : Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomizationList(BuildContext context, bool isDark) {
    final tiles = [
      {'title': 'Yoga Practice Preferences', 'sub': 'Goals, lineage, instructor gender & duration', 'icon': Icons.self_improvement_rounded, 'screen': const YogaAssessmentScreen(), 'color': const Color(0xFFC5A059)},
      {'title': 'Ayurvedic & Nutrition Profile', 'sub': 'Sattvic diet, calories, water target & supplements', 'icon': Icons.restaurant_menu_rounded, 'screen': const NutritionProfileScreen(), 'color': const Color(0xFF10B981)},
      {'title': 'Meditation & Breathwork', 'sub': 'Voice guides, 432Hz soundscapes & focus areas', 'icon': Icons.spa_outlined, 'screen': const MeditationProfileScreen(), 'color': const Color(0xFF8B5CF6)},
      {'title': 'AI Coach Customization', 'sub': 'Coaching persona, reminders, voice & language', 'icon': Icons.psychology_outlined, 'screen': const AiPersonalizationScreen(), 'color': const Color(0xFF3B82F6)},
      {'title': 'Analytics & Progress Charts', 'sub': 'Custom stress vs energy curves & sleep trends', 'icon': Icons.analytics_outlined, 'screen': const WellnessChartsScreen(), 'color': const Color(0xFFEC4899)},
    ];

    return Column(
      children: tiles.map((t) {
        final color = t['color'] as Color;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.25), width: 1.0),
          ),
          child: Material(
            color: Colors.transparent,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(t['icon'] as IconData, color: color, size: 24),
              ),
              title: Text(t['title'] as String, style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w700, fontSize: 15, color: isDark ? Colors.white : Colors.black87)),
              subtitle: Text(t['sub'] as String, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey[600])),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => t['screen'] as Widget)),
            ),
          ),
        );
      }).toList(),
    );
  }
}

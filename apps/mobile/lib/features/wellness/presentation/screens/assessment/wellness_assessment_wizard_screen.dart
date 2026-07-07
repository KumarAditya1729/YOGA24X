// ==============================================================================
// Yoga24X AI Engineering OS — Enterprise Wellness Assessment Wizard Screen
// Step-by-Step Interactive Wizard for Stress, Sleep, Energy, Mobility & BMI
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/assessment_provider.dart';

class WellnessAssessmentWizardScreen extends ConsumerStatefulWidget {
  const WellnessAssessmentWizardScreen({super.key});

  @override
  ConsumerState<WellnessAssessmentWizardScreen> createState() => _WellnessAssessmentWizardScreenState();
}

class _WellnessAssessmentWizardScreenState extends ConsumerState<WellnessAssessmentWizardScreen> {
  int _currentStep = 0;

  // Sliders (1-10)
  double _stressLevel = 5.0;
  double _sleepQuality = 7.0;
  double _energyLevel = 6.0;
  final double _hydrationScore = 7.0;
  double _flexibilityScore = 5.0;
  double _strengthScore = 5.0;
  double _mobilityScore = 6.0;

  // Bio Inputs
  final TextEditingController _weightController = TextEditingController(text: '68');
  final TextEditingController _heightController = TextEditingController(text: '172');
  final TextEditingController _heartRateController = TextEditingController(text: '68');
  String _breathingPattern = 'DEEP_DIAPHRAGMATIC';
  String _activityLevel = 'MODERATE';

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _heartRateController.dispose();
    super.dispose();
  }

  double get _calculatedBmi {
    final w = double.tryParse(_weightController.text) ?? 68.0;
    final hCm = double.tryParse(_heightController.text) ?? 172.0;
    if (hCm <= 0) return 22.0;
    final hM = hCm / 100.0;
    return double.parse((w / (hM * hM)).toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSubmitting = ref.watch(assessmentNotifierProvider).isSubmitting;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Wellness Assessment', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / 4,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildStepContent(theme),
              ),
            ),
            _buildNavigationFooter(theme, isSubmitting),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(ThemeData theme) {
    switch (_currentStep) {
      case 0:
        return _buildMentalRecoveryStep(theme);
      case 1:
        return _buildPhysicalCapacityStep(theme);
      case 2:
        return _buildBiometricsStep(theme);
      case 3:
        return _buildSummaryConfirmationStep(theme);
      default:
        return _buildMentalRecoveryStep(theme);
    }
  }

  Widget _buildMentalRecoveryStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('Step 1 of 4: Mental & Recovery State', 'How are your stress and sleep patterns currently?'),
        const SizedBox(height: 24),
        _buildSliderItem(
          title: 'Daily Stress Level',
          subtitle: '1 = Zen & Peaceful, 10 = Overwhelmed & Burnout',
          value: _stressLevel,
          onChanged: (v) => setState(() => _stressLevel = v),
          activeColor: _stressLevel > 7 ? Colors.red : Colors.teal,
        ),
        const SizedBox(height: 24),
        _buildSliderItem(
          title: 'Sleep Quality Score',
          subtitle: '1 = Insomnia / Restless, 10 = Deep & Rejuvenating',
          value: _sleepQuality,
          onChanged: (v) => setState(() => _sleepQuality = v),
          activeColor: Colors.indigo,
        ),
        const SizedBox(height: 24),
        _buildSliderItem(
          title: 'Daytime Energy Level',
          subtitle: '1 = Lethargic / Fatigued, 10 = Vibrant & Unstoppable',
          value: _energyLevel,
          onChanged: (v) => setState(() => _energyLevel = v),
          activeColor: Colors.amber.shade700,
        ),
      ],
    );
  }

  Widget _buildPhysicalCapacityStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('Step 2 of 4: Physical Capacity & Mobility', 'Assess your biomechanical baseline for pose recommendations.'),
        const SizedBox(height: 24),
        _buildSliderItem(
          title: 'Spinal & Joint Flexibility',
          subtitle: '1 = Stiff / Tight Hamstrings, 10 = Full splits & backbends',
          value: _flexibilityScore,
          onChanged: (v) => setState(() => _flexibilityScore = v),
          activeColor: const Color(0xFF6750A4),
        ),
        const SizedBox(height: 24),
        _buildSliderItem(
          title: 'Core & Upper Body Strength',
          subtitle: '1 = Difficulty with plank, 10 = Advanced arm balances',
          value: _strengthScore,
          onChanged: (v) => setState(() => _strengthScore = v),
          activeColor: Colors.blue.shade700,
        ),
        const SizedBox(height: 24),
        _buildSliderItem(
          title: 'Joint Mobility & Range of Motion',
          subtitle: '1 = Restricted hips/shoulders, 10 = Fluid pain-free motion',
          value: _mobilityScore,
          onChanged: (v) => setState(() => _mobilityScore = v),
          activeColor: Colors.green.shade700,
        ),
      ],
    );
  }

  Widget _buildBiometricsStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('Step 3 of 4: Biometrics & Vitals', 'Enter vitals to calibrate calorie and cardio intensity goals.'),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Weight (kg)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.monitor_weight_outlined)),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Height (cm)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.height)),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Calculated BMI Baseline:', style: TextStyle(fontWeight: FontWeight.w600)),
                Text('$_calculatedBmi kg/m²', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _heartRateController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Resting Heart Rate (bpm)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.favorite_outline)),
        ),
        const SizedBox(height: 24),
        DropdownButtonFormField<String>(
          initialValue: _breathingPattern,
          decoration: const InputDecoration(labelText: 'Primary Breathing Pattern', border: OutlineInputBorder()),
          items: const [
            DropdownMenuItem(value: 'DEEP_DIAPHRAGMATIC', child: Text('Deep Diaphragmatic (Belly)')),
            DropdownMenuItem(value: 'SHALLOW_CHEST', child: Text('Shallow Chest Breathing')),
            DropdownMenuItem(value: 'IRREGULAR_STRESSED', child: Text('Irregular / Stressed')),
            DropdownMenuItem(value: 'PRANAYAMA_TRAINED', child: Text('Pranayama Trained')),
          ],
          onChanged: (v) => setState(() => _breathingPattern = v ?? 'DEEP_DIAPHRAGMATIC'),
        ),
        const SizedBox(height: 24),
        DropdownButtonFormField<String>(
          initialValue: _activityLevel,
          decoration: const InputDecoration(labelText: 'Daily Physical Activity Level', border: OutlineInputBorder()),
          items: const [
            DropdownMenuItem(value: 'SEDENTARY', child: Text('Sedentary (Desk Job, <3k steps)')),
            DropdownMenuItem(value: 'MODERATE', child: Text('Moderate (3k-8k steps / Light exercise)')),
            DropdownMenuItem(value: 'ACTIVE', child: Text('Active (8k+ steps / Regular workout)')),
            DropdownMenuItem(value: 'ATHLETE', child: Text('High Performance Athlete')),
          ],
          onChanged: (v) => setState(() => _activityLevel = v ?? 'MODERATE'),
        ),
      ],
    );
  }

  Widget _buildSummaryConfirmationStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('Step 4 of 4: AI Assessment Summary', 'Review your wellness profile before our AI generates your personalized practice plan.'),
        const SizedBox(height: 20),
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildSummaryRow('Stress Index', '${_stressLevel.toInt()} / 10', _stressLevel > 7 ? Colors.red : Colors.green),
                const Divider(),
                _buildSummaryRow('Sleep Quality', '${_sleepQuality.toInt()} / 10', Colors.indigo),
                const Divider(),
                _buildSummaryRow('Flexibility Baseline', '${_flexibilityScore.toInt()} / 10', const Color(0xFF6750A4)),
                const Divider(),
                _buildSummaryRow('Strength Baseline', '${_strengthScore.toInt()} / 10', Colors.blue),
                const Divider(),
                _buildSummaryRow('Estimated BMI', '$_calculatedBmi kg/m²', Colors.teal),
                const Divider(),
                _buildSummaryRow('Activity Level', _activityLevel, Colors.amber.shade800),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.shade300),
          ),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.amber.shade800, size: 32),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Yoga24X AI will automatically synthesize this assessment with your medical contraindications to recommend safe Hatha & Vinyasa flows.',
                  style: TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepTitle(String stepText, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(stepText, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF6750A4))),
        const SizedBox(height: 6),
        Text(desc, style: const TextStyle(fontSize: 15, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSliderItem({
    required String title,
    required String subtitle,
    required double value,
    required ValueChanged<double> onChanged,
    required Color activeColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: activeColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
              child: Text(value.toInt().toString(), style: TextStyle(fontWeight: FontWeight.bold, color: activeColor, fontSize: 16)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Slider(
          value: value,
          min: 1,
          max: 10,
          divisions: 9,
          activeColor: activeColor,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15, color: Colors.grey)),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildNavigationFooter(ThemeData theme, bool isSubmitting) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            OutlinedButton.icon(
              onPressed: isSubmitting ? null : () => setState(() => _currentStep--),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
            )
          else
            const SizedBox(),
          ElevatedButton.icon(
            onPressed: isSubmitting ? null : _handleNextOrSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: isSubmitting
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Icon(_currentStep == 3 ? Icons.check_circle : Icons.arrow_forward),
            label: Text(_currentStep == 3 ? 'Complete Assessment' : 'Next Step'),
          ),
        ],
      ),
    );
  }

  void _handleNextOrSubmit() async {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      final success = await ref.read(assessmentNotifierProvider.notifier).submitGeneralAssessment({
        'stressLevel': _stressLevel.toInt(),
        'sleepQuality': _sleepQuality.toInt(),
        'energyLevel': _energyLevel.toInt(),
        'hydrationScore': _hydrationScore.toInt(),
        'flexibilityScore': _flexibilityScore.toInt(),
        'strengthScore': _strengthScore.toInt(),
        'mobilityScore': _mobilityScore.toInt(),
        'bmi': _calculatedBmi,
        'restingHeartRate': int.tryParse(_heartRateController.text) ?? 68,
        'breathingPattern': _breathingPattern,
        'dailyActivityLevel': _activityLevel,
      });

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('AI Assessment successfully analyzed and saved!')));
        Navigator.pop(context);
      }
    }
  }
}

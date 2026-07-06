// ==============================================================================
// Yoga24X AI Engineering OS — Nutrition & Ayurvedic Profile Screen
// Configures Diet, Calorie Targets, Water Goals, Meal Timing, & Supplements
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/assessment_provider.dart';

class NutritionProfileScreen extends ConsumerStatefulWidget {
  const NutritionProfileScreen({super.key});

  @override
  ConsumerState<NutritionProfileScreen> createState() => _NutritionProfileScreenState();
}

class _NutritionProfileScreenState extends ConsumerState<NutritionProfileScreen> {
  String _dietType = 'SATTVIC_VEGETARIAN';
  double _caloriesGoal = 2100.0;
  double _waterGoalMl = 3000.0;
  double _proteinGoalGrams = 65.0;

  final List<String> _selectedAllergies = ['Gluten Sensitivity', 'Dairy / Lactose'];
  final List<String> _allAllergies = [
    'Gluten Sensitivity',
    'Dairy / Lactose',
    'Peanuts & Tree Nuts',
    'Soy',
    'Eggs',
    'Shellfish / Seafood',
    'Nightshade Vegetables'
  ];

  final List<String> _selectedSupplements = ['Ashwagandha KSM-66', 'Vitamin D3 + K2', 'Magnesium Glycinate'];
  final List<String> _allSupplements = [
    'Ashwagandha KSM-66',
    'Vitamin D3 + K2',
    'Magnesium Glycinate',
    'Omega-3 Fish Oil / Algae',
    'Triphala Ayurvedic Extract',
    'B-Complex',
    'Whey / Plant Protein'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSubmitting = ref.watch(assessmentNotifierProvider).isSubmitting;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayurvedic & Nutrition Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('1. Dietary Classification & Lineage', Icons.restaurant_menu),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _dietType,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'SATTVIC_VEGETARIAN', child: Text('Sattvic Vegetarian (Yogic Pure Diet)')),
                DropdownMenuItem(value: 'VEGETARIAN', child: Text('Standard Vegetarian')),
                DropdownMenuItem(value: 'VEGAN', child: Text('100% Plant-Based / Vegan')),
                DropdownMenuItem(value: 'PESCATARIAN', child: Text('Pescatarian (Fish & Vegetables)')),
                DropdownMenuItem(value: 'KETO_LOW_CARB', child: Text('Low Carb / Ketogenic')),
                DropdownMenuItem(value: 'OMNIVORE', child: Text('Omnivore / Balanced Everything')),
              ],
              onChanged: (v) => setState(() => _dietType = v ?? 'SATTVIC_VEGETARIAN'),
            ),
            const SizedBox(height: 24),
            _buildHeader('2. Daily Nutrition & Hydration Targets', Icons.water_drop_outlined),
            const SizedBox(height: 16),
            _buildSlider(
              label: 'Daily Calorie Target',
              value: _caloriesGoal,
              min: 1200,
              max: 4000,
              divisions: 28,
              unit: 'kcal',
              onChanged: (v) => setState(() => _caloriesGoal = v),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              label: 'Daily Hydration Target',
              value: _waterGoalMl,
              min: 1500,
              max: 5000,
              divisions: 35,
              unit: 'ml (${(_waterGoalMl / 1000).toStringAsFixed(1)} L)',
              onChanged: (v) => setState(() => _waterGoalMl = v),
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildSlider(
              label: 'Daily Protein Target',
              value: _proteinGoalGrams,
              min: 30,
              max: 200,
              divisions: 34,
              unit: 'grams',
              onChanged: (v) => setState(() => _proteinGoalGrams = v),
              color: Colors.amber.shade800,
            ),
            const SizedBox(height: 24),
            _buildHeader('3. Food Allergies & Intolerances', Icons.warning_amber_rounded),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allAllergies.map((allergy) {
                final isSelected = _selectedAllergies.contains(allergy);
                return FilterChip(
                  label: Text(allergy),
                  selected: isSelected,
                  selectedColor: Colors.red.shade100,
                  checkmarkColor: Colors.red.shade800,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedAllergies.add(allergy);
                      } else {
                        _selectedAllergies.remove(allergy);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            _buildHeader('4. Supplements & Ayurvedic Herbs', Icons.healing),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allSupplements.map((supp) {
                final isSelected = _selectedSupplements.contains(supp);
                return FilterChip(
                  label: Text(supp),
                  selected: isSelected,
                  selectedColor: Colors.teal.shade100,
                  checkmarkColor: Colors.teal.shade800,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedSupplements.add(supp);
                      } else {
                        _selectedSupplements.remove(supp);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isSubmitting ? null : _saveNutritionProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.check),
                label: const Text('Save Nutrition Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6750A4)),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String unit,
    required ValueChanged<double> onChanged,
    Color? color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            Text('${value.toInt()} $unit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color ?? const Color(0xFF6750A4))),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: color ?? const Color(0xFF6750A4),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _saveNutritionProfile() async {
    final success = await ref.read(assessmentNotifierProvider.notifier).saveNutritionProfile({
      'dietType': _dietType,
      'dailyCaloriesGoal': _caloriesGoal.toInt(),
      'dailyProteinGoalGrams': _proteinGoalGrams.toInt(),
      'dailyWaterGoalMl': _waterGoalMl.toInt(),
      'foodAllergies': _selectedAllergies,
      'foodPreferences': ['Organic Greens', 'Ghee', 'Moong Dal', 'Fresh Berries'],
      'mealTiming': {'breakfast': '08:00 AM', 'lunch': '01:00 PM', 'dinner': '07:30 PM'},
      'supplements': _selectedSupplements,
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nutrition profile saved successfully!')));
      Navigator.pop(context);
    }
  }
}

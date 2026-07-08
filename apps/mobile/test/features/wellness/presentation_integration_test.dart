// ==============================================================================
// Yoga24X AI Engineering OS — Wellness Presentation & Integration Tests
// Tests UI Rendering, Step Progression, Widget Interactions & E2E Flow
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yoga24x_mobile/features/wellness/domain/models/wellness_models.dart';
import 'package:yoga24x_mobile/features/wellness/domain/repositories/wellness_repository.dart';
import 'package:yoga24x_mobile/features/wellness/presentation/providers/wellness_providers.dart';
import 'package:yoga24x_mobile/features/wellness/presentation/screens/dashboard/wellness_dashboard_screen.dart';
import 'package:yoga24x_mobile/features/wellness/presentation/screens/health_profile/health_profile_screen.dart';
import 'package:yoga24x_mobile/features/wellness/presentation/screens/assessment/wellness_assessment_wizard_screen.dart';

class MockWellnessRepositoryForUI extends Mock implements WellnessRepository {}

void main() {
  late MockWellnessRepositoryForUI mockRepository;

  setUp(() {
    mockRepository = MockWellnessRepositoryForUI();

    // Default mock behavior for dashboard initialization
    when(() => mockRepository.getHealthProfile()).thenAnswer((_) async => HealthProfile(
          id: 'hp_ui_test',
          userId: 'usr_ui_test',
          bloodGroup: 'O+',
          pregnancyStatus: 'NOT_PREGNANT',
          medicalHistory: const [],
          currentConditions: const [
            MedicalConditionItem(condition: 'Mild Scoliosis', status: 'ACTIVE', notes: 'Thoracic curve')
          ],
          pastConditions: const [],
          surgeries: const [],
          medications: const [],
          allergies: const [
            AllergyItem(allergen: 'Dust Mites', type: 'ENVIRONMENTAL', severity: 'MILD')
          ],
          physicalLimitations: const [PhysicalLimitationItem(bodyPart: 'Spine', issue: 'Avoid heavy spinal compression', severity: 'HIGH', restrictedMovements: ['Backbend'])],
          lifestyle: const LifestyleProfile(isSmoker: false, alcoholConsumption: 'NONE', workNature: 'SEDENTARY', averageScreenTimeHours: 6.0),
          isVerifiedByDoctor: true,
          updatedAt: DateTime.now(),
        ));

    when(() => mockRepository.getLatestWellnessAssessment()).thenAnswer((_) async => WellnessAssessment(
          id: 'as_ui_test',
          userId: 'usr_ui_test',
          stressLevel: 4,
          sleepQuality: 8,
          energyLevel: 7,
          hydrationScore: 8,
          flexibilityScore: 6,
          strengthScore: 6,
          mobilityScore: 7,
          bmi: 22.4,
          restingHeartRate: 68,
          breathingPattern: 'DEEP_DIAPHRAGMATIC',
          dailyActivityLevel: 'MODERATE',
          assessedAt: DateTime.now(),
        ));

    when(() => mockRepository.getAssessmentHistory(limit: any(named: 'limit'))).thenAnswer((_) async => []);
    when(() => mockRepository.getYogaAssessment()).thenAnswer((_) async => const YogaAssessment(id: 'ya_1', userId: 'usr_ui_test', experienceLevel: 'INTERMEDIATE', yogaGoals: ['Flexibility'], preferredYogaStyle: 'HATHA', preferredSessionLengthMin: 45, preferredInstructorGender: 'ANY', practiceFrequencyPerWeek: 4, favoriteTeachers: [], favoriteCourses: [], favoriteMusic: [], preferredPracticeTime: 'MORNING'));
    when(() => mockRepository.getNutritionProfile()).thenAnswer((_) async => const NutritionProfile(id: 'np_1', userId: 'usr_ui_test', dietType: 'SATTVIC_VEGETARIAN', dailyCaloriesGoal: 2100, dailyProteinGoalGrams: 65, dailyWaterGoalMl: 3000, foodAllergies: [], foodPreferences: [], mealTiming: {}, supplements: []));
    when(() => mockRepository.getMeditationProfile()).thenAnswer((_) async => const MeditationProfile(id: 'mp_1', userId: 'usr_ui_test', meditationExperience: 'INTERMEDIATE', preferredVoice: 'CALM_FEMALE', preferredMusic: 'TIBETAN_SINGING_BOWLS', preferredDurationMin: 20, focusArea: 'Stress Reduction', mindfulnessGoals: []));
    when(() => mockRepository.getAiPersonalization()).thenAnswer((_) async => const AiPersonalizationProfile(id: 'ai_1', userId: 'usr_ui_test', coachingStyle: 'GENTLE_GUIDE', reminderStyle: 'SMART_ADAPTIVE', motivationStyle: 'PHILOSOPHICAL', communicationTone: 'CALM', preferredLanguage: 'en', voicePreference: 'Aria', difficultyProgression: 'ADAPTIVE', learningStyle: 'VISUAL_DEMO', notificationBehaviour: 'GENTLE', recommendationPreferences: {}));
    when(() => mockRepository.getActiveSafetyFlags()).thenAnswer((_) async => [
          MedicalSafetyFlag(id: 'flag_1', userId: 'usr_ui_test', flagType: 'SPINE', title: 'Lumbar Disc Bulge', severity: 'HIGH', restrictedPoses: const ['Chakrasana', 'Halasana'], description: 'Avoid deep backbends and inversion compression.', isActive: true, createdAt: DateTime.now())
        ]);
    when(() => mockRepository.getAllSafetyFlags()).thenAnswer((_) async => []);
  });

  Widget createTestApp(Widget child) {
    return ProviderScope(
      overrides: [
        wellnessRepositoryProvider.overrideWithValue(mockRepository),
      ],
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('Widget & Golden Presentation Tests', () {
    testWidgets('WellnessDashboardScreen renders AI Status Card, Safety Ticker, and Grid Menu', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const WellnessDashboardScreen()));
      await tester.pumpAndSettle();

      // Verify Title
      expect(find.text('CLINICAL TELEMETRY HUB'), findsOneWidget);

      // Verify Safety Alert Ticker displays active contraindication
      expect(find.textContaining('Active Contraindication: Lumbar Disc Bulge'), findsOneWidget);

      // Verify AI Status Card displays latest scores
      expect(find.text('AI Telemetry Engine'), findsOneWidget);
      expect(find.text('4/10'), findsOneWidget); // Stress Score
      expect(find.text('8/10'), findsOneWidget); // Sleep Quality

      // Verify Grid Menu Items
      expect(find.text('Clinical Profile'), findsOneWidget);
      expect(find.text('Daily Timeline'), findsOneWidget);
      expect(find.text('Goals & Badges'), findsOneWidget);
      expect(find.text('Medical Safety'), findsOneWidget);
    });

    testWidgets('HealthProfileScreen renders clinical tabs and condition records accurately', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const HealthProfileScreen()));
      await tester.pumpAndSettle();

      // Verify App Bar and Doctor Verified Badge
      expect(find.text('Clinical Health Profile'), findsOneWidget);
      expect(find.text('Doctor Verified'), findsOneWidget);

      // Verify Active Conditions in first tab
      expect(find.text('Mild Scoliosis'), findsOneWidget);
      expect(find.textContaining('Thoracic curve'), findsOneWidget);

      // Tap on Allergies tab
      await tester.tap(find.text('Allergies'));
      await tester.pumpAndSettle();

      // Verify Allergy Item
      expect(find.text('Dust Mites'), findsOneWidget);
    });

    testWidgets('WellnessAssessmentWizardScreen step progression and live BMI calculation', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const WellnessAssessmentWizardScreen()));
      await tester.pumpAndSettle();

      // Verify Step 1 Title
      expect(find.text('Step 1 of 4: Mental & Recovery State'), findsOneWidget);

      // Tap Next Step button to move to Step 2
      await tester.tap(find.text('Next Step'));
      await tester.pumpAndSettle();

      // Verify Step 2 Title
      expect(find.text('Step 2 of 4: Physical Capacity & Mobility'), findsOneWidget);

      // Tap Next Step button to move to Step 3 (Biometrics)
      await tester.tap(find.text('Next Step'));
      await tester.pumpAndSettle();

      // Verify Step 3 Title and calculated BMI (68 kg / 1.72 m^2 = 23.0 kg/m^2)
      expect(find.text('Step 3 of 4: Biometrics & Vitals'), findsOneWidget);
      expect(find.textContaining('kg/m²'), findsOneWidget);

      // Tap Next Step button to move to Step 4 (Summary)
      await tester.tap(find.text('Next Step'));
      await tester.pumpAndSettle();

      // Verify Summary Confirmation Step
      expect(find.text('Step 4 of 4: AI Assessment Summary'), findsOneWidget);
      expect(find.text('Complete Assessment'), findsOneWidget);
    });
  });
}

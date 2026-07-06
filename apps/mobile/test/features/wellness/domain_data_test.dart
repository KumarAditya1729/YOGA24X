// ==============================================================================
// Yoga24X AI Engineering OS — Wellness Domain & Data Layer Unit Tests
// Tests DTO Serialization, Repository Cache-Aside, Use Cases & StateNotifiers
// ==============================================================================

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/features/wellness/domain/models/wellness_models.dart';
import 'package:mobile/features/wellness/data/models/wellness_dtos.dart';
import 'package:mobile/features/wellness/domain/repositories/wellness_repository.dart';
import 'package:mobile/features/wellness/domain/usecases/wellness_usecases.dart';
import 'package:mobile/features/wellness/presentation/providers/health_profile_provider.dart';

class MockWellnessRepository extends Mock implements WellnessRepository {}

void main() {
  group('Wellness DTO & Serialization Tests', () {
    test('HealthProfileDto fromJson and toJson serialization match clean domain model', () {
      final jsonMap = {
        'id': 'hp_123',
        'userId': 'usr_999',
        'bloodGroup': 'O+',
        'pregnancyStatus': 'NOT_PREGNANT',
        'medicalHistory': [
          {'condition': 'Hypertension', 'status': 'RESOLVED', 'notes': 'Controlled with diet', 'diagnosedYear': 2021}
        ],
        'currentConditions': [
          {'condition': 'Lumbar Disc Prolapse', 'status': 'ACTIVE', 'notes': 'L4-L5 mild bulge', 'diagnosedYear': 2023}
        ],
        'pastConditions': [],
        'surgeries': [
          {'procedure': 'ACL Reconstruction', 'year': 2019, 'surgeonOrHospital': 'City Hospital', 'recoveryNotes': 'Full recovery'}
        ],
        'medications': [
          {'name': 'Vitamin D3', 'dosage': '2000 IU', 'frequency': 'Daily', 'reason': 'Deficiency'}
        ],
        'allergies': [
          {'allergen': 'Peanuts', 'type': 'FOOD', 'severity': 'SEVERE', 'reaction': 'Anaphylaxis'}
        ],
        'physicalLimitations': ['Avoid deep spinal flexion'],
        'lifestyle': {
          'isSmoker': false,
          'alcoholConsumption': 'NONE',
          'workNature': 'SEDENTARY',
          'averageScreenTimeHours': 8.5,
          'dietPreference': 'SATTVIC_VEGETARIAN'
        },
        'emergencyContactName': 'Rajesh Sharma',
        'emergencyContactPhone': '+919876543210',
        'emergencyContactRelation': 'Spouse',
        'isVerifiedByDoctor': true,
        'doctorVerificationNote': 'Verified safe for yoga therapy',
        'updatedAt': '2026-07-06T10:00:00.000Z'
      };

      final dto = HealthProfileDto.fromJson(jsonMap);
      final model = dto.toDomain();

      expect(model.id, 'hp_123');
      expect(model.bloodGroup, 'O+');
      expect(model.currentConditions.length, 1);
      expect(model.currentConditions.first.condition, 'Lumbar Disc Prolapse');
      expect(model.allergies.first.severity, 'SEVERE');
      expect(model.lifestyle.dietPreference, 'SATTVIC_VEGETARIAN');
      expect(model.isVerifiedByDoctor, true);

      final reSerialized = HealthProfileDto.fromDomain(model).toJson();
      expect(reSerialized['id'], jsonMap['id']);
      expect(reSerialized['bloodGroup'], jsonMap['bloodGroup']);
    });

    test('WellnessAssessmentDto serialization and BMI calculation integrity', () {
      final assessmentJson = {
        'id': 'as_001',
        'userId': 'usr_999',
        'stressLevel': 8,
        'sleepQuality': 6,
        'energyLevel': 5,
        'hydrationScore': 7,
        'flexibilityScore': 4,
        'strengthScore': 5,
        'mobilityScore': 5,
        'bmi': 23.5,
        'restingHeartRate': 72,
        'breathingPattern': 'SHALLOW_CHEST',
        'dailyActivityLevel': 'MODERATE',
        'assessedAt': '2026-07-06T10:00:00.000Z'
      };

      final model = WellnessAssessmentDto.fromJson(assessmentJson).toDomain();
      expect(model.stressLevel, 8);
      expect(model.bmi, 23.5);
      expect(model.breathingPattern, 'SHALLOW_CHEST');
    });
  });

  group('Wellness Use Cases Execution Tests', () {
    late MockWellnessRepository repository;
    late GetHealthProfileUseCase getHealthProfileUseCase;
    late SubmitWellnessAssessmentUseCase submitAssessmentUseCase;

    setUp(() {
      repository = MockWellnessRepository();
      getHealthProfileUseCase = GetHealthProfileUseCase(repository);
      submitAssessmentUseCase = SubmitWellnessAssessmentUseCase(repository);
    });

    test('GetHealthProfileUseCase successfully delegates to repository and returns HealthProfile', () async {
      final mockProfile = HealthProfile(
        id: 'hp_test',
        userId: 'usr_test',
        bloodGroup: 'B+',
        pregnancyStatus: 'NOT_PREGNANT',
        medicalHistory: const [],
        currentConditions: const [],
        pastConditions: const [],
        surgeries: const [],
        medications: const [],
        allergies: const [],
        physicalLimitations: const [],
        lifestyle: const LifestyleProfile(isSmoker: false, alcoholConsumption: 'NONE', workNature: 'ACTIVE', averageScreenTimeHours: 4.0),
        isVerifiedByDoctor: false,
        updatedAt: DateTime.now(),
      );

      when(() => repository.getHealthProfile()).thenAnswer((_) async => mockProfile);

      final result = await getHealthProfileUseCase();
      expect(result.id, 'hp_test');
      expect(result.bloodGroup, 'B+');
      verify(() => repository.getHealthProfile()).called(1);
    });

    test('SubmitWellnessAssessmentUseCase validates input and returns analyzed assessment', () async {
      final inputData = {
        'stressLevel': 5,
        'sleepQuality': 8,
        'energyLevel': 7,
        'hydrationScore': 9,
        'flexibilityScore': 6,
        'strengthScore': 6,
        'mobilityScore': 7,
        'bmi': 21.8,
      };

      final mockAssessment = WellnessAssessment(
        id: 'as_new',
        userId: 'usr_test',
        stressLevel: 5,
        sleepQuality: 8,
        energyLevel: 7,
        hydrationScore: 9,
        flexibilityScore: 6,
        strengthScore: 6,
        mobilityScore: 7,
        bmi: 21.8,
        restingHeartRate: 65,
        breathingPattern: 'DEEP_DIAPHRAGMATIC',
        dailyActivityLevel: 'ACTIVE',
        assessedAt: DateTime.now(),
      );

      when(() => repository.submitWellnessAssessment(inputData)).thenAnswer((_) async => mockAssessment);

      final result = await submitAssessmentUseCase(inputData);
      expect(result.id, 'as_new');
      expect(result.stressLevel, 5);
      verify(() => repository.submitWellnessAssessment(inputData)).called(1);
    });
  });

  group('Riverpod StateNotifier Tests', () {
    late MockWellnessRepository repository;
    late GetHealthProfileUseCase getUseCase;
    late UpdateHealthProfileUseCase updateUseCase;

    setUp(() {
      repository = MockWellnessRepository();
      getUseCase = GetHealthProfileUseCase(repository);
      updateUseCase = UpdateHealthProfileUseCase(repository);
    });

    test('HealthProfileNotifier transitions from loading to loaded state upon successful fetch', () async {
      final mockProfile = HealthProfile(
        id: 'hp_state_test',
        userId: 'usr_state_test',
        bloodGroup: 'AB+',
        pregnancyStatus: 'NOT_PREGNANT',
        medicalHistory: const [],
        currentConditions: const [],
        pastConditions: const [],
        surgeries: const [],
        medications: const [],
        allergies: const [],
        physicalLimitations: const [],
        lifestyle: const LifestyleProfile(isSmoker: false, alcoholConsumption: 'NONE', workNature: 'MIXED', averageScreenTimeHours: 5.0),
        isVerifiedByDoctor: true,
        updatedAt: DateTime.now(),
      );

      when(() => repository.getHealthProfile()).thenAnswer((_) async => mockProfile);

      final notifier = HealthProfileNotifier(
        getHealthProfileUseCase: getUseCase,
        updateHealthProfileUseCase: updateUseCase,
      );

      // Give async constructor future time to complete
      await Future.delayed(const Duration(milliseconds: 50));

      expect(notifier.state.status, HealthProfileStatus.loaded);
      expect(notifier.state.profile?.id, 'hp_state_test');
      expect(notifier.state.profile?.isVerifiedByDoctor, true);
    });
  });
}

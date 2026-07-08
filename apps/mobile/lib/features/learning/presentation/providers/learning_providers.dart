
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/learning_repository.dart';
import '../../domain/models/learning_models.dart';

final learningRepositoryProvider = Provider<LearningRepository>((ref) {
  return LearningRepository(ref.watch(dioProvider));
});

final coursesProvider = FutureProvider<List<Course>>((ref) {
  return ref.watch(learningRepositoryProvider).getCourses();
});

final eventsProvider = FutureProvider<List<LearningEvent>>((ref) {
  return ref.watch(learningRepositoryProvider).getEvents();
});

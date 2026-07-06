
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../data/learning_repository.dart';
import '../../domain/models/learning_models.dart';

final learningRepositoryProvider = Provider<LearningRepository>((ref) {
  return LearningRepository(Dio(BaseOptions(baseUrl: 'http://localhost:3000')));
});

final coursesProvider = FutureProvider<List<Course>>((ref) {
  return ref.watch(learningRepositoryProvider).getCourses();
});

final eventsProvider = FutureProvider<List<LearningEvent>>((ref) {
  return ref.watch(learningRepositoryProvider).getEvents();
});

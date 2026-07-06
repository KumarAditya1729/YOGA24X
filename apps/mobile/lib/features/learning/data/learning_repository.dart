
import 'package:dio/dio.dart';
import '../domain/models/learning_models.dart';

class LearningRepository {
  final Dio _dio;
  LearningRepository(this._dio);

  Future<List<Course>> getCourses() async {
    final response = await _dio.get('/api/v1/learning/courses');
    return (response.data as List).map((x) => Course.fromJson(x)).toList();
  }

  Future<List<LearningEvent>> getEvents() async {
    final response = await _dio.get('/api/v1/learning/events');
    return (response.data as List).map((x) => LearningEvent.fromJson(x)).toList();
  }
}

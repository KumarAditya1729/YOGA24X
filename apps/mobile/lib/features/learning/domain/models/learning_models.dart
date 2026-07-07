
import 'package:freezed_annotation/freezed_annotation.dart';

part 'learning_models.freezed.dart';
part 'learning_models.g.dart';

@freezed
class Course with _$Course {
  const factory Course({
    required String id,
    required String title,
    required String description,
    required String visibility,
    required List<String> tags,
    String? thumbnailUrl,
    required int priceCents,
  }) = _Course;
  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
}

@freezed
class LearningEvent with _$LearningEvent {
  const factory LearningEvent({
    required String id,
    required String title,
    required String eventType,
    required DateTime scheduledStartAt,
    required DateTime scheduledEndAt,
    required int capacity,
    String? meetingUrl,
  }) = _LearningEvent;
  factory LearningEvent.fromJson(Map<String, dynamic> json) => _$LearningEventFromJson(json);
}

@freezed
class TeacherPublication with _$TeacherPublication {
  const factory TeacherPublication({
    required String id,
    required String title,
    required String publicationType,
    String? contentBody,
    String? assetUrl,
  }) = _TeacherPublication;
  factory TeacherPublication.fromJson(Map<String, dynamic> json) => _$TeacherPublicationFromJson(json);
}

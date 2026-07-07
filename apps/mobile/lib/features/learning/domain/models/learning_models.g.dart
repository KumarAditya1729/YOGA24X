// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourseImpl _$$CourseImplFromJson(Map<String, dynamic> json) => _$CourseImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      visibility: json['visibility'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      priceCents: (json['priceCents'] as num).toInt(),
    );

Map<String, dynamic> _$$CourseImplToJson(_$CourseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'visibility': instance.visibility,
      'tags': instance.tags,
      'thumbnailUrl': instance.thumbnailUrl,
      'priceCents': instance.priceCents,
    };

_$LearningEventImpl _$$LearningEventImplFromJson(Map<String, dynamic> json) =>
    _$LearningEventImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      eventType: json['eventType'] as String,
      scheduledStartAt: DateTime.parse(json['scheduledStartAt'] as String),
      scheduledEndAt: DateTime.parse(json['scheduledEndAt'] as String),
      capacity: (json['capacity'] as num).toInt(),
      meetingUrl: json['meetingUrl'] as String?,
    );

Map<String, dynamic> _$$LearningEventImplToJson(_$LearningEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'eventType': instance.eventType,
      'scheduledStartAt': instance.scheduledStartAt.toIso8601String(),
      'scheduledEndAt': instance.scheduledEndAt.toIso8601String(),
      'capacity': instance.capacity,
      'meetingUrl': instance.meetingUrl,
    };

_$TeacherPublicationImpl _$$TeacherPublicationImplFromJson(
        Map<String, dynamic> json) =>
    _$TeacherPublicationImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      publicationType: json['publicationType'] as String,
      contentBody: json['contentBody'] as String?,
      assetUrl: json['assetUrl'] as String?,
    );

Map<String, dynamic> _$$TeacherPublicationImplToJson(
        _$TeacherPublicationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'publicationType': instance.publicationType,
      'contentBody': instance.contentBody,
      'assetUrl': instance.assetUrl,
    };

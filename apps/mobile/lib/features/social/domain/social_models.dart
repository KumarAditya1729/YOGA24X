import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_models.freezed.dart';
part 'social_models.g.dart';

@freezed
class CommunityPost with _$CommunityPost {
  const factory CommunityPost({
    required String id,
    required String authorId,
    required String postType,
    String? title,
    String? contentText,
    @Default([]) List<String> mediaAssetIds,
    @Default(0) int likesCount,
    @Default(0) int commentsCount,
    String? groupId,
    required DateTime createdAt,
  }) = _CommunityPost;

  factory CommunityPost.fromJson(Map<String, dynamic> json) => _$CommunityPostFromJson(json);
}

@freezed
class CommunityGroup with _$CommunityGroup {
  const factory CommunityGroup({
    required String id,
    required String name,
    String? description,
    required String groupType,
    @Default(0) int memberCount,
  }) = _CommunityGroup;

  factory CommunityGroup.fromJson(Map<String, dynamic> json) => _$CommunityGroupFromJson(json);
}

@freezed
class ChatConversation with _$ChatConversation {
  const factory ChatConversation({
    required String id,
    required String chatType,
    String? name,
    required DateTime updatedAt,
  }) = _ChatConversation;

  factory ChatConversation.fromJson(Map<String, dynamic> json) => _$ChatConversationFromJson(json);
}

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String conversationId,
    required String senderId,
    String? contentText,
    String? attachmentUrl,
    required DateTime createdAt,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}

@freezed
class Challenge with _$Challenge {
  const factory Challenge({
    required String id,
    required String title,
    String? description,
    required String challengeType,
    required DateTime startDate,
    required DateTime endDate,
    @Default(0) int rewardsXp,
  }) = _Challenge;

  factory Challenge.fromJson(Map<String, dynamic> json) => _$ChallengeFromJson(json);
}

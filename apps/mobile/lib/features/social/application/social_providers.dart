import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../domain/social_models.dart';

final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return SocialRepository(dio);
});

class SocialRepository {
  final Dio _dio;
  SocialRepository(this._dio);

  Future<List<CommunityPost>> getGlobalFeed() async {
    final response = await _dio.get('/api/v1/social/feed');
    return (response.data as List).map((x) => CommunityPost.fromJson(x)).toList();
  }

  Future<List<CommunityGroup>> getGroups() async {
    final response = await _dio.get('/api/v1/social/groups');
    return (response.data as List).map((x) => CommunityGroup.fromJson(x)).toList();
  }

  Future<List<ChatConversation>> getConversations() async {
    final response = await _dio.get('/api/v1/chat/conversations');
    return (response.data as List).map((x) => ChatConversation.fromJson(x)).toList();
  }

  Future<List<Challenge>> getActiveChallenges() async {
    final response = await _dio.get('/api/v1/challenges/active');
    return (response.data as List).map((x) => Challenge.fromJson(x)).toList();
  }
}

final globalFeedProvider = FutureProvider.autoDispose<List<CommunityPost>>((ref) {
  final repo = ref.watch(socialRepositoryProvider);
  return repo.getGlobalFeed();
});

final communityGroupsProvider = FutureProvider.autoDispose<List<CommunityGroup>>((ref) {
  final repo = ref.watch(socialRepositoryProvider);
  return repo.getGroups();
});

final chatConversationsProvider = FutureProvider.autoDispose<List<ChatConversation>>((ref) {
  final repo = ref.watch(socialRepositoryProvider);
  return repo.getConversations();
});

final activeChallengesProvider = FutureProvider.autoDispose<List<Challenge>>((ref) {
  final repo = ref.watch(socialRepositoryProvider);
  return repo.getActiveChallenges();
});

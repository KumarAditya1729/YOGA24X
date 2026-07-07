import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../auth/presentation/providers/auth_providers.dart';

final aiProvider = StateNotifierProvider<AiNotifier, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final dio = ref.watch(dioProvider);
  return AiNotifier(dio: dio);
});

class AiNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final Dio dio;
  
  AiNotifier({required this.dio}) : super(const AsyncValue.data([]));

  Future<void> sendMessage(String conversationId, String message) async {
    // Optimistic UI update
    final currentMessages = state.value ?? [];
    state = AsyncValue.data([
      ...currentMessages,
      {'role': 'user', 'content': message}
    ]);

    try {
      final response = await dio.post(
        '/api/v1/ai/chat',
        data: {
          'conversationId': conversationId,
          'message': message,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        state = AsyncValue.data([
          ...state.value ?? [],
          {'role': 'assistant', 'content': response.data['content']}
        ]);
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

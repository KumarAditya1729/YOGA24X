import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../auth/providers/auth_provider.dart';

final aiProvider = StateNotifierProvider<AiNotifier, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final token = ref.watch(authProvider).valueOrNull?.token;
  return AiNotifier(token: token);
});

class AiNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final String? token;
  
  AiNotifier({this.token}) : super(const AsyncValue.data([]));

  Future<void> sendMessage(String conversationId, String message) async {
    if (token == null) return;

    // Optimistic UI update
    final currentMessages = state.value ?? [];
    state = AsyncValue.data([
      ...currentMessages,
      {'role': 'user', 'content': message}
    ]);

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/v1/ai/chat'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'conversationId': conversationId,
          'message': message,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        state = AsyncValue.data([
          ...state.value ?? [],
          {'role': 'assistant', 'content': data['content']}
        ]);
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

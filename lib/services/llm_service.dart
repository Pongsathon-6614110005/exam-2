import 'package:dio/dio.dart';
import 'package:smart_vision_journal/features/note/data/models/llm_response_model.dart';

class LlmService {
  final Dio dio;
  final String apiKey;
  final String model;

  LlmService(
    this.dio, {
    required this.apiKey,
    required this.model,
  });

  Future<String> summarize(String text) async {
    final response = await dio.post(
      '/v1beta/models/$model:generateContent',
      data: {
        'contents': [
          {
            'parts': [
              {
                'text': 'Summarize the following text:\n$text',
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.2,
          'maxOutputTokens': 256,
        },
      },
    );

    final parsed = GeminiResponse.fromJson(response.data as Map<String, dynamic>);
    var output = parsed.candidates?.first.output?.trim();

    if (output == null || output.isEmpty) {
      // Fallback: try other common response shapes from Gemini-like APIs.
      final data = response.data as Map<String, dynamic>;
      final candidates = data['candidates'] as List<dynamic>?;
      if (candidates != null && candidates.isNotEmpty) {
        final first = candidates.first as Map<String, dynamic>;

        // Gemini may return `output`, or it may return `content.parts[].text`.
        output = (first['output'] as String?)?.trim();

        if (output == null || output.isEmpty) {
          final content = first['content'] as Map<String, dynamic>?;
          final parts = content?['parts'] as List<dynamic>?;
          if (parts != null && parts.isNotEmpty) {
            output = (parts.first['text'] as String?)?.trim();
          }
        }

        // Some Gemini responses nest the text in a `message` field.
        final message = first['message'];
        if ((output == null || output.isEmpty) && message is Map<String, dynamic>) {
          output = (message['content'] as String?)?.trim();
        }
      }
    }

    return output ?? '';
  }
}

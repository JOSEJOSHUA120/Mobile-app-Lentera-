import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';

class GeminiService {
  const GeminiService();

  Future<String> ask(String question) async {
    if (!AppConfig.hasGeminiApiKey) {
      throw Exception('Mode AI belum dapat digunakan karena Gemini API key belum diatur.');
    }

    final uri = Uri.https(
      'generativelanguage.googleapis.com',
      '/v1beta/models/${AppConfig.geminiModel}:generateContent',
      {'key': AppConfig.geminiApiKey},
    );

    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {
                    'text':
                        'Jawab dalam bahasa Indonesia dengan singkat, jelas, dan mudah didengar oleh pengguna tunanetra. Pertanyaan: $question',
                  },
                ],
              },
            ],
          }),
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Pertanyaan belum dapat diproses oleh Gemini.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = data['candidates'] as List<dynamic>?;
    final content = candidates?.firstOrNull?['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>?;
    final text = parts?.firstOrNull?['text']?.toString();

    if (text == null || text.trim().isEmpty) {
      throw Exception('Gemini tidak memberikan jawaban.');
    }

    return text.trim();
  }
}

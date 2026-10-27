import 'dart:convert';

import 'package:http/http.dart' as http;

import '../generated/protocol.dart';
import 'gemini_service.dart';

/// Fallback LLM provider (Groq, OpenAI-compatible API). Groq has no embedding
/// models, so it covers recaps and an LLM-judged duplicate check.
class GroqService {
  static const _url = 'https://api.groq.com/openai/v1/chat/completions';

  final String apiKey;
  final String model;

  GroqService({required this.apiKey, this.model = 'openai/gpt-oss-120b'});

  Future<Map<String, dynamic>> _chatJson(String prompt) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'model': model,
        'response_format': {'type': 'json_object'},
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      }),
    );
    if (response.statusCode != 200) {
      throw StateError(
        'Groq request failed (${response.statusCode}): ${response.body}',
      );
    }
    final data = json.decode(response.body) as Map<String, dynamic>;
    final content = data['choices'][0]['message']['content'] as String;
    return json.decode(content) as Map<String, dynamic>;
  }

  Future<RecapResult> generateRecap(
    String title,
    List<Question> questions,
  ) async {
    final parsed = await _chatJson(recapPrompt(title, questions));
    return parseRecapJson(json.encode(parsed));
  }

  /// Returns the question in [candidates] that [text] duplicates, or null.
  /// Used only when embeddings are unavailable.
  Future<Question?> findDuplicate(
    String text,
    List<Question> candidates,
  ) async {
    if (candidates.isEmpty) return null;
    final list = [
      for (var i = 0; i < candidates.length; i++) '$i: ${candidates[i].text}',
    ].join('\n');
    final parsed = await _chatJson('''
A new audience question was submitted. Decide whether it asks essentially the
same thing as one of the existing questions (same intent, different wording).

New question: "$text"

Existing questions:
$list

Return JSON: {"duplicate_of": <index of the matching existing question, or null if none>}
''');
    final index = parsed['duplicate_of'];
    if (index is int && index >= 0 && index < candidates.length) {
      return candidates[index];
    }
    return null;
  }
}

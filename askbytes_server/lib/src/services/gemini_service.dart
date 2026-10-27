import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

import '../generated/protocol.dart';

/// The structured result of an AI recap.
class RecapResult {
  final String markdown;
  final List<String> themes;
  final List<String> unanswered;

  RecapResult({
    required this.markdown,
    required this.themes,
    required this.unanswered,
  });
}

/// Prompt shared by every provider that can write a recap.
String recapPrompt(String title, List<Question> questions) {
  final questionsText = questions
      .map((q) => '[${q.voteCount} votes] ${q.text}')
      .join('\n');
  return '''
You are summarizing audience Q&A from the conference talk "$title".
Questions (sorted by votes):
$questionsText

Return JSON with exactly these keys:
- "themes": 3-5 short theme tags (strings)
- "markdown": a concise recap in markdown (under 400 words) with sections
  "Key Themes", "Top 5 Questions" (with vote counts) and "Needs Follow-up"
- "unanswered": up to 5 question texts that likely need a follow-up answer
''';
}

/// Parses the JSON a model returned for [recapPrompt].
RecapResult parseRecapJson(String text) {
  final parsed = json.decode(text) as Map<String, dynamic>;
  return RecapResult(
    markdown: parsed['markdown'] as String,
    themes: List<String>.from(parsed['themes'] ?? const []),
    unanswered: List<String>.from(parsed['unanswered'] ?? const []),
  );
}

/// Server-side Gemini client. The API key never leaves the server.
class GeminiService {
  static const _base =
      'https://generativelanguage.googleapis.com/v1beta/models';
  static const embeddingDimensions = 768;

  final String apiKey;
  final String generationModel;
  final String embeddingModel;

  GeminiService({
    required this.apiKey,
    this.generationModel = 'gemini-2.5-flash',
    this.embeddingModel = 'gemini-embedding-001',
  });

  /// Builds a service for [key], optionally overriding the generation model.
  factory GeminiService.fromKey(String key, {String? model}) => GeminiService(
    apiKey: key,
    generationModel: model ?? 'gemini-2.5-flash',
  );

  /// Embeds [text] into a 768-dim vector.
  Future<List<double>> embedText(String text) async {
    final response = await http.post(
      Uri.parse('$_base/$embeddingModel:embedContent'),
      headers: {'Content-Type': 'application/json', 'x-goog-api-key': apiKey},
      body: json.encode({
        'model': 'models/$embeddingModel',
        'content': {
          'parts': [
            {'text': text},
          ],
        },
        'taskType': 'SEMANTIC_SIMILARITY',
        'outputDimensionality': embeddingDimensions,
      }),
    );
    if (response.statusCode != 200) {
      throw StateError(
        'Gemini embed failed (${response.statusCode}): '
        '${response.body}',
      );
    }
    final data = json.decode(response.body) as Map<String, dynamic>;
    final values = List<double>.from(
      (data['embedding']['values'] as List).map((v) => (v as num).toDouble()),
    );
    return _normalize(values);
  }

  /// Generates a structured recap from the session's questions.
  Future<RecapResult> generateRecap(
    String title,
    List<Question> questions,
  ) async {
    final prompt = recapPrompt(title, questions);
    final response = await http.post(
      Uri.parse('$_base/$generationModel:generateContent'),
      headers: {'Content-Type': 'application/json', 'x-goog-api-key': apiKey},
      body: json.encode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
        'generationConfig': {'responseMimeType': 'application/json'},
      }),
    );
    if (response.statusCode != 200) {
      throw StateError(
        'Gemini generate failed (${response.statusCode}): '
        '${response.body}',
      );
    }
    final data = json.decode(response.body) as Map<String, dynamic>;
    final text = data['candidates'][0]['content']['parts'][0]['text'] as String;
    return parseRecapJson(text);
  }

  static List<double> _normalize(List<double> v) {
    var sum = 0.0;
    for (final x in v) {
      sum += x * x;
    }
    if (sum == 0) return v;
    final norm = math.sqrt(sum);
    return [for (final x in v) x / norm];
  }
}

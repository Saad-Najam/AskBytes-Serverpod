// Live checks against the real AI providers. Skipped unless the keys are set:
//   GEMINI_API_KEY=... GROQ_API_KEY=... dart test test/ai_live_test.dart
import 'dart:io';
import 'dart:math' as math;

import 'package:askbytes_server/src/generated/protocol.dart';
import 'package:askbytes_server/src/services/gemini_service.dart';
import 'package:askbytes_server/src/services/groq_service.dart';
import 'package:test/test.dart';

double cosine(List<double> a, List<double> b) {
  var dot = 0.0, na = 0.0, nb = 0.0;
  for (var i = 0; i < a.length; i++) {
    dot += a[i] * b[i];
    na += a[i] * a[i];
    nb += b[i] * b[i];
  }
  return dot / (math.sqrt(na) * math.sqrt(nb));
}

void main() {
  final geminiKey = Platform.environment['GEMINI_API_KEY'];
  final groqKey = Platform.environment['GROQ_API_KEY'];

  final questions = [
    Question(
      id: 1,
      sessionId: 1,
      text: 'How does Serverpod handle state in streaming methods?',
      voteCount: 5,
      postedById: 'a',
      createdAt: DateTime.now(),
    ),
    Question(
      id: 2,
      sessionId: 1,
      text: 'Will there be a recording of this talk?',
      voteCount: 2,
      postedById: 'b',
      createdAt: DateTime.now(),
    ),
  ];

  group('Gemini', () {
    test(
      'similar questions clear the 0.88 dedup threshold, unrelated do not',
      () async {
        final g = GeminiService(apiKey: geminiKey!);
        final a = await g.embedText(
          'How does Serverpod handle state in streaming methods?',
        );
        final b = await g.embedText(
          "What's the best way to manage state with Serverpod streams?",
        );
        final c = await g.embedText('Will there be a recording of this talk?');
        expect(a, hasLength(768));
        // ignore: avoid_print
        print(
          'similar=${cosine(a, b).toStringAsFixed(3)} '
          'unrelated=${cosine(a, c).toStringAsFixed(3)}',
        );
        expect(cosine(a, b), greaterThan(0.88));
        expect(cosine(a, c), lessThan(0.88));
      },
    );

    test('writes a structured recap', () async {
      final r = await GeminiService(
        apiKey: geminiKey!,
      ).generateRecap('Serverpod Workshop', questions);
      expect(r.markdown, isNotEmpty);
      expect(r.themes, isNotEmpty);
    });
  }, skip: geminiKey == null ? 'GEMINI_API_KEY not set' : false);

  group('Groq fallback', () {
    test('writes a structured recap', () async {
      final r = await GroqService(
        apiKey: groqKey!,
      ).generateRecap('Serverpod Workshop', questions);
      expect(r.markdown, isNotEmpty);
      expect(r.themes, isNotEmpty);
    });

    test('judges duplicates without embeddings', () async {
      final groq = GroqService(apiKey: groqKey!);
      final dup = await groq.findDuplicate(
        "What's the best way to manage state with Serverpod streams?",
        questions,
      );
      expect(dup?.id, 1);
      final none = await groq.findDuplicate(
        'Which database does Serverpod support?',
        questions,
      );
      expect(none, isNull);
    });
  }, skip: groqKey == null ? 'GROQ_API_KEY not set' : false);
}

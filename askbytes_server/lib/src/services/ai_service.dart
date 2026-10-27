import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'gemini_service.dart';
import 'groq_service.dart';

/// Facade over the AI providers: Gemini first, Groq as the fallback. Every
/// method degrades gracefully so a provider outage never blocks the Q&A flow.
class AiService {
  final Session _session;
  final GeminiService? gemini;
  final GroqService? groq;

  AiService._(this._session, this.gemini, this.groq);

  factory AiService.fromSession(Session session) {
    final geminiKey = session.passwords['geminiApiKey'];
    final groqKey = session.passwords['groqApiKey'];
    return AiService._(
      session,
      (geminiKey == null || geminiKey.isEmpty)
          ? null
          : GeminiService.fromKey(
              geminiKey,
              model: session.passwords['geminiModel'],
            ),
      (groqKey == null || groqKey.isEmpty)
          ? null
          : GroqService(
              apiKey: groqKey,
              model: session.passwords['groqModel'] ?? 'openai/gpt-oss-120b',
            ),
    );
  }

  bool get hasAnyProvider => gemini != null || groq != null;

  /// Embedding for semantic search, or null if embeddings are unavailable
  /// (Groq cannot embed, so only Gemini serves this).
  Future<List<double>?> embed(String text) async {
    if (gemini == null) return null;
    try {
      return await gemini!.embedText(text);
    } catch (e, st) {
      _warn('Gemini embedding failed', e, st);
      return null;
    }
  }

  /// Recap from Gemini, falling back to Groq. Throws if neither works.
  Future<RecapResult> recap(String title, List<Question> questions) async {
    Object? lastError;
    if (gemini != null) {
      try {
        return await gemini!.generateRecap(title, questions);
      } catch (e, st) {
        lastError = e;
        _warn('Gemini recap failed, trying Groq', e, st);
      }
    }
    if (groq != null) {
      return groq!.generateRecap(title, questions);
    }
    throw lastError ?? StateError('No AI provider configured');
  }

  /// LLM-judged duplicate lookup, used when embeddings could not be computed.
  Future<Question?> findDuplicateWithLlm(
    String text,
    List<Question> candidates,
  ) async {
    if (groq == null) return null;
    try {
      return await groq!.findDuplicate(text, candidates);
    } catch (e, st) {
      _warn('Groq duplicate check failed', e, st);
      return null;
    }
  }

  void _warn(String message, Object e, StackTrace st) {
    _session.log(
      '$message: $e',
      level: LogLevel.warning,
      stackTrace: st,
    );
  }
}

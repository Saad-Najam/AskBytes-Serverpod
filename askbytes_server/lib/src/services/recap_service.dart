import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'ai_service.dart';
import 'gemini_service.dart';
import 'live_channel.dart';

/// Generates (or regenerates) the recap for [talk], saves it and broadcasts it.
Future<SessionRecap> generateAndSaveRecap(
  Session session,
  TalkSession talk,
) async {
  final questions = await Question.db.find(
    session,
    where: (t) => t.sessionId.equals(talk.id!),
    orderBy: (t) => t.voteCount.desc(),
  );

  final top = questions.take(5).toList();
  final topJson = json.encode([
    for (final q in top) {'text': q.text, 'votes': q.voteCount},
  ]);

  RecapResult result;
  try {
    if (questions.isEmpty) throw StateError('No questions to summarize');
    result = await AiService.fromSession(session).recap(talk.title, questions);
  } catch (e, st) {
    session.log(
      'Recap generation fell back to a plain summary: $e',
      level: LogLevel.warning,
      stackTrace: st,
    );
    result = _fallbackRecap(questions);
  }

  final existing = await SessionRecap.db.findFirstRow(
    session,
    where: (t) => t.sessionId.equals(talk.id!),
  );
  var recap = SessionRecap(
    id: existing?.id,
    sessionId: talk.id!,
    summaryMarkdown: result.markdown,
    keyThemes: result.themes,
    topQuestions: topJson,
    unanswered: result.unanswered,
    generatedAt: DateTime.now(),
  );
  recap = existing == null
      ? await SessionRecap.db.insertRow(session, recap)
      : await SessionRecap.db.updateRow(session, recap);

  await broadcast(
    session,
    talk.id!,
    LiveUpdate(type: LiveUpdateType.recapReady, recap: recap),
  );
  return recap;
}

RecapResult _fallbackRecap(List<Question> questions) {
  final buf = StringBuffer('## Key Themes\n');
  buf.writeln(
    questions.isEmpty
        ? 'No questions were asked in this session.'
        : 'See the top questions below.',
  );
  buf.writeln('\n## Top 5 Questions');
  for (final q in questions.take(5)) {
    buf.writeln('- ${q.text} (${q.voteCount} votes)');
  }
  return RecapResult(
    markdown: buf.toString(),
    themes: const [],
    unanswered: [for (final q in questions.skip(5).take(3)) q.text],
  );
}

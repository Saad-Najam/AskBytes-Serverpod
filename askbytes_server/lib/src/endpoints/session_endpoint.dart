import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/auth_helpers.dart';
import '../services/live_channel.dart';
import '../services/session_lifecycle.dart';

/// Manages the lifecycle of a talk session and streams live updates.
class SessionEndpoint extends Endpoint {
  // No ambiguous characters (0/O, 1/I) so codes are easy to type from a slide.
  static const _codeAlphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static final _random = Random.secure();

  /// Creates a session owned by the signed-in speaker.
  Future<TalkSession> createSession(
    Session session, {
    required String title,
    required String speakerName,
    String? description,
    int? durationMinutes,
    bool? autoEnd,
  }) async {
    final speakerId = await requireSpeaker(session);
    title = title.trim();
    speakerName = speakerName.trim();
    if (title.isEmpty || speakerName.isEmpty) {
      throw AskBytesException(message: 'Title and speaker name are required.');
    }
    final desc = description?.trim();

    for (var attempt = 0; attempt < 8; attempt++) {
      final code = List.generate(
        6,
        (_) => _codeAlphabet[_random.nextInt(_codeAlphabet.length)],
      ).join();
      final taken = await TalkSession.db.findFirstRow(
        session,
        where: (t) => t.joinCode.equals(code),
      );
      if (taken != null) continue;
      final created = await TalkSession.db.insertRow(
        session,
        TalkSession(
          title: title,
          speakerName: speakerName,
          description: (desc == null || desc.isEmpty) ? null : desc,
          durationMinutes: durationMinutes,
          speakerId: speakerId,
          joinCode: code,
        ),
      );
      // Opt-in: the session ends itself (and writes the recap) when time is up.
      if (autoEnd == true && durationMinutes != null && durationMinutes > 0) {
        final scheduled = await scheduleAutoEnd(
          session,
          created.id!,
          Duration(minutes: durationMinutes),
        );
        return created.copyWith(autoEndScheduled: scheduled);
      }
      return created;
    }
    throw AskBytesException(message: 'Could not create a join code. Retry.');
  }

  /// Public: session by join code with its questions sorted by votes.
  Future<SessionSnapshot> getSession(Session session, String joinCode) async {
    final talk = await _byCode(session, joinCode);
    return _snapshot(session, talk);
  }

  /// Public: session by id (used by manage, present and recap routes).
  Future<SessionSnapshot> getSessionById(Session session, int sessionId) async {
    final talk = await TalkSession.db.findById(session, sessionId);
    if (talk == null) {
      throw AskBytesException(message: 'Session not found.');
    }
    return _snapshot(session, talk);
  }

  /// Sessions owned by the signed-in speaker, newest first.
  Future<List<TalkSession>> getSpeakerSessions(Session session) async {
    final speakerId = await requireSpeaker(session);
    final sessions = await TalkSession.db.find(
      session,
      where: (t) => t.speakerId.equals(speakerId),
      orderBy: (t) => t.createdAt.desc(),
    );
    final result = <TalkSession>[];
    for (final s in sessions) {
      final count = await Question.db.count(
        session,
        where: (t) => t.sessionId.equals(s.id!),
      );
      result.add(s.copyWith(questionCount: count));
    }
    return result;
  }

  /// Ends the session, locks input, then generates and broadcasts the recap.
  Future<SessionRecap> endSession(Session session, int sessionId) async {
    final talk = await requireOwnedSession(session, sessionId);
    return closeSessionAndRecap(session, talk);
  }

  /// Public aggregate numbers for a session (shown on the recap).
  Future<SessionStats> getStats(Session session, int sessionId) async {
    final questions = await Question.db.find(
      session,
      where: (t) => t.sessionId.equals(sessionId),
    );
    final ids = questions.map((q) => q.id!).toSet();
    final votes = ids.isEmpty
        ? <Vote>[]
        : await Vote.db.find(session, where: (t) => t.questionId.inSet(ids));
    return SessionStats(
      totalQuestions: questions.length,
      totalVotes: questions.fold(0, (sum, q) => sum + q.voteCount),
      mergedDuplicates: questions.fold(0, (sum, q) => sum + q.mergeCount),
      participants: {
        ...questions.map((q) => q.postedById),
        ...votes.map((v) => v.voterToken),
      }.length,
    );
  }

  /// Streams live updates for a session: a snapshot first, then changes.
  Stream<LiveUpdate> listenToSession(Session session, String joinCode) async* {
    final talk = await _byCode(session, joinCode);

    // Subscribe before reading so no update is lost between snapshot and live.
    final updates = session.messages.createStream<LiveUpdate>(
      sessionChannel(talk.id!),
    );
    final snapshot = await _snapshot(session, talk);
    yield LiveUpdate(
      type: LiveUpdateType.snapshot,
      session: snapshot.session,
      questions: snapshot.questions,
      recap: snapshot.recap,
    );
    yield* updates;
  }

  Future<TalkSession> _byCode(Session session, String joinCode) async {
    final talk = await TalkSession.db.findFirstRow(
      session,
      where: (t) => t.joinCode.equals(joinCode.trim().toUpperCase()),
    );
    if (talk == null) {
      throw AskBytesException(message: 'No session with that code.');
    }
    return talk;
  }

  Future<SessionSnapshot> _snapshot(Session session, TalkSession talk) async {
    final questions = await Question.db.find(
      session,
      where: (t) => t.sessionId.equals(talk.id!),
      orderByList: (t) => [t.voteCount.desc(), t.createdAt.asc()],
    );
    final recap = await SessionRecap.db.findFirstRow(
      session,
      where: (t) => t.sessionId.equals(talk.id!),
    );
    return SessionSnapshot(
      session: talk.copyWith(questionCount: questions.length),
      questions: questions,
      recap: recap,
    );
  }
}

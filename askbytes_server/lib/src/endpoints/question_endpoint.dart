import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/auth_helpers.dart';
import '../services/ai_service.dart';
import '../services/live_channel.dart';

/// Posting, merging and voting on audience questions.
class QuestionEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Cosine similarity above which a new question counts as a duplicate.
  static const _similarityThreshold = 0.88;
  static const _maxLength = 500;

  /// Posts a question. A near-duplicate is merged into the existing question
  /// (its votes +1) instead of creating a new row.
  Future<QuestionResult> postQuestion(
    Session session,
    int sessionId,
    String text,
  ) async {
    final token = requireUserToken(session);
    text = text.trim();
    if (text.isEmpty) {
      throw AskBytesException(message: 'Write a question first.');
    }
    if (text.length > _maxLength) {
      throw AskBytesException(
        message: 'Questions are limited to $_maxLength characters.',
      );
    }
    final talk = await TalkSession.db.findById(session, sessionId);
    if (talk == null) throw AskBytesException(message: 'Session not found.');
    if (talk.status != 'active') {
      throw AskBytesException(message: 'This session has ended.');
    }

    // Semantic dedup: embed with Gemini and search by cosine distance. If
    // embeddings are unavailable, fall back to asking Groq to judge against the
    // session's top questions.
    final ai = AiService.fromSession(session);
    final values = await ai.embed(text);
    final embedding = values == null ? null : Vector(values);

    Question? duplicate;
    if (embedding != null) {
      final candidates = await Question.db.find(
        session,
        where: (t) =>
            t.sessionId.equals(sessionId) &
            (t.embedding.distanceCosine(embedding) < 1 - _similarityThreshold),
        orderBy: (t) => t.embedding.distanceCosine(embedding),
        limit: 1,
      );
      duplicate = candidates.firstOrNull;
    } else if (ai.groq != null) {
      final recent = await Question.db.find(
        session,
        where: (t) => t.sessionId.equals(sessionId),
        orderByList: (t) => [t.voteCount.desc(), t.createdAt.desc()],
        limit: 40,
      );
      duplicate = await ai.findDuplicateWithLlm(text, recent);
    }

    if (duplicate != null) {
      final merged = await _mergeInto(session, duplicate, token);
      await broadcast(
        session,
        sessionId,
        LiveUpdate(type: LiveUpdateType.questionUpdated, question: merged),
      );
      return QuestionResult(
        merged: true,
        question: merged,
        message: 'Your question was combined with a similar one!',
      );
    }

    final created = await Question.db.insertRow(
      session,
      Question(
        sessionId: sessionId,
        text: text,
        embedding: embedding,
        postedById: token,
      ),
    );
    await broadcast(
      session,
      sessionId,
      LiveUpdate(type: LiveUpdateType.questionAdded, question: created),
    );
    return QuestionResult(
      merged: false,
      question: created,
      message: 'Question posted!',
    );
  }

  /// Upvotes a question once per attendee.
  Future<Question> upvoteQuestion(Session session, int questionId) async {
    final token = requireUserToken(session);
    final updated = await session.db.transaction((tx) async {
      final question = await Question.db.findById(
        session,
        questionId,
        transaction: tx,
        lockMode: LockMode.forUpdate,
      );
      if (question == null) {
        throw AskBytesException(message: 'Question not found.');
      }
      final talk = await TalkSession.db.findById(
        session,
        question.sessionId,
        transaction: tx,
      );
      if (talk == null || talk.status != 'active') {
        throw AskBytesException(message: 'This session has ended.');
      }
      final voted = await Vote.db.findFirstRow(
        session,
        where: (t) =>
            t.questionId.equals(questionId) & t.voterToken.equals(token),
        transaction: tx,
      );
      if (voted != null) {
        throw AskBytesException(
          message: 'You already voted for this question.',
        );
      }
      await Vote.db.insertRow(
        session,
        Vote(questionId: questionId, voterToken: token),
        transaction: tx,
      );
      return Question.db.updateRow(
        session,
        question.copyWith(voteCount: question.voteCount + 1),
        transaction: tx,
      );
    });
    await broadcast(
      session,
      updated.sessionId,
      LiveUpdate(type: LiveUpdateType.questionUpdated, question: updated),
    );
    return updated;
  }

  /// Ids of the questions in [sessionId] the caller already voted for, so the
  /// vote buttons stay lit after a page reload.
  Future<List<int>> getMyVotes(Session session, int sessionId) async {
    final token = requireUserToken(session);
    final questions = await Question.db.find(
      session,
      where: (t) => t.sessionId.equals(sessionId),
    );
    final ids = questions.map((q) => q.id!).toSet();
    if (ids.isEmpty) return [];
    final votes = await Vote.db.find(
      session,
      where: (t) => t.questionId.inSet(ids) & t.voterToken.equals(token),
    );
    return votes.map((v) => v.questionId).toList();
  }

  /// Speaker: pin or unpin a question so it floats to the top.
  Future<Question> togglePin(Session session, int questionId) async {
    final question = await Question.db.findById(session, questionId);
    if (question == null) {
      throw AskBytesException(message: 'Question not found.');
    }
    await requireOwnedSession(session, question.sessionId);
    final updated = await Question.db.updateRow(
      session,
      question.copyWith(pinned: !question.pinned),
    );
    await broadcast(
      session,
      updated.sessionId,
      LiveUpdate(type: LiveUpdateType.questionUpdated, question: updated),
    );
    return updated;
  }

  /// Folds a duplicate into [original]; the poster's vote counts once.
  Future<Question> _mergeInto(
    Session session,
    Question original,
    String token,
  ) {
    return session.db.transaction((tx) async {
      final current =
          await Question.db.findById(
            session,
            original.id!,
            transaction: tx,
            lockMode: LockMode.forUpdate,
          ) ??
          original;
      final alreadyVoted = await Vote.db.findFirstRow(
        session,
        where: (t) =>
            t.questionId.equals(current.id!) & t.voterToken.equals(token),
        transaction: tx,
      );
      if (alreadyVoted == null) {
        await Vote.db.insertRow(
          session,
          Vote(questionId: current.id!, voterToken: token),
          transaction: tx,
        );
      }
      final mergeCount = current.mergeCount + 1;
      return Question.db.updateRow(
        session,
        current.copyWith(
          voteCount: alreadyVoted == null
              ? current.voteCount + 1
              : current.voteCount,
          mergeCount: mergeCount,
          mergeNote:
              '+$mergeCount similar question${mergeCount == 1 ? '' : 's'} merged',
        ),
        transaction: tx,
      );
    });
  }
}

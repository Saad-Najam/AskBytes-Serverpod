import 'package:askbytes_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the Q&A flow', (sessionBuilder, endpoints) {
    final speakerId = const Uuid().v4();
    final attendeeId = const Uuid().v4();

    late TestSessionBuilder speaker;
    late TestSessionBuilder attendee;

    setUp(() {
      speaker = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          speakerId,
          {},
        ),
      );
      attendee = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          attendeeId,
          {},
        ),
      );
    });

    test('speaker creates a session with a 6 char join code', () async {
      final talk = await endpoints.session.createSession(
        speaker,
        title: 'Serverpod Workshop',
        speakerName: 'Ada',
      );
      expect(talk.joinCode, hasLength(6));
      expect(talk.status, 'active');
    });

    test('unauthenticated users cannot create sessions', () async {
      await expectLater(
        endpoints.session.createSession(
          sessionBuilder,
          title: 'x',
          speakerName: 'y',
        ),
        throwsA(isA<AskBytesException>()),
      );
    });

    test(
      'attendee posts, votes once, speaker ends and recap is saved',
      () async {
        final talk = await endpoints.session.createSession(
          speaker,
          title: 'Serverpod Workshop',
          speakerName: 'Ada',
        );

        final posted = await endpoints.question.postQuestion(
          attendee,
          talk.id!,
          'How do streams work?',
        );
        expect(posted.merged, isFalse);

        final voted = await endpoints.question.upvoteQuestion(
          attendee,
          posted.question.id!,
        );
        expect(voted.voteCount, 1);

        await expectLater(
          endpoints.question.upvoteQuestion(attendee, posted.question.id!),
          throwsA(isA<AskBytesException>()),
        );

        final myVotes = await endpoints.question.getMyVotes(
          attendee,
          talk.id!,
        );
        expect(myVotes, [posted.question.id]);

        final stats = await endpoints.session.getStats(
          sessionBuilder,
          talk.id!,
        );
        expect(stats.totalQuestions, 1);
        expect(stats.totalVotes, 1);
        expect(stats.participants, 1);

        final snapshot = await endpoints.session.getSession(
          sessionBuilder,
          talk.joinCode.toLowerCase(),
        );
        expect(snapshot.questions.single.voteCount, 1);

        final recap = await endpoints.session.endSession(speaker, talk.id!);
        expect(recap.summaryMarkdown, contains('How do streams work?'));

        await expectLater(
          endpoints.question.postQuestion(attendee, talk.id!, 'Too late?'),
          throwsA(isA<AskBytesException>()),
        );
      },
    );

    test('pgvector cosine search finds the near duplicate only', () async {
      final talk = await endpoints.session.createSession(
        speaker,
        title: 'Vectors',
        speakerName: 'Ada',
      );
      final db = sessionBuilder.build();
      List<double> unit(int hot) => [
        for (var i = 0; i < 768; i++) i == hot ? 1.0 : 0.0,
      ];

      await Question.db.insertRow(
        db,
        Question(
          sessionId: talk.id!,
          text: 'a',
          embedding: Vector(unit(0)),
          postedById: 't',
        ),
      );
      await Question.db.insertRow(
        db,
        Question(
          sessionId: talk.id!,
          text: 'b',
          embedding: Vector(unit(1)),
          postedById: 't',
        ),
      );

      final probe = Vector(unit(0));
      final hits = await Question.db.find(
        db,
        where: (t) =>
            t.sessionId.equals(talk.id!) &
            (t.embedding.distanceCosine(probe) < 0.12),
        orderBy: (t) => t.embedding.distanceCosine(probe),
      );
      expect(hits.map((q) => q.text), ['a']);
    });
  });
}

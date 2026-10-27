// End-to-end check against a running local server (real DB, real Gemini).
//   dart run tool/e2e.dart <path-to-server-log> [--fast]
//   dart run tool/e2e.dart --url https://x.api.serverpod.space/ //       --login speaker@example.com 'password' [--fast]
// With --login the speaker account must already exist (use it for deployed
// servers, where the email code can't be read from a local log).
import 'dart:async';
import 'dart:io';

import 'package:askbytes_client/askbytes_client.dart';

class _Token implements ClientAuthKeyProvider {
  _Token(this.token);
  final String token;
  @override
  Future<String?> get authHeaderValue async =>
      wrapAsBearerAuthHeaderValue(token);
}

var failures = 0;
void check(String name, bool ok, [Object? detail]) {
  if (!ok) failures++;
  print(
    '${ok ? "PASS" : "FAIL"}  $name${detail == null ? "" : "  -> $detail"}',
  );
}

Future<void> expectThrows(String name, Future<Object?> Function() f) async {
  try {
    await f();
    check(name, false, 'did not throw');
  } on AskBytesException catch (e) {
    check(name, true, e.message);
  } catch (e) {
    check(name, false, 'wrong exception: $e');
  }
}

var baseUrl = 'http://localhost:8080/';

Client newClient([String? token]) {
  final c = Client(baseUrl);
  if (token != null) c.authKeyProvider = _Token(token);
  return c;
}

Future<String> registerSpeaker(String? logPath, List<String>? login) async {
  if (login != null) {
    return (await newClient().emailIdp.login(
      email: login[0],
      password: login[1],
    )).token;
  }
  logPath!;
  final email = 'speaker-${DateTime.now().millisecondsSinceEpoch}@example.com';
  final c = newClient();
  final requestId = await c.emailIdp.startRegistration(email: email);
  String? code;
  for (var i = 0; i < 20 && code == null; i++) {
    await Future.delayed(const Duration(milliseconds: 300));
    final text = File(logPath).readAsStringSync();
    final m = RegExp(
      'Registration code for ${RegExp.escape(email)}: <(\\w+)>',
    ).firstMatch(text);
    code = m?.group(1);
  }
  if (code == null) throw StateError('no registration code in log');
  final regToken = await c.emailIdp.verifyRegistrationCode(
    accountRequestId: requestId,
    verificationCode: code,
  );
  final auth = await c.emailIdp.finishRegistration(
    registrationToken: regToken,
    password: 'Sup3r-secret-pass!',
  );
  return auth.token;
}

Future<String> anonymous() async =>
    (await newClient().anonymousIdp.login()).token;

Future<void> main(List<String> args) async {
  final urlIndex = args.indexOf('--url');
  if (urlIndex >= 0) baseUrl = args[urlIndex + 1];
  final loginIndex = args.indexOf('--login');
  final login = loginIndex >= 0
      ? [args[loginIndex + 1], args[loginIndex + 2]]
      : null;
  final logPath = args.isNotEmpty && !args.first.startsWith('--')
      ? args.first
      : null;

  final speakerToken = await registerSpeaker(logPath, login);
  final speaker = newClient(speakerToken);
  final alice = newClient(await anonymous());
  final bob = newClient(await anonymous());
  final publicClient = newClient();
  check('speaker registered by email, 2 anonymous attendees joined', true);

  // --- permissions
  await expectThrows(
    'anonymous attendee cannot create a session',
    () => alice.session.createSession(title: 'x', speakerName: 'y'),
  );
  try {
    await publicClient.question.postQuestion(1, 'hi');
    check('unauthenticated user cannot post a question', false, 'no error');
  } on ServerpodClientUnauthorized {
    check('unauthenticated user cannot post a question', true, '401');
  }

  // --- create
  final talk = await speaker.session.createSession(
    title: 'FlutterBytes 2026 - Serverpod Workshop',
    speakerName: 'Ada Lovelace',
    description: 'e2e',
    durationMinutes: 45,
  );
  check(
    'session created with 6-char code',
    talk.joinCode.length == 6,
    talk.joinCode,
  );

  // --- live streams (attendee + speaker + public projector)
  final aliceEvents = <LiveUpdate>[];
  final speakerEvents = <LiveUpdate>[];
  final aliceSub = alice.session
      .listenToSession(talk.joinCode)
      .listen(aliceEvents.add);
  final speakerSub = speaker.session
      .listenToSession(talk.joinCode)
      .listen(speakerEvents.add);
  await Future.delayed(const Duration(seconds: 2));
  check(
    'streams deliver an initial snapshot',
    aliceEvents.isNotEmpty &&
        aliceEvents.first.type == LiveUpdateType.snapshot &&
        speakerEvents.isNotEmpty,
  );

  // --- post + latency
  final sw = Stopwatch()..start();
  final q1 = await alice.question.postQuestion(
    talk.id!,
    'How does Serverpod handle state in streaming methods?',
  );
  check('first question is created (not merged)', !q1.merged, q1.message);
  while (!speakerEvents.any((e) => e.type == LiveUpdateType.questionAdded) &&
      sw.elapsed < const Duration(seconds: 5)) {
    await Future.delayed(const Duration(milliseconds: 25));
  }
  final addMs = sw.elapsedMilliseconds;
  check(
    'question reaches the speaker stream within 3s',
    addMs <= 3000,
    '${addMs}ms',
  );

  // --- AI dedup (real Gemini embeddings + pgvector)
  sw
    ..reset()
    ..start();
  final q2 = await bob.question.postQuestion(
    talk.id!,
    "What's the best way to manage state with Serverpod streams?",
  );
  final dedupMs = sw.elapsedMilliseconds;
  check('similar question is merged by AI', q2.merged, q2.message);
  check('dedup responds within ~2s', dedupMs <= 2500, '${dedupMs}ms');
  check(
    'merged into original with +1 vote and a note',
    q2.question.id == q1.question.id &&
        q2.question.voteCount == 1 &&
        q2.question.mergeNote != null,
    q2.question.mergeNote,
  );
  await Future.delayed(const Duration(milliseconds: 500));
  check(
    'merge was broadcast as questionUpdated',
    aliceEvents.any((e) => e.type == LiveUpdateType.questionUpdated),
  );

  final q3 = await bob.question.postQuestion(
    talk.id!,
    'Will the slides and a recording be shared after the conference?',
  );
  check('unrelated question is NOT merged', !q3.merged, q3.message);

  // --- voting
  final v = await alice.question.upvoteQuestion(q3.question.id!);
  check('upvote increments votes', v.voteCount == 1, 'votes=${v.voteCount}');
  await expectThrows(
    'double upvote is rejected',
    () => alice.question.upvoteQuestion(q3.question.id!),
  );
  // bob already voted on q1 through the merge, so a manual vote must fail too.
  await expectThrows(
    'merger cannot vote again on the merged question',
    () => bob.question.upvoteQuestion(q1.question.id!),
  );
  await alice.question.upvoteQuestion(q1.question.id!);
  await bob.question
      .upvoteQuestion(q3.question.id!)
      .catchError((_) => q3.question);

  // --- pin (speaker only)
  await expectThrows(
    'attendee cannot pin',
    () => alice.question.togglePin(q3.question.id!),
  );
  final pinned = await speaker.question.togglePin(q3.question.id!);
  check('speaker can pin a question', pinned.pinned);
  await speaker.question.togglePin(q3.question.id!);

  // --- public reads
  final snap = await publicClient.session.getSession(
    talk.joinCode.toLowerCase(),
  );
  check(
    'public getSession is case-insensitive and sorted by votes',
    snap.questions.length == 2 &&
        snap.questions.first.voteCount >= snap.questions.last.voteCount,
    snap.questions
        .map((q) => '${q.voteCount}:${q.text.substring(0, 12)}')
        .toList(),
  );
  final mine = await speaker.session.getSpeakerSessions();
  check(
    'dashboard lists the session with question count',
    mine.any((s) => s.id == talk.id && s.questionCount == 2),
  );

  // --- end session + recap
  sw
    ..reset()
    ..start();
  final recap = await speaker.session.endSession(talk.id!);
  final recapMs = sw.elapsedMilliseconds;
  check('recap generated within 30s', recapMs <= 30000, '${recapMs}ms');
  check(
    'recap has markdown + themes',
    recap.summaryMarkdown.isNotEmpty && recap.keyThemes.isNotEmpty,
    recap.keyThemes,
  );
  await Future.delayed(const Duration(seconds: 1));
  check(
    'attendee stream got sessionEnded then recapReady',
    aliceEvents.any((e) => e.type == LiveUpdateType.sessionEnded) &&
        aliceEvents.any((e) => e.type == LiveUpdateType.recapReady),
  );
  await expectThrows(
    'posting after the session ended is rejected',
    () => alice.question.postQuestion(talk.id!, 'too late?'),
  );
  final pub = await publicClient.recap.getRecap(talk.id!);
  check(
    'public recap permalink data is available',
    pub != null && pub.id == recap.id,
  );

  // --- votes persistence + stats
  final myVotes = await alice.question.getMyVotes(talk.id!);
  check(
    'getMyVotes returns the questions alice voted on',
    myVotes.toSet().containsAll({q1.question.id, q3.question.id}),
    myVotes,
  );
  final stats = await publicClient.session.getStats(talk.id!);
  check(
    'stats aggregate questions, votes, merges and people',
    stats.totalQuestions == 2 &&
        stats.mergedDuplicates == 1 &&
        stats.totalVotes >= 3 &&
        stats.participants == 2,
    'q=${stats.totalQuestions} v=${stats.totalVotes} '
        'm=${stats.mergedDuplicates} p=${stats.participants}',
  );

  // --- auto-end timer (future call). Takes ~1 minute, skip with --fast.
  if (!args.contains('--fast')) {
    final timed = await speaker.session.createSession(
      title: 'Timer test',
      speakerName: 'Ada',
      durationMinutes: 1,
      autoEnd: true,
    );
    if (!timed.autoEndScheduled) {
      print(
        'SKIP  auto-end timer: server reports future calls are unavailable '
        '(expected on the Serverpod Cloud starter plan)',
      );
    }
    await alice.question.postQuestion(timed.id!, 'Will this end by itself?');
    final started = DateTime.now();
    var ended = false;
    while (timed.autoEndScheduled &&
        DateTime.now().difference(started) < const Duration(seconds: 100)) {
      await Future.delayed(const Duration(seconds: 3));
      final s = await publicClient.session.getSessionById(timed.id!);
      if (s.session.status == 'closed' && s.recap != null) {
        ended = true;
        break;
      }
    }
    if (timed.autoEndScheduled) {
      check(
        'session auto-ends with a recap when its timer fires',
        ended,
        '${DateTime.now().difference(started).inSeconds}s',
      );
    }
    final untimed = await speaker.session.createSession(
      title: 'No timer',
      speakerName: 'Ada',
      durationMinutes: 1,
    );
    await Future.delayed(const Duration(seconds: 1));
    check(
      'a session without autoEnd stays active',
      (await publicClient.session.getSessionById(untimed.id!)).session.status ==
          'active',
    );
  }

  print(
    '\n--- recap markdown ---\n${recap.summaryMarkdown}\n--- themes: ${recap.keyThemes}',
  );

  await aliceSub.cancel();
  await speakerSub.cancel();
  print(failures == 0 ? '\nALL CHECKS PASSED' : '\n$failures CHECK(S) FAILED');
  exit(failures == 0 ? 0 : 1);
}

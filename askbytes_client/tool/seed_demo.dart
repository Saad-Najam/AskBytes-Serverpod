// Seeds a "FlutterBytes 2026 Demo" session with a few questions and votes.
//   dart run tool/seed_demo.dart <speaker-email> <speaker-password> [server-url]
// The speaker account must already exist (sign up once in the app).
import 'dart:io';

import 'package:askbytes_client/askbytes_client.dart';

class _Token implements ClientAuthKeyProvider {
  _Token(this.token);
  final String token;
  @override
  Future<String?> get authHeaderValue async =>
      wrapAsBearerAuthHeaderValue(token);
}

Client _client(String url, [String? token]) {
  final c = Client(url);
  if (token != null) c.authKeyProvider = _Token(token);
  return c;
}

Future<void> main(List<String> args) async {
  if (args.length < 2) {
    stderr.writeln(
      'usage: dart run tool/seed_demo.dart <email> <password> [server-url]',
    );
    exit(64);
  }
  final url = args.length > 2 ? args[2] : 'http://localhost:8080/';

  final auth = await _client(
    url,
  ).emailIdp.login(email: args[0], password: args[1]);
  final speaker = _client(url, auth.token);

  final talk = await speaker.session.createSession(
    title: 'FlutterBytes 2026 Demo',
    speakerName: 'Demo Speaker',
    description: 'Seeded demo session',
    durationMinutes: 45,
  );

  // Four different attendees, each an anonymous user.
  final attendees = <Client>[];
  for (var i = 0; i < 4; i++) {
    final anon = await _client(url).anonymousIdp.login();
    attendees.add(_client(url, anon.token));
  }

  final questions = [
    'How do I deploy a Serverpod app to Serverpod Cloud?',
    'Can I use Gemini from the Flutter client safely?',
    'Does Serverpod support real-time streaming over WebSockets?',
    'What is the best way to structure a large Flutter app?',
  ];
  final ids = <int>[];
  for (var i = 0; i < questions.length; i++) {
    final result = await attendees[i].question.postQuestion(
      talk.id!,
      questions[i],
    );
    ids.add(result.question.id!);
  }
  // A few votes so the ranking is interesting.
  await attendees[1].question.upvoteQuestion(ids[0]);
  await attendees[2].question.upvoteQuestion(ids[0]);
  await attendees[3].question.upvoteQuestion(ids[0]);
  await attendees[0].question.upvoteQuestion(ids[2]);
  await attendees[3].question.upvoteQuestion(ids[2]);

  // Local dev serves the web app on :8082; Cloud uses <id>.serverpod.space
  // for the web app and <id>.api.serverpod.space for the API.
  final base = url
      .replaceFirst(RegExp(r':8080/?$'), ':8082')
      .replaceFirst('.api.', '.')
      .replaceFirst(RegExp(r'/$'), '');
  print('Seeded session ${talk.id}  code ${talk.joinCode}');
  print('Join:    $base/join/${talk.joinCode}');
  print('Present: $base/present/${talk.id}');
  exit(0);
}

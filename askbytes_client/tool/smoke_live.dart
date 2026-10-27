// Smoke test against a deployed server (no speaker account needed).
//   dart run tool/smoke_live.dart https://askbytes.api.serverpod.space/
import 'dart:async';

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

Future<void> main(List<String> args) async {
  final url = args.isNotEmpty ? args.first : 'http://localhost:8080/';
  final anon = Client(url);

  try {
    final auth = await anon.anonymousIdp.login();
    check('anonymous login works (database write)', auth.token.isNotEmpty);
    final attendee = Client(url)..authKeyProvider = _Token(auth.token);

    try {
      await attendee.session.getSession('ZZZZZZ');
      check('unknown join code is rejected', false);
    } on AskBytesException catch (e) {
      check(
        'unknown join code is rejected with a friendly message',
        true,
        e.message,
      );
    }

    try {
      await attendee.session.createSession(title: 'x', speakerName: 'y');
      check('attendee cannot create sessions', false);
    } on AskBytesException {
      check('attendee cannot create sessions', true);
    }

    // WebSocket streaming over TLS: the server answers with an error for an
    // unknown code, which proves the stream round-trips.
    final done = Completer<Object>();
    final sub = attendee.session
        .listenToSession('ZZZZZZ')
        .listen(
          (_) {},
          onError: (Object e) {
            if (!done.isCompleted) done.complete(e);
          },
        );
    final result = await done.future.timeout(
      const Duration(seconds: 20),
      onTimeout: () => 'timeout',
    );
    await sub.cancel();
    check(
      'WebSocket stream round-trips',
      result is AskBytesException,
      result is AskBytesException ? result.message : result,
    );

    try {
      final r = await anon.recap.getRecap(999999);
      check('public recap endpoint reachable (no recap -> null)', r == null);
    } catch (e) {
      check('public recap endpoint reachable', false, e);
    }
  } catch (e) {
    check('smoke test ran without crashing', false, e);
  }
  print(failures == 0 ? '\nLIVE SMOKE PASSED' : '\n$failures CHECK(S) FAILED');
}

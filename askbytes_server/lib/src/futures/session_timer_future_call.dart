import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/session_lifecycle.dart';

/// Ends sessions on a timer when the speaker opted into auto-close.
class SessionTimerFutureCall extends FutureCall {
  /// Ends [sessionId] if it is still active. Idempotent: a session the speaker
  /// already ended is left alone.
  Future<void> autoEnd(Session session, int sessionId) async {
    final talk = await TalkSession.db.findById(session, sessionId);
    if (talk == null || talk.status != 'active') return;
    await closeSessionAndRecap(session, talk);
  }
}

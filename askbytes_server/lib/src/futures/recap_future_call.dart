import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/live_channel.dart';

/// Scheduled work around a session's recap.
class RecapFutureCall extends FutureCall {
  /// Re-broadcasts the saved recap so attendees who joined (or reconnected)
  /// after the session ended still receive it. Idempotent.
  Future<void> rebroadcast(Session session, int sessionId) async {
    final recap = await SessionRecap.db.findFirstRow(
      session,
      where: (t) => t.sessionId.equals(sessionId),
    );
    if (recap == null) return;
    await broadcast(
      session,
      sessionId,
      LiveUpdate(type: LiveUpdateType.recapReady, recap: recap),
    );
  }
}

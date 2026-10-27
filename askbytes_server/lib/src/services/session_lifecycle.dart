import 'package:serverpod/serverpod.dart';

import '../generated/future_calls.dart';
import '../generated/protocol.dart';
import 'live_channel.dart';
import 'recap_service.dart';

/// Identifier of the auto-end future call for [sessionId].
String autoEndIdentifier(int sessionId) => 'auto_end_$sessionId';

/// Closes [talk] (idempotent), broadcasts the end, generates the recap and
/// queues the latecomer re-broadcast. Shared by the speaker's End Session
/// button and the auto-end timer.
Future<SessionRecap> closeSessionAndRecap(
  Session session,
  TalkSession talk,
) async {
  final sessionId = talk.id!;
  if (talk.status != 'closed') {
    talk = await TalkSession.db.updateRow(
      session,
      talk.copyWith(status: 'closed', endedAt: DateTime.now()),
    );
    await broadcast(
      session,
      sessionId,
      LiveUpdate(type: LiveUpdateType.sessionEnded, session: talk),
    );
  }
  await _cancelAutoEnd(session, sessionId);
  final recap = await generateAndSaveRecap(session, talk);
  await _scheduleLatecomerRecap(session, sessionId);
  return recap;
}

/// Schedules the session to end itself [after] from now. Returns false when
/// future calls are unavailable (e.g. on some hosting plans).
Future<bool> scheduleAutoEnd(
  Session session,
  int sessionId,
  Duration after,
) async {
  try {
    await session.serverpod.futureCalls
        .callWithDelay(after, identifier: autoEndIdentifier(sessionId))
        .sessionTimer
        .autoEnd(sessionId);
    return true;
  } catch (e, st) {
    session.log(
      'Could not schedule auto-end: $e',
      level: LogLevel.warning,
      stackTrace: st,
    );
    return false;
  }
}

Future<void> _cancelAutoEnd(Session session, int sessionId) async {
  try {
    await session.serverpod.futureCalls.cancel(autoEndIdentifier(sessionId));
  } catch (e, st) {
    session.log(
      'Could not cancel auto-end: $e',
      level: LogLevel.warning,
      stackTrace: st,
    );
  }
}

/// Queues a future call that re-sends the recap five minutes later for
/// latecomers. Future calls can be unavailable on some hosting plans, so a
/// failure here must never break ending the session.
Future<void> _scheduleLatecomerRecap(Session session, int sessionId) async {
  try {
    await session.serverpod.futureCalls
        .callWithDelay(
          const Duration(minutes: 5),
          identifier: 'recap_rebroadcast_$sessionId',
        )
        .recap
        .rebroadcast(sessionId);
  } catch (e, st) {
    session.log(
      'Could not schedule latecomer recap: $e',
      level: LogLevel.warning,
      stackTrace: st,
    );
  }
}

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Name of the message-central channel carrying live updates for a session.
String sessionChannel(int sessionId) => 'session_$sessionId';

/// Broadcasts [update] to every client listening to [sessionId].
Future<void> broadcast(Session session, int sessionId, LiveUpdate update) {
  return session.messages.postMessage(sessionChannel(sessionId), update);
}

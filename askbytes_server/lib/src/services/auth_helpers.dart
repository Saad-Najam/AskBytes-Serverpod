import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

/// Returns the signed-in user's id as a string, used as the anonymous
/// attendee token for posting and voting.
String requireUserToken(Session session) {
  final id = session.authenticated?.authUserId;
  if (id == null) {
    throw AskBytesException(message: 'Please join the session first.');
  }
  return id.toString();
}

/// Requires a signed-in speaker (email or Google account, not anonymous).
Future<UuidValue> requireSpeaker(Session session) async {
  final id = session.authenticated?.authUserId;
  if (id == null) {
    throw AskBytesException(message: 'Sign in as a speaker to do this.');
  }
  final anonymous = await AnonymousAccount.db.findFirstRow(
    session,
    where: (t) => t.authUserId.equals(id),
  );
  if (anonymous != null) {
    throw AskBytesException(message: 'Sign in as a speaker to do this.');
  }
  return id;
}

/// Loads a session and verifies the caller owns it.
Future<TalkSession> requireOwnedSession(Session session, int sessionId) async {
  final speakerId = await requireSpeaker(session);
  final talk = await TalkSession.db.findById(session, sessionId);
  if (talk == null || talk.speakerId != speakerId) {
    throw AskBytesException(message: 'Session not found.');
  }
  return talk;
}

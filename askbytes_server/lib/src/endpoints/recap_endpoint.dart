import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/auth_helpers.dart';
import '../services/recap_service.dart';

/// AI recap retrieval and (re)generation.
class RecapEndpoint extends Endpoint {
  /// Speaker: regenerate the recap (e.g. retry after an AI failure).
  Future<SessionRecap> generateRecap(Session session, int sessionId) async {
    final talk = await requireOwnedSession(session, sessionId);
    return generateAndSaveRecap(session, talk);
  }

  /// Public: the recap behind the shareable permalink, or null if not ready.
  Future<SessionRecap?> getRecap(Session session, int sessionId) {
    return SessionRecap.db.findFirstRow(
      session,
      where: (t) => t.sessionId.equals(sessionId),
    );
  }
}

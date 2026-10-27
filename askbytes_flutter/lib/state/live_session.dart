import 'dart:async';

import 'package:askbytes_client/askbytes_client.dart';
import 'package:flutter/foundation.dart';

import '../client.dart';

/// Keeps a session's questions, status and recap in sync with the server over
/// a Serverpod streaming method, reconnecting automatically if it drops.
class LiveSessionController extends ChangeNotifier {
  LiveSessionController({this.joinCode, this.sessionId})
    : assert(joinCode != null || sessionId != null);

  String? joinCode;
  final int? sessionId;

  TalkSession? session;
  SessionRecap? recap;
  String? error;
  bool connected = false;

  final Map<int, Question> _questions = {};
  StreamSubscription<LiveUpdate>? _subscription;
  Timer? _retryTimer;
  bool _disposed = false;
  int _attempt = 0;

  bool get isEnded => session?.status == 'closed';
  bool get isLoaded => session != null;

  /// Pinned first, then most votes, then oldest.
  List<Question> get questions {
    final list = _questions.values.toList()
      ..sort((a, b) {
        if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
        if (a.voteCount != b.voteCount) return b.voteCount - a.voteCount;
        return a.createdAt.compareTo(b.createdAt);
      });
    return list;
  }

  Future<void> start() async {
    if (joinCode == null) {
      try {
        final snapshot = await client.session.getSessionById(sessionId!);
        joinCode = snapshot.session.joinCode;
      } catch (e) {
        error = _message(e);
        notifyListeners();
        return;
      }
    }
    _connect();
  }

  void _connect() {
    if (_disposed) return;
    _subscription?.cancel();
    _subscription = client.session
        .listenToSession(joinCode!)
        .listen(
          (update) {
            _attempt = 0;
            connected = true;
            error = null;
            _apply(update);
          },
          onError: (Object e) {
            connected = false;
            // A bad code will never recover; surface it instead of looping.
            if (e is AskBytesException) {
              error = e.message;
              notifyListeners();
              return;
            }
            notifyListeners();
            _scheduleRetry();
          },
          onDone: () {
            connected = false;
            notifyListeners();
            _scheduleRetry();
          },
          cancelOnError: true,
        );
  }

  void _scheduleRetry() {
    if (_disposed) return;
    _retryTimer?.cancel();
    final delay = Duration(seconds: (1 << _attempt.clamp(0, 4)));
    _attempt++;
    _retryTimer = Timer(delay, _connect);
  }

  void _apply(LiveUpdate update) {
    switch (update.type) {
      case LiveUpdateType.snapshot:
        session = update.session;
        recap = update.recap;
        _questions
          ..clear()
          ..addEntries(
            (update.questions ?? const <Question>[]).map(
              (q) => MapEntry(q.id!, q),
            ),
          );
      case LiveUpdateType.questionAdded:
      case LiveUpdateType.questionUpdated:
        final q = update.question;
        if (q != null) _questions[q.id!] = q;
      case LiveUpdateType.sessionEnded:
        session = update.session ?? session;
      case LiveUpdateType.recapReady:
        recap = update.recap;
    }
    notifyListeners();
  }

  /// Applies a locally known question so the UI reflects the user's own
  /// action immediately, even before the broadcast arrives.
  void applyLocal(Question q) {
    _questions[q.id!] = q;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _retryTimer?.cancel();
    _subscription?.cancel();
    super.dispose();
  }
}

/// Human friendly text for any error thrown by a client call.
String _message(Object e) {
  if (e is AskBytesException) return e.message;
  return 'Something went wrong. Please try again.';
}

String errorMessage(Object e) => _message(e);

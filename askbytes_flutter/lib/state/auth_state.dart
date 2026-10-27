import 'package:askbytes_client/askbytes_client.dart';
import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';

/// Whether Google sign-in is offered to speakers. Enable with
/// `--dart-define=GOOGLE_ENABLED=true` once the server has a Google client
/// secret configured.
const googleEnabled = bool.fromEnvironment('GOOGLE_ENABLED');

/// Tracks whether the signed-in user is a speaker (email / Google) rather than
/// an anonymous attendee. The server is the source of truth.
class AuthState extends ChangeNotifier {
  AuthState() {
    client.auth.authInfoListenable.addListener(_onAuthChanged);
  }

  bool? _isSpeaker;
  Future<bool>? _pending;

  bool get isAuthenticated => client.auth.isAuthenticated;

  void _onAuthChanged() {
    _isSpeaker = null;
    _pending = null;
    notifyListeners();
  }

  /// Resolves (and caches) whether the current user is a speaker.
  Future<bool> isSpeaker() {
    if (!client.auth.isAuthenticated) return Future.value(false);
    final cached = _isSpeaker;
    if (cached != null) return Future.value(cached);
    return _pending ??= _probe();
  }

  Future<bool> _probe() async {
    try {
      await client.session.getSpeakerSessions();
      return _isSpeaker = true;
    } on AskBytesException {
      return _isSpeaker = false;
    } catch (_) {
      // Network trouble: don't cache, let the next call retry.
      _pending = null;
      return false;
    }
  }

  /// Signs in anonymously if nobody is signed in (attendee flow).
  Future<void> ensureAttendee() async {
    if (client.auth.isAuthenticated) return;
    Object? failure;
    await AnonymousAuthController(
      client: client,
      onError: (e) => failure = e,
    ).login();
    if (!client.auth.isAuthenticated) {
      throw failure ?? StateError('Could not start an anonymous session.');
    }
  }

  Future<void> signOut() => client.auth.signOutDevice();

  @override
  void dispose() {
    client.auth.authInfoListenable.removeListener(_onAuthChanged);
    super.dispose();
  }
}

final authState = AuthState();

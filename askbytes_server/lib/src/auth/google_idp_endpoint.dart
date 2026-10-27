import 'package:serverpod_auth_idp_server/providers/google.dart';

/// Exposes Google sign-in for speakers. Only usable when a Google client
/// secret is configured (see `googleClientSecret` in config/passwords.yaml).
class GoogleIdpEndpoint extends GoogleIdpBaseEndpoint {}

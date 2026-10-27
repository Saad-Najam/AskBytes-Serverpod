/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:askbytes_client/src/protocol/live_update.dart' as _isf3smdv;
import 'package:askbytes_client/src/protocol/question.dart' as _ilxe3guf;
import 'package:askbytes_client/src/protocol/question_result.dart' as _inygqgc1;
import 'package:askbytes_client/src/protocol/session_recap.dart' as _iyp7xr35;
import 'package:askbytes_client/src/protocol/session_snapshot.dart'
    as _ivdi1m24;
import 'package:askbytes_client/src/protocol/session_stats.dart' as _ihkwm25a;
import 'package:askbytes_client/src/protocol/talk_session.dart' as _i3bzerrm;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// Exposes anonymous sign-in so attendees can join a session from a QR code
/// without creating an account.
/// {@category Endpoint}
class EndpointAnonymousIdp extends _iaic.EndpointAnonymousIdpBase {
  EndpointAnonymousIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'anonymousIdp';

  /// Creates a new anonymous account and returns its session.
  ///
  /// Invokes the [AnonymousIdp.beforeAnonymousAccount] callback if configured,
  /// which may prevent account creation if the endpoint is protected.
  @override
  _ida.Future<_iacc.AuthSuccess> login({String? token}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'anonymousIdp',
        'login',
        {'token': token},
      );
}

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// Exposes Google sign-in for speakers. Only usable when a Google client
/// secret is configured (see `googleClientSecret` in config/passwords.yaml).
/// {@category Endpoint}
class EndpointGoogleIdp extends _iaic.EndpointGoogleIdpBase {
  EndpointGoogleIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'googleIdp';

  /// Validates a Google ID token and either logs in the associated user or
  /// creates a new user account if the Google account ID is not yet known.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String idToken,
    required String? accessToken,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'googleIdp',
    'login',
    {
      'idToken': idToken,
      'accessToken': accessToken,
    },
  );

  /// Validates a Google authorization code from the web OAuth2 PKCE flow and
  /// either logs in the associated user or creates a new account.
  ///
  /// This is the web counterpart of [login], which accepts an ID token directly
  /// (used on native platforms via the `google_sign_in` package).
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  @override
  _ida.Future<_iacc.AuthSuccess> loginWithCode({
    required String code,
    required String codeVerifier,
    required String redirectUri,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'googleIdp',
    'loginWithCode',
    {
      'code': code,
      'codeVerifier': codeVerifier,
      'redirectUri': redirectUri,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'googleIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// Posting, merging and voting on audience questions.
/// {@category Endpoint}
class EndpointQuestion extends _isc.EndpointRef {
  EndpointQuestion(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'question';

  /// Posts a question. A near-duplicate is merged into the existing question
  /// (its votes +1) instead of creating a new row.
  _ida.Future<_inygqgc1.QuestionResult> postQuestion(
    int sessionId,
    String text,
  ) => caller.callServerEndpoint<_inygqgc1.QuestionResult>(
    'question',
    'postQuestion',
    {
      'sessionId': sessionId,
      'text': text,
    },
  );

  /// Upvotes a question once per attendee.
  _ida.Future<_ilxe3guf.Question> upvoteQuestion(int questionId) =>
      caller.callServerEndpoint<_ilxe3guf.Question>(
        'question',
        'upvoteQuestion',
        {'questionId': questionId},
      );

  /// Ids of the questions in [sessionId] the caller already voted for, so the
  /// vote buttons stay lit after a page reload.
  _ida.Future<List<int>> getMyVotes(int sessionId) =>
      caller.callServerEndpoint<List<int>>(
        'question',
        'getMyVotes',
        {'sessionId': sessionId},
      );

  /// Speaker: pin or unpin a question so it floats to the top.
  _ida.Future<_ilxe3guf.Question> togglePin(int questionId) =>
      caller.callServerEndpoint<_ilxe3guf.Question>(
        'question',
        'togglePin',
        {'questionId': questionId},
      );
}

/// AI recap retrieval and (re)generation.
/// {@category Endpoint}
class EndpointRecap extends _isc.EndpointRef {
  EndpointRecap(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'recap';

  /// Speaker: regenerate the recap (e.g. retry after an AI failure).
  _ida.Future<_iyp7xr35.SessionRecap> generateRecap(int sessionId) =>
      caller.callServerEndpoint<_iyp7xr35.SessionRecap>(
        'recap',
        'generateRecap',
        {'sessionId': sessionId},
      );

  /// Public: the recap behind the shareable permalink, or null if not ready.
  _ida.Future<_iyp7xr35.SessionRecap?> getRecap(int sessionId) =>
      caller.callServerEndpoint<_iyp7xr35.SessionRecap?>(
        'recap',
        'getRecap',
        {'sessionId': sessionId},
      );
}

/// Manages the lifecycle of a talk session and streams live updates.
/// {@category Endpoint}
class EndpointSession extends _isc.EndpointRef {
  EndpointSession(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'session';

  /// Creates a session owned by the signed-in speaker.
  _ida.Future<_i3bzerrm.TalkSession> createSession({
    required String title,
    required String speakerName,
    String? description,
    int? durationMinutes,
    bool? autoEnd,
  }) => caller.callServerEndpoint<_i3bzerrm.TalkSession>(
    'session',
    'createSession',
    {
      'title': title,
      'speakerName': speakerName,
      'description': description,
      'durationMinutes': durationMinutes,
      'autoEnd': autoEnd,
    },
  );

  /// Public: session by join code with its questions sorted by votes.
  _ida.Future<_ivdi1m24.SessionSnapshot> getSession(String joinCode) =>
      caller.callServerEndpoint<_ivdi1m24.SessionSnapshot>(
        'session',
        'getSession',
        {'joinCode': joinCode},
      );

  /// Public: session by id (used by manage, present and recap routes).
  _ida.Future<_ivdi1m24.SessionSnapshot> getSessionById(int sessionId) =>
      caller.callServerEndpoint<_ivdi1m24.SessionSnapshot>(
        'session',
        'getSessionById',
        {'sessionId': sessionId},
      );

  /// Sessions owned by the signed-in speaker, newest first.
  _ida.Future<List<_i3bzerrm.TalkSession>> getSpeakerSessions() =>
      caller.callServerEndpoint<List<_i3bzerrm.TalkSession>>(
        'session',
        'getSpeakerSessions',
        {},
      );

  /// Ends the session, locks input, then generates and broadcasts the recap.
  _ida.Future<_iyp7xr35.SessionRecap> endSession(int sessionId) =>
      caller.callServerEndpoint<_iyp7xr35.SessionRecap>(
        'session',
        'endSession',
        {'sessionId': sessionId},
      );

  /// Public aggregate numbers for a session (shown on the recap).
  _ida.Future<_ihkwm25a.SessionStats> getStats(int sessionId) =>
      caller.callServerEndpoint<_ihkwm25a.SessionStats>(
        'session',
        'getStats',
        {'sessionId': sessionId},
      );

  /// Streams live updates for a session: a snapshot first, then changes.
  _ida.Stream<_isf3smdv.LiveUpdate> listenToSession(String joinCode) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_isf3smdv.LiveUpdate>,
        _isf3smdv.LiveUpdate
      >(
        'session',
        'listenToSession',
        {'joinCode': joinCode},
        {},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    anonymousIdp = EndpointAnonymousIdp(this);
    emailIdp = EndpointEmailIdp(this);
    googleIdp = EndpointGoogleIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    question = EndpointQuestion(this);
    recap = EndpointRecap(this);
    session = EndpointSession(this);
    modules = Modules(this);
  }

  late final EndpointAnonymousIdp anonymousIdp;

  late final EndpointEmailIdp emailIdp;

  late final EndpointGoogleIdp googleIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointQuestion question;

  late final EndpointRecap recap;

  late final EndpointSession session;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'anonymousIdp': anonymousIdp,
    'emailIdp': emailIdp,
    'googleIdp': googleIdp,
    'jwtRefresh': jwtRefresh,
    'question': question,
    'recap': recap,
    'session': session,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}

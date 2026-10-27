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
import 'package:askbytes_server/src/generated/protocol.dart' as _i904v5el;
import 'package:serverpod/serverpod.dart' as _is;
import 'question.dart' as _in6mynjk;
import 'session_recap.dart' as _ierkbos6;
import 'talk_session.dart' as _idvyhnfa;

abstract class SessionSnapshot
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SessionSnapshot._({
    required this.session,
    required this.questions,
    this.recap,
  });

  factory SessionSnapshot({
    required _idvyhnfa.TalkSession session,
    required List<_in6mynjk.Question> questions,
    _ierkbos6.SessionRecap? recap,
  }) = _SessionSnapshotImpl;

  factory SessionSnapshot.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionSnapshot(
      session: _i904v5el.Protocol().deserialize<_idvyhnfa.TalkSession>(
        jsonSerialization['session'],
      ),
      questions: _i904v5el.Protocol().deserialize<List<_in6mynjk.Question>>(
        jsonSerialization['questions'],
      ),
      recap: jsonSerialization['recap'] == null
          ? null
          : _i904v5el.Protocol().deserialize<_ierkbos6.SessionRecap>(
              jsonSerialization['recap'],
            ),
    );
  }

  _idvyhnfa.TalkSession session;

  List<_in6mynjk.Question> questions;

  _ierkbos6.SessionRecap? recap;

  /// Returns a shallow copy of this [SessionSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SessionSnapshot copyWith({
    _idvyhnfa.TalkSession? session,
    List<_in6mynjk.Question>? questions,
    _ierkbos6.SessionRecap? recap,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SessionSnapshot',
      'session': session.toJson(),
      'questions': questions.toJson(valueToJson: (v) => v.toJson()),
      if (recap != null) 'recap': recap?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SessionSnapshot',
      'session': session.toJsonForProtocol(),
      'questions': questions.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (recap != null) 'recap': recap?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SessionSnapshotImpl extends SessionSnapshot {
  _SessionSnapshotImpl({
    required _idvyhnfa.TalkSession session,
    required List<_in6mynjk.Question> questions,
    _ierkbos6.SessionRecap? recap,
  }) : super._(
         session: session,
         questions: questions,
         recap: recap,
       );

  /// Returns a shallow copy of this [SessionSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SessionSnapshot copyWith({
    _idvyhnfa.TalkSession? session,
    List<_in6mynjk.Question>? questions,
    Object? recap = _Undefined,
  }) {
    return SessionSnapshot(
      session: session ?? this.session.copyWith(),
      questions:
          questions ?? this.questions.map((e0) => e0.copyWith()).toList(),
      recap: recap is _ierkbos6.SessionRecap? ? recap : this.recap?.copyWith(),
    );
  }
}

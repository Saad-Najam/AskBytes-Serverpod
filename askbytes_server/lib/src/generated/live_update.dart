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
import 'live_update_type.dart' as _ifu9ospq;
import 'question.dart' as _in6mynjk;
import 'session_recap.dart' as _ierkbos6;
import 'talk_session.dart' as _idvyhnfa;

abstract class LiveUpdate
    implements _is.SerializableModel, _is.ProtocolSerialization {
  LiveUpdate._({
    required this.type,
    this.questions,
    this.question,
    this.session,
    this.recap,
  });

  factory LiveUpdate({
    required _ifu9ospq.LiveUpdateType type,
    List<_in6mynjk.Question>? questions,
    _in6mynjk.Question? question,
    _idvyhnfa.TalkSession? session,
    _ierkbos6.SessionRecap? recap,
  }) = _LiveUpdateImpl;

  factory LiveUpdate.fromJson(Map<String, dynamic> jsonSerialization) {
    return LiveUpdate(
      type: _ifu9ospq.LiveUpdateType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      questions: jsonSerialization['questions'] == null
          ? null
          : _i904v5el.Protocol().deserialize<List<_in6mynjk.Question>>(
              jsonSerialization['questions'],
            ),
      question: jsonSerialization['question'] == null
          ? null
          : _i904v5el.Protocol().deserialize<_in6mynjk.Question>(
              jsonSerialization['question'],
            ),
      session: jsonSerialization['session'] == null
          ? null
          : _i904v5el.Protocol().deserialize<_idvyhnfa.TalkSession>(
              jsonSerialization['session'],
            ),
      recap: jsonSerialization['recap'] == null
          ? null
          : _i904v5el.Protocol().deserialize<_ierkbos6.SessionRecap>(
              jsonSerialization['recap'],
            ),
    );
  }

  _ifu9ospq.LiveUpdateType type;

  List<_in6mynjk.Question>? questions;

  _in6mynjk.Question? question;

  _idvyhnfa.TalkSession? session;

  _ierkbos6.SessionRecap? recap;

  /// Returns a shallow copy of this [LiveUpdate]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LiveUpdate copyWith({
    _ifu9ospq.LiveUpdateType? type,
    List<_in6mynjk.Question>? questions,
    _in6mynjk.Question? question,
    _idvyhnfa.TalkSession? session,
    _ierkbos6.SessionRecap? recap,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LiveUpdate',
      'type': type.toJson(),
      if (questions != null)
        'questions': questions?.toJson(valueToJson: (v) => v.toJson()),
      if (question != null) 'question': question?.toJson(),
      if (session != null) 'session': session?.toJson(),
      if (recap != null) 'recap': recap?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LiveUpdate',
      'type': type.toJson(),
      if (questions != null)
        'questions': questions?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      if (question != null) 'question': question?.toJsonForProtocol(),
      if (session != null) 'session': session?.toJsonForProtocol(),
      if (recap != null) 'recap': recap?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LiveUpdateImpl extends LiveUpdate {
  _LiveUpdateImpl({
    required _ifu9ospq.LiveUpdateType type,
    List<_in6mynjk.Question>? questions,
    _in6mynjk.Question? question,
    _idvyhnfa.TalkSession? session,
    _ierkbos6.SessionRecap? recap,
  }) : super._(
         type: type,
         questions: questions,
         question: question,
         session: session,
         recap: recap,
       );

  /// Returns a shallow copy of this [LiveUpdate]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LiveUpdate copyWith({
    _ifu9ospq.LiveUpdateType? type,
    Object? questions = _Undefined,
    Object? question = _Undefined,
    Object? session = _Undefined,
    Object? recap = _Undefined,
  }) {
    return LiveUpdate(
      type: type ?? this.type,
      questions: questions is List<_in6mynjk.Question>?
          ? questions
          : this.questions?.map((e0) => e0.copyWith()).toList(),
      question: question is _in6mynjk.Question?
          ? question
          : this.question?.copyWith(),
      session: session is _idvyhnfa.TalkSession?
          ? session
          : this.session?.copyWith(),
      recap: recap is _ierkbos6.SessionRecap? ? recap : this.recap?.copyWith(),
    );
  }
}

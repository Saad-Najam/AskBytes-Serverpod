/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:askbytes_client/src/protocol/talk_session.dart' as _i3bzerrm;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'askbytes_exception.dart' as _ino9uf2p;
import 'event.dart' as _iu57571s;
import 'live_update.dart' as _irca74ja;
import 'live_update_type.dart' as _ifu9ospq;
import 'question.dart' as _in6mynjk;
import 'question_result.dart' as _irqizq2p;
import 'session_recap.dart' as _ierkbos6;
import 'session_snapshot.dart' as _ivskvuzv;
import 'session_stats.dart' as _iq65gbsd;
import 'talk_session.dart' as _idvyhnfa;
import 'vote.dart' as _idh2mpcr;
export 'askbytes_exception.dart';
export 'event.dart';
export 'live_update.dart';
export 'live_update_type.dart';
export 'question.dart';
export 'question_result.dart';
export 'session_recap.dart';
export 'session_snapshot.dart';
export 'session_stats.dart';
export 'talk_session.dart';
export 'vote.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _ino9uf2p.AskBytesException) {
      return _ino9uf2p.AskBytesException.fromJson(data) as T;
    }
    if (t == _iu57571s.Event) {
      return _iu57571s.Event.fromJson(data) as T;
    }
    if (t == _irca74ja.LiveUpdate) {
      return _irca74ja.LiveUpdate.fromJson(data) as T;
    }
    if (t == _ifu9ospq.LiveUpdateType) {
      return _ifu9ospq.LiveUpdateType.fromJson(data) as T;
    }
    if (t == _in6mynjk.Question) {
      return _in6mynjk.Question.fromJson(data) as T;
    }
    if (t == _irqizq2p.QuestionResult) {
      return _irqizq2p.QuestionResult.fromJson(data) as T;
    }
    if (t == _ierkbos6.SessionRecap) {
      return _ierkbos6.SessionRecap.fromJson(data) as T;
    }
    if (t == _ivskvuzv.SessionSnapshot) {
      return _ivskvuzv.SessionSnapshot.fromJson(data) as T;
    }
    if (t == _iq65gbsd.SessionStats) {
      return _iq65gbsd.SessionStats.fromJson(data) as T;
    }
    if (t == _idvyhnfa.TalkSession) {
      return _idvyhnfa.TalkSession.fromJson(data) as T;
    }
    if (t == _idh2mpcr.Vote) {
      return _idh2mpcr.Vote.fromJson(data) as T;
    }
    if (t == _isc.getType<_ino9uf2p.AskBytesException?>()) {
      return (data != null ? _ino9uf2p.AskBytesException.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iu57571s.Event?>()) {
      return (data != null ? _iu57571s.Event.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_irca74ja.LiveUpdate?>()) {
      return (data != null ? _irca74ja.LiveUpdate.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ifu9ospq.LiveUpdateType?>()) {
      return (data != null ? _ifu9ospq.LiveUpdateType.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_in6mynjk.Question?>()) {
      return (data != null ? _in6mynjk.Question.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_irqizq2p.QuestionResult?>()) {
      return (data != null ? _irqizq2p.QuestionResult.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ierkbos6.SessionRecap?>()) {
      return (data != null ? _ierkbos6.SessionRecap.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ivskvuzv.SessionSnapshot?>()) {
      return (data != null ? _ivskvuzv.SessionSnapshot.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iq65gbsd.SessionStats?>()) {
      return (data != null ? _iq65gbsd.SessionStats.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_idvyhnfa.TalkSession?>()) {
      return (data != null ? _idvyhnfa.TalkSession.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_idh2mpcr.Vote?>()) {
      return (data != null ? _idh2mpcr.Vote.fromJson(data) : null) as T;
    }
    if (t == List<_in6mynjk.Question>) {
      return (data as List)
              .map((e) => deserialize<_in6mynjk.Question>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_in6mynjk.Question>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_in6mynjk.Question>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i3bzerrm.TalkSession>) {
      return (data as List)
              .map((e) => deserialize<_i3bzerrm.TalkSession>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ino9uf2p.AskBytesException => 'AskBytesException',
      _iu57571s.Event => 'Event',
      _irca74ja.LiveUpdate => 'LiveUpdate',
      _ifu9ospq.LiveUpdateType => 'LiveUpdateType',
      _in6mynjk.Question => 'Question',
      _irqizq2p.QuestionResult => 'QuestionResult',
      _ierkbos6.SessionRecap => 'SessionRecap',
      _ivskvuzv.SessionSnapshot => 'SessionSnapshot',
      _iq65gbsd.SessionStats => 'SessionStats',
      _idvyhnfa.TalkSession => 'TalkSession',
      _idh2mpcr.Vote => 'Vote',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('askbytes.', '');
    }

    switch (data) {
      case _ino9uf2p.AskBytesException():
        return 'AskBytesException';
      case _iu57571s.Event():
        return 'Event';
      case _irca74ja.LiveUpdate():
        return 'LiveUpdate';
      case _ifu9ospq.LiveUpdateType():
        return 'LiveUpdateType';
      case _in6mynjk.Question():
        return 'Question';
      case _irqizq2p.QuestionResult():
        return 'QuestionResult';
      case _ierkbos6.SessionRecap():
        return 'SessionRecap';
      case _ivskvuzv.SessionSnapshot():
        return 'SessionSnapshot';
      case _iq65gbsd.SessionStats():
        return 'SessionStats';
      case _idvyhnfa.TalkSession():
        return 'TalkSession';
      case _idh2mpcr.Vote():
        return 'Vote';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AskBytesException') {
      return deserialize<_ino9uf2p.AskBytesException>(data['data']);
    }
    if (dataClassName == 'Event') {
      return deserialize<_iu57571s.Event>(data['data']);
    }
    if (dataClassName == 'LiveUpdate') {
      return deserialize<_irca74ja.LiveUpdate>(data['data']);
    }
    if (dataClassName == 'LiveUpdateType') {
      return deserialize<_ifu9ospq.LiveUpdateType>(data['data']);
    }
    if (dataClassName == 'Question') {
      return deserialize<_in6mynjk.Question>(data['data']);
    }
    if (dataClassName == 'QuestionResult') {
      return deserialize<_irqizq2p.QuestionResult>(data['data']);
    }
    if (dataClassName == 'SessionRecap') {
      return deserialize<_ierkbos6.SessionRecap>(data['data']);
    }
    if (dataClassName == 'SessionSnapshot') {
      return deserialize<_ivskvuzv.SessionSnapshot>(data['data']);
    }
    if (dataClassName == 'SessionStats') {
      return deserialize<_iq65gbsd.SessionStats>(data['data']);
    }
    if (dataClassName == 'TalkSession') {
      return deserialize<_idvyhnfa.TalkSession>(data['data']);
    }
    if (dataClassName == 'Vote') {
      return deserialize<_idh2mpcr.Vote>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('askbytes', this);
    _iacc.Protocol().registerHostProtocol('askbytes', this);
  }

  @override
  String getModuleName() => 'askbytes';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}

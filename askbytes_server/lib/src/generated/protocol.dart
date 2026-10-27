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
import 'package:askbytes_server/src/generated/talk_session.dart' as _i27inhfv;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'askbytes_exception.dart' as _ino9uf2p;
import 'event.dart' as _iu57571s;
import 'future_calls_generated_models/recap_future_call_rebroadcast_model.dart'
    as _i27li2e4;
import 'future_calls_generated_models/session_timer_future_call_auto_end_model.dart'
    as _ibif6k04;
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

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'event',
      dartName: 'Event',
      schema: 'public',
      module: 'askbytes',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'question',
      dartName: 'Question',
      schema: 'public',
      module: 'askbytes',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'sessionId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'text',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'voteCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'embedding',
          columnType: _isp.ColumnType.vector,
          isNullable: true,
          dartType: 'Vector(768)?',
          vectorDimension: 768,
        ),
        _isp.ColumnDefinition(
          name: 'mergeCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'mergeNote',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'pinned',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'postedById',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'question_fk_0',
          columns: ['sessionId'],
          referenceTable: 'talk_session',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'question_session_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sessionId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'session_recap',
      dartName: 'SessionRecap',
      schema: 'public',
      module: 'askbytes',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'sessionId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'summaryMarkdown',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'keyThemes',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'topQuestions',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'unanswered',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'generatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'session_recap_fk_0',
          columns: ['sessionId'],
          referenceTable: 'talk_session',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'session_recap_session_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sessionId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'talk_session',
      dartName: 'TalkSession',
      schema: 'public',
      module: 'askbytes',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'eventId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'speakerName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'durationMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'speakerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'joinCode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'active\'',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'endedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'talk_session_fk_0',
          columns: ['eventId'],
          referenceTable: 'event',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'talk_session_join_code_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'joinCode',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'talk_session_speaker_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'speakerId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'vote',
      dartName: 'Vote',
      schema: 'public',
      module: 'askbytes',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'questionId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'voterToken',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'vote_fk_0',
          columns: ['questionId'],
          referenceTable: 'question',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'vote_unique_voter_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'questionId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'voterToken',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._iais.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
  ];

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
      } on _is.DeserializationClassNameNotFoundException catch (_) {
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
    if (t == _i27li2e4.RecapFutureCallRebroadcastModel) {
      return _i27li2e4.RecapFutureCallRebroadcastModel.fromJson(data) as T;
    }
    if (t == _ibif6k04.SessionTimerFutureCallAutoEndModel) {
      return _ibif6k04.SessionTimerFutureCallAutoEndModel.fromJson(data) as T;
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
    if (t == _is.getType<_ino9uf2p.AskBytesException?>()) {
      return (data != null ? _ino9uf2p.AskBytesException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iu57571s.Event?>()) {
      return (data != null ? _iu57571s.Event.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i27li2e4.RecapFutureCallRebroadcastModel?>()) {
      return (data != null
              ? _i27li2e4.RecapFutureCallRebroadcastModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ibif6k04.SessionTimerFutureCallAutoEndModel?>()) {
      return (data != null
              ? _ibif6k04.SessionTimerFutureCallAutoEndModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_irca74ja.LiveUpdate?>()) {
      return (data != null ? _irca74ja.LiveUpdate.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ifu9ospq.LiveUpdateType?>()) {
      return (data != null ? _ifu9ospq.LiveUpdateType.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_in6mynjk.Question?>()) {
      return (data != null ? _in6mynjk.Question.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_irqizq2p.QuestionResult?>()) {
      return (data != null ? _irqizq2p.QuestionResult.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ierkbos6.SessionRecap?>()) {
      return (data != null ? _ierkbos6.SessionRecap.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ivskvuzv.SessionSnapshot?>()) {
      return (data != null ? _ivskvuzv.SessionSnapshot.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iq65gbsd.SessionStats?>()) {
      return (data != null ? _iq65gbsd.SessionStats.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_idvyhnfa.TalkSession?>()) {
      return (data != null ? _idvyhnfa.TalkSession.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_idh2mpcr.Vote?>()) {
      return (data != null ? _idh2mpcr.Vote.fromJson(data) : null) as T;
    }
    if (t == List<_in6mynjk.Question>) {
      return (data as List)
              .map((e) => deserialize<_in6mynjk.Question>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_in6mynjk.Question>?>()) {
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
    if (t == List<_i27inhfv.TalkSession>) {
      return (data as List)
              .map((e) => deserialize<_i27inhfv.TalkSession>(e))
              .toList()
          as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ino9uf2p.AskBytesException => 'AskBytesException',
      _iu57571s.Event => 'Event',
      _i27li2e4.RecapFutureCallRebroadcastModel =>
        'RecapFutureCallRebroadcastModel',
      _ibif6k04.SessionTimerFutureCallAutoEndModel =>
        'SessionTimerFutureCallAutoEndModel',
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
      case _i27li2e4.RecapFutureCallRebroadcastModel():
        return 'RecapFutureCallRebroadcastModel';
      case _ibif6k04.SessionTimerFutureCallAutoEndModel():
        return 'SessionTimerFutureCallAutoEndModel';
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
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
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
    if (dataClassName == 'RecapFutureCallRebroadcastModel') {
      return deserialize<_i27li2e4.RecapFutureCallRebroadcastModel>(
        data['data'],
      );
    }
    if (dataClassName == 'SessionTimerFutureCallAutoEndModel') {
      return deserialize<_ibif6k04.SessionTimerFutureCallAutoEndModel>(
        data['data'],
      );
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
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('askbytes', this);
    _iacs.Protocol().registerHostProtocol('askbytes', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _iu57571s.Event:
        return _iu57571s.Event.t;
      case _in6mynjk.Question:
        return _in6mynjk.Question.t;
      case _ierkbos6.SessionRecap:
        return _ierkbos6.SessionRecap.t;
      case _idvyhnfa.TalkSession:
        return _idvyhnfa.TalkSession.t;
      case _idh2mpcr.Vote:
        return _idh2mpcr.Vote.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

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
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}

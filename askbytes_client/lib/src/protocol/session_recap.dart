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
import 'package:askbytes_client/src/protocol/protocol.dart' as _id62ch32;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class SessionRecap
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SessionRecap._({
    this.id,
    required this.sessionId,
    required this.summaryMarkdown,
    required this.keyThemes,
    required this.topQuestions,
    required this.unanswered,
    DateTime? generatedAt,
  }) : generatedAt = generatedAt ?? DateTime.now();

  factory SessionRecap({
    int? id,
    required int sessionId,
    required String summaryMarkdown,
    required List<String> keyThemes,
    required String topQuestions,
    required List<String> unanswered,
    DateTime? generatedAt,
  }) = _SessionRecapImpl;

  factory SessionRecap.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionRecap(
      id: jsonSerialization['id'] as int?,
      sessionId: jsonSerialization['sessionId'] as int,
      summaryMarkdown: jsonSerialization['summaryMarkdown'] as String,
      keyThemes: _id62ch32.Protocol().deserialize<List<String>>(
        jsonSerialization['keyThemes'],
      ),
      topQuestions: jsonSerialization['topQuestions'] as String,
      unanswered: _id62ch32.Protocol().deserialize<List<String>>(
        jsonSerialization['unanswered'],
      ),
      generatedAt: jsonSerialization['generatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['generatedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int sessionId;

  String summaryMarkdown;

  List<String> keyThemes;

  String topQuestions;

  List<String> unanswered;

  DateTime generatedAt;

  /// Returns a shallow copy of this [SessionRecap]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SessionRecap copyWith({
    int? id,
    int? sessionId,
    String? summaryMarkdown,
    List<String>? keyThemes,
    String? topQuestions,
    List<String>? unanswered,
    DateTime? generatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SessionRecap',
      if (id != null) 'id': id,
      'sessionId': sessionId,
      'summaryMarkdown': summaryMarkdown,
      'keyThemes': keyThemes.toJson(),
      'topQuestions': topQuestions,
      'unanswered': unanswered.toJson(),
      'generatedAt': generatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SessionRecap',
      if (id != null) 'id': id,
      'sessionId': sessionId,
      'summaryMarkdown': summaryMarkdown,
      'keyThemes': keyThemes.toJson(),
      'topQuestions': topQuestions,
      'unanswered': unanswered.toJson(),
      'generatedAt': generatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SessionRecapImpl extends SessionRecap {
  _SessionRecapImpl({
    int? id,
    required int sessionId,
    required String summaryMarkdown,
    required List<String> keyThemes,
    required String topQuestions,
    required List<String> unanswered,
    DateTime? generatedAt,
  }) : super._(
         id: id,
         sessionId: sessionId,
         summaryMarkdown: summaryMarkdown,
         keyThemes: keyThemes,
         topQuestions: topQuestions,
         unanswered: unanswered,
         generatedAt: generatedAt,
       );

  /// Returns a shallow copy of this [SessionRecap]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SessionRecap copyWith({
    Object? id = _Undefined,
    int? sessionId,
    String? summaryMarkdown,
    List<String>? keyThemes,
    String? topQuestions,
    List<String>? unanswered,
    DateTime? generatedAt,
  }) {
    return SessionRecap(
      id: id is int? ? id : this.id,
      sessionId: sessionId ?? this.sessionId,
      summaryMarkdown: summaryMarkdown ?? this.summaryMarkdown,
      keyThemes: keyThemes ?? this.keyThemes.map((e0) => e0).toList(),
      topQuestions: topQuestions ?? this.topQuestions,
      unanswered: unanswered ?? this.unanswered.map((e0) => e0).toList(),
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }
}

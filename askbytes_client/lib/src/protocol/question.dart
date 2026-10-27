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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class Question
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Question._({
    this.id,
    required this.sessionId,
    required this.text,
    int? voteCount,
    int? mergeCount,
    this.mergeNote,
    bool? pinned,
    required this.postedById,
    DateTime? createdAt,
  }) : voteCount = voteCount ?? 0,
       mergeCount = mergeCount ?? 0,
       pinned = pinned ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory Question({
    int? id,
    required int sessionId,
    required String text,
    int? voteCount,
    int? mergeCount,
    String? mergeNote,
    bool? pinned,
    required String postedById,
    DateTime? createdAt,
  }) = _QuestionImpl;

  factory Question.fromJson(Map<String, dynamic> jsonSerialization) {
    return Question(
      id: jsonSerialization['id'] as int?,
      sessionId: jsonSerialization['sessionId'] as int,
      text: jsonSerialization['text'] as String,
      voteCount: jsonSerialization['voteCount'] as int?,
      mergeCount: jsonSerialization['mergeCount'] as int?,
      mergeNote: jsonSerialization['mergeNote'] as String?,
      pinned: jsonSerialization['pinned'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['pinned']),
      postedById: jsonSerialization['postedById'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int sessionId;

  String text;

  int voteCount;

  int mergeCount;

  String? mergeNote;

  bool pinned;

  String postedById;

  DateTime createdAt;

  /// Returns a shallow copy of this [Question]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Question copyWith({
    int? id,
    int? sessionId,
    String? text,
    int? voteCount,
    int? mergeCount,
    String? mergeNote,
    bool? pinned,
    String? postedById,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Question',
      if (id != null) 'id': id,
      'sessionId': sessionId,
      'text': text,
      'voteCount': voteCount,
      'mergeCount': mergeCount,
      if (mergeNote != null) 'mergeNote': mergeNote,
      'pinned': pinned,
      'postedById': postedById,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Question',
      if (id != null) 'id': id,
      'sessionId': sessionId,
      'text': text,
      'voteCount': voteCount,
      'mergeCount': mergeCount,
      if (mergeNote != null) 'mergeNote': mergeNote,
      'pinned': pinned,
      'postedById': postedById,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QuestionImpl extends Question {
  _QuestionImpl({
    int? id,
    required int sessionId,
    required String text,
    int? voteCount,
    int? mergeCount,
    String? mergeNote,
    bool? pinned,
    required String postedById,
    DateTime? createdAt,
  }) : super._(
         id: id,
         sessionId: sessionId,
         text: text,
         voteCount: voteCount,
         mergeCount: mergeCount,
         mergeNote: mergeNote,
         pinned: pinned,
         postedById: postedById,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Question]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Question copyWith({
    Object? id = _Undefined,
    int? sessionId,
    String? text,
    int? voteCount,
    int? mergeCount,
    Object? mergeNote = _Undefined,
    bool? pinned,
    String? postedById,
    DateTime? createdAt,
  }) {
    return Question(
      id: id is int? ? id : this.id,
      sessionId: sessionId ?? this.sessionId,
      text: text ?? this.text,
      voteCount: voteCount ?? this.voteCount,
      mergeCount: mergeCount ?? this.mergeCount,
      mergeNote: mergeNote is String? ? mergeNote : this.mergeNote,
      pinned: pinned ?? this.pinned,
      postedById: postedById ?? this.postedById,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

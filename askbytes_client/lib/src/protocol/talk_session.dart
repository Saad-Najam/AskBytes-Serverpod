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

abstract class TalkSession
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TalkSession._({
    this.id,
    this.eventId,
    required this.title,
    required this.speakerName,
    this.description,
    this.durationMinutes,
    required this.speakerId,
    required this.joinCode,
    String? status,
    int? questionCount,
    bool? autoEndScheduled,
    DateTime? createdAt,
    this.endedAt,
  }) : status = status ?? 'active',
       questionCount = questionCount ?? 0,
       autoEndScheduled = autoEndScheduled ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory TalkSession({
    int? id,
    int? eventId,
    required String title,
    required String speakerName,
    String? description,
    int? durationMinutes,
    required _isc.UuidValue speakerId,
    required String joinCode,
    String? status,
    int? questionCount,
    bool? autoEndScheduled,
    DateTime? createdAt,
    DateTime? endedAt,
  }) = _TalkSessionImpl;

  factory TalkSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return TalkSession(
      id: jsonSerialization['id'] as int?,
      eventId: jsonSerialization['eventId'] as int?,
      title: jsonSerialization['title'] as String,
      speakerName: jsonSerialization['speakerName'] as String,
      description: jsonSerialization['description'] as String?,
      durationMinutes: jsonSerialization['durationMinutes'] as int?,
      speakerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['speakerId'],
      ),
      joinCode: jsonSerialization['joinCode'] as String,
      status: jsonSerialization['status'] as String?,
      questionCount: jsonSerialization['questionCount'] as int?,
      autoEndScheduled: jsonSerialization['autoEndScheduled'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['autoEndScheduled'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      endedAt: jsonSerialization['endedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['endedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int? eventId;

  String title;

  String speakerName;

  String? description;

  int? durationMinutes;

  _isc.UuidValue speakerId;

  String joinCode;

  String status;

  int questionCount;

  bool autoEndScheduled;

  DateTime createdAt;

  DateTime? endedAt;

  /// Returns a shallow copy of this [TalkSession]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TalkSession copyWith({
    int? id,
    int? eventId,
    String? title,
    String? speakerName,
    String? description,
    int? durationMinutes,
    _isc.UuidValue? speakerId,
    String? joinCode,
    String? status,
    int? questionCount,
    bool? autoEndScheduled,
    DateTime? createdAt,
    DateTime? endedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TalkSession',
      if (id != null) 'id': id,
      if (eventId != null) 'eventId': eventId,
      'title': title,
      'speakerName': speakerName,
      if (description != null) 'description': description,
      if (durationMinutes != null) 'durationMinutes': durationMinutes,
      'speakerId': speakerId.toJson(),
      'joinCode': joinCode,
      'status': status,
      'questionCount': questionCount,
      'autoEndScheduled': autoEndScheduled,
      'createdAt': createdAt.toJson(),
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TalkSession',
      if (id != null) 'id': id,
      if (eventId != null) 'eventId': eventId,
      'title': title,
      'speakerName': speakerName,
      if (description != null) 'description': description,
      if (durationMinutes != null) 'durationMinutes': durationMinutes,
      'speakerId': speakerId.toJson(),
      'joinCode': joinCode,
      'status': status,
      'questionCount': questionCount,
      'autoEndScheduled': autoEndScheduled,
      'createdAt': createdAt.toJson(),
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TalkSessionImpl extends TalkSession {
  _TalkSessionImpl({
    int? id,
    int? eventId,
    required String title,
    required String speakerName,
    String? description,
    int? durationMinutes,
    required _isc.UuidValue speakerId,
    required String joinCode,
    String? status,
    int? questionCount,
    bool? autoEndScheduled,
    DateTime? createdAt,
    DateTime? endedAt,
  }) : super._(
         id: id,
         eventId: eventId,
         title: title,
         speakerName: speakerName,
         description: description,
         durationMinutes: durationMinutes,
         speakerId: speakerId,
         joinCode: joinCode,
         status: status,
         questionCount: questionCount,
         autoEndScheduled: autoEndScheduled,
         createdAt: createdAt,
         endedAt: endedAt,
       );

  /// Returns a shallow copy of this [TalkSession]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TalkSession copyWith({
    Object? id = _Undefined,
    Object? eventId = _Undefined,
    String? title,
    String? speakerName,
    Object? description = _Undefined,
    Object? durationMinutes = _Undefined,
    _isc.UuidValue? speakerId,
    String? joinCode,
    String? status,
    int? questionCount,
    bool? autoEndScheduled,
    DateTime? createdAt,
    Object? endedAt = _Undefined,
  }) {
    return TalkSession(
      id: id is int? ? id : this.id,
      eventId: eventId is int? ? eventId : this.eventId,
      title: title ?? this.title,
      speakerName: speakerName ?? this.speakerName,
      description: description is String? ? description : this.description,
      durationMinutes: durationMinutes is int?
          ? durationMinutes
          : this.durationMinutes,
      speakerId: speakerId ?? this.speakerId,
      joinCode: joinCode ?? this.joinCode,
      status: status ?? this.status,
      questionCount: questionCount ?? this.questionCount,
      autoEndScheduled: autoEndScheduled ?? this.autoEndScheduled,
      createdAt: createdAt ?? this.createdAt,
      endedAt: endedAt is DateTime? ? endedAt : this.endedAt,
    );
  }
}

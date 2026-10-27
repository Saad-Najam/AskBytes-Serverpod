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

abstract class Event
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Event._({
    this.id,
    required this.name,
    this.description,
    required this.ownerId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Event({
    int? id,
    required String name,
    String? description,
    required _isc.UuidValue ownerId,
    DateTime? createdAt,
  }) = _EventImpl;

  factory Event.fromJson(Map<String, dynamic> jsonSerialization) {
    return Event(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String? description;

  _isc.UuidValue ownerId;

  DateTime createdAt;

  /// Returns a shallow copy of this [Event]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Event copyWith({
    int? id,
    String? name,
    String? description,
    _isc.UuidValue? ownerId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Event',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'ownerId': ownerId.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Event',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'ownerId': ownerId.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EventImpl extends Event {
  _EventImpl({
    int? id,
    required String name,
    String? description,
    required _isc.UuidValue ownerId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         name: name,
         description: description,
         ownerId: ownerId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Event]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Event copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    _isc.UuidValue? ownerId,
    DateTime? createdAt,
  }) {
    return Event(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

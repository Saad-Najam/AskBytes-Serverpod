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
import 'question.dart' as _in6mynjk;

abstract class QuestionResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  QuestionResult._({
    required this.merged,
    required this.question,
    required this.message,
  });

  factory QuestionResult({
    required bool merged,
    required _in6mynjk.Question question,
    required String message,
  }) = _QuestionResultImpl;

  factory QuestionResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return QuestionResult(
      merged: _isc.BoolJsonExtension.fromJson(jsonSerialization['merged']),
      question: _id62ch32.Protocol().deserialize<_in6mynjk.Question>(
        jsonSerialization['question'],
      ),
      message: jsonSerialization['message'] as String,
    );
  }

  bool merged;

  _in6mynjk.Question question;

  String message;

  /// Returns a shallow copy of this [QuestionResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  QuestionResult copyWith({
    bool? merged,
    _in6mynjk.Question? question,
    String? message,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'QuestionResult',
      'merged': merged,
      'question': question.toJson(),
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'QuestionResult',
      'merged': merged,
      'question': question.toJsonForProtocol(),
      'message': message,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _QuestionResultImpl extends QuestionResult {
  _QuestionResultImpl({
    required bool merged,
    required _in6mynjk.Question question,
    required String message,
  }) : super._(
         merged: merged,
         question: question,
         message: message,
       );

  /// Returns a shallow copy of this [QuestionResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  QuestionResult copyWith({
    bool? merged,
    _in6mynjk.Question? question,
    String? message,
  }) {
    return QuestionResult(
      merged: merged ?? this.merged,
      question: question ?? this.question.copyWith(),
      message: message ?? this.message,
    );
  }
}

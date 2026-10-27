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

abstract class SessionStats
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SessionStats._({
    required this.totalQuestions,
    required this.totalVotes,
    required this.mergedDuplicates,
    required this.participants,
  });

  factory SessionStats({
    required int totalQuestions,
    required int totalVotes,
    required int mergedDuplicates,
    required int participants,
  }) = _SessionStatsImpl;

  factory SessionStats.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionStats(
      totalQuestions: jsonSerialization['totalQuestions'] as int,
      totalVotes: jsonSerialization['totalVotes'] as int,
      mergedDuplicates: jsonSerialization['mergedDuplicates'] as int,
      participants: jsonSerialization['participants'] as int,
    );
  }

  int totalQuestions;

  int totalVotes;

  int mergedDuplicates;

  int participants;

  /// Returns a shallow copy of this [SessionStats]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SessionStats copyWith({
    int? totalQuestions,
    int? totalVotes,
    int? mergedDuplicates,
    int? participants,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SessionStats',
      'totalQuestions': totalQuestions,
      'totalVotes': totalVotes,
      'mergedDuplicates': mergedDuplicates,
      'participants': participants,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SessionStats',
      'totalQuestions': totalQuestions,
      'totalVotes': totalVotes,
      'mergedDuplicates': mergedDuplicates,
      'participants': participants,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SessionStatsImpl extends SessionStats {
  _SessionStatsImpl({
    required int totalQuestions,
    required int totalVotes,
    required int mergedDuplicates,
    required int participants,
  }) : super._(
         totalQuestions: totalQuestions,
         totalVotes: totalVotes,
         mergedDuplicates: mergedDuplicates,
         participants: participants,
       );

  /// Returns a shallow copy of this [SessionStats]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SessionStats copyWith({
    int? totalQuestions,
    int? totalVotes,
    int? mergedDuplicates,
    int? participants,
  }) {
    return SessionStats(
      totalQuestions: totalQuestions ?? this.totalQuestions,
      totalVotes: totalVotes ?? this.totalVotes,
      mergedDuplicates: mergedDuplicates ?? this.mergedDuplicates,
      participants: participants ?? this.participants,
    );
  }
}

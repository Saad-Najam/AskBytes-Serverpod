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

abstract class AskBytesException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  AskBytesException._({required this.message});

  factory AskBytesException({required String message}) = _AskBytesExceptionImpl;

  factory AskBytesException.fromJson(Map<String, dynamic> jsonSerialization) {
    return AskBytesException(message: jsonSerialization['message'] as String);
  }

  String message;

  /// Returns a shallow copy of this [AskBytesException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AskBytesException copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AskBytesException',
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AskBytesException',
      'message': message,
    };
  }

  @override
  String toString() {
    return 'AskBytesException(message: $message)';
  }
}

class _AskBytesExceptionImpl extends AskBytesException {
  _AskBytesExceptionImpl({required String message}) : super._(message: message);

  /// Returns a shallow copy of this [AskBytesException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AskBytesException copyWith({String? message}) {
    return AskBytesException(message: message ?? this.message);
  }
}

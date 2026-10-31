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

/// A small arithmetic question the app shows before a support message can
/// be sent. The answer stays on the server; the id is single-use.
abstract class SupportChallenge
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SupportChallenge._({
    required this.id,
    required this.question,
    required this.expiresAt,
  });

  factory SupportChallenge({
    required String id,
    required String question,
    required DateTime expiresAt,
  }) = _SupportChallengeImpl;

  factory SupportChallenge.fromJson(Map<String, dynamic> jsonSerialization) {
    return SupportChallenge(
      id: jsonSerialization['id'] as String,
      question: jsonSerialization['question'] as String,
      expiresAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
    );
  }

  /// Opaque id to send back with the answer.
  String id;

  /// Human-readable question, e.g. "7 + 5".
  String question;

  /// After this moment the challenge is refused and a new one is needed.
  DateTime expiresAt;

  /// Returns a shallow copy of this [SupportChallenge]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SupportChallenge copyWith({
    String? id,
    String? question,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SupportChallenge',
      'id': id,
      'question': question,
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SupportChallenge',
      'id': id,
      'question': question,
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SupportChallengeImpl extends SupportChallenge {
  _SupportChallengeImpl({
    required String id,
    required String question,
    required DateTime expiresAt,
  }) : super._(
         id: id,
         question: question,
         expiresAt: expiresAt,
       );

  /// Returns a shallow copy of this [SupportChallenge]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SupportChallenge copyWith({
    String? id,
    String? question,
    DateTime? expiresAt,
  }) {
    return SupportChallenge(
      id: id ?? this.id,
      question: question ?? this.question,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}

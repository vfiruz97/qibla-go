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

/// Outcome of sending a support message.
enum SupportSubmitResult implements _isc.SerializableModel {
  /// Stored. Thank the user.
  accepted,

  /// The arithmetic answer was wrong; the challenge is spent, ask for a new one.
  wrongAnswer,

  /// Unknown or expired challenge id; ask for a new one.
  challengeExpired,

  /// This client has sent too much recently; try later.
  tooManyRequests,

  /// Message empty, too short or too long, or contact too long.
  messageInvalid;

  static SupportSubmitResult fromJson(String name) {
    switch (name) {
      case 'accepted':
        return SupportSubmitResult.accepted;
      case 'wrongAnswer':
        return SupportSubmitResult.wrongAnswer;
      case 'challengeExpired':
        return SupportSubmitResult.challengeExpired;
      case 'tooManyRequests':
        return SupportSubmitResult.tooManyRequests;
      case 'messageInvalid':
        return SupportSubmitResult.messageInvalid;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "SupportSubmitResult"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}

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

/// One event as the app sends it. The launch-wide context (session id,
/// platform, version, language) travels once per batch, not per event.
abstract class AnalyticsEventInput
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AnalyticsEventInput._({
    required this.occurredAt,
    required this.name,
    this.screen,
    this.fromScreen,
    this.durationMs,
    this.outcome,
  });

  factory AnalyticsEventInput({
    required DateTime occurredAt,
    required String name,
    String? screen,
    String? fromScreen,
    int? durationMs,
    String? outcome,
  }) = _AnalyticsEventInputImpl;

  factory AnalyticsEventInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return AnalyticsEventInput(
      occurredAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['occurredAt'],
      ),
      name: jsonSerialization['name'] as String,
      screen: jsonSerialization['screen'] as String?,
      fromScreen: jsonSerialization['fromScreen'] as String?,
      durationMs: jsonSerialization['durationMs'] as int?,
      outcome: jsonSerialization['outcome'] as String?,
    );
  }

  /// When it happened on the device (UTC).
  DateTime occurredAt;

  /// Event name; see AnalyticsGuard.allowedNames.
  String name;

  /// Screen or sheet name, when the event has one.
  String? screen;

  /// Previous screen, for navigation events.
  String? fromScreen;

  /// Duration in milliseconds, when the event has one.
  int? durationMs;

  /// Short result tag, when the event has one.
  String? outcome;

  /// Returns a shallow copy of this [AnalyticsEventInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AnalyticsEventInput copyWith({
    DateTime? occurredAt,
    String? name,
    String? screen,
    String? fromScreen,
    int? durationMs,
    String? outcome,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AnalyticsEventInput',
      'occurredAt': occurredAt.toJson(),
      'name': name,
      if (screen != null) 'screen': screen,
      if (fromScreen != null) 'fromScreen': fromScreen,
      if (durationMs != null) 'durationMs': durationMs,
      if (outcome != null) 'outcome': outcome,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AnalyticsEventInput',
      'occurredAt': occurredAt.toJson(),
      'name': name,
      if (screen != null) 'screen': screen,
      if (fromScreen != null) 'fromScreen': fromScreen,
      if (durationMs != null) 'durationMs': durationMs,
      if (outcome != null) 'outcome': outcome,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AnalyticsEventInputImpl extends AnalyticsEventInput {
  _AnalyticsEventInputImpl({
    required DateTime occurredAt,
    required String name,
    String? screen,
    String? fromScreen,
    int? durationMs,
    String? outcome,
  }) : super._(
         occurredAt: occurredAt,
         name: name,
         screen: screen,
         fromScreen: fromScreen,
         durationMs: durationMs,
         outcome: outcome,
       );

  /// Returns a shallow copy of this [AnalyticsEventInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AnalyticsEventInput copyWith({
    DateTime? occurredAt,
    String? name,
    Object? screen = _Undefined,
    Object? fromScreen = _Undefined,
    Object? durationMs = _Undefined,
    Object? outcome = _Undefined,
  }) {
    return AnalyticsEventInput(
      occurredAt: occurredAt ?? this.occurredAt,
      name: name ?? this.name,
      screen: screen is String? ? screen : this.screen,
      fromScreen: fromScreen is String? ? fromScreen : this.fromScreen,
      durationMs: durationMs is int? ? durationMs : this.durationMs,
      outcome: outcome is String? ? outcome : this.outcome,
    );
  }
}

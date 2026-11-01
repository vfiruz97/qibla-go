/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:qibla_go_client/src/protocol/analytics/analytics_event_input.dart'
    as _io41fdcy;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'analytics/analytics_event_input.dart' as _i7agsfz9;
import 'support/support_challenge.dart' as _iti73b7j;
import 'support/support_submit_result.dart' as _ian8tpl6;
export 'analytics/analytics_event_input.dart';
export 'support/support_challenge.dart';
export 'support/support_submit_result.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager
    implements _isc.ProtocolDeserializationProvider {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  _isc.ProtocolDeserialization get deserializationMetadata =>
      _isc.ProtocolDeserialization.cached(
        this,
        types: const [
          _isc.getType<_i7agsfz9.AnalyticsEventInput>,
          _isc.getType<_iti73b7j.SupportChallenge>,
          _isc.getType<_ian8tpl6.SupportSubmitResult>,
          _isc.getType<_i7agsfz9.AnalyticsEventInput?>,
          _isc.getType<_iti73b7j.SupportChallenge?>,
          _isc.getType<_ian8tpl6.SupportSubmitResult?>,
          _isc.getType<List<_io41fdcy.AnalyticsEventInput>>,
        ],
        modules: const [],
        classNames: const [
          'AnalyticsEventInput',
          'SupportChallenge',
          'SupportSubmitResult',
        ],
      );

  static String? getClassNameFromObjectJson(dynamic data) =>
      _isc.ProtocolDeserialization.readClassName(data);

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    final rawDataClassName = _isc.ProtocolDeserialization.readClassName(data);
    final dataClassName = rawDataClassName;
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i7agsfz9.AnalyticsEventInput) {
      return _i7agsfz9.AnalyticsEventInput.fromJson(data) as T;
    }
    if (t == _iti73b7j.SupportChallenge) {
      return _iti73b7j.SupportChallenge.fromJson(data) as T;
    }
    if (t == _ian8tpl6.SupportSubmitResult) {
      return _ian8tpl6.SupportSubmitResult.fromJson(data) as T;
    }
    if (t == _isc.getType<_i7agsfz9.AnalyticsEventInput?>()) {
      return (data != null
              ? _i7agsfz9.AnalyticsEventInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iti73b7j.SupportChallenge?>()) {
      return (data != null ? _iti73b7j.SupportChallenge.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ian8tpl6.SupportSubmitResult?>()) {
      return (data != null
              ? _ian8tpl6.SupportSubmitResult.fromJson(data)
              : null)
          as T;
    }
    if (t == List<_io41fdcy.AnalyticsEventInput>) {
      return (data as List)
              .map((e) => deserialize<_io41fdcy.AnalyticsEventInput>(e))
              .toList()
          as T;
    }
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i7agsfz9.AnalyticsEventInput => 'AnalyticsEventInput',
      _iti73b7j.SupportChallenge => 'SupportChallenge',
      _ian8tpl6.SupportSubmitResult => 'SupportSubmitResult',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('qibla_go.', '');
    }

    switch (data) {
      case _i7agsfz9.AnalyticsEventInput():
        return 'AnalyticsEventInput';
      case _iti73b7j.SupportChallenge():
        return 'SupportChallenge';
      case _ian8tpl6.SupportSubmitResult():
        return 'SupportSubmitResult';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AnalyticsEventInput') {
      return deserialize<_i7agsfz9.AnalyticsEventInput>(data['data']);
    }
    if (dataClassName == 'SupportChallenge') {
      return deserialize<_iti73b7j.SupportChallenge>(data['data']);
    }
    if (dataClassName == 'SupportSubmitResult') {
      return deserialize<_ian8tpl6.SupportSubmitResult>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  @override
  String getModuleName() => 'qibla_go';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}

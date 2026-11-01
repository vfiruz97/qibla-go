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
import 'package:qibla_go_server/src/generated/analytics/analytics_event_input.dart'
    as _ij72q2bz;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'analytics/analytics_event.dart' as _i69cfam9;
import 'analytics/analytics_event_input.dart' as _i7agsfz9;
import 'support/support_challenge.dart' as _iti73b7j;
import 'support/support_message.dart' as _izh8ly96;
import 'support/support_submit_result.dart' as _ian8tpl6;
export 'analytics/analytics_event.dart';
export 'analytics/analytics_event_input.dart';
export 'support/support_challenge.dart';
export 'support/support_message.dart';
export 'support/support_submit_result.dart';

class Protocol extends _is.DatabaseSerializationManager
    implements _is.DatabaseProtocolDeserializationProvider {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  _is.ProtocolDeserialization get deserializationMetadata =>
      _is.ProtocolDeserialization.cached(
        this,
        types: const [
          _is.getType<_i69cfam9.AnalyticsEvent>,
          _is.getType<_i7agsfz9.AnalyticsEventInput>,
          _is.getType<_iti73b7j.SupportChallenge>,
          _is.getType<_izh8ly96.SupportMessage>,
          _is.getType<_ian8tpl6.SupportSubmitResult>,
          _is.getType<_i69cfam9.AnalyticsEvent?>,
          _is.getType<_i7agsfz9.AnalyticsEventInput?>,
          _is.getType<_iti73b7j.SupportChallenge?>,
          _is.getType<_izh8ly96.SupportMessage?>,
          _is.getType<_ian8tpl6.SupportSubmitResult?>,
          _is.getType<List<_ij72q2bz.AnalyticsEventInput>>,
        ],
        modules: const [_isp.Protocol.new],
        classNames: const [
          'AnalyticsEvent',
          'AnalyticsEventInput',
          'SupportChallenge',
          'SupportMessage',
          'SupportSubmitResult',
        ],
      );

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'analytics_event',
      dartName: 'AnalyticsEvent',
      schema: 'public',
      module: 'qibla_go',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'receivedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'occurredAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'sessionId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'platform',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'appVersion',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'language',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'screen',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'fromScreen',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'durationMs',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'outcome',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'analytics_event_name_time_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'name',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'occurredAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'analytics_event_received_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'receivedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'analytics_event_session_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sessionId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'support_message',
      dartName: 'SupportMessage',
      schema: 'public',
      module: 'qibla_go',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'message',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'contact',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'platform',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'appVersion',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'handledAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'support_message_created_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) =>
      _is.ProtocolDeserialization.readClassName(data);

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    final rawDataClassName = _is.ProtocolDeserialization.readClassName(data);
    final dataClassName = rawDataClassName;
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i69cfam9.AnalyticsEvent) {
      return _i69cfam9.AnalyticsEvent.fromJson(data) as T;
    }
    if (t == _i7agsfz9.AnalyticsEventInput) {
      return _i7agsfz9.AnalyticsEventInput.fromJson(data) as T;
    }
    if (t == _iti73b7j.SupportChallenge) {
      return _iti73b7j.SupportChallenge.fromJson(data) as T;
    }
    if (t == _izh8ly96.SupportMessage) {
      return _izh8ly96.SupportMessage.fromJson(data) as T;
    }
    if (t == _ian8tpl6.SupportSubmitResult) {
      return _ian8tpl6.SupportSubmitResult.fromJson(data) as T;
    }
    if (t == _is.getType<_i69cfam9.AnalyticsEvent?>()) {
      return (data != null ? _i69cfam9.AnalyticsEvent.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i7agsfz9.AnalyticsEventInput?>()) {
      return (data != null
              ? _i7agsfz9.AnalyticsEventInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iti73b7j.SupportChallenge?>()) {
      return (data != null ? _iti73b7j.SupportChallenge.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_izh8ly96.SupportMessage?>()) {
      return (data != null ? _izh8ly96.SupportMessage.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ian8tpl6.SupportSubmitResult?>()) {
      return (data != null
              ? _ian8tpl6.SupportSubmitResult.fromJson(data)
              : null)
          as T;
    }
    if (t == List<_ij72q2bz.AnalyticsEventInput>) {
      return (data as List)
              .map((e) => deserialize<_ij72q2bz.AnalyticsEventInput>(e))
              .toList()
          as T;
    }
    final modules = deserializationMetadata.modulesForDeserialization(
      t,
      className: rawDataClassName,
    );
    for (final module in modules) {
      try {
        return module.deserialize<T>(data, t);
      } on _is.DeserializationTypeNotFoundException catch (_) {}
    }

    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i69cfam9.AnalyticsEvent => 'AnalyticsEvent',
      _i7agsfz9.AnalyticsEventInput => 'AnalyticsEventInput',
      _iti73b7j.SupportChallenge => 'SupportChallenge',
      _izh8ly96.SupportMessage => 'SupportMessage',
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
      case _i69cfam9.AnalyticsEvent():
        return 'AnalyticsEvent';
      case _i7agsfz9.AnalyticsEventInput():
        return 'AnalyticsEventInput';
      case _iti73b7j.SupportChallenge():
        return 'SupportChallenge';
      case _izh8ly96.SupportMessage():
        return 'SupportMessage';
      case _ian8tpl6.SupportSubmitResult():
        return 'SupportSubmitResult';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AnalyticsEvent') {
      return deserialize<_i69cfam9.AnalyticsEvent>(data['data']);
    }
    if (dataClassName == 'AnalyticsEventInput') {
      return deserialize<_i7agsfz9.AnalyticsEventInput>(data['data']);
    }
    if (dataClassName == 'SupportChallenge') {
      return deserialize<_iti73b7j.SupportChallenge>(data['data']);
    }
    if (dataClassName == 'SupportMessage') {
      return deserialize<_izh8ly96.SupportMessage>(data['data']);
    }
    if (dataClassName == 'SupportSubmitResult') {
      return deserialize<_ian8tpl6.SupportSubmitResult>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      return _isp.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(10),
      });
    }
    return super.deserializeByClassName(data);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i69cfam9.AnalyticsEvent:
        return _i69cfam9.AnalyticsEvent.t;
      case _izh8ly96.SupportMessage:
        return _izh8ly96.SupportMessage.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

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
    try {
      return _isp.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}

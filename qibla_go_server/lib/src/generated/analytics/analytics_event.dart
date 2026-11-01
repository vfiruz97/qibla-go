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
import 'dart:async' as _ida;
import 'package:serverpod/serverpod.dart' as _is;

/// One anonymous usage event from the app: a launch, a screen view, a
/// support message sent. Server-only; the app never reads events back.
/// Holds no identifier that outlives a launch, no location, no address,
/// no free text. Rows older than the retention period are purged.
abstract class AnalyticsEvent
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  AnalyticsEvent._({
    this.id,
    required this.receivedAt,
    required this.occurredAt,
    required this.sessionId,
    required this.name,
    required this.platform,
    this.appVersion,
    this.language,
    this.screen,
    this.fromScreen,
    this.durationMs,
    this.outcome,
  });

  factory AnalyticsEvent({
    int? id,
    required DateTime receivedAt,
    required DateTime occurredAt,
    required String sessionId,
    required String name,
    required String platform,
    String? appVersion,
    String? language,
    String? screen,
    String? fromScreen,
    int? durationMs,
    String? outcome,
  }) = _AnalyticsEventImpl;

  factory AnalyticsEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return AnalyticsEvent(
      id: jsonSerialization['id'] as int?,
      receivedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['receivedAt'],
      ),
      occurredAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['occurredAt'],
      ),
      sessionId: jsonSerialization['sessionId'] as String,
      name: jsonSerialization['name'] as String,
      platform: jsonSerialization['platform'] as String,
      appVersion: jsonSerialization['appVersion'] as String?,
      language: jsonSerialization['language'] as String?,
      screen: jsonSerialization['screen'] as String?,
      fromScreen: jsonSerialization['fromScreen'] as String?,
      durationMs: jsonSerialization['durationMs'] as int?,
      outcome: jsonSerialization['outcome'] as String?,
    );
  }

  static final t = AnalyticsEventTable();

  static const db = AnalyticsEventRepository._();

  @override
  int? id;

  /// When the server stored it (UTC).
  DateTime receivedAt;

  /// When it happened on the device (UTC, by the device clock, clamped to a
  /// plausible window around receivedAt).
  DateTime occurredAt;

  /// Random hex id the app draws at launch and forgets at exit. Groups the
  /// events of one launch; never persisted on the device, so two launches
  /// cannot be linked.
  String sessionId;

  /// Event name from the allowlist in AnalyticsGuard (app_launch,
  /// screen_view, ...).
  String name;

  /// "android", "ios", "web", "macos", "windows", "linux" or "unknown".
  String platform;

  /// App version string ("0.1.0+1"), if the app knew it.
  String? appVersion;

  /// Language the app was shown in (ISO 639 code, no region).
  String? language;

  /// Screen or sheet the event is about ("qibla", "map", "details").
  String? screen;

  /// For navigation: the screen the user came from.
  String? fromScreen;

  /// A duration in milliseconds, where the event has one (launch to first
  /// frame, time in foreground).
  int? durationMs;

  /// A short result tag ("accepted", "offline", "rate", "notNow").
  String? outcome;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AnalyticsEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AnalyticsEvent copyWith({
    int? id,
    DateTime? receivedAt,
    DateTime? occurredAt,
    String? sessionId,
    String? name,
    String? platform,
    String? appVersion,
    String? language,
    String? screen,
    String? fromScreen,
    int? durationMs,
    String? outcome,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AnalyticsEvent',
      if (id != null) 'id': id,
      'receivedAt': receivedAt.toJson(),
      'occurredAt': occurredAt.toJson(),
      'sessionId': sessionId,
      'name': name,
      'platform': platform,
      if (appVersion != null) 'appVersion': appVersion,
      if (language != null) 'language': language,
      if (screen != null) 'screen': screen,
      if (fromScreen != null) 'fromScreen': fromScreen,
      if (durationMs != null) 'durationMs': durationMs,
      if (outcome != null) 'outcome': outcome,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static AnalyticsEventInclude include() {
    return AnalyticsEventInclude._();
  }

  static AnalyticsEventIncludeList includeList({
    _is.WhereExpressionBuilder<AnalyticsEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AnalyticsEventTable>? orderBy,
    _is.OrderByListBuilder<AnalyticsEventTable>? orderByList,
    AnalyticsEventInclude? include,
  }) {
    return AnalyticsEventIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AnalyticsEvent.t),
      orderByList: orderByList?.call(AnalyticsEvent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AnalyticsEventImpl extends AnalyticsEvent {
  _AnalyticsEventImpl({
    int? id,
    required DateTime receivedAt,
    required DateTime occurredAt,
    required String sessionId,
    required String name,
    required String platform,
    String? appVersion,
    String? language,
    String? screen,
    String? fromScreen,
    int? durationMs,
    String? outcome,
  }) : super._(
         id: id,
         receivedAt: receivedAt,
         occurredAt: occurredAt,
         sessionId: sessionId,
         name: name,
         platform: platform,
         appVersion: appVersion,
         language: language,
         screen: screen,
         fromScreen: fromScreen,
         durationMs: durationMs,
         outcome: outcome,
       );

  /// Returns a shallow copy of this [AnalyticsEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AnalyticsEvent copyWith({
    Object? id = _Undefined,
    DateTime? receivedAt,
    DateTime? occurredAt,
    String? sessionId,
    String? name,
    String? platform,
    Object? appVersion = _Undefined,
    Object? language = _Undefined,
    Object? screen = _Undefined,
    Object? fromScreen = _Undefined,
    Object? durationMs = _Undefined,
    Object? outcome = _Undefined,
  }) {
    return AnalyticsEvent(
      id: id is int? ? id : this.id,
      receivedAt: receivedAt ?? this.receivedAt,
      occurredAt: occurredAt ?? this.occurredAt,
      sessionId: sessionId ?? this.sessionId,
      name: name ?? this.name,
      platform: platform ?? this.platform,
      appVersion: appVersion is String? ? appVersion : this.appVersion,
      language: language is String? ? language : this.language,
      screen: screen is String? ? screen : this.screen,
      fromScreen: fromScreen is String? ? fromScreen : this.fromScreen,
      durationMs: durationMs is int? ? durationMs : this.durationMs,
      outcome: outcome is String? ? outcome : this.outcome,
    );
  }
}

class AnalyticsEventUpdateTable extends _is.UpdateTable<AnalyticsEventTable> {
  AnalyticsEventUpdateTable(super.table);

  _is.ColumnValue<DateTime, DateTime> receivedAt(DateTime value) =>
      _is.ColumnValue(
        table.receivedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> occurredAt(DateTime value) =>
      _is.ColumnValue(
        table.occurredAt,
        value,
      );

  _is.ColumnValue<String, String> sessionId(String value) => _is.ColumnValue(
    table.sessionId,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> platform(String value) => _is.ColumnValue(
    table.platform,
    value,
  );

  _is.ColumnValue<String, String> appVersion(String? value) => _is.ColumnValue(
    table.appVersion,
    value,
  );

  _is.ColumnValue<String, String> language(String? value) => _is.ColumnValue(
    table.language,
    value,
  );

  _is.ColumnValue<String, String> screen(String? value) => _is.ColumnValue(
    table.screen,
    value,
  );

  _is.ColumnValue<String, String> fromScreen(String? value) => _is.ColumnValue(
    table.fromScreen,
    value,
  );

  _is.ColumnValue<int, int> durationMs(int? value) => _is.ColumnValue(
    table.durationMs,
    value,
  );

  _is.ColumnValue<String, String> outcome(String? value) => _is.ColumnValue(
    table.outcome,
    value,
  );
}

class AnalyticsEventTable extends _is.Table<int?> {
  AnalyticsEventTable({super.tableRelation})
    : super(tableName: 'analytics_event') {
    updateTable = AnalyticsEventUpdateTable(this);
    receivedAt = _is.ColumnDateTime(
      'receivedAt',
      this,
    );
    occurredAt = _is.ColumnDateTime(
      'occurredAt',
      this,
    );
    sessionId = _is.ColumnString(
      'sessionId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    platform = _is.ColumnString(
      'platform',
      this,
    );
    appVersion = _is.ColumnString(
      'appVersion',
      this,
    );
    language = _is.ColumnString(
      'language',
      this,
    );
    screen = _is.ColumnString(
      'screen',
      this,
    );
    fromScreen = _is.ColumnString(
      'fromScreen',
      this,
    );
    durationMs = _is.ColumnInt(
      'durationMs',
      this,
    );
    outcome = _is.ColumnString(
      'outcome',
      this,
    );
  }

  late final AnalyticsEventUpdateTable updateTable;

  /// When the server stored it (UTC).
  late final _is.ColumnDateTime receivedAt;

  /// When it happened on the device (UTC, by the device clock, clamped to a
  /// plausible window around receivedAt).
  late final _is.ColumnDateTime occurredAt;

  /// Random hex id the app draws at launch and forgets at exit. Groups the
  /// events of one launch; never persisted on the device, so two launches
  /// cannot be linked.
  late final _is.ColumnString sessionId;

  /// Event name from the allowlist in AnalyticsGuard (app_launch,
  /// screen_view, ...).
  late final _is.ColumnString name;

  /// "android", "ios", "web", "macos", "windows", "linux" or "unknown".
  late final _is.ColumnString platform;

  /// App version string ("0.1.0+1"), if the app knew it.
  late final _is.ColumnString appVersion;

  /// Language the app was shown in (ISO 639 code, no region).
  late final _is.ColumnString language;

  /// Screen or sheet the event is about ("qibla", "map", "details").
  late final _is.ColumnString screen;

  /// For navigation: the screen the user came from.
  late final _is.ColumnString fromScreen;

  /// A duration in milliseconds, where the event has one (launch to first
  /// frame, time in foreground).
  late final _is.ColumnInt durationMs;

  /// A short result tag ("accepted", "offline", "rate", "notNow").
  late final _is.ColumnString outcome;

  @override
  List<_is.Column> get columns => [
    id,
    receivedAt,
    occurredAt,
    sessionId,
    name,
    platform,
    appVersion,
    language,
    screen,
    fromScreen,
    durationMs,
    outcome,
  ];
}

class AnalyticsEventInclude extends _is.IncludeObject {
  AnalyticsEventInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => AnalyticsEvent.t;
}

class AnalyticsEventIncludeList extends _is.IncludeList {
  AnalyticsEventIncludeList._({
    _is.WhereExpressionBuilder<AnalyticsEventTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AnalyticsEvent.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AnalyticsEvent.t;
}

class AnalyticsEventRepository {
  const AnalyticsEventRepository._();

  /// Returns a list of [AnalyticsEvent]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<AnalyticsEvent>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AnalyticsEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AnalyticsEventTable>? orderBy,
    _is.OrderByListBuilder<AnalyticsEventTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AnalyticsEvent>(
      where: where?.call(AnalyticsEvent.t),
      orderBy: orderBy?.call(AnalyticsEvent.t),
      orderByList: orderByList?.call(AnalyticsEvent.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [AnalyticsEvent]s matching the given query parameters every time the
  /// source tables are modified.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// Use [throttle] to specify the minimum interval between queries. It can
  /// also be set to `null`, in which case the stream will only be throttled
  /// when its subscription is paused.
  ///
  /// Source tables are collected from the queried table, [where], [orderBy],
  /// [orderByList], and the [include] graph. [alsoTriggerOnTables] is added
  /// to that set. Pass [Table] instances such as `AnalyticsEvent.t`.
  ///
  /// Raw [Expression] SQL is not inspected. Tables referenced only in raw
  /// SQL must be passed via [alsoTriggerOnTables].
  ///
  /// The stream always reads committed state and never joins an ambient
  /// [Transaction]. Emissions for a write fire after that write commits.
  ///
  /// Currently only supported on SQLite. Calling this method on PostgreSQL
  /// throws an [UnsupportedError].
  ///
  /// ```dart
  /// var subscription = Persons.db.watch(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// ).listen((persons) {
  ///   // Handle the latest matching rows.
  /// });
  /// ```
  _ida.Stream<List<AnalyticsEvent>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AnalyticsEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AnalyticsEventTable>? orderBy,
    _is.OrderByListBuilder<AnalyticsEventTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<AnalyticsEvent>(
      where: where?.call(AnalyticsEvent.t),
      orderBy: orderBy?.call(AnalyticsEvent.t),
      orderByList: orderByList?.call(AnalyticsEvent.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [AnalyticsEvent] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<AnalyticsEvent?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AnalyticsEventTable>? where,
    int? offset,
    _is.OrderByBuilder<AnalyticsEventTable>? orderBy,
    _is.OrderByListBuilder<AnalyticsEventTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AnalyticsEvent>(
      where: where?.call(AnalyticsEvent.t),
      orderBy: orderBy?.call(AnalyticsEvent.t),
      orderByList: orderByList?.call(AnalyticsEvent.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AnalyticsEvent] by its [id] or null if no such row exists.
  Future<AnalyticsEvent?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AnalyticsEvent>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AnalyticsEvent]s in the list and returns the inserted rows.
  ///
  /// The returned [AnalyticsEvent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AnalyticsEvent>> insert(
    _is.DatabaseSession session,
    List<AnalyticsEvent> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AnalyticsEvent>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AnalyticsEvent] and returns the inserted row.
  ///
  /// The returned [AnalyticsEvent] will have its `id` field set.
  Future<AnalyticsEvent> insertRow(
    _is.DatabaseSession session,
    AnalyticsEvent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AnalyticsEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AnalyticsEvent]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [AnalyticsEvent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AnalyticsEvent>> upsert(
    _is.DatabaseSession session,
    List<AnalyticsEvent> rows, {
    required _is.ColumnSelections<AnalyticsEventTable> conflictColumns,
    _is.ColumnSelections<AnalyticsEventTable>? updateColumns,
    _is.WhereExpressionBuilder<AnalyticsEventTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AnalyticsEvent>(
      rows,
      conflictColumns: conflictColumns(AnalyticsEvent.t),
      updateColumns: updateColumns?.call(AnalyticsEvent.t),
      updateWhere: updateWhere?.call(AnalyticsEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AnalyticsEvent] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [AnalyticsEvent] will have its `id` field set.
  Future<AnalyticsEvent?> upsertRow(
    _is.DatabaseSession session,
    AnalyticsEvent row, {
    required _is.ColumnSelections<AnalyticsEventTable> conflictColumns,
    _is.ColumnSelections<AnalyticsEventTable>? updateColumns,
    _is.WhereExpressionBuilder<AnalyticsEventTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AnalyticsEvent>(
      row,
      conflictColumns: conflictColumns(AnalyticsEvent.t),
      updateColumns: updateColumns?.call(AnalyticsEvent.t),
      updateWhere: updateWhere?.call(AnalyticsEvent.t),
      transaction: transaction,
    );
  }

  /// Updates all [AnalyticsEvent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AnalyticsEvent>> update(
    _is.DatabaseSession session,
    List<AnalyticsEvent> rows, {
    _is.ColumnSelections<AnalyticsEventTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AnalyticsEvent>(
      rows,
      columns: columns?.call(AnalyticsEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AnalyticsEvent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AnalyticsEvent> updateRow(
    _is.DatabaseSession session,
    AnalyticsEvent row, {
    _is.ColumnSelections<AnalyticsEventTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AnalyticsEvent>(
      row,
      columns: columns?.call(AnalyticsEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AnalyticsEvent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AnalyticsEvent?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AnalyticsEventUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AnalyticsEvent>(
      id,
      columnValues: columnValues(AnalyticsEvent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AnalyticsEvent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AnalyticsEvent>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AnalyticsEventUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AnalyticsEventTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AnalyticsEventTable>? orderBy,
    _is.OrderByListBuilder<AnalyticsEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AnalyticsEvent>(
      columnValues: columnValues(AnalyticsEvent.t.updateTable),
      where: where(AnalyticsEvent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AnalyticsEvent.t),
      orderByList: orderByList?.call(AnalyticsEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AnalyticsEvent]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AnalyticsEvent>> delete(
    _is.DatabaseSession session,
    List<AnalyticsEvent> rows, {
    _is.OrderByBuilder<AnalyticsEventTable>? orderBy,
    _is.OrderByListBuilder<AnalyticsEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AnalyticsEvent>(
      rows,
      orderBy: orderBy?.call(AnalyticsEvent.t),
      orderByList: orderByList?.call(AnalyticsEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AnalyticsEvent].
  Future<AnalyticsEvent> deleteRow(
    _is.DatabaseSession session,
    AnalyticsEvent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AnalyticsEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AnalyticsEvent>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AnalyticsEventTable> where,
    _is.OrderByBuilder<AnalyticsEventTable>? orderBy,
    _is.OrderByListBuilder<AnalyticsEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AnalyticsEvent>(
      where: where(AnalyticsEvent.t),
      orderBy: orderBy?.call(AnalyticsEvent.t),
      orderByList: orderByList?.call(AnalyticsEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AnalyticsEventTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AnalyticsEvent>(
      where: where?.call(AnalyticsEvent.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AnalyticsEvent] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AnalyticsEventTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AnalyticsEvent>(
      where: where(AnalyticsEvent.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

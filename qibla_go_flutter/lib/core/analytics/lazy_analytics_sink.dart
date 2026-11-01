import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'analytics_context.dart';
import 'analytics_event.dart';
import 'analytics_sink.dart';
import 'serverpod_analytics_sink.dart' deferred as impl;

/// Loads the Serverpod-backed sink on the first batch, which on the web is
/// seconds after the first frame, so the client library ships as a part
/// file and not in `main.dart.js`. No cost on phones beyond one await.
final class LazyAnalyticsSink implements AnalyticsSink {
  LazyAnalyticsSink(this._ref);

  final Ref _ref;
  Future<AnalyticsSink>? _loaded;

  Future<AnalyticsSink> get _sink => _loaded ??= impl.loadLibrary().then(
    (_) => impl.ServerpodAnalyticsSink(_ref),
  );

  @override
  Future<void> send(
    AnalyticsContext context,
    List<AnalyticsEvent> events,
  ) async => (await _sink).send(context, events);
}

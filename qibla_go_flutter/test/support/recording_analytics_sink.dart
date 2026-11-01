import 'package:qibla_go_flutter/core/analytics/analytics_context.dart';
import 'package:qibla_go_flutter/core/analytics/analytics_event.dart';
import 'package:qibla_go_flutter/core/analytics/analytics_sink.dart';

/// Keeps every batch; can be told to fail.
final class RecordingAnalyticsSink implements AnalyticsSink {
  final batches = <(AnalyticsContext, List<AnalyticsEvent>)>[];
  bool fail = false;

  List<AnalyticsEvent> get events => [for (final b in batches) ...b.$2];

  @override
  Future<void> send(AnalyticsContext context, List<AnalyticsEvent> events) {
    if (fail) throw StateError('offline');
    batches.add((context, List.of(events)));
    return Future.value();
  }
}

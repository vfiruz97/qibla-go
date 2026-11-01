import 'analytics_context.dart';
import 'analytics_event.dart';

/// Where batches go. The app's sink is the Serverpod endpoint behind a
/// deferred import; tests use a recording fake. Throws on failure; the
/// caller decides whether to retry.
abstract interface class AnalyticsSink {
  Future<void> send(AnalyticsContext context, List<AnalyticsEvent> events);
}

/// Swallows everything. The default outside `main`, so tests and tools
/// never send anything.
final class NullAnalyticsSink implements AnalyticsSink {
  const NullAnalyticsSink();

  @override
  Future<void> send(AnalyticsContext context, List<AnalyticsEvent> events) =>
      Future.value();
}

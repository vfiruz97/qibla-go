import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'analytics_guard.dart';
import 'analytics_retention.dart';

/// Anonymous usage events from the app. Write-only: nothing reads them back
/// through the API; counting happens in the database.
///
/// No challenge here (the app sends in the background, and a wrong batch
/// costs nothing but a row), so [AnalyticsGuard] carries the whole burden:
/// allowlists, bounds and an hourly budget per client address. The address
/// is used in memory only and never stored or logged.
class AnalyticsEndpoint extends Endpoint {
  /// One guard and one retention clock per server process.
  static final guard = AnalyticsGuard();
  static final retention = AnalyticsRetention();

  /// Stores the acceptable events of one batch and returns how many were
  /// stored. Always answers; a refused batch is 0, never an error, so the
  /// app has nothing to retry or report.
  Future<int> record(
    Session session, {
    required String sessionId,
    required String platform,
    String? appVersion,
    String? language,
    required List<AnalyticsEventInput> events,
  }) async {
    final rows = guard.accept(
      client: _clientKey(session),
      sessionId: sessionId,
      platform: platform,
      appVersion: appVersion,
      language: language,
      events: events,
    );
    if (rows == null || rows.isEmpty) return 0;
    await AnalyticsEvent.db.insert(session, rows);
    await retention.maybePurge(session);
    return rows.length;
  }

  /// Same rule as the support endpoint: first X-Forwarded-For hop behind a
  /// proxy, else the socket address. Not persisted anywhere.
  static String _clientKey(Session session) {
    final request = session.request;
    if (request == null) return 'unknown';
    final forwarded = request.headers.xForwardedFor?.addresses;
    if (forwarded != null && forwarded.isNotEmpty) return forwarded.first;
    return request.connectionInfo.remote.address.toString();
  }
}

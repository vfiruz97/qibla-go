import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'analytics_guard.dart';

/// Deletes events older than [AnalyticsGuard.retention]. Runs from the
/// record endpoint at most once an hour per server process: boring, needs
/// no scheduler, and the `receivedAt` index keeps it cheap.
class AnalyticsRetention {
  AnalyticsRetention({DateTime Function()? now}) : _now = now ?? DateTime.now;

  static const interval = Duration(hours: 1);

  final DateTime Function() _now;
  DateTime? _lastRun;

  /// Purges when due. Returns the number of rows deleted, 0 when not due.
  Future<int> maybePurge(Session session) async {
    final now = _now().toUtc();
    final last = _lastRun;
    if (last != null && now.difference(last) < interval) return 0;
    _lastRun = now;
    return purge(session, now: now);
  }

  /// Purges unconditionally; the test calls this directly.
  static Future<int> purge(Session session, {required DateTime now}) async {
    final cutoff = now.toUtc().subtract(AnalyticsGuard.retention);
    final deleted = await AnalyticsEvent.db.deleteWhere(
      session,
      where: (t) => t.receivedAt < cutoff,
    );
    if (deleted.isNotEmpty) {
      session.log(
        'analytics: purged ${deleted.length} events older than $cutoff',
      );
    }
    return deleted.length;
  }
}

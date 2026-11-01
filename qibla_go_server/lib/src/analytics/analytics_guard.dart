import '../generated/protocol.dart';

/// Decides what of an analytics batch is stored. Pure Dart, no `Session`.
///
/// The endpoint is public and write-only, so this is where abuse and
/// garbage are stopped: an allowlist of event names and platforms, bounds
/// on every string and number, a plausibility window for client clocks, and
/// a per-client hourly budget kept in memory (the client address is the key
/// and is never stored or logged).
class AnalyticsGuard {
  AnalyticsGuard({DateTime Function()? now}) : _now = now ?? DateTime.now;

  /// Every event the app may record. Adding one is a deliberate change: it
  /// goes here, in the app's `AnalyticsEventName`, and in `README.md`.
  static const allowedNames = {
    'app_launch',
    'app_resume',
    'app_background',
    'screen_view',
    'sheet_view',
    'support_sent',
    'rating_prompt',
    'rating_answer',
  };

  static const allowedPlatforms = {
    'android',
    'ios',
    'web',
    'macos',
    'windows',
    'linux',
    'unknown',
  };

  static const maxBatch = 50;
  static const maxTagLength = 40;
  static const maxDurationMs = 24 * 60 * 60 * 1000;
  static const clockPast = Duration(hours: 24);
  static const clockFuture = Duration(minutes: 5);
  static const window = Duration(hours: 1);
  static const maxEventsPerWindow = 1000;

  /// How long an event is kept before [AnalyticsRetention] purges it.
  static const retention = Duration(days: 90);

  static final _sessionId = RegExp(r'^[0-9a-f]{16,64}$');
  static final _language = RegExp(r'^[a-z]{2,3}$');
  static final _tag = RegExp(r'^[A-Za-z0-9_.+\-]{1,40}$');

  final DateTime Function() _now;
  final _counters = <String, _Counter>{};

  /// The rows to store for this batch, or null when the batch as a whole is
  /// refused (bad session id or platform, too many events, over budget).
  /// Individual events that fail a check are dropped, not the batch.
  List<AnalyticsEvent>? accept({
    required String client,
    required String sessionId,
    required String platform,
    String? appVersion,
    String? language,
    required List<AnalyticsEventInput> events,
  }) {
    if (!_sessionId.hasMatch(sessionId)) return null;
    if (!allowedPlatforms.contains(platform)) return null;
    if (events.isEmpty || events.length > maxBatch) return null;
    final version = _optionalTag(appVersion);
    final lang = language != null && _language.hasMatch(language)
        ? language
        : null;
    final now = _now().toUtc();
    final rows = <AnalyticsEvent>[];
    for (final e in events) {
      if (!allowedNames.contains(e.name)) continue;
      final duration = e.durationMs;
      if (duration != null && (duration < 0 || duration > maxDurationMs)) {
        continue;
      }
      rows.add(
        AnalyticsEvent(
          receivedAt: now,
          occurredAt: _clamp(e.occurredAt.toUtc(), now),
          sessionId: sessionId,
          name: e.name,
          platform: platform,
          appVersion: version,
          language: lang,
          screen: _optionalTag(e.screen),
          fromScreen: _optionalTag(e.fromScreen),
          durationMs: duration,
          outcome: _optionalTag(e.outcome),
        ),
      );
    }
    if (rows.isEmpty) return const [];
    if (!_charge(client, rows.length)) return null;
    return rows;
  }

  /// A device clock far off is not evidence; the event is dated by arrival.
  static DateTime _clamp(DateTime occurred, DateTime now) {
    if (occurred.isBefore(now.subtract(clockPast))) return now;
    if (occurred.isAfter(now.add(clockFuture))) return now;
    return occurred;
  }

  static String? _optionalTag(String? raw) {
    final text = raw?.trim() ?? '';
    if (text.isEmpty) return null;
    return _tag.hasMatch(text) ? text : null;
  }

  bool _charge(String client, int count) {
    final now = _now();
    _counters.removeWhere((_, c) => !c.resetAt.isAfter(now));
    var counter = _counters[client];
    if (counter == null) {
      counter = _Counter(resetAt: now.add(window));
      _counters[client] = counter;
    }
    if (counter.count + count > maxEventsPerWindow) return false;
    counter.count += count;
    return true;
  }
}

class _Counter {
  _Counter({required this.resetAt});
  final DateTime resetAt;
  int count = 0;
}

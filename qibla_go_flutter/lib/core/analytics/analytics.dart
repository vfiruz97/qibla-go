import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'analytics_context.dart';
import 'analytics_event.dart';
import 'analytics_sink.dart';

/// Build-time switch: `--dart-define=QIBLA_ANALYTICS=false` turns the
/// whole feature into no-ops.
const analyticsEnabled = bool.fromEnvironment(
  'QIBLA_ANALYTICS',
  defaultValue: true,
);

/// Started first thing in `main`; the launch event reports how long the
/// first content frame took from there.
final appLaunchStopwatch = Stopwatch();

/// The app's analytics. `main` overrides this with a live instance; the
/// default records nothing, which is what every test and tool gets.
final analyticsProvider = Provider<Analytics>((ref) => Analytics.disabled());

/// Collects events in memory and sends them in small batches: after
/// [flushAfter] of quiet, when [flushAt] have piled up, or when the app
/// goes to the background. Everything is best effort. A failed batch is
/// kept for the next attempt a few times and then dropped; nothing is ever
/// written to disk, so a launch that never reaches the server leaves no
/// trace anywhere. Never throws into the caller and never blocks a frame.
final class Analytics {
  Analytics({
    required this.sink,
    required AnalyticsContext context,
    DateTime Function()? now,
    this.flushAfter = const Duration(seconds: 10),
    this.flushAt = 20,
    this.maxBatch = 50,
    this.maxQueued = 200,
    this.maxFailures = 3,
  }) : _context = context, // ignore: prefer_initializing_formals
       _now = now ?? DateTime.now,
       enabled = true;

  Analytics.disabled()
    : sink = const NullAnalyticsSink(),
      _context = const AnalyticsContext(sessionId: '', platform: 'unknown'),
      _now = DateTime.now,
      flushAfter = Duration.zero,
      flushAt = 0,
      maxBatch = 0,
      maxQueued = 0,
      maxFailures = 0,
      enabled = false;

  final AnalyticsSink sink;
  final DateTime Function() _now;
  final Duration flushAfter;
  final int flushAt;
  final int maxBatch;
  final int maxQueued;
  final int maxFailures;
  final bool enabled;

  AnalyticsContext _context;
  final _queue = <AnalyticsEvent>[];
  Timer? _timer;
  Future<void>? _inFlight;
  int _failures = 0;

  AnalyticsContext get context => _context;

  /// Events waiting to be sent (for tests and diagnostics).
  List<AnalyticsEvent> get pending => List.unmodifiable(_queue);

  /// The language the UI resolved to; set from below `Localizations`.
  set language(String? code) {
    if (code != _context.language) _context = _context.withLanguage(code);
  }

  void track(
    AnalyticsEventName name, {
    String? screen,
    String? fromScreen,
    int? durationMs,
    String? outcome,
  }) {
    if (!enabled) return;
    _queue.add(
      AnalyticsEvent(
        name: name,
        occurredAt: _now().toUtc(),
        screen: screen,
        fromScreen: fromScreen,
        durationMs: durationMs,
        outcome: outcome,
      ),
    );
    if (_queue.length > maxQueued) _queue.removeAt(0);
    if (_queue.length >= flushAt) {
      flush();
    } else {
      _timer ??= Timer(flushAfter, flush);
    }
  }

  /// Sends what is queued, oldest first, one batch per call. Returns when
  /// the attempt is over; never throws.
  Future<void> flush() {
    _timer?.cancel();
    _timer = null;
    if (!enabled) return Future.value();
    return _inFlight ??= _send().whenComplete(() => _inFlight = null);
  }

  Future<void> _send() async {
    if (_queue.isEmpty) return;
    final batch = _queue.take(maxBatch).toList(growable: false);
    try {
      await sink.send(_context, batch);
      _queue.removeRange(0, batch.length);
      _failures = 0;
    } catch (_) {
      _failures++;
      if (_failures >= maxFailures) {
        // The server is not there for us this launch; stop carrying the
        // backlog and stop hammering.
        _queue.removeRange(0, batch.length);
        _failures = 0;
      }
    }
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

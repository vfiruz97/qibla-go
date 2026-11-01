import 'package:flutter/widgets.dart';

import 'analytics.dart';
import 'analytics_event.dart';

/// Records the app going to the background and coming back, with the time
/// spent in the foreground, and flushes the queue on the way out, since
/// the process may not come back.
final class AnalyticsLifecycleObserver with WidgetsBindingObserver {
  AnalyticsLifecycleObserver(this._analytics) {
    _foreground.start();
  }

  final Analytics _analytics;
  final _foreground = Stopwatch();
  bool _inForeground = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_inForeground) return;
        _inForeground = true;
        _foreground
          ..reset()
          ..start();
        _analytics.track(AnalyticsEventName.appResume);
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        if (!_inForeground) return;
        _inForeground = false;
        _foreground.stop();
        _analytics.track(
          AnalyticsEventName.appBackground,
          durationMs: _foreground.elapsedMilliseconds,
        );
        _analytics.flush();
      case AppLifecycleState.inactive:
        break;
    }
  }
}

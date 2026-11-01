/// Every event the app can record. The wire name must be in the server's
/// `AnalyticsGuard.allowedNames`; adding one is a change to both, to
/// `README.md` ("Usage statistics") and to the store privacy declarations.
enum AnalyticsEventName {
  /// First content frame; `durationMs` is Dart `main` to that frame.
  appLaunch('app_launch'),

  /// Back to the foreground after a pause.
  appResume('app_resume'),

  /// Left the foreground; `durationMs` is the time spent in it.
  appBackground('app_background'),

  /// A screen came on top; `screen` and the `fromScreen` it replaced.
  screenView('screen_view'),

  /// A bottom sheet opened over `fromScreen`.
  sheetView('sheet_view'),

  /// "Write to us" was submitted; `outcome` is the server's answer or
  /// `offline`. Never the message.
  supportSent('support_sent'),

  /// The rating sheet was shown.
  ratingPrompt('rating_prompt'),

  /// The rating sheet was answered; `outcome` is `rate`, `notNow` or
  /// `dismissed`.
  ratingAnswer('rating_answer');

  const AnalyticsEventName(this.wire);

  final String wire;
}

/// One recorded event. Only short tags and numbers: no free text, no
/// coordinates, nothing that identifies the person or the device.
final class AnalyticsEvent {
  const AnalyticsEvent({
    required this.name,
    required this.occurredAt,
    this.screen,
    this.fromScreen,
    this.durationMs,
    this.outcome,
  });

  final AnalyticsEventName name;
  final DateTime occurredAt;
  final String? screen;
  final String? fromScreen;
  final int? durationMs;
  final String? outcome;

  @override
  String toString() =>
      'AnalyticsEvent(${name.wire}, screen: $screen, from: $fromScreen, '
      'ms: $durationMs, outcome: $outcome)';
}

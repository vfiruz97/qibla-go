import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_go_flutter/core/analytics/analytics.dart';
import 'package:qibla_go_flutter/core/analytics/analytics_context.dart';
import 'package:qibla_go_flutter/core/analytics/analytics_event.dart';

import '../../support/recording_analytics_sink.dart';

void main() {
  const context = AnalyticsContext(
    sessionId: '00112233445566778899aabbccddeeff',
    platform: 'android',
  );
  late RecordingAnalyticsSink sink;
  late Analytics analytics;

  setUp(() {
    sink = RecordingAnalyticsSink();
    analytics = Analytics(
      sink: sink,
      context: context,
      now: () => DateTime.utc(2026, 11, 1, 8),
      flushAt: 3,
      maxBatch: 2,
      maxQueued: 4,
    );
  });

  tearDown(() => analytics.dispose());

  testWidgets('events wait for the quiet period, then go out in one batch', (
    tester,
  ) async {
    analytics.track(AnalyticsEventName.appLaunch, durationMs: 400);
    analytics.track(
      AnalyticsEventName.screenView,
      screen: 'qibla',
      fromScreen: null,
    );
    expect(sink.batches, isEmpty);
    await tester.pump(const Duration(seconds: 9));
    expect(sink.batches, isEmpty);
    await tester.pump(const Duration(seconds: 2));
    expect(sink.batches, hasLength(1));
    final (ctx, events) = sink.batches.single;
    expect(ctx.sessionId, context.sessionId);
    expect(ctx.platform, 'android');
    expect(events.map((e) => e.name), [
      AnalyticsEventName.appLaunch,
      AnalyticsEventName.screenView,
    ]);
    expect(events.first.durationMs, 400);
    expect(events.first.occurredAt.isUtc, isTrue);
    expect(analytics.pending, isEmpty);
  });

  testWidgets('a full queue is sent at once, in batches of maxBatch', (
    tester,
  ) async {
    for (var i = 0; i < 3; i++) {
      analytics.track(AnalyticsEventName.sheetView, screen: 'details');
    }
    await tester.pump();
    expect(sink.batches, hasLength(1));
    expect(sink.batches.single.$2, hasLength(2));
    expect(analytics.pending, hasLength(1));
    await analytics.flush();
    expect(sink.events, hasLength(3));
  });

  testWidgets('the language set later travels with the next batch', (
    tester,
  ) async {
    analytics.language = 'tg';
    analytics.track(AnalyticsEventName.appLaunch);
    await analytics.flush();
    expect(sink.batches.single.$1.language, 'tg');
  });

  testWidgets('a failed batch is kept and retried, then dropped after '
      'three failures', (tester) async {
    sink.fail = true;
    analytics.track(AnalyticsEventName.appLaunch);
    await analytics.flush();
    expect(analytics.pending, hasLength(1));
    await analytics.flush();
    expect(analytics.pending, hasLength(1));
    await analytics.flush();
    expect(analytics.pending, isEmpty, reason: 'given up for this launch');
    sink.fail = false;
    analytics.track(AnalyticsEventName.appResume);
    await analytics.flush();
    expect(sink.events.single.name, AnalyticsEventName.appResume);
  });

  testWidgets('the queue keeps the most recent events when it overflows', (
    tester,
  ) async {
    sink.fail = true;
    for (var i = 0; i < 6; i++) {
      analytics.track(AnalyticsEventName.screenView, screen: 'n$i');
    }
    await tester.pump();
    expect(analytics.pending.map((e) => e.screen), ['n2', 'n3', 'n4', 'n5']);
  });

  testWidgets('a second flush while one is in flight joins it', (
    tester,
  ) async {
    analytics.track(AnalyticsEventName.appLaunch);
    final a = analytics.flush();
    final b = analytics.flush();
    expect(identical(a, b), isTrue);
    await a;
    expect(sink.batches, hasLength(1));
  });

  testWidgets('disabled analytics records nothing and sets no timer', (
    tester,
  ) async {
    final off = Analytics.disabled();
    off.track(AnalyticsEventName.appLaunch);
    await off.flush();
    expect(off.pending, isEmpty);
    expect(off.enabled, isFalse);
  });

  test('session ids are 32 hex characters and differ', () {
    final a = AnalyticsContext.newSessionId(Random(1));
    final b = AnalyticsContext.newSessionId(Random(2));
    expect(a, matches(RegExp(r'^[0-9a-f]{32}$')));
    expect(a, isNot(b));
  });

  test('platform tags match the server allowlist', () {
    expect(AnalyticsContext.platformTag(web: true), 'web');
    expect(
      AnalyticsContext.platformTag(web: false, platform: TargetPlatform.iOS),
      'ios',
    );
    expect(
      AnalyticsContext.platformTag(web: false, platform: TargetPlatform.macOS),
      'macos',
    );
    expect(
      AnalyticsContext.platformTag(
        web: false,
        platform: TargetPlatform.android,
      ),
      'android',
    );
    expect(
      AnalyticsContext.platformTag(
        web: false,
        platform: TargetPlatform.fuchsia,
      ),
      'unknown',
    );
  });
}

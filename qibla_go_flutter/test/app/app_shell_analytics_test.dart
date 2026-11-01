import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_go_flutter/app/app.dart';
import 'package:qibla_go_flutter/core/analytics/analytics.dart';
import 'package:qibla_go_flutter/core/analytics/analytics_context.dart';
import 'package:qibla_go_flutter/core/analytics/analytics_event.dart';
import 'package:qibla_go_flutter/core/compass/simulated_compass_source.dart';
import 'package:qibla_go_flutter/core/location/location_models.dart';
import 'package:qibla_go_flutter/features/qibla/application/location_controller.dart';
import 'package:qibla_go_flutter/core/storage/app_preferences.dart';
import 'package:qibla_go_flutter/features/qibla/application/compass_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fake_location_service.dart';
import '../support/golden_fonts.dart';
import '../support/recording_analytics_sink.dart';

void main() {
  // Real fonts: with the test framework's square glyphs the header row
  // overflows, which has nothing to do with analytics.
  setUpAll(loadGoldenFonts);

  testWidgets('the app shell records the launch, the first screen, the '
      'language and the background transition', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final sink = RecordingAnalyticsSink();
    final analytics = Analytics(
      sink: sink,
      context: const AnalyticsContext(
        sessionId: 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',
        platform: 'android',
      ),
    );
    addTearDown(analytics.dispose);
    final compass = SimulatedCompassSource(initialHeading: 10);
    appLaunchStopwatch
      ..reset()
      ..start();
    // A phone, as in the goldens; the 800 px default would pick the wide
    // two-column layout.
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          analyticsProvider.overrideWithValue(analytics),
          locationServiceProvider.overrideWithValue(
            FakeLocationService(permission: LocationPermissionState.denied),
          ),
          compassSourceProvider.overrideWithValue(compass),
        ],
        child: const QiblaGoApp(playIntro: false),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final names = analytics.pending.map((e) => e.name).toList();
    expect(names, contains(AnalyticsEventName.appLaunch));
    expect(names.where((n) => n == AnalyticsEventName.appLaunch), hasLength(1));
    final launch = analytics.pending.firstWhere(
      (e) => e.name == AnalyticsEventName.appLaunch,
    );
    expect(launch.durationMs, isNotNull);
    final view = analytics.pending.firstWhere(
      (e) => e.name == AnalyticsEventName.screenView,
    );
    expect(view.screen, 'qibla');
    expect(view.fromScreen, isNull);
    expect(analytics.context.language, 'en');

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    expect(analytics.pending, isEmpty, reason: 'flushed on background');
    expect(
      sink.events.last.name,
      AnalyticsEventName.appBackground,
    );
    expect(sink.events.last.durationMs, isNotNull);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(analytics.pending.single.name, AnalyticsEventName.appResume);

    // Unmount so sensors and tickers are gone before the test ends, and
    // drop the flush timer.
    await tester.pumpWidget(const SizedBox.shrink());
    compass.dispose();
    analytics.dispose();
  });
}

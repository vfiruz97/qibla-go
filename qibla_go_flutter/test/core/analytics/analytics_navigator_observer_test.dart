import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_go_flutter/core/analytics/analytics.dart';
import 'package:qibla_go_flutter/core/analytics/analytics_context.dart';
import 'package:qibla_go_flutter/core/analytics/analytics_event.dart';
import 'package:qibla_go_flutter/core/analytics/analytics_navigator_observer.dart';

import '../../support/recording_analytics_sink.dart';

void main() {
  late RecordingAnalyticsSink sink;
  late Analytics analytics;

  setUp(() {
    sink = RecordingAnalyticsSink();
    analytics = Analytics(
      sink: sink,
      context: const AnalyticsContext(
        sessionId: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
        platform: 'ios',
      ),
    );
  });

  tearDown(() => analytics.dispose());

  Widget app() => MaterialApp(
    navigatorObservers: [AnalyticsNavigatorObserver(analytics)],
    initialRoute: '/',
    routes: {
      '/': (context) => Scaffold(
        body: Column(
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/map'),
              child: const Text('to map'),
            ),
            TextButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                routeSettings: const RouteSettings(name: 'details'),
                builder: (_) => const SizedBox(height: 100),
              ),
              child: const Text('details'),
            ),
            TextButton(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => const SizedBox(),
              ),
              child: const Text('dialog'),
            ),
          ],
        ),
      ),
      '/map': (context) => Scaffold(
        body: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('back'),
        ),
      ),
    },
  );

  String describe(AnalyticsEvent e) =>
      '${e.name.wire} ${e.screen} from ${e.fromScreen}';

  testWidgets('screens, sheets and the way back are counted; unnamed '
      'routes are not', (tester) async {
    await tester.pumpWidget(app());
    expect(analytics.pending.map(describe), ['screen_view / from null']);

    await tester.tap(find.text('details'));
    await tester.pumpAndSettle();
    expect(analytics.pending.last.name, AnalyticsEventName.sheetView);
    expect(describe(analytics.pending.last), 'sheet_view details from /');
    Navigator.of(tester.element(find.byType(SizedBox).first)).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.text('dialog'));
    await tester.pumpAndSettle();
    expect(analytics.pending, hasLength(2), reason: 'dialog is unnamed');
    Navigator.of(tester.element(find.byType(SizedBox).first)).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.text('to map'));
    await tester.pumpAndSettle();
    expect(describe(analytics.pending.last), 'screen_view /map from /');

    await tester.tap(find.text('back'));
    await tester.pumpAndSettle();
    expect(describe(analytics.pending.last), 'screen_view / from /map');
    expect(analytics.pending, hasLength(4));
    // The flush timer must not outlive the test.
    analytics.dispose();
  });
}

import 'package:qibla_go_server/src/analytics/analytics_retention.dart';
import 'package:qibla_go_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Analytics endpoint', (sessionBuilder, endpoints) {
    final session = sessionBuilder.build();
    const sessionId = '0123456789abcdef0123456789abcdef';

    test(
      'when a batch is recorded then the rows are stored with context',
      () async {
        final at = DateTime.now().toUtc().subtract(const Duration(seconds: 5));
        final stored = await endpoints.analytics.record(
          sessionBuilder,
          sessionId: sessionId,
          platform: 'web',
          appVersion: '0.1.0+1',
          language: 'ar',
          events: [
            AnalyticsEventInput(
              occurredAt: at,
              name: 'app_launch',
              durationMs: 840,
            ),
            AnalyticsEventInput(
              occurredAt: at,
              name: 'screen_view',
              screen: 'map',
              fromScreen: 'qibla',
            ),
            AnalyticsEventInput(occurredAt: at, name: 'not_a_thing'),
          ],
        );
        expect(stored, 2);

        final rows = await AnalyticsEvent.db.find(
          session,
          orderBy: (t) => t.id,
        );
        expect(rows, hasLength(2));
        expect(rows[0].name, 'app_launch');
        expect(rows[0].durationMs, 840);
        expect(rows[0].sessionId, sessionId);
        expect(rows[0].platform, 'web');
        expect(rows[0].appVersion, '0.1.0+1');
        expect(rows[0].language, 'ar');
        expect(rows[0].occurredAt, at);
        expect(rows[0].receivedAt.isUtc, isTrue);
        expect(rows[1].screen, 'map');
        expect(rows[1].fromScreen, 'qibla');
      },
    );

    test(
      'when the batch is refused then nothing is stored and 0 is returned',
      () async {
        final stored = await endpoints.analytics.record(
          sessionBuilder,
          sessionId: 'nope',
          platform: 'web',
          events: [
            AnalyticsEventInput(
              occurredAt: DateTime.now().toUtc(),
              name: 'app_launch',
            ),
          ],
        );
        expect(stored, 0);
        expect(await AnalyticsEvent.db.count(session), 0);
      },
    );

    test('when events are older than the retention then purge removes only '
        'those', () async {
      final now = DateTime.now().toUtc();
      AnalyticsEvent row(DateTime receivedAt) => AnalyticsEvent(
        receivedAt: receivedAt,
        occurredAt: receivedAt,
        sessionId: sessionId,
        name: 'app_launch',
        platform: 'ios',
      );
      await AnalyticsEvent.db.insert(session, [
        row(now.subtract(const Duration(days: 91))),
        row(now.subtract(const Duration(days: 89))),
        row(now),
      ]);
      final deleted = await AnalyticsRetention.purge(session, now: now);
      expect(deleted, 1);
      final left = await AnalyticsEvent.db.find(session);
      expect(left, hasLength(2));
      expect(
        left.every(
          (r) => r.receivedAt.isAfter(now.subtract(const Duration(days: 90))),
        ),
        isTrue,
      );
    });
  });
}

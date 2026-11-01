import 'package:qibla_go_server/src/analytics/analytics_guard.dart';
import 'package:qibla_go_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  final now = DateTime.utc(2026, 11, 1, 12);
  late DateTime clock;
  late AnalyticsGuard guard;

  setUp(() {
    clock = now;
    guard = AnalyticsGuard(now: () => clock);
  });

  AnalyticsEventInput event(
    String name, {
    DateTime? at,
    String? screen,
    String? from,
    int? durationMs,
    String? outcome,
  }) => AnalyticsEventInput(
    occurredAt: at ?? now,
    name: name,
    screen: screen,
    fromScreen: from,
    durationMs: durationMs,
    outcome: outcome,
  );

  List<AnalyticsEvent>? accept(
    List<AnalyticsEventInput> events, {
    String client = '10.0.0.1',
    String sessionId = 'abcdef0123456789abcdef0123456789',
    String platform = 'android',
    String? appVersion = '0.1.0+1',
    String? language = 'tg',
  }) => guard.accept(
    client: client,
    sessionId: sessionId,
    platform: platform,
    appVersion: appVersion,
    language: language,
    events: events,
  );

  group('Given an analytics batch', () {
    test('when it is well formed then every field is carried over', () {
      final rows = accept([
        event(
          'screen_view',
          screen: 'map',
          from: 'qibla',
          durationMs: 120,
          outcome: 'ok',
        ),
      ])!;
      final row = rows.single;
      expect(row.name, 'screen_view');
      expect(row.screen, 'map');
      expect(row.fromScreen, 'qibla');
      expect(row.durationMs, 120);
      expect(row.outcome, 'ok');
      expect(row.platform, 'android');
      expect(row.appVersion, '0.1.0+1');
      expect(row.language, 'tg');
      expect(row.receivedAt, now);
      expect(row.occurredAt, now);
    });

    test(
      'when the session id or platform is off then the batch is refused',
      () {
        expect(accept([event('app_launch')], sessionId: 'short'), isNull);
        expect(accept([event('app_launch')], sessionId: 'G' * 32), isNull);
        expect(accept([event('app_launch')], platform: 'Android'), isNull);
        expect(accept([event('app_launch')], platform: 'tv'), isNull);
      },
    );

    test('when it is empty or too large then it is refused', () {
      expect(accept([]), isNull);
      expect(
        accept(List.filled(AnalyticsGuard.maxBatch + 1, event('app_launch'))),
        isNull,
      );
    });

    test(
      'when an event has an unknown name then only that event is dropped',
      () {
        final rows = accept([
          event('app_launch'),
          event('location'),
          event('screen_view', screen: 'map'),
        ])!;
        expect(rows.map((r) => r.name), ['app_launch', 'screen_view']);
      },
    );

    test('when a tag is not a short token then it is stored as null', () {
      final rows = accept(
        [
          event('screen_view', screen: 'map; drop table', outcome: ' ok '),
        ],
        appVersion: 'a' * 41,
        language: 'en-US',
      )!;
      expect(rows.single.screen, isNull);
      expect(rows.single.outcome, 'ok');
      expect(rows.single.appVersion, isNull);
      expect(rows.single.language, isNull);
    });

    test('when a duration is negative or absurd then the event is dropped', () {
      expect(accept([event('app_launch', durationMs: -1)]), isEmpty);
      expect(
        accept([
          event('app_launch', durationMs: AnalyticsGuard.maxDurationMs + 1),
        ]),
        isEmpty,
      );
    });

    test(
      'when the device clock is far off then the event is dated by arrival',
      () {
        final rows = accept([
          event('app_launch', at: now.subtract(const Duration(days: 2))),
          event('app_launch', at: now.add(const Duration(hours: 1))),
          event('app_launch', at: now.subtract(const Duration(hours: 3))),
        ])!;
        expect(rows[0].occurredAt, now);
        expect(rows[1].occurredAt, now);
        expect(rows[2].occurredAt, now.subtract(const Duration(hours: 3)));
      },
    );

    test('when a client exceeds the hourly budget then its batches are refused '
        'until the window passes, and other clients are unaffected', () {
      final batch = List.filled(AnalyticsGuard.maxBatch, event('app_launch'));
      final full = AnalyticsGuard.maxEventsPerWindow ~/ AnalyticsGuard.maxBatch;
      for (var i = 0; i < full; i++) {
        expect(accept(batch), hasLength(AnalyticsGuard.maxBatch), reason: '$i');
      }
      expect(accept(batch), isNull);
      expect(accept(batch, client: '10.0.0.2'), isNotNull);
      clock = now.add(AnalyticsGuard.window);
      expect(accept(batch), isNotNull);
    });
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_go_flutter/core/storage/app_preferences.dart';
import 'package:qibla_go_flutter/features/rating/application/rating_controller.dart';
import 'package:qibla_go_flutter/features/rating/application/review_launcher.dart';
import 'package:qibla_go_flutter/features/rating/domain/rating_policy.dart';
import 'package:qibla_go_flutter/features/rating/domain/rating_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/fake_review_launcher.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DateTime now;
  late SharedPreferences prefs;
  late FakeReviewLauncher launcher;

  setUp(() async {
    now = DateTime.utc(2026, 11, 1, 9);
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    launcher = FakeReviewLauncher();
  });

  ProviderContainer container() {
    final c = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        reviewLauncherProvider.overrideWithValue(launcher),
        ratingClockProvider.overrideWithValue(() => now),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  /// Hold the needle on the qibla for [hold], then turn away.
  bool findQibla(RatingController r, {Duration? hold}) {
    r.onAlignmentChanged(aligned: true);
    now = now.add(hold ?? RatingPolicy.minAlignmentHold);
    return r.onAlignmentChanged(aligned: false);
  }

  test('a launch is counted once per process and persisted', () async {
    final c = container();
    final r = c.read(ratingControllerProvider.notifier);
    await r.recordLaunch();
    await r.recordLaunch();
    expect(c.read(ratingControllerProvider).launches, 1);
    expect(c.read(ratingControllerProvider).firstLaunchAt, now);

    final again = container();
    expect(again.read(ratingControllerProvider).launches, 1);
    await again.read(ratingControllerProvider.notifier).recordLaunch();
    expect(again.read(ratingControllerProvider).launches, 2);
    // The first launch date is kept.
    expect(again.read(ratingControllerProvider).firstLaunchAt, now);
  });

  test('a sweep past the qibla does not count; a held alignment does, once '
      'per session', () async {
    final c = container();
    final r = c.read(ratingControllerProvider.notifier);
    findQibla(r, hold: const Duration(seconds: 1));
    expect(c.read(ratingControllerProvider).qiblaFoundSessions, 0);
    findQibla(r);
    findQibla(r);
    expect(c.read(ratingControllerProvider).qiblaFoundSessions, 1);
  });

  test('turning away without having been aligned is ignored', () {
    final c = container();
    final r = c.read(ratingControllerProvider.notifier);
    expect(r.onAlignmentChanged(aligned: false), isFalse);
    expect(c.read(ratingControllerProvider).qiblaFoundSessions, 0);
  });

  test('the first launch never prompts, the third launch two days later '
      'does, after the qibla was found', () async {
    // Day 1, launch 1.
    var c = container();
    var r = c.read(ratingControllerProvider.notifier);
    await r.recordLaunch();
    expect(findQibla(r), isFalse);

    // Day 1, launch 2.
    now = now.add(const Duration(hours: 6));
    c = container();
    r = c.read(ratingControllerProvider.notifier);
    await r.recordLaunch();
    expect(findQibla(r), isFalse);

    // Day 3, launch 3: everything met, but only after the hold.
    now = now.add(const Duration(days: 2));
    c = container();
    r = c.read(ratingControllerProvider.notifier);
    await r.recordLaunch();
    expect(r.onAlignmentChanged(aligned: true), isFalse);
    now = now.add(RatingPolicy.minAlignmentHold);
    expect(r.onAlignmentChanged(aligned: false), isTrue);
  });

  group('once every milestone is met', () {
    late ProviderContainer c;
    late RatingController r;

    setUp(() async {
      await prefs.setString(
        'qibla.v1.rating',
        '{"v":1,"firstLaunchAt":"2026-10-01T00:00:00.000Z","launches":9,'
            '"qiblaFoundSessions":9,"prompts":0,"decision":"undecided"}',
      );
      c = container();
      r = c.read(ratingControllerProvider.notifier);
    });

    test('markPrompted is remembered before any answer', () async {
      expect(findQibla(r), isTrue);
      await r.markPrompted();
      final s = c.read(ratingControllerProvider);
      expect(s.prompts, 1);
      expect(s.lastPromptAt, now);
      expect(findQibla(r), isFalse, reason: 'cooldown after an unanswered ask');
    });

    test('decline is final and persisted', () async {
      await r.decline();
      expect(
        c.read(ratingControllerProvider).decision,
        RatingDecision.declined,
      );
      expect(findQibla(r), isFalse);
      expect(
        container().read(ratingControllerProvider).decision,
        RatingDecision.declined,
      );
    });

    test('accept runs the in-app review when available', () async {
      expect(await r.accept(), RatingOutcome.inAppReview);
      expect(launcher.calls, ['isAvailable', 'requestReview']);
      expect(c.read(ratingControllerProvider).decision, RatingDecision.rated);
      expect(findQibla(r), isFalse);
    });

    test(
      'accept opens the listing when the in-app review is unavailable',
      () async {
        launcher.available = false;
        expect(await r.accept(), RatingOutcome.storeOpened);
        expect(launcher.calls, ['isAvailable', 'openStoreListing']);
      },
    );

    test('accept opens the listing when the in-app review throws', () async {
      launcher.reviewThrows = true;
      expect(await r.accept(), RatingOutcome.storeOpened);
      expect(launcher.calls, [
        'isAvailable',
        'requestReview',
        'openStoreListing',
      ]);
    });

    test(
      'accept reports failure when nothing works, and stays final',
      () async {
        launcher.availabilityThrows = true;
        launcher.storeThrows = true;
        expect(await r.accept(), RatingOutcome.failed);
        expect(c.read(ratingControllerProvider).decision, RatingDecision.rated);
        expect(
          container().read(ratingControllerProvider).decision,
          RatingDecision.rated,
        );
      },
    );

    test('openStore is independent of the decision', () async {
      await r.decline();
      expect(await r.openStore(), isTrue);
      launcher.storeThrows = true;
      expect(await r.openStore(), isFalse);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_go_flutter/features/rating/domain/rating_policy.dart';
import 'package:qibla_go_flutter/features/rating/domain/rating_state.dart';

void main() {
  final installed = DateTime.utc(2026, 11, 1, 9);
  final now = installed.add(const Duration(days: 5));

  /// Every gate satisfied; each test knocks one out.
  final ready = RatingState(
    firstLaunchAt: installed,
    launches: RatingPolicy.minLaunches,
    qiblaFoundSessions: RatingPolicy.minQiblaFoundSessions,
  );

  group('RatingPolicy.shouldPrompt', () {
    test('asks when every milestone is met and nothing was decided', () {
      expect(RatingPolicy.shouldPrompt(ready, now), isTrue);
    });

    test('never on the first launch', () {
      final first = RatingState(
        firstLaunchAt: now,
        launches: 1,
        qiblaFoundSessions: 1,
      );
      expect(RatingPolicy.shouldPrompt(first, now), isFalse);
    });

    test('waits for the install to age', () {
      final young = ready.copyWith(
        firstLaunchAt: now.subtract(
          RatingPolicy.minInstallAge - const Duration(minutes: 1),
        ),
      );
      expect(RatingPolicy.shouldPrompt(young, now), isFalse);
      final old = ready.copyWith(
        firstLaunchAt: now.subtract(RatingPolicy.minInstallAge),
      );
      expect(RatingPolicy.shouldPrompt(old, now), isTrue);
    });

    test('waits for enough launches', () {
      expect(
        RatingPolicy.shouldPrompt(
          ready.copyWith(launches: RatingPolicy.minLaunches - 1),
          now,
        ),
        isFalse,
      );
    });

    test('waits for enough sessions in which the qibla was found', () {
      expect(
        RatingPolicy.shouldPrompt(
          ready.copyWith(
            qiblaFoundSessions: RatingPolicy.minQiblaFoundSessions - 1,
          ),
          now,
        ),
        isFalse,
      );
    });

    test('an unknown first launch (old install, new feature) waits too', () {
      expect(
        RatingPolicy.shouldPrompt(const RatingState(launches: 50), now),
        isFalse,
      );
    });

    test('a decision either way is final', () {
      for (final d in [RatingDecision.rated, RatingDecision.declined]) {
        expect(
          RatingPolicy.shouldPrompt(ready.copyWith(decision: d), now),
          isFalse,
          reason: d.name,
        );
      }
    });

    test('an unanswered prompt is retried once, after the cooldown', () {
      final shown = ready.copyWith(prompts: 1, lastPromptAt: now);
      expect(RatingPolicy.shouldPrompt(shown, now), isFalse);
      final soon = now.add(
        RatingPolicy.repromptCooldown - const Duration(hours: 1),
      );
      expect(RatingPolicy.shouldPrompt(shown, soon), isFalse);
      final later = now.add(RatingPolicy.repromptCooldown);
      expect(RatingPolicy.shouldPrompt(shown, later), isTrue);
      final twice = shown.copyWith(prompts: RatingPolicy.maxPrompts);
      expect(
        RatingPolicy.shouldPrompt(twice, later.add(const Duration(days: 400))),
        isFalse,
      );
    });
  });

  group('RatingState json', () {
    test('round-trips', () {
      final s = RatingState(
        firstLaunchAt: installed,
        launches: 4,
        qiblaFoundSessions: 3,
        prompts: 1,
        lastPromptAt: now,
        decision: RatingDecision.declined,
      );
      expect(RatingState.fromJson(s.toJson()), s);
    });

    test('garbage falls back to a state that cannot prompt early', () {
      final s = RatingState.fromJson({
        'launches': 'many',
        'qiblaFoundSessions': -3,
        'firstLaunchAt': 'yesterday',
        'decision': 'maybe',
      });
      expect(s, RatingState.initial);
    });

    test('a decision survives even when the counters are garbage', () {
      final s = RatingState.fromJson({'decision': 'rated', 'launches': 1.5});
      expect(s.decision, RatingDecision.rated);
      expect(s.launches, 0);
    });
  });
}

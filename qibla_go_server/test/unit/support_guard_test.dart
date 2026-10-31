import 'dart:math';

import 'package:qibla_go_server/src/support/support_guard.dart';
import 'package:test/test.dart';

void main() {
  late DateTime now;
  late SupportGuard guard;

  setUp(() {
    now = DateTime.utc(2026, 10, 31, 12);
    guard = SupportGuard(random: Random(7), now: () => now);
  });

  int solve(String question) {
    final parts = question.split(' ');
    final a = int.parse(parts[0]);
    final b = int.parse(parts[2]);
    return parts[1] == '+' ? a + b : a - b;
  }

  group('Given a fresh guard', () {
    test(
      'when a challenge is issued then its question has a non-negative answer',
      () {
        for (var i = 0; i < 200; i++) {
          final c = guard.issue('client-$i')!;
          expect(solve(c.question), greaterThanOrEqualTo(0));
          expect(c.expiresAt, now.add(SupportGuard.challengeLifetime));
        }
      },
    );

    test('when the right answer is given then the verdict is ok, once', () {
      final c = guard.issue('a')!;
      final answer = solve(c.question);
      expect(
        guard.check(client: 'a', challengeId: c.id, answer: answer),
        GuardVerdict.ok,
      );
      expect(
        guard.check(client: 'a', challengeId: c.id, answer: answer),
        GuardVerdict.challengeExpired,
        reason: 'a challenge is single-use',
      );
    });

    test('when a wrong answer is given then the challenge is spent', () {
      final c = guard.issue('a')!;
      final answer = solve(c.question);
      expect(
        guard.check(client: 'a', challengeId: c.id, answer: answer + 1),
        GuardVerdict.wrongAnswer,
      );
      expect(
        guard.check(client: 'a', challengeId: c.id, answer: answer),
        GuardVerdict.challengeExpired,
      );
    });

    test(
      'when the challenge is older than its lifetime then it is refused',
      () {
        final c = guard.issue('a')!;
        now = now.add(SupportGuard.challengeLifetime);
        expect(
          guard.check(
            client: 'a',
            challengeId: c.id,
            answer: solve(c.question),
          ),
          GuardVerdict.challengeExpired,
        );
      },
    );

    test('when an unknown id is given then it is refused', () {
      expect(
        guard.check(client: 'a', challengeId: 'nope', answer: 1),
        GuardVerdict.challengeExpired,
      );
    });
  });

  group('Given a client that has sent the hourly maximum', () {
    setUp(() {
      for (var i = 0; i < SupportGuard.maxSubmitsPerWindow; i++) {
        guard.recordAccepted('a');
      }
    });

    test('when it submits again then it is told to wait', () {
      final c = guard.issue('a')!;
      expect(
        guard.check(client: 'a', challengeId: c.id, answer: solve(c.question)),
        GuardVerdict.tooManyRequests,
      );
    });

    test('when another client submits then it is not affected', () {
      final c = guard.issue('b')!;
      expect(
        guard.check(client: 'b', challengeId: c.id, answer: solve(c.question)),
        GuardVerdict.ok,
      );
    });

    test('when the window has passed then it may submit again', () {
      now = now.add(SupportGuard.window);
      final c = guard.issue('a')!;
      expect(
        guard.check(client: 'a', challengeId: c.id, answer: solve(c.question)),
        GuardVerdict.ok,
      );
    });
  });

  test('Given a client asking for too many challenges, then it gets none', () {
    for (var i = 0; i < SupportGuard.maxChallengesPerWindow; i++) {
      expect(guard.issue('a'), isNotNull);
    }
    expect(guard.issue('a'), isNull);
    expect(guard.issue('b'), isNotNull);
  });

  group('normalize', () {
    test('message is trimmed and bounded', () {
      expect(
        SupportGuard.normalizeMessage('  hello there friend  '),
        'hello there friend',
      );
      expect(SupportGuard.normalizeMessage('short'), isNull);
      expect(SupportGuard.normalizeMessage('x' * 2001), isNull);
      expect(SupportGuard.normalizeMessage('x' * 2000), isNotNull);
    });

    test('optional fields: empty becomes null, too long is invalid', () {
      expect(SupportGuard.normalizeOptional('  ', 10), isNull);
      expect(SupportGuard.normalizeOptional(null, 10), isNull);
      expect(SupportGuard.normalizeOptional(' a@b.c ', 10), 'a@b.c');
      expect(
        identical(
          SupportGuard.normalizeOptional('x' * 11, 10),
          SupportGuard.invalid,
        ),
        isTrue,
      );
    });
  });
}

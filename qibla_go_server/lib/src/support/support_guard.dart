import 'dart:math';

/// Keeps "Write to us" usable by people and dull for bots, without any
/// account: a single-use arithmetic challenge per message plus per-client
/// counters. Pure Dart, no `Session`, so it is unit tested directly.
///
/// State lives in memory on one server instance. That is fine for this
/// project's scale; with several instances each would limit separately.
class SupportGuard {
  SupportGuard({Random? random, DateTime Function()? now})
    : _random = random ?? Random.secure(),
      _now = now ?? DateTime.now;

  static const challengeLifetime = Duration(minutes: 10);
  static const window = Duration(hours: 1);
  static const maxSubmitsPerWindow = 5;
  static const maxChallengesPerWindow = 30;
  static const minMessageLength = 10;
  static const maxMessageLength = 2000;
  static const maxContactLength = 200;
  static const maxTagLength = 40;

  final Random _random;
  final DateTime Function() _now;
  final _challenges = <String, _Challenge>{};
  final _counters = <String, _Counter>{};

  /// A fresh challenge for [client], or null when it has asked too often.
  IssuedChallenge? issue(String client) {
    _prune();
    if (!_count('challenge:$client', maxChallengesPerWindow)) return null;
    final a = 2 + _random.nextInt(19); // 2..20
    final b = 1 + _random.nextInt(9); // 1..9
    final subtract = _random.nextBool() && a > b;
    final answer = subtract ? a - b : a + b;
    final id = _id();
    final expiresAt = _now().add(challengeLifetime);
    _challenges[id] = _Challenge(answer: answer, expiresAt: expiresAt);
    return IssuedChallenge(
      id: id,
      question: subtract ? '$a − $b' : '$a + $b',
      expiresAt: expiresAt,
    );
  }

  /// Consumes the challenge and tells whether [client] may store a message
  /// now. Call once per submit attempt, before validating the message, so
  /// a wrong answer or a flood never reaches the database.
  GuardVerdict check({
    required String client,
    required String challengeId,
    required int answer,
  }) {
    _prune();
    final counter = _counters['submit:$client'];
    if (counter != null && counter.count >= maxSubmitsPerWindow) {
      return GuardVerdict.tooManyRequests;
    }
    final challenge = _challenges.remove(challengeId);
    if (challenge == null || !challenge.expiresAt.isAfter(_now())) {
      return GuardVerdict.challengeExpired;
    }
    if (challenge.answer != answer) return GuardVerdict.wrongAnswer;
    return GuardVerdict.ok;
  }

  /// Counts an accepted message against [client]'s hourly allowance.
  void recordAccepted(String client) => _count('submit:$client', 1 << 30);

  /// Returns the trimmed message when it is acceptable, otherwise null.
  static String? normalizeMessage(String raw) {
    final text = raw.trim();
    if (text.length < minMessageLength || text.length > maxMessageLength) {
      return null;
    }
    return text;
  }

  /// Trims an optional short field; empty becomes null; too long is invalid
  /// (returns [invalid]).
  static Object? normalizeOptional(String? raw, int maxLength) {
    final text = raw?.trim() ?? '';
    if (text.isEmpty) return null;
    if (text.length > maxLength) return invalid;
    return text;
  }

  /// Sentinel returned by [normalizeOptional] for an over-long value.
  static const invalid = Object();

  bool _count(String key, int limit) {
    final now = _now();
    var counter = _counters[key];
    if (counter == null || !counter.resetAt.isAfter(now)) {
      counter = _Counter(resetAt: now.add(window));
      _counters[key] = counter;
    }
    if (counter.count >= limit) return false;
    counter.count++;
    return true;
  }

  void _prune() {
    final now = _now();
    _challenges.removeWhere((_, c) => !c.expiresAt.isAfter(now));
    _counters.removeWhere((_, c) => !c.resetAt.isAfter(now));
  }

  String _id() {
    const alphabet =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
      24,
      (_) => alphabet[_random.nextInt(alphabet.length)],
    ).join();
  }
}

/// What [SupportGuard.issue] hands out.
class IssuedChallenge {
  const IssuedChallenge({
    required this.id,
    required this.question,
    required this.expiresAt,
  });

  final String id;
  final String question;
  final DateTime expiresAt;
}

enum GuardVerdict { ok, wrongAnswer, challengeExpired, tooManyRequests }

class _Challenge {
  _Challenge({required this.answer, required this.expiresAt});
  final int answer;
  final DateTime expiresAt;
}

class _Counter {
  _Counter({required this.resetAt});
  final DateTime resetAt;
  int count = 0;
}

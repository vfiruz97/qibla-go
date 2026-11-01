/// What the user has told us about rating the app. Both answers are final:
/// once given, the prompt is never shown again.
enum RatingDecision {
  /// Never asked, or asked and the app died before an answer was saved.
  undecided,

  /// Tapped "Rate". We cannot know whether a review was written (the store
  /// APIs do not say), so this is treated as "thank you, done".
  rated,

  /// Tapped "Not now", swiped the sheet away or tapped outside it.
  declined,
}

/// Engagement counters and the decision, persisted between launches.
///
/// Nothing here identifies the user or leaves the device.
final class RatingState {
  const RatingState({
    this.firstLaunchAt,
    this.launches = 0,
    this.qiblaFoundSessions = 0,
    this.prompts = 0,
    this.lastPromptAt,
    this.decision = RatingDecision.undecided,
  });

  static const initial = RatingState();

  /// First time the app ran with this feature present.
  final DateTime? firstLaunchAt;

  /// Cold starts, one per process.
  final int launches;

  /// Sessions in which the user found the qibla and held it for a moment.
  final int qiblaFoundSessions;

  /// How many times the sheet was shown.
  final int prompts;
  final DateTime? lastPromptAt;
  final RatingDecision decision;

  RatingState copyWith({
    DateTime? firstLaunchAt,
    int? launches,
    int? qiblaFoundSessions,
    int? prompts,
    DateTime? lastPromptAt,
    RatingDecision? decision,
  }) => RatingState(
    firstLaunchAt: firstLaunchAt ?? this.firstLaunchAt,
    launches: launches ?? this.launches,
    qiblaFoundSessions: qiblaFoundSessions ?? this.qiblaFoundSessions,
    prompts: prompts ?? this.prompts,
    lastPromptAt: lastPromptAt ?? this.lastPromptAt,
    decision: decision ?? this.decision,
  );

  Map<String, Object?> toJson() => {
    'v': 1,
    'firstLaunchAt': firstLaunchAt?.toUtc().toIso8601String(),
    'launches': launches,
    'qiblaFoundSessions': qiblaFoundSessions,
    'prompts': prompts,
    'lastPromptAt': lastPromptAt?.toUtc().toIso8601String(),
    'decision': decision.name,
  };

  /// Lenient: a missing or malformed field falls back to its default, so a
  /// corrupted record can never make the prompt fire early (counters reset
  /// to zero) or forget a decision that parses.
  static RatingState fromJson(Map<String, Object?> json) {
    DateTime? date(Object? v) => v is String ? DateTime.tryParse(v) : null;
    int count(Object? v) => v is int && v >= 0 ? v : 0;
    final decisionName = json['decision'];
    final decision = RatingDecision.values.cast<RatingDecision?>().firstWhere(
      (d) => d!.name == decisionName,
      orElse: () => null,
    );
    return RatingState(
      firstLaunchAt: date(json['firstLaunchAt']),
      launches: count(json['launches']),
      qiblaFoundSessions: count(json['qiblaFoundSessions']),
      prompts: count(json['prompts']),
      lastPromptAt: date(json['lastPromptAt']),
      decision: decision ?? RatingDecision.undecided,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is RatingState &&
      other.firstLaunchAt == firstLaunchAt &&
      other.launches == launches &&
      other.qiblaFoundSessions == qiblaFoundSessions &&
      other.prompts == prompts &&
      other.lastPromptAt == lastPromptAt &&
      other.decision == decision;

  @override
  int get hashCode => Object.hash(
    firstLaunchAt,
    launches,
    qiblaFoundSessions,
    prompts,
    lastPromptAt,
    decision,
  );

  @override
  String toString() => 'RatingState(${toJson()})';
}

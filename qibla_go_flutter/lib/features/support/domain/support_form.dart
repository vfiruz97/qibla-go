import '../../../core/text/digits.dart';

/// Pure state of the "Write to us" form. No I/O here; the controller in
/// `application/` drives it.
enum SupportPhase {
  /// Asking the server for an arithmetic question.
  loadingChallenge,

  /// Question shown, waiting for the user to write and send.
  ready,

  /// Message in flight.
  sending,

  /// Stored on the server; show thanks.
  sent,
}

/// Why the last attempt did not go through. Shown as one sentence.
enum SupportFailure {
  /// Server unreachable; the text is kept so the user can retry.
  offline,

  /// Hourly limit for this connection reached.
  tooManyRequests,

  /// Arithmetic answer wrong; a new question has been fetched.
  wrongAnswer,

  /// Question expired; a new one has been fetched.
  challengeExpired,

  /// Server rejected the content (should not happen after local checks).
  invalid,
}

final class SupportFormState {
  const SupportFormState({
    this.phase = SupportPhase.loadingChallenge,
    this.challengeId,
    this.question,
    this.failure,
  });

  final SupportPhase phase;
  final String? challengeId;

  /// e.g. "7 + 5". Null while loading or when the server refused one.
  final String? question;
  final SupportFailure? failure;

  bool get canSend => phase == SupportPhase.ready && challengeId != null;

  SupportFormState copyWith({
    SupportPhase? phase,
    String? challengeId,
    String? question,
    SupportFailure? failure,
    bool clearFailure = false,
    bool clearChallenge = false,
  }) => SupportFormState(
    phase: phase ?? this.phase,
    challengeId: clearChallenge ? null : (challengeId ?? this.challengeId),
    question: clearChallenge ? null : (question ?? this.question),
    failure: clearFailure ? null : (failure ?? this.failure),
  );
}

/// Same bounds as the server; checked here first so a believer never pays
/// a challenge for a message the server would refuse anyway.
abstract final class SupportLimits {
  static const minMessageLength = 10;
  static const maxMessageLength = 2000;
  static const maxContactLength = 200;
}

/// Local validation of the message text; null means acceptable.
SupportInputProblem? checkMessage(String raw) {
  final length = raw.trim().length;
  if (length < SupportLimits.minMessageLength) {
    return SupportInputProblem.tooShort;
  }
  if (length > SupportLimits.maxMessageLength) {
    return SupportInputProblem.tooLong;
  }
  return null;
}

/// Parses what the user typed as the answer; null when not a whole number.
int? parseAnswer(String raw) {
  final text = toAsciiDigits(raw).trim().replaceAll(RegExp(r'\s+'), '');
  if (text.isEmpty) return null;
  return int.tryParse(text);
}

enum SupportInputProblem { tooShort, tooLong, answerMissing }

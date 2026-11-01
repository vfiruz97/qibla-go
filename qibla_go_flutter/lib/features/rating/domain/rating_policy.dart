import 'rating_state.dart';

/// When it is acceptable to ask for a rating. Pure; the numbers are the
/// product decision and are explained in `docs/DECISIONS.md`.
///
/// The ask happens at the end of a completed task, never at launch: the
/// user has just found the qibla, held it for [minAlignmentHold] and turned
/// away. Before that moment the app must have been used on a few separate
/// occasions, so the first launch and a one-off try never see the sheet.
abstract final class RatingPolicy {
  /// Cold starts before the first ask.
  static const minLaunches = 3;

  /// Age of the install before the first ask.
  static const minInstallAge = Duration(days: 2);

  /// Sessions in which the qibla was found, including the current one.
  static const minQiblaFoundSessions = 3;

  /// How long the needle must stay on the qibla for the session to count as
  /// "found". Shorter is a sweep past, not a direction taken.
  static const minAlignmentHold = Duration(seconds: 4);

  /// Pause between the user turning away and the sheet appearing, so it does
  /// not feel like a reaction to the movement.
  static const promptDelay = Duration(milliseconds: 1200);

  /// Safety net for a sheet that was shown but never answered (the process
  /// died first): ask again no sooner than this, and at most [maxPrompts]
  /// times in the life of the install.
  static const repromptCooldown = Duration(days: 30);
  static const maxPrompts = 2;

  static bool shouldPrompt(RatingState s, DateTime now) {
    if (s.decision != RatingDecision.undecided) return false;
    if (s.prompts >= maxPrompts) return false;
    final first = s.firstLaunchAt;
    if (first == null || now.difference(first) < minInstallAge) return false;
    if (s.launches < minLaunches) return false;
    if (s.qiblaFoundSessions < minQiblaFoundSessions) return false;
    final last = s.lastPromptAt;
    if (last != null && now.difference(last) < repromptCooldown) return false;
    return true;
  }
}

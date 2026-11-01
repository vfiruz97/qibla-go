import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/app_preferences.dart';
import '../domain/rating_policy.dart';
import '../domain/rating_state.dart';
import 'review_launcher.dart';

/// The clock, injectable so tests can move time.
final ratingClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

final ratingControllerProvider =
    NotifierProvider<RatingController, RatingState>(RatingController.new);

/// What happened after the user tapped "Rate".
enum RatingOutcome {
  /// The system review card was requested (it may or may not have shown).
  inAppReview,

  /// The in-app flow was unavailable or failed; the store listing opened.
  storeOpened,

  /// Neither worked. The user is told, once, and not asked again.
  failed,
}

/// Counts engagement, decides when to ask, remembers the answer, and talks to
/// the store. Everything persisted goes through [AppPreferences]; nothing
/// leaves the device.
final class RatingController extends Notifier<RatingState> {
  bool _launchRecorded = false;
  bool _foundThisSession = false;
  DateTime? _alignedSince;

  @override
  RatingState build() {
    final json = ref.read(appPreferencesProvider).readRatingJson();
    return json == null ? RatingState.initial : RatingState.fromJson(json);
  }

  DateTime get _now => ref.read(ratingClockProvider)();

  Future<void> _save(RatingState next) {
    state = next;
    return ref.read(appPreferencesProvider).writeRatingJson(next.toJson());
  }

  /// One cold start. Safe to call from every screen build; counts once per
  /// process.
  Future<void> recordLaunch() {
    if (_launchRecorded) return Future.value();
    _launchRecorded = true;
    final now = _now;
    return _save(
      state.copyWith(
        launches: state.launches + 1,
        firstLaunchAt: state.firstLaunchAt ?? now,
      ),
    );
  }

  /// Feed every alignment transition of the needle. Returns true when the
  /// sheet should be shown now: the user held the qibla long enough to have
  /// taken the direction and has just turned away, and the policy agrees.
  bool onAlignmentChanged({required bool aligned}) {
    final now = _now;
    if (aligned) {
      _alignedSince = now;
      return false;
    }
    final since = _alignedSince;
    _alignedSince = null;
    if (since == null) return false;
    if (now.difference(since) < RatingPolicy.minAlignmentHold) return false;
    if (!_foundThisSession) {
      _foundThisSession = true;
      _save(state.copyWith(qiblaFoundSessions: state.qiblaFoundSessions + 1));
    }
    return RatingPolicy.shouldPrompt(state, now);
  }

  /// The sheet is on screen. Saved before the answer so a crash in between
  /// cannot turn into an endless loop of asks.
  Future<void> markPrompted() =>
      _save(state.copyWith(prompts: state.prompts + 1, lastPromptAt: _now));

  /// "Not now", a swipe or a tap outside: final.
  Future<void> decline() =>
      _save(state.copyWith(decision: RatingDecision.declined));

  /// "Rate": final too. The decision is saved before the store is involved
  /// so a failure there never leads to a second ask.
  Future<RatingOutcome> accept() async {
    await _save(state.copyWith(decision: RatingDecision.rated));
    final launcher = ref.read(reviewLauncherProvider);
    try {
      if (await launcher.isAvailable()) {
        await launcher.requestReview();
        return RatingOutcome.inAppReview;
      }
    } on Object {
      // Fall through to the listing.
    }
    return await openStore() ? RatingOutcome.storeOpened : RatingOutcome.failed;
  }

  /// Opens the store listing; for the permanent link in Details. Returns
  /// false when nothing could be opened.
  Future<bool> openStore() async {
    try {
      await ref.read(reviewLauncherProvider).openStoreListing();
      return true;
    } on Object {
      return false;
    }
  }

  /// Debug builds: a way to see the sheet without earning it.
  void resetForDebug() {
    _foundThisSession = false;
    _alignedSince = null;
    _save(RatingState.initial);
  }
}

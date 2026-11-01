import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qibla_go_client/qibla_go_client.dart';

import '../../../core/analytics/analytics.dart';
import '../../../core/analytics/analytics_event.dart';
import '../domain/support_form.dart';
import 'support_api.dart';

/// Lives while the "Write to us" sheet is open: fetches the arithmetic
/// question, sends the message, and turns server answers into [SupportFailure]s.
final supportControllerProvider =
    NotifierProvider.autoDispose<SupportController, SupportFormState>(
      SupportController.new,
    );

final class SupportController extends Notifier<SupportFormState> {
  @override
  SupportFormState build() {
    Future<void>.microtask(loadChallenge);
    return const SupportFormState();
  }

  SupportApi get _api => ref.read(supportApiProvider);

  /// Asks for a (new) question. Keeps any failure already on screen so the
  /// user still sees why the previous attempt did not go through.
  Future<void> loadChallenge() async {
    state = state.copyWith(
      phase: SupportPhase.loadingChallenge,
      clearChallenge: true,
    );
    try {
      final challenge = await _api.challenge();
      if (!ref.mounted) return;
      if (challenge == null) {
        state = state.copyWith(
          phase: SupportPhase.ready,
          failure: SupportFailure.tooManyRequests,
        );
        return;
      }
      state = state.copyWith(
        phase: SupportPhase.ready,
        challengeId: challenge.id,
        question: challenge.question,
      );
    } catch (_) {
      if (!ref.mounted) return;
      state = state.copyWith(
        phase: SupportPhase.ready,
        failure: SupportFailure.offline,
      );
    }
  }

  /// Sends the message. Local checks (`checkMessage`, `parseAnswer`) are the
  /// sheet's job; this assumes they passed.
  Future<void> send({
    required String message,
    required String contact,
    required int answer,
  }) async {
    final challengeId = state.challengeId;
    if (challengeId == null || state.phase != SupportPhase.ready) return;
    state = state.copyWith(phase: SupportPhase.sending, clearFailure: true);
    final SupportSubmitResult result;
    try {
      result = await _api.submit(
        challengeId: challengeId,
        answer: answer,
        message: message.trim(),
        contact: contact.trim().isEmpty ? null : contact.trim(),
        platform: _platformTag,
      );
    } catch (_) {
      if (!ref.mounted) return;
      _trackSent('offline');
      // The challenge may or may not have been consumed; fetch a fresh one
      // so the next attempt cannot fail for that reason.
      state = state.copyWith(
        phase: SupportPhase.ready,
        failure: SupportFailure.offline,
      );
      await loadChallenge();
      return;
    }
    if (!ref.mounted) return;
    _trackSent(result.name);
    switch (result) {
      case SupportSubmitResult.accepted:
        state = state.copyWith(phase: SupportPhase.sent, clearChallenge: true);
      case SupportSubmitResult.wrongAnswer:
        state = state.copyWith(failure: SupportFailure.wrongAnswer);
        await loadChallenge();
      case SupportSubmitResult.challengeExpired:
        state = state.copyWith(failure: SupportFailure.challengeExpired);
        await loadChallenge();
      case SupportSubmitResult.tooManyRequests:
        state = state.copyWith(
          phase: SupportPhase.ready,
          failure: SupportFailure.tooManyRequests,
          clearChallenge: true,
        );
      case SupportSubmitResult.messageInvalid:
        state = state.copyWith(failure: SupportFailure.invalid);
        await loadChallenge();
    }
  }

  /// Counts the attempt and its outcome; never the message or the contact.
  void _trackSent(String outcome) => ref
      .read(analyticsProvider)
      .track(AnalyticsEventName.supportSent, outcome: outcome);

  /// A coarse tag for triage ("web", "android"); never a device identifier.
  static String get _platformTag => kIsWeb ? 'web' : defaultTargetPlatform.name;
}

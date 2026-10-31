import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/qibla_palette.dart';
import '../../../l10n/app_localizations.dart';
import '../application/support_controller.dart';
import '../domain/support_form.dart';

/// "Write to us": a message, an optional way to reply, and one small sum to
/// keep bots out. Bottom sheet, like every secondary flow in the app.
class SupportSheet extends ConsumerStatefulWidget {
  const SupportSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const SupportSheet(),
  );

  @override
  ConsumerState<SupportSheet> createState() => _SupportSheetState();
}

class _SupportSheetState extends ConsumerState<SupportSheet> {
  final _message = TextEditingController();
  final _contact = TextEditingController();
  final _answer = TextEditingController();
  SupportInputProblem? _inputProblem;

  @override
  void dispose() {
    _message.dispose();
    _contact.dispose();
    _answer.dispose();
    super.dispose();
  }

  void _send() {
    final problem = checkMessage(_message.text);
    final answer = parseAnswer(_answer.text);
    final inputProblem =
        problem ?? (answer == null ? SupportInputProblem.answerMissing : null);
    setState(() => _inputProblem = inputProblem);
    if (inputProblem != null || answer == null) return;
    FocusScope.of(context).unfocus();
    ref
        .read(supportControllerProvider.notifier)
        .send(message: _message.text, contact: _contact.text, answer: answer);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = QiblaPalette.of(context);
    final text = Theme.of(context).textTheme;
    final state = ref.watch(supportControllerProvider);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    // A new question arrives after a wrong answer: clear the old answer.
    ref.listen(supportControllerProvider.select((s) => s.challengeId), (
      previous,
      next,
    ) {
      if (previous != next) _answer.clear();
    });

    if (state.phase == SupportPhase.sent) {
      return _Sent(onClose: () => Navigator.of(context).pop());
    }

    final failureText = switch (state.failure) {
      null => null,
      SupportFailure.offline => l10n.supportErrorOffline,
      SupportFailure.tooManyRequests => l10n.supportErrorTooMany,
      SupportFailure.wrongAnswer => l10n.supportErrorWrongAnswer,
      SupportFailure.challengeExpired => l10n.supportErrorExpired,
      SupportFailure.invalid => l10n.supportErrorInvalid,
    };
    final inputText = switch (_inputProblem) {
      null => null,
      SupportInputProblem.tooShort => l10n.supportErrorTooShort,
      SupportInputProblem.tooLong => l10n.supportErrorTooLong,
      SupportInputProblem.answerMissing => l10n.supportErrorAnswerMissing,
    };
    final busy = state.phase == SupportPhase.sending;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24, 4, 24, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.supportTitle, style: text.headlineSmall),
          const SizedBox(height: 8),
          Text(l10n.supportIntro, style: text.bodyMedium),
          const SizedBox(height: 18),
          TextField(
            key: const ValueKey('support-message'),
            controller: _message,
            enabled: !busy,
            minLines: 4,
            maxLines: 8,
            maxLength: SupportLimits.maxMessageLength,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.supportMessageLabel,
              hintText: l10n.supportMessageHint,
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            key: const ValueKey('support-contact'),
            controller: _contact,
            enabled: !busy,
            maxLength: SupportLimits.maxContactLength,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: l10n.supportContactLabel,
              hintText: l10n.supportContactHint,
              counterText: '',
            ),
          ),
          const SizedBox(height: 14),
          _Challenge(
            state: state,
            controller: _answer,
            enabled: !busy,
            onRefresh: () =>
                ref.read(supportControllerProvider.notifier).loadChallenge(),
            onSubmitted: _send,
          ),
          if (inputText != null || failureText != null) ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 18, color: p.warning),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    inputText ?? failureText!,
                    style: text.bodySmall?.copyWith(color: p.warning),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 18),
          FilledButton.icon(
            key: const ValueKey('support-send'),
            onPressed: state.canSend && !busy ? _send : null,
            icon: busy
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: p.background,
                    ),
                  )
                : const Icon(Icons.send_rounded, size: 18),
            label: Text(busy ? l10n.supportSending : l10n.supportSend),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.supportPrivacyNote,
            textAlign: TextAlign.center,
            style: text.labelSmall?.copyWith(color: p.inkFaint),
          ),
        ],
      ),
    );
  }
}

/// "Quick check: what is 7 + 5?" with a small answer box and a way to get
/// another question.
class _Challenge extends StatelessWidget {
  const _Challenge({
    required this.state,
    required this.controller,
    required this.enabled,
    required this.onRefresh,
    required this.onSubmitted,
  });

  final SupportFormState state;
  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onRefresh;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = QiblaPalette.of(context);
    final text = Theme.of(context).textTheme;
    final loading = state.phase == SupportPhase.loadingChallenge;
    final question = state.question;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.gold.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Expanded(
            child: loading
                ? Row(
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: p.gold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(l10n.supportChallengeLoading, style: text.bodySmall),
                    ],
                  )
                : Text(
                    question == null
                        ? l10n.supportChallengeUnavailable
                        : l10n.supportChallengeLabel(question),
                    style: text.bodyMedium,
                  ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 72,
            child: TextField(
              key: const ValueKey('support-answer'),
              controller: controller,
              enabled: enabled && question != null,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              textAlign: TextAlign.center,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSubmitted(),
              decoration: InputDecoration(
                hintText: l10n.supportAnswerHint,
                isDense: true,
              ),
            ),
          ),
          IconButton(
            tooltip: l10n.supportNewQuestion,
            onPressed: enabled && !loading ? onRefresh : null,
            icon: const Icon(Icons.refresh, size: 20),
          ),
        ],
      ),
    );
  }
}

class _Sent extends StatelessWidget {
  const _Sent({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = QiblaPalette.of(context);
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.check_circle_outline, color: p.gold, size: 40),
          const SizedBox(height: 12),
          Text(
            l10n.supportSentTitle,
            textAlign: TextAlign.center,
            style: text.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.supportSentBody,
            textAlign: TextAlign.center,
            style: text.bodyMedium,
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: onClose, child: Text(l10n.supportClose)),
        ],
      ),
    );
  }
}

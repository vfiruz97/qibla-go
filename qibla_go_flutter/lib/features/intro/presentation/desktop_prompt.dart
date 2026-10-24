import 'package:flutter/material.dart';

import '../../../app/theme/qibla_palette.dart';
import '../../../l10n/app_localizations.dart';

/// Shown once on desktop browsers after the intro, over the map that is
/// already open behind it: the compass needs a phone, the map works
/// everywhere. Drawn as an overlay (not a dialog) because it lives above the
/// router's Navigator.
class DesktopPrompt extends StatelessWidget {
  const DesktopPrompt({
    super.key,
    required this.onContinue,
  });

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = QiblaPalette.of(context);
    final text = Theme.of(context).textTheme;
    return Material(
      color: p.background.withValues(alpha: 0.55),
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 360),
          curve: Curves.easeOutCubic,
          builder: (context, v, child) => Opacity(
            opacity: v,
            child: Transform.translate(
              offset: Offset(0, (1 - v) * 16),
              child: child,
            ),
          ),
          child: Container(
            width: 420,
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
            decoration: BoxDecoration(
              color: p.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: p.gold.withValues(alpha: 0.45)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.phone_android_outlined, color: p.gold, size: 34),
                const SizedBox(height: 14),
                Text(l10n.desktopPromptTitle, style: text.headlineSmall),
                const SizedBox(height: 10),
                Text(l10n.desktopPromptBody, style: text.bodyMedium),
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: onContinue,
                  icon: const Icon(Icons.map_outlined, size: 18),
                  label: Text(l10n.desktopPromptContinue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

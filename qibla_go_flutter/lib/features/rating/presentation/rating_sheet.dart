import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../app/theme/qibla_palette.dart';
import '../../../l10n/app_localizations.dart';

/// The one ask for a store rating: why it matters (free, no ads, reviews
/// help others find and trust the app), a button to rate, a button to pass.
/// Bottom sheet like every secondary flow; returns true for "Rate", false
/// for "Not now", null when swiped away or tapped outside.
class RatingSheet extends StatelessWidget {
  const RatingSheet({super.key});

  static Future<bool?> show(BuildContext context) => showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const RatingSheet(),
  );

  /// Apple's store on Apple platforms, Google Play everywhere else. Only the
  /// wording depends on this; the plugin picks the real store itself.
  static bool isAppStore(TargetPlatform platform) =>
      platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = QiblaPalette.of(context);
    final text = Theme.of(context).textTheme;
    final appStore = isAppStore(defaultTargetPlatform);
    // Scrollable so large text or a short landscape screen never clips the
    // buttons; the sheet still takes only the height it needs.
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _Stars(),
          const SizedBox(height: 16),
          Text(
            l10n.ratingTitle,
            textAlign: TextAlign.center,
            style: text.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            appStore ? l10n.ratingBodyAppStore : l10n.ratingBodyGooglePlay,
            textAlign: TextAlign.center,
            style: text.bodyMedium,
          ),
          const SizedBox(height: 22),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.ratingRate),
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.ratingNotNow),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.ratingFootnote,
            textAlign: TextAlign.center,
            style: text.bodySmall?.copyWith(color: p.inkFaint),
          ),
        ],
      ),
    );
  }
}

/// Five gold stars that light up one after another; a still row when the
/// system asks for reduced motion.
class _Stars extends StatelessWidget {
  const _Stars();

  static const _count = 5;
  static const _duration = Duration(milliseconds: 900);

  @override
  Widget build(BuildContext context) {
    final p = QiblaPalette.of(context);
    final animate = !MediaQuery.disableAnimationsOf(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < _count; i++)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: animate ? 0 : 1, end: 1),
            duration: _duration,
            curve: Interval(
              i / (_count + 1),
              (i + 2) / (_count + 1),
              curve: Curves.easeOutBack,
            ),
            builder: (context, t, child) => Transform.scale(
              scale: 0.6 + 0.4 * t,
              child: Opacity(opacity: t.clamp(0, 1), child: child),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Icon(Icons.star_rounded, color: p.gold, size: 30),
            ),
          ),
      ],
    );
  }
}

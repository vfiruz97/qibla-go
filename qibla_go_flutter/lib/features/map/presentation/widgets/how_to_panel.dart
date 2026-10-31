import 'package:flutter/material.dart';

import '../../../../app/theme/qibla_palette.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/astro/sky_position.dart';
import '../../../support/presentation/support_sheet.dart' deferred as support;
import '../../application/sky_providers.dart';
import 'sky_overlay.dart';

/// "Write to us" and the Serverpod client behind it load on first use, so
/// they are not part of the initial web bundle (dart2js deferred part).
Future<void> _openSupport(BuildContext context) async {
  await support.loadLibrary();
  if (context.mounted) await support.SupportSheet.show(context);
}

/// Plain-language guide: what the line is, how to use landmarks, and how
/// the sun or moon can orient you right now.
class HowToPanel extends StatelessWidget {
  const HowToPanel({
    super.key,
    required this.sky,
    required this.expanded,
    required this.onToggle,
  });

  final SkySnapshot? sky;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = QiblaPalette.of(context);
    final text = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: p.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: p.inkFaint.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 12, 14),
              child: Row(
                children: [
                  Icon(Icons.auto_stories_outlined, size: 20, color: p.gold),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(l10n.mapHowTitle, style: text.titleSmall),
                  ),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: Icon(Icons.expand_more, color: p.inkMuted),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: expanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Step(n: 1, text: l10n.mapHowStep1),
                        _Step(n: 2, text: l10n.mapHowStep2),
                        _Step(n: 3, text: l10n.mapHowStep3),
                        const SizedBox(height: 8),
                        _SkySentence(sky: sky),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => _openSupport(context),
                            icon: const Icon(Icons.mail_outline, size: 16),
                            label: Text(l10n.supportButton),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.n, required this.text});

  final int n;
  final String text;

  @override
  Widget build(BuildContext context) {
    final p = QiblaPalette.of(context);
    final style = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: p.gold),
            ),
            child: Text(
              '$n',
              style: style.labelSmall?.copyWith(
                color: p.gold,
                letterSpacing: 0,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: style.bodySmall)),
        ],
      ),
    );
  }
}

class _SkySentence extends StatelessWidget {
  const _SkySentence({required this.sky});

  final SkySnapshot? sky;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = QiblaPalette.of(context);
    final style = Theme.of(context).textTheme;
    final sky = this.sky;
    final lines = <(IconData, Color, String)>[];
    if (sky != null && sky.sun.isAboveHorizon) {
      final offset = sky.qiblaFromSun;
      lines.add((
        Icons.wb_sunny_rounded,
        p.warning,
        l10n.mapHowSunAbove(
          sky.sun.azimuth.round(),
          compassPointName(l10n, sky.sun.azimuth),
          offset.abs().round(),
          offset >= 0 ? l10n.sideRight : l10n.sideLeft,
        ),
      ));
    }
    if (sky != null && sky.showMoon) {
      final offset = sky.qiblaFromMoon;
      lines.add((
        Icons.nightlight_round,
        p.ink,
        l10n.mapHowMoonAbove(
          moonPhaseName(l10n, sky.moonIllumination),
          sky.moon.azimuth.round(),
          offset.abs().round(),
          offset >= 0 ? l10n.sideRight : l10n.sideLeft,
        ),
      ));
    }
    if (lines.isEmpty) {
      lines.add((Icons.nights_stay_outlined, p.inkMuted, l10n.mapHowSkyNone));
    }
    return Column(
      children: [
        for (final (icon, color, text) in lines)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    text,
                    style: style.bodySmall?.copyWith(color: p.ink),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

String compassPointName(AppLocalizations l10n, double azimuth) =>
    switch (compassPointIndex(azimuth)) {
      0 => l10n.compassPointNorth,
      1 => l10n.compassPointNortheast,
      2 => l10n.compassPointEast,
      3 => l10n.compassPointSoutheast,
      4 => l10n.compassPointSouth,
      5 => l10n.compassPointSouthwest,
      6 => l10n.compassPointWest,
      _ => l10n.compassPointNorthwest,
    };

String moonPhaseName(AppLocalizations l10n, MoonIllumination illumination) =>
    switch (moonPhaseIndex(illumination)) {
      0 => l10n.moonPhaseNew,
      1 => l10n.moonPhaseWaxingCrescent,
      2 => l10n.moonPhaseFirstQuarter,
      3 => l10n.moonPhaseWaxingGibbous,
      4 => l10n.moonPhaseFull,
      5 => l10n.moonPhaseWaningGibbous,
      6 => l10n.moonPhaseLastQuarter,
      _ => l10n.moonPhaseWaningCrescent,
    };

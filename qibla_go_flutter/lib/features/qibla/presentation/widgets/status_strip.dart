import 'package:flutter/material.dart';

import '../../../../app/theme/qibla_palette.dart';
import '../../../../core/compass/compass_reading.dart';
import '../../../../core/compass/compass_source.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/qibla_state.dart';
import 'calibration_hint.dart';

/// One sentence about the thing most worth saying, plus two small facts.
class StatusStrip extends StatelessWidget {
  const StatusStrip({
    super.key,
    required this.snapshot,
    required this.compass,
    required this.onRequestPermission,
    required this.onRetry,
  });

  final QiblaSnapshot? snapshot;
  final CompassState compass;
  final VoidCallback onRequestPermission;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = QiblaPalette.of(context);
    final reading = snapshot?.reading;
    final notice = _notice(context, l10n, p);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (snapshot != null)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _Pill(
                icon: Icons.near_me_outlined,
                label: l10n.distanceToMakkah(
                  _formatDistance(snapshot!.geometry.distanceKm),
                ),
              ),
              if (reading != null) _accuracyPill(l10n, p, reading),
              if (snapshot!.trueHeading != null)
                _Pill(
                  icon: Icons.explore_outlined,
                  label:
                      '${l10n.headingLabel} '
                      '${snapshot!.trueHeading!.round() % 360}°',
                ),
            ],
          ),
        if (notice != null) ...[const SizedBox(height: 14), notice],
      ],
    );
  }

  Widget _accuracyPill(
    AppLocalizations l10n,
    QiblaPalette p,
    CompassReading reading,
  ) {
    final accuracy = reading.accuracyDegrees;
    final quality = reading.confidence >= 70
        ? l10n.qualityGood
        : reading.confidence >= 40
        ? l10n.qualityFair
        : l10n.qualityPoor;
    final color = reading.confidence >= 70
        ? p.success
        : reading.confidence >= 40
        ? p.warning
        : p.danger;
    final label = accuracy == null
        ? l10n.accuracyUnknown
        : '${l10n.accuracyPlusMinus(accuracy.round())} · $quality';
    return _Pill(icon: Icons.adjust, label: label, accent: color);
  }

  Widget? _notice(BuildContext context, AppLocalizations l10n, QiblaPalette p) {
    final reading = snapshot?.reading;
    switch (compass.phase) {
      case CompassPhase.checking:
        return _Notice(
          title: l10n.compassCheckingTitle,
          tone: _Tone.neutral,
          leading: const _Spinner(),
        );
      case CompassPhase.waiting:
        return _Notice(
          title: l10n.compassWaitingTitle,
          body: l10n.compassWaitingBody,
          tone: _Tone.neutral,
          leading: const _Spinner(),
        );
      case CompassPhase.stale:
        return _Notice(
          title: l10n.compassStaleTitle,
          body: l10n.compassStaleBody,
          tone: _Tone.warning,
          action: TextButton(
            onPressed: onRetry,
            child: Text(l10n.compassRetry),
          ),
        );
      case CompassPhase.paused:
        return _Notice(title: l10n.compassPausedTitle, tone: _Tone.neutral);
      case CompassPhase.unavailable:
        return _unavailableNotice(l10n);
      case CompassPhase.active:
        break;
    }
    if (reading == null) return null;

    final issue = reading.topIssue;
    if (issue != null) {
      return switch (issue) {
        CompassIssue.magneticInterference => _Notice(
          title: l10n.issueInterferenceTitle,
          body: l10n.issueInterferenceBody,
          tone: _Tone.danger,
          leading: const Icon(Icons.block_outlined),
        ),
        CompassIssue.movingFast => _Notice(
          title: l10n.issueMovingFastTitle,
          body: l10n.issueMovingFastBody,
          tone: _Tone.danger,
          leading: const Icon(Icons.directions_car_outlined),
        ),
        CompassIssue.needsCalibration => _Notice(
          title: l10n.issueCalibrationTitle,
          body: l10n.issueCalibrationBody,
          tone: _Tone.warning,
          leading: const CalibrationHint(size: 34),
        ),
        CompassIssue.deviceNotFlat => _Notice(
          title: l10n.issueNotFlatTitle,
          body: l10n.issueNotFlatBody,
          tone: _Tone.warning,
          leading: const Icon(Icons.screen_rotation_alt_outlined),
        ),
      };
    }
    if (reading.sourceKind == CompassSourceKind.web) {
      return _Notice(
        title: l10n.issueBrowserTitle,
        body: l10n.issueBrowserBody,
        tone: _Tone.warning,
        leading: const Icon(Icons.language_outlined),
      );
    }
    if (snapshot?.trust == NeedleTrust.degraded) {
      return _Notice(
        title: l10n.issueLowAccuracyTitle,
        body: l10n.issueLowAccuracyBody,
        tone: _Tone.warning,
        leading: const Icon(Icons.adjust),
      );
    }
    if (snapshot?.geometry.declinationIsExtrapolated ?? false) {
      return _Notice(
        title: l10n.declinationExtrapolatedNote,
        tone: _Tone.warning,
        leading: const Icon(Icons.update_outlined),
      );
    }
    return null;
  }

  Widget _unavailableNotice(AppLocalizations l10n) {
    final reason = compass.availability?.reason;
    final isWeb =
        compass.reading?.sourceKind == CompassSourceKind.web ||
        compass.error != null;
    switch (reason) {
      case CompassUnavailableReason.permissionRequired:
        return _Notice(
          title: l10n.compassPermissionTitle,
          body: l10n.compassPermissionBody,
          tone: _Tone.neutral,
          leading: const Icon(Icons.screen_rotation_outlined),
          action: FilledButton(
            onPressed: onRequestPermission,
            child: Text(l10n.compassPermissionButton),
          ),
        );
      case CompassUnavailableReason.permissionDenied:
        return _Notice(
          title: l10n.compassPermissionTitle,
          body: l10n.compassPermissionDeniedBody,
          tone: _Tone.warning,
          leading: const Icon(Icons.screen_rotation_outlined),
          action: TextButton(
            onPressed: onRequestPermission,
            child: Text(l10n.compassRetry),
          ),
        );
      case CompassUnavailableReason.noReadings:
        return _Notice(
          title: l10n.compassBrowserNoSensorTitle,
          body: l10n.compassBrowserNoSensorBody,
          tone: _Tone.neutral,
          leading: const Icon(Icons.desktop_windows_outlined),
          action: TextButton(
            onPressed: onRetry,
            child: Text(l10n.compassRetry),
          ),
        );
      case CompassUnavailableReason.noSensor:
      case null:
        return _Notice(
          title: isWeb
              ? l10n.compassBrowserNoSensorTitle
              : l10n.compassNoSensorTitle,
          body: isWeb
              ? l10n.compassBrowserNoSensorBody
              : l10n.compassNoSensorBody,
          tone: _Tone.neutral,
          leading: const Icon(Icons.explore_off_outlined),
        );
    }
  }

  static String _formatDistance(double km) {
    if (km < 10) return km.toStringAsFixed(1);
    final rounded = km.round();
    final s = rounded.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      buffer.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(' ');
    }
    return buffer.toString();
  }
}

enum _Tone { neutral, warning, danger }

class _Notice extends StatelessWidget {
  const _Notice({
    required this.title,
    required this.tone,
    this.body,
    this.leading,
    this.action,
  });

  final String title;
  final String? body;
  final _Tone tone;
  final Widget? leading;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final p = QiblaPalette.of(context);
    final text = Theme.of(context).textTheme;
    final accent = switch (tone) {
      _Tone.neutral => p.inkMuted,
      _Tone.warning => p.warning,
      _Tone.danger => p.danger,
    };
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: p.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[
            IconTheme(
              data: IconThemeData(color: accent, size: 24),
              child: leading!,
            ),
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: text.titleSmall?.copyWith(
                    color: tone == _Tone.neutral ? p.ink : accent,
                  ),
                ),
                if (body != null) ...[
                  const SizedBox(height: 3),
                  Text(body!, style: text.bodySmall),
                ],
                if (action != null) ...[
                  const SizedBox(height: 6),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: action,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label, this.accent});

  final IconData icon;
  final String label;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final p = QiblaPalette.of(context);
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: p.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: p.inkFaint.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: accent ?? p.inkMuted),
          const SizedBox(width: 6),
          Text(
            label,
            style: text.bodySmall?.copyWith(
              color: p.ink,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 18,
    height: 18,
    child: CircularProgressIndicator(
      strokeWidth: 2,
      color: QiblaPalette.of(context).gold,
    ),
  );
}

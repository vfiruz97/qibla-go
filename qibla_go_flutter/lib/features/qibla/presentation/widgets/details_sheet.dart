import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/qibla_palette.dart';
import '../../../../core/compass/simulated_compass_source.dart';
import '../../../../core/geo/qibla_geometry.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/compass_controller.dart';
import '../../application/location_controller.dart';
import '../../application/qibla_providers.dart';
import 'location_sheet.dart';

/// Every number behind the needle, for the user who wants to check the
/// app's work (and for us, when a report says the direction is wrong).
class DetailsSheet extends ConsumerWidget {
  const DetailsSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const DetailsSheet(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final p = QiblaPalette.of(context);
    final snapshot = ref.watch(qiblaSnapshotProvider);
    final location = ref.watch(locationControllerProvider);
    final reading = snapshot?.reading;
    final geometry = snapshot?.geometry;
    const na = '—';

    String deg(double? v, {int decimals = 1}) =>
        v == null ? na : '${v.toStringAsFixed(decimals)}°';
    String signedDeg(double? v) => v == null
        ? na
        : '${v >= 0 ? '+' : ''}${v.toStringAsFixed(2)}° '
              '${v >= 0 ? 'E' : 'W'}';
    String microTesla(double? v) =>
        v == null ? na : '${v.toStringAsFixed(1)} µT';

    final rows = <(String, String)>[
      (l10n.detailsSource, reading?.sourceLabel ?? na),
      (l10n.detailsMagneticHeading, deg(reading?.magneticHeading)),
      (l10n.detailsDeclination, signedDeg(geometry?.declination)),
      (l10n.detailsTrueHeading, deg(snapshot?.trueHeading)),
      (l10n.detailsPlatformTrueHeading, deg(reading?.platformTrueHeading)),
      (l10n.detailsAccuracy, deg(reading?.accuracyDegrees, decimals: 0)),
      (
        l10n.detailsConfidence,
        reading == null ? na : '${reading.confidence} / 100',
      ),
      (l10n.detailsPitch, deg(reading?.pitchDegrees, decimals: 0)),
      (l10n.detailsField, microTesla(reading?.fieldStrengthMicroTesla)),
      (
        l10n.detailsFieldExpected,
        microTesla(reading?.expectedFieldStrengthMicroTesla),
      ),
      (l10n.detailsBearing, deg(geometry?.bearingFromTrueNorth, decimals: 2)),
      (
        l10n.detailsBearingMagnetic,
        deg(geometry?.bearingFromMagneticNorth, decimals: 2),
      ),
      (
        l10n.detailsDistance,
        geometry == null ? na : '${geometry.distanceKm.toStringAsFixed(1)} km',
      ),
      (
        l10n.detailsLocation,
        location.fix == null
            ? na
            : '${location.fix!.point.latitude.toStringAsFixed(5)}, '
                  '${location.fix!.point.longitude.toStringAsFixed(5)} · '
                  '${formatAge(l10n, DateTime.now().difference(location.fix!.time))}',
      ),
      (
        l10n.detailsKaaba,
        '${kaaba.latitude.toStringAsFixed(6)}, '
            '${kaaba.longitude.toStringAsFixed(6)}',
      ),
    ];

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
        children: [
          Text(l10n.detailsTitle, style: text.headlineSmall),
          const SizedBox(height: 6),
          Text(l10n.detailsMethod, style: text.bodySmall),
          const SizedBox(height: 18),
          for (final (label, value) in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(label, style: text.bodyMedium),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 6,
                    child: Text(
                      value,
                      textAlign: TextAlign.end,
                      style: text.bodyMedium?.copyWith(
                        color: p.ink,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (kDebugMode) ...[
            const Divider(height: 32),
            const _DebugControls(),
          ],
        ],
      ),
    );
  }
}

/// Debug builds only: drive a fake heading to work on the dial at a desk.
class _DebugControls extends ConsumerWidget {
  const _DebugControls();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final simulate = ref.watch(simulateCompassProvider);
    final source = ref.watch(compassSourceProvider);
    final reading = ref.watch(
      compassControllerProvider.select((s) => s.reading),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.detailsSimulateToggle),
          value: simulate,
          onChanged: (v) => ref.read(simulateCompassProvider.notifier).set(v),
        ),
        if (simulate && source is SimulatedCompassSource) ...[
          Text(
            '${l10n.detailsSimulateHeading}: '
            '${(reading?.magneticHeading ?? source.heading).round()}°',
          ),
          Slider(
            min: 0,
            max: 359.9,
            value: source.heading,
            onChanged: (v) {
              source.heading = v;
              // Slider shows the source's value; nudge a rebuild.
              (context as Element).markNeedsBuild();
            },
          ),
        ],
      ],
    );
  }
}

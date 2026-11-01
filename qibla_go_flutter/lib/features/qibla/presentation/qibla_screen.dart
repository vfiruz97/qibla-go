import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/qibla_palette.dart';
import '../../../core/location/location_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../rating/application/rating_controller.dart';
import '../../rating/domain/rating_policy.dart';
import '../../rating/presentation/rating_sheet.dart';
import '../application/compass_controller.dart';
import '../application/location_controller.dart';
import '../application/qibla_providers.dart';
import '../domain/qibla_state.dart';
import 'widgets/backdrop.dart';
import 'widgets/compass_dial.dart';
import 'widgets/details_sheet.dart';
import 'widgets/location_sheet.dart';
import 'widgets/status_strip.dart';
import '../../support/presentation/support_sheet.dart' deferred as support;

/// "Write to us" and the Serverpod client behind it load on first use, so
/// they are not part of the initial web bundle (dart2js deferred part).
Future<void> _openSupport(BuildContext context) async {
  await support.loadLibrary();
  if (context.mounted) await support.SupportSheet.show(context);
}

/// The one screen that matters: the dial, the number, the sentence.
class QiblaScreen extends ConsumerStatefulWidget {
  const QiblaScreen({super.key});

  @override
  ConsumerState<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends ConsumerState<QiblaScreen>
    with WidgetsBindingObserver {
  final _alignment = AlignmentTracker();
  bool _isAligned = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // After the first frame: a provider may not change while the tree builds.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(ratingControllerProvider.notifier).recordLaunch();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final compass = ref.read(compassControllerProvider.notifier);
    switch (state) {
      case AppLifecycleState.resumed:
        compass.setActive(true);
        final fix = ref.read(locationControllerProvider).fix;
        final stale =
            fix == null ||
            DateTime.now().difference(fix.time) > const Duration(minutes: 10);
        if (stale) {
          ref
              .read(locationControllerProvider.notifier)
              .refresh(requestPermission: false);
        }
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        compass.setActive(false);
      case AppLifecycleState.inactive:
        break;
    }
  }

  void _onSnapshot(QiblaSnapshot? snapshot) {
    final aligned = _alignment.update(
      snapshot?.offset,
      trust: snapshot?.trust ?? NeedleTrust.blocked,
    );
    if (aligned == _isAligned) return;
    setState(() => _isAligned = aligned);
    if (aligned) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.selectionClick();
    }
    _maybeAskForRating(aligned: aligned);
  }

  /// The rating ask comes at the end of a completed task: the user held the
  /// qibla, then turned away. The controller decides whether this is the
  /// moment; this only checks that the screen is in a state to show a sheet.
  void _maybeAskForRating({required bool aligned}) {
    final rating = ref.read(ratingControllerProvider.notifier);
    if (!rating.onAlignmentChanged(aligned: aligned)) return;
    Future<void>.delayed(RatingPolicy.promptDelay, () {
      if (!mounted) return;
      final route = ModalRoute.of(context);
      if (route != null && !route.isCurrent) return;
      final lifecycle = WidgetsBinding.instance.lifecycleState;
      if (lifecycle != null && lifecycle != AppLifecycleState.resumed) return;
      _askForRating();
    });
  }

  Future<void> _askForRating() async {
    final rating = ref.read(ratingControllerProvider.notifier);
    await rating.markPrompted();
    if (!mounted) return;
    final answer = await RatingSheet.show(context);
    if (answer != true) {
      await rating.decline();
      return;
    }
    // Let the sheet finish closing before the system's review card appears
    // over the dial rather than over our sheet.
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final outcome = await rating.accept();
    if (outcome == RatingOutcome.failed && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).ratingOpenFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(qiblaSnapshotProvider, (_, next) => _onSnapshot(next));
    final location = ref.watch(locationControllerProvider);
    final compass = ref.watch(compassControllerProvider);
    final snapshot = ref.watch(qiblaSnapshotProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Backdrop(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 760;
                final header = _Header(
                  location: location,
                  onTapLocation: () => LocationSheet.show(context),
                );
                final dial = _DialArea(
                  snapshot: snapshot,
                  compass: compass,
                  hasLocation: location.hasFix,
                  isAligned: _isAligned,
                  isLocating: location.isRefreshing,
                  onUseLocation: () =>
                      ref.read(locationControllerProvider.notifier).refresh(),
                  onEnterCoordinates: () =>
                      LocationSheet.show(context, startWithForm: true),
                );
                final readout = _Readout(
                  snapshot: snapshot,
                  isAligned: _isAligned,
                );
                final strip = StatusStrip(
                  snapshot: snapshot,
                  compass: compass,
                  onRequestPermission: () => ref
                      .read(compassControllerProvider.notifier)
                      .requestPermission(),
                  onRetry: () =>
                      ref.read(compassControllerProvider.notifier).retry(),
                );
                final footer = _Footer(
                  snapshot: snapshot,
                  onDetails: () => DetailsSheet.show(context),
                );

                if (wide) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: dial,
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 20, 32, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              header,
                              const Spacer(),
                              readout,
                              const SizedBox(height: 20),
                              strip,
                              const Spacer(),
                              footer,
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      header,
                      Expanded(child: dial),
                      readout,
                      const SizedBox(height: 16),
                      strip,
                      const SizedBox(height: 16),
                      footer,
                    ],
                  ),
                );
              },
            ),
          ),
          Semantics(
            label: l10n.appName,
            child: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.location, required this.onTapLocation});

  final LocationState location;
  final VoidCallback onTapLocation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = QiblaPalette.of(context);
    final text = Theme.of(context).textTheme;
    final fix = location.fix;
    final label = location.isRefreshing && fix == null
        ? l10n.locationLocating
        : fix == null
        ? l10n.locationSetLocation
        : l10n.locationCoordinates(
            fix.point.latitude.toStringAsFixed(2),
            fix.point.longitude.toStringAsFixed(2),
          );
    final icon = fix == null
        ? Icons.add_location_alt_outlined
        : switch (fix.origin) {
            LocationOrigin.device => Icons.my_location,
            LocationOrigin.cached => Icons.history,
            LocationOrigin.manual => Icons.edit_location_alt_outlined,
          };
    final attention = fix == null || location.problem != LocationProblem.none;

    return Row(
      children: [
        Text(
          l10n.appName,
          style: text.headlineSmall?.copyWith(letterSpacing: 1.2),
        ),
        const Spacer(),
        IconButton(
          tooltip: l10n.navMap,
          onPressed: () => context.go(AppRoutes.map),
          icon: Icon(Icons.map_outlined, color: p.inkMuted),
          visualDensity: VisualDensity.compact,
        ),
        const SizedBox(width: 2),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onTapLocation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: attention ? p.gold : p.inkFaint.withValues(alpha: 0.5),
                ),
                color: p.surface.withValues(alpha: 0.7),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 15, color: attention ? p.gold : p.inkMuted),
                  const SizedBox(width: 7),
                  Text(
                    label,
                    style: text.bodySmall?.copyWith(
                      color: p.ink,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DialArea extends StatelessWidget {
  const _DialArea({
    required this.snapshot,
    required this.compass,
    required this.hasLocation,
    required this.isAligned,
    required this.isLocating,
    required this.onUseLocation,
    required this.onEnterCoordinates,
  });

  final QiblaSnapshot? snapshot;
  final CompassState compass;
  final bool hasLocation;
  final bool isAligned;
  final bool isLocating;
  final VoidCallback onUseLocation;
  final VoidCallback onEnterCoordinates;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math
            .min(
              constraints.maxWidth - 16,
              constraints.maxHeight - 16,
            )
            .clamp(200.0, 460.0);
        final trust = snapshot?.trust ?? NeedleTrust.trusted;
        final hasHeading = snapshot?.trueHeading != null;
        final showRay = hasLocation && !(snapshot?.geometry.isAtKaaba ?? false);

        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              CompassDial(
                size: size,
                trueHeading: hasHeading ? snapshot!.trueHeading : null,
                qiblaBearing: showRay
                    ? snapshot?.geometry.bearingFromTrueNorth
                    : null,
                trust: hasHeading ? trust : NeedleTrust.degraded,
                isAligned: isAligned,
              ),
              if (!hasLocation)
                _LocationPrompt(
                  width: size * 0.78,
                  isLocating: isLocating,
                  onUseLocation: onUseLocation,
                  onEnterCoordinates: onEnterCoordinates,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _LocationPrompt extends StatelessWidget {
  const _LocationPrompt({
    required this.width,
    required this.isLocating,
    required this.onUseLocation,
    required this.onEnterCoordinates,
  });

  final double width;
  final bool isLocating;
  final VoidCallback onUseLocation;
  final VoidCallback onEnterCoordinates;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = QiblaPalette.of(context);
    final text = Theme.of(context).textTheme;
    return Container(
      width: width,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: p.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: p.gold.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: p.background.withValues(alpha: 0.6),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.locationNeededTitle,
            style: text.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.locationNeededBody,
            style: text.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: isLocating ? null : onUseLocation,
            icon: isLocating
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: p.background,
                    ),
                  )
                : const Icon(Icons.my_location, size: 18),
            label: Text(
              isLocating ? l10n.locationLocating : l10n.locationUseMyLocation,
            ),
          ),
          TextButton(
            onPressed: onEnterCoordinates,
            child: Text(l10n.locationEnterCoordinates),
          ),
        ],
      ),
    );
  }
}

class _Readout extends StatelessWidget {
  const _Readout({required this.snapshot, required this.isAligned});

  final QiblaSnapshot? snapshot;
  final bool isAligned;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = QiblaPalette.of(context);
    final text = Theme.of(context).textTheme;
    final snapshot = this.snapshot;
    if (snapshot == null) return const SizedBox(height: 96);

    final geometry = snapshot.geometry;
    final offset = snapshot.offset;
    final blocked = snapshot.trust == NeedleTrust.blocked;

    final String instruction;
    final Color instructionColor;
    if (geometry.isAtKaaba) {
      instruction = l10n.atKaabaTitle;
      instructionColor = p.gold;
    } else if (offset == null || blocked) {
      instruction = '';
      instructionColor = p.inkMuted;
    } else if (isAligned) {
      instruction = l10n.facingQibla;
      instructionColor = snapshot.trust == NeedleTrust.trusted
          ? p.gold
          : p.warning;
    } else if (offset.abs() > 150) {
      instruction = l10n.turnAround;
      instructionColor = p.ink;
    } else if (offset > 0) {
      instruction = l10n.turnRight(offset.round());
      instructionColor = p.ink;
    } else {
      instruction = l10n.turnLeft(offset.abs().round());
      instructionColor = p.ink;
    }

    return Column(
      children: [
        Text(l10n.qiblaLabel, style: text.labelMedium),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '${geometry.bearingFromTrueNorth.round() % 360}°',
              style: text.displayMedium?.copyWith(
                color: isAligned ? p.goldBright : p.ink,
              ),
            ),
            const SizedBox(width: 10),
            Text(l10n.fromTrueNorth, style: text.bodySmall),
          ],
        ),
        const SizedBox(height: 6),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: Row(
            key: ValueKey(instruction),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isAligned && instruction.isNotEmpty) ...[
                Icon(Icons.check_circle, size: 18, color: instructionColor),
                const SizedBox(width: 6),
              ],
              Text(
                instruction,
                style: text.titleMedium?.copyWith(color: instructionColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.snapshot, required this.onDetails});

  final QiblaSnapshot? snapshot;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final p = QiblaPalette.of(context);
    final geometry = snapshot?.geometry;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (geometry != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  l10n.bearingSummary(
                    geometry.bearingFromTrueNorth.round() % 360,
                    geometry.bearingFromMagneticNorth.round() % 360,
                  ),
                  style: text.bodySmall,
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: onDetails,
                icon: const Icon(Icons.info_outline, size: 16),
                label: Text(l10n.detailsButton),
              ),
            ],
          ),
        Align(
          alignment: Alignment.center,
          child: TextButton.icon(
            onPressed: () => _openSupport(context),
            icon: const Icon(Icons.mail_outline, size: 16),
            label: Text(l10n.supportButton),
          ),
        ),
        Text(
          '${l10n.footerFree}  ·  ${l10n.footerIntention}',
          textAlign: TextAlign.center,
          style: text.labelSmall?.copyWith(color: p.inkFaint),
        ),
      ],
    );
  }
}

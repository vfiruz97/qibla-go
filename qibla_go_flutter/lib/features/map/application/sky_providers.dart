import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/astro/sky_position.dart';
import '../../../core/geo/angles.dart';
import '../../../core/geo/geo_point.dart';
import '../../qibla/application/location_controller.dart';
import '../../qibla/application/qibla_geometry_provider.dart';

/// Ticks once a minute; sun and moon move about a quarter degree in that
/// time, which no one can see on a map.
final minuteClockProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream.periodic(const Duration(minutes: 1), (_) => DateTime.now());
});

/// Sun and moon as seen from the user's position right now, with how far
/// the qibla is from each of them.
final class SkySnapshot {
  const SkySnapshot({
    required this.at,
    required this.when,
    required this.sun,
    required this.moon,
    required this.moonIllumination,
    required this.qiblaBearing,
  });

  final GeoPoint at;
  final DateTime when;
  final SkyPosition sun;
  final SkyPosition moon;
  final MoonIllumination moonIllumination;
  final double qiblaBearing;

  /// Signed turn from the sun to the qibla; positive = to the right.
  double get qiblaFromSun => Angles.delta(sun.azimuth, qiblaBearing);

  double get qiblaFromMoon => Angles.delta(moon.azimuth, qiblaBearing);

  /// Moon shown only when up and the sun is low enough for it to be
  /// visible, so the map does not invite looking for a moon in daylight.
  bool get showMoon => moon.isAboveHorizon && sun.altitude < 6;
}

final skySnapshotProvider = Provider<SkySnapshot?>((ref) {
  final point = ref.watch(locationPointProvider);
  final geometry = ref.watch(qiblaGeometryProvider);
  if (point == null || geometry == null) return null;
  final when = ref.watch(minuteClockProvider).value ?? DateTime.now();
  return SkySnapshot(
    at: point,
    when: when,
    sun: SkyCalculator.sun(point, when),
    moon: SkyCalculator.moon(point, when),
    moonIllumination: SkyCalculator.moonIllumination(when),
    qiblaBearing: geometry.bearingFromTrueNorth,
  );
});

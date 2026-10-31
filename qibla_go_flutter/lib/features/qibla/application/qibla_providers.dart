import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/geo/qibla_geometry.dart';
import '../domain/qibla_state.dart';
import 'compass_controller.dart';
import 'location_controller.dart';

/// Bearing, distance and declination for the current position.
///
/// Recomputed only when the coordinates change, never per sensor sample.
final qiblaGeometryProvider = Provider<QiblaGeometry?>((ref) {
  final point = ref.watch(locationPointProvider);
  if (point == null) return null;
  return QiblaGeometry.compute(point, DateTime.now());
});

/// What the dial draws: geometry joined with the latest reading.
final qiblaSnapshotProvider = Provider<QiblaSnapshot?>((ref) {
  final geometry = ref.watch(qiblaGeometryProvider);
  if (geometry == null) return null;
  final reading = ref.watch(
    compassControllerProvider.select((s) => s.reading),
  );
  return QiblaSnapshot.from(geometry, reading);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/geo/qibla_geometry.dart';
import 'location_controller.dart';

/// Bearing, distance and declination for the current position.
///
/// Recomputed only when the coordinates change, never per sensor sample.
/// Lives apart from the compass providers so the map (and the web build,
/// which has no compass) can use it without pulling in sensor code.
final qiblaGeometryProvider = Provider<QiblaGeometry?>((ref) {
  final point = ref.watch(locationPointProvider);
  if (point == null) return null;
  return QiblaGeometry.compute(point, DateTime.now());
});

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/qibla_state.dart';
import 'compass_controller.dart';
import 'qibla_geometry_provider.dart';

export 'qibla_geometry_provider.dart';

/// What the dial draws: geometry joined with the latest reading.
final qiblaSnapshotProvider = Provider<QiblaSnapshot?>((ref) {
  final geometry = ref.watch(qiblaGeometryProvider);
  if (geometry == null) return null;
  final reading = ref.watch(
    compassControllerProvider.select((s) => s.reading),
  );
  return QiblaSnapshot.from(geometry, reading);
});

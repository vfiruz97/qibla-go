import 'dart:async';

import 'package:flutter/foundation.dart';

import '../geo/geo_point.dart';
import 'compass_reading.dart';
import 'compass_source.dart';

/// A heading you drive by hand, for developing the dial on a desk.
///
/// Refuses to exist in release builds: a simulated direction in a believer's
/// hands would be worse than no direction at all.
final class SimulatedCompassSource implements CompassSource {
  SimulatedCompassSource({double initialHeading = 0})
    : assert(!kReleaseMode, 'SimulatedCompassSource is debug-only'),
      _heading = initialHeading;

  final _controller = StreamController<CompassReading>.broadcast();
  Timer? _ticker;
  double _heading;
  List<CompassIssue> _issues = const [];

  double get heading => _heading;

  set heading(double degrees) {
    _heading = degrees % 360;
    _emit();
  }

  set issues(List<CompassIssue> issues) {
    _issues = issues;
    _emit();
  }

  @override
  CompassSourceKind get kind => CompassSourceKind.simulated;

  @override
  Future<CompassAvailability> availability() async => kReleaseMode
      ? const CompassAvailability.unavailable(
          CompassUnavailableReason.noSensor,
        )
      : const CompassAvailability.available();

  @override
  Future<CompassAvailability> requestPermission() => availability();

  @override
  Future<void> configure(GeoPoint? location) async {}

  @override
  Stream<CompassReading> get readings {
    _ticker ??= Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (!_controller.hasListener) {
        _ticker?.cancel();
        _ticker = null;
        return;
      }
      _emit();
    });
    return _controller.stream;
  }

  void _emit() {
    if (_controller.isClosed) return;
    _controller.add(
      CompassReading(
        magneticHeading: _heading,
        accuracyDegrees: 2,
        confidence: 95,
        issues: _issues,
        timestamp: DateTime.now(),
        sourceKind: kind,
        sourceLabel: 'simulated',
      ),
    );
  }

  void dispose() {
    _ticker?.cancel();
    _controller.close();
  }
}

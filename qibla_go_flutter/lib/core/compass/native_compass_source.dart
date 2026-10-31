import 'dart:async';

import 'package:compass_max/compass_max.dart' as cm;

import '../geo/geo_point.dart';
import 'compass_reading.dart';
import 'compass_source.dart';

/// Android and iOS sensors through the vendored `compass_max` plugin.
///
/// The plugin already smooths the heading, debounces its conditions and runs
/// the sensor fallback chain (rotation vector → geomagnetic rotation vector →
/// accelerometer + magnetometer), so this class only translates its event
/// into the app's [CompassReading].
final class NativeCompassSource implements CompassSource {
  NativeCompassSource();

  GeoPoint? _location;

  @override
  CompassSourceKind get kind => CompassSourceKind.native;

  @override
  Future<CompassAvailability> availability() async {
    try {
      final capabilities = await cm.CompassMax.capabilities();
      return capabilities.hasCompass
          ? const CompassAvailability.available()
          : const CompassAvailability.unavailable(
              CompassUnavailableReason.noSensor,
            );
    } catch (_) {
      return const CompassAvailability.unavailable(
        CompassUnavailableReason.noSensor,
      );
    }
  }

  @override
  Future<CompassAvailability> requestPermission() => availability();

  @override
  Future<void> configure(GeoPoint? location) async {
    _location = location;
    await cm.CompassMax.configure(
      location: location == null
          ? null
          : cm.CompassLocation(
              latitude: location.latitude,
              longitude: location.longitude,
            ),
      smoothing: cm.CompassSmoothing.medium,
    );
  }

  @override
  Stream<CompassReading> get readings => cm.CompassMax.events
      .map(_toReading)
      .handleError(
        (Object error, StackTrace stack) => throw CompassSourceException(
          'native compass stream failed',
          error,
        ),
      );

  CompassReading _toReading(cm.CompassEvent event) {
    final d = event.diagnostics;
    return CompassReading(
      magneticHeading: d.magneticHeading,
      platformTrueHeading: d.isTrueNorth ? event.heading : null,
      accuracyDegrees: d.accuracyDegrees,
      confidence: d.confidence,
      issues: event.conditions.map(_toIssue).toList(growable: false),
      pitchDegrees: d.pitch,
      rollDegrees: d.roll,
      fieldStrengthMicroTesla: d.fieldStrength,
      expectedFieldStrengthMicroTesla: d.expectedFieldStrength,
      timestamp: d.timestamp,
      sourceKind: kind,
      sourceLabel: _location == null
          ? '${d.source.name} (no location)'
          : d.source.name,
    );
  }

  static CompassIssue _toIssue(cm.CompassCondition condition) =>
      switch (condition) {
        cm.CompassCondition.magneticInterference =>
          CompassIssue.magneticInterference,
        cm.CompassCondition.movingFast => CompassIssue.movingFast,
        cm.CompassCondition.needsCalibration => CompassIssue.needsCalibration,
        cm.CompassCondition.phoneNotFlat => CompassIssue.deviceNotFlat,
      };
}

/// Raised on the stream when a platform source fails after subscribing.
final class CompassSourceException implements Exception {
  const CompassSourceException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() =>
      'CompassSourceException: $message'
      '${cause == null ? '' : ' ($cause)'}';
}

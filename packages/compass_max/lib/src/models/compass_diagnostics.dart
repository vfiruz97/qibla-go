import 'compass_condition.dart';
import 'compass_source.dart';

/// Everything behind the heading and the condition list.
///
/// Nothing here belongs in a user facing screen. It is for your debug page and
/// for the crash report a user attaches when they say the direction is wrong.
class CompassDiagnostics {
  const CompassDiagnostics({
    required this.magneticHeading,
    required this.isTrueNorth,
    required this.confidence,
    required this.interference,
    required this.sensorAccuracy,
    required this.pitch,
    required this.roll,
    required this.jitter,
    required this.source,
    required this.timestamp,
    this.accuracyDegrees,
    this.fieldStrength,
    this.expectedFieldStrength,
  });

  /// Degrees clockwise from magnetic north, `0..360`.
  final double magneticHeading;

  /// False means declination was unknown, so the heading is really the
  /// magnetic one and may be off by up to about 20 degrees.
  ///
  /// This is a wiring mistake rather than a runtime state: pass a location to
  /// `CompassMax.configure`. Debug builds log a warning when it happens.
  final bool isTrueNorth;

  /// Platform estimate of heading error in degrees, when it reports one.
  final double? accuracyDegrees;

  /// `0..100`, combining platform accuracy, field health, needle stability
  /// and tilt.
  final int confidence;

  final CompassInterference interference;

  final CompassSensorAccuracy sensorAccuracy;

  /// Degrees away from lying flat, `-180..180`.
  final double pitch;

  final double roll;

  /// Mean absolute heading change per sample, in degrees. High values mean
  /// the needle is swinging on its own.
  final double jitter;

  final CompassSource source;

  /// Measured field magnitude in microtesla.
  final double? fieldStrength;

  /// What the World Magnetic Model predicts here, in microtesla. Null on iOS
  /// and before a location is configured.
  final double? expectedFieldStrength;

  final DateTime timestamp;

  /// Human readable error, for a debug screen or a support reply.
  String get accuracyLabel {
    final double? degrees = accuracyDegrees;

    if (degrees == null) {
      return 'unknown';
    }

    return '±${degrees.toStringAsFixed(0)}°';
  }

  /// How far the measured field is from the predicted one, in microtesla.
  double? get fieldDeviation {
    final double? measured = fieldStrength;
    final double? expected = expectedFieldStrength;

    if (measured == null || expected == null) {
      return null;
    }

    return (measured - expected).abs();
  }

  @override
  String toString() {
    return 'CompassDiagnostics(magneticHeading: '
        '${magneticHeading.toStringAsFixed(1)}, isTrueNorth: $isTrueNorth, '
        'accuracy: $accuracyLabel, confidence: $confidence, '
        'interference: $interference, sensorAccuracy: $sensorAccuracy, '
        'pitch: ${pitch.toStringAsFixed(0)}, jitter: '
        '${jitter.toStringAsFixed(1)}, source: $source, '
        'field: $fieldStrength, expected: $expectedFieldStrength)';
  }
}

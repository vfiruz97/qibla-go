import '../models/compass_config.dart';
import '../models/compass_condition.dart';
import '../models/compass_source.dart';

/// Decides which conditions are true for a single sample, before debouncing.
class ConditionDetector {
  const ConditionDetector({
    this.thresholds = const CompassThresholds(),
  });

  final CompassThresholds thresholds;

  Set<CompassCondition> detect({
    required CompassInterference interference,
    required CompassSensorAccuracy sensorAccuracy,
    required double? accuracyDegrees,
    required double pitch,
    required double? speedMetersPerSecond,
  }) {
    final Set<CompassCondition> conditions = <CompassCondition>{};

    if (pitch.abs() > thresholds.tiltDegreesAbove) {
      conditions.add(CompassCondition.phoneNotFlat);
    }

    if (speedMetersPerSecond != null &&
        speedMetersPerSecond >= thresholds.movingFastSpeedMetersPerSecond) {
      conditions.add(CompassCondition.movingFast);
    }

    if (interference == CompassInterference.severe) {
      conditions.add(CompassCondition.magneticInterference);

      // Calibrating inside a polluted field makes the stored estimate worse,
      // so the user is never asked to do it until they have moved away.
      return conditions;
    }

    if (_needsCalibration(
      sensorAccuracy: sensorAccuracy,
      accuracyDegrees: accuracyDegrees,
    )) {
      conditions.add(CompassCondition.needsCalibration);
    }

    return conditions;
  }

  /// Only the platform's own report counts here.
  ///
  /// Needle jitter deliberately does not: a heading wanders just as much when
  /// the user turns the phone as when the sensor is bad, so using it asks
  /// people with working compasses to wave their phone around. Catching a
  /// genuinely wandering needle needs the gyroscope to confirm the phone is
  /// actually still, which is a separate job.
  bool _needsCalibration({
    required CompassSensorAccuracy sensorAccuracy,
    required double? accuracyDegrees,
  }) {
    // Medium counts as calibrated on purpose. It is accurate enough, and some
    // devices never report anything better no matter what the user does.
    if (sensorAccuracy == CompassSensorAccuracy.low ||
        sensorAccuracy == CompassSensorAccuracy.unreliable) {
      return true;
    }

    return accuracyDegrees != null &&
        accuracyDegrees > thresholds.calibrationAccuracyDegreesAbove;
  }
}

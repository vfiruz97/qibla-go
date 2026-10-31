import 'package:compass_max/compass_max.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const ConditionDetector detector = ConditionDetector();

  Set<CompassCondition> detect({
    CompassInterference interference = CompassInterference.none,
    CompassSensorAccuracy sensorAccuracy = CompassSensorAccuracy.high,
    double? accuracyDegrees = 8,
    double pitch = 0,
    double? speed,
  }) {
    return detector.detect(
      interference: interference,
      sensorAccuracy: sensorAccuracy,
      accuracyDegrees: accuracyDegrees,
      pitch: pitch,
      speedMetersPerSecond: speed,
    );
  }

  test('a healthy reading has no conditions', () {
    expect(detect(), isEmpty);
  });

  group('calibration', () {
    test('is asked for on a low sensor level', () {
      expect(
        detect(sensorAccuracy: CompassSensorAccuracy.low),
        contains(CompassCondition.needsCalibration),
      );
    });

    test('is asked for on an unreliable sensor level', () {
      expect(
        detect(sensorAccuracy: CompassSensorAccuracy.unreliable),
        contains(CompassCondition.needsCalibration),
      );
    });

    test('is not asked for at medium, which is good enough', () {
      expect(
        detect(sensorAccuracy: CompassSensorAccuracy.medium),
        isEmpty,
      );
    });

    test('is asked for on a wide reported error', () {
      expect(
        detect(accuracyDegrees: 30),
        contains(CompassCondition.needsCalibration),
      );
    });

    test('is not asked for just because the heading is moving', () {
      // A heading wanders as much when the user turns the phone as when the
      // sensor is bad, so jitter must never reach this decision. Tilting the
      // phone used to produce a calibration prompt on a healthy compass.
      expect(
        detect(sensorAccuracy: CompassSensorAccuracy.high, accuracyDegrees: 8),
        isEmpty,
      );
    });

    test('is suppressed while the field is polluted', () {
      // Calibrating inside a bad field stores a worse estimate than before.
      final Set<CompassCondition> conditions = detect(
        interference: CompassInterference.severe,
        sensorAccuracy: CompassSensorAccuracy.unreliable,
      );

      expect(conditions, contains(CompassCondition.magneticInterference));
      expect(conditions, isNot(contains(CompassCondition.needsCalibration)));
    });
  });

  group('interference', () {
    test('standing still reports the fixable case', () {
      expect(
        detect(interference: CompassInterference.severe),
        contains(CompassCondition.magneticInterference),
      );
    });

    test('mild interference is not an condition on its own', () {
      expect(detect(interference: CompassInterference.mild), isEmpty);
    });
  });

  group('speed', () {
    test('is reported on its own, without any interference', () {
      expect(
          detect(speed: 20), <CompassCondition>{CompassCondition.movingFast});
    });

    test('is not reported at walking pace', () {
      expect(detect(speed: 1.4), isEmpty);
    });

    test('is reported alongside interference', () {
      expect(
        detect(interference: CompassInterference.severe, speed: 20),
        <CompassCondition>{
          CompassCondition.magneticInterference,
          CompassCondition.movingFast,
        },
      );
    });

    test('is not reported when no speed is fed', () {
      expect(detect(), isEmpty);
    });
  });

  group('tilt', () {
    test('is reported past the threshold', () {
      expect(detect(pitch: 40), contains(CompassCondition.phoneNotFlat));
    });

    test('is not reported for a phone lying flat', () {
      expect(detect(pitch: 10), isEmpty);
    });

    test('is reported alongside interference', () {
      expect(
        detect(pitch: 40, interference: CompassInterference.severe),
        <CompassCondition>{
          CompassCondition.phoneNotFlat,
          CompassCondition.magneticInterference,
        },
      );
    });
  });
}

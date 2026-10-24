import 'package:compass_max/compass_max.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final DateTime start = DateTime(2026, 1, 1);

  RawCompassReading reading({
    double magneticHeading = 90,
    double? trueHeading = 95,
    double? accuracy = 8,
    double pitch = 0,
    double? fieldStrength = 48,
    double? expectedFieldStrength = 48,
    RawSensorAccuracy sensorAccuracy = RawSensorAccuracy.high,
    RawCompassSource source = RawCompassSource.rotationVector,
    Duration at = Duration.zero,
  }) {
    return RawCompassReading(
      magneticHeading: magneticHeading,
      trueHeading: trueHeading,
      headingAccuracyDegrees: accuracy,
      pitchDegrees: pitch,
      rollDegrees: 0,
      fieldStrengthMicroTesla: fieldStrength,
      expectedFieldStrengthMicroTesla: expectedFieldStrength,
      sensorAccuracy: sensorAccuracy,
      source: source,
      timestampMillis: start.add(at).millisecondsSinceEpoch,
    );
  }

  test('passes the first reading through unsmoothed', () {
    final CompassPipeline pipeline = CompassPipeline();

    final CompassEvent event = pipeline.process(reading());

    expect(event.heading, closeTo(95, 0.001));
    expect(event.diagnostics.magneticHeading, closeTo(90, 0.001));
    expect(event.diagnostics.isTrueNorth, isTrue);
  });

  test('falls back to the magnetic heading rather than emitting null', () {
    final CompassPipeline pipeline = CompassPipeline();

    final CompassEvent event = pipeline.process(
      reading(trueHeading: null, magneticHeading: 200),
    );

    expect(event.heading, closeTo(200, 0.001));
    expect(event.diagnostics.isTrueNorth, isFalse);
  });

  test('a clean reading has nothing to say', () {
    final CompassPipeline pipeline = CompassPipeline();

    final CompassEvent event = pipeline.process(reading(accuracy: 5));

    expect(event.conditions, isEmpty);
    expect(event.topCondition, isNull);
    expect(event.diagnostics.confidence, greaterThan(90));
  });

  test('a magnet nearby is reported, but only after the delay', () {
    final CompassPipeline pipeline = CompassPipeline();

    pipeline.process(reading(fieldStrength: 140));

    final CompassEvent early = pipeline.process(
      reading(fieldStrength: 140, at: const Duration(milliseconds: 500)),
    );

    expect(early.conditions, isEmpty);
    expect(early.diagnostics.interference, CompassInterference.severe);

    final CompassEvent late = pipeline.process(
      reading(fieldStrength: 140, at: const Duration(milliseconds: 2000)),
    );

    expect(late.conditions, contains(CompassCondition.magneticInterference));
  });

  test('speed is reported next to the interference, not instead of it', () {
    final CompassPipeline pipeline = CompassPipeline();

    pipeline.process(reading(fieldStrength: 140), speedMetersPerSecond: 25);

    final CompassEvent event = pipeline.process(
      reading(fieldStrength: 140, at: const Duration(milliseconds: 2000)),
      speedMetersPerSecond: 25,
    );

    expect(event.conditions, <CompassCondition>[
      CompassCondition.magneticInterference,
      CompassCondition.movingFast,
    ]);
  });

  test('speed alone is reported with a clean field', () {
    final CompassPipeline pipeline = CompassPipeline();

    pipeline.process(reading(), speedMetersPerSecond: 25);

    final CompassEvent event = pipeline.process(
      reading(at: const Duration(milliseconds: 2000)),
      speedMetersPerSecond: 25,
    );

    expect(event.conditions, <CompassCondition>[CompassCondition.movingFast]);
  });

  test('calibration is never asked for while the field is polluted', () {
    final CompassPipeline pipeline = CompassPipeline();

    for (int index = 0; index < 4; index++) {
      pipeline.process(
        reading(
          fieldStrength: 140,
          sensorAccuracy: RawSensorAccuracy.unreliable,
          accuracy: null,
          at: Duration(milliseconds: index * 800),
        ),
      );
    }

    final CompassEvent event = pipeline.process(
      reading(
        fieldStrength: 140,
        sensorAccuracy: RawSensorAccuracy.unreliable,
        accuracy: null,
        at: const Duration(milliseconds: 4000),
      ),
    );

    expect(event.conditions, contains(CompassCondition.magneticInterference));
    expect(
        event.conditions, isNot(contains(CompassCondition.needsCalibration)));
  });

  test('an uncalibrated sensor asks for calibration', () {
    final CompassPipeline pipeline = CompassPipeline();

    pipeline.process(
      reading(sensorAccuracy: RawSensorAccuracy.low, accuracy: null),
    );

    final CompassEvent event = pipeline.process(
      reading(
        sensorAccuracy: RawSensorAccuracy.low,
        accuracy: null,
        at: const Duration(milliseconds: 2000),
      ),
    );

    expect(event.conditions, contains(CompassCondition.needsCalibration));
  });

  test('medium accuracy counts as calibrated', () {
    final CompassPipeline pipeline = CompassPipeline();

    pipeline.process(
      reading(sensorAccuracy: RawSensorAccuracy.medium, accuracy: 10),
    );

    final CompassEvent event = pipeline.process(
      reading(
        sensorAccuracy: RawSensorAccuracy.medium,
        accuracy: 10,
        at: const Duration(milliseconds: 2000),
      ),
    );

    expect(event.conditions, isEmpty);
  });

  test('smooths across north without swinging the long way', () {
    final CompassPipeline pipeline = CompassPipeline();

    pipeline.process(reading(trueHeading: 350, magneticHeading: 350));

    final CompassEvent event = pipeline.process(
      reading(
        trueHeading: 10,
        magneticHeading: 10,
        at: const Duration(milliseconds: 33),
      ),
    );

    expect(Angles.distance(event.heading, 355), lessThan(10));
  });

  test('a tilted phone is asked to lie flat, sorted below interference', () {
    final CompassPipeline pipeline = CompassPipeline();

    pipeline.process(reading(pitch: 70, fieldStrength: 140));

    final CompassEvent event = pipeline.process(
      reading(
        pitch: 70,
        fieldStrength: 140,
        at: const Duration(milliseconds: 2000),
      ),
    );

    expect(event.conditions, <CompassCondition>[
      CompassCondition.magneticInterference,
      CompassCondition.phoneNotFlat,
    ]);
    expect(event.topCondition, CompassCondition.magneticInterference);
  });

  test('every true condition is reported, whatever else is true', () {
    final CompassPipeline pipeline = CompassPipeline();

    pipeline.process(
      reading(pitch: 70, fieldStrength: 140),
      speedMetersPerSecond: 25,
    );

    final CompassEvent event = pipeline.process(
      reading(
        pitch: 70,
        fieldStrength: 140,
        at: const Duration(milliseconds: 2000),
      ),
      speedMetersPerSecond: 25,
    );

    expect(event.conditions, <CompassCondition>[
      CompassCondition.magneticInterference,
      CompassCondition.movingFast,
      CompassCondition.phoneNotFlat,
    ]);
  });

  test('reset clears both the filter and the conditions', () {
    final CompassPipeline pipeline = CompassPipeline();

    pipeline.process(reading(fieldStrength: 140));
    pipeline.process(
      reading(fieldStrength: 140, at: const Duration(milliseconds: 2000)),
    );
    pipeline.reset();

    final CompassEvent event = pipeline.process(
      reading(magneticHeading: 200, trueHeading: 200),
    );

    expect(event.conditions, isEmpty);
    expect(event.heading, closeTo(200, 0.001));
  });

  test('diagnostics carry everything the UI does not need', () {
    final CompassPipeline pipeline = CompassPipeline();

    final CompassEvent event = pipeline.process(
      reading(source: RawCompassSource.geomagneticRotationVector),
    );

    expect(event.diagnostics.source, CompassSource.geomagneticRotationVector);
    expect(event.diagnostics.accuracyLabel, '±8°');
    expect(event.diagnostics.fieldDeviation, closeTo(0, 0.001));
    expect(event.diagnostics.sensorAccuracy, CompassSensorAccuracy.high);
  });

  test('accuracy label survives a device that reports nothing', () {
    final CompassPipeline pipeline = CompassPipeline();

    final CompassEvent event = pipeline.process(reading(accuracy: null));

    expect(event.diagnostics.accuracyLabel, 'unknown');
  });

  test('iOS style readings without a predicted field still classify', () {
    final CompassPipeline pipeline = CompassPipeline();

    final CompassEvent event = pipeline.process(
      reading(
        expectedFieldStrength: null,
        fieldStrength: 300,
        source: RawCompassSource.coreLocation,
      ),
    );

    expect(event.diagnostics.interference, CompassInterference.severe);
    expect(event.diagnostics.fieldDeviation, isNull);
  });
}

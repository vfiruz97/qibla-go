import 'package:compass_max/compass_max.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const ConfidenceCalculator calculator = ConfidenceCalculator();

  int score({
    double? accuracyDegrees,
    CompassSensorAccuracy sensorAccuracy = CompassSensorAccuracy.high,
    CompassInterference interference = CompassInterference.none,
    double jitter = 0,
    double pitch = 0,
  }) {
    return calculator.calculate(
      accuracyDegrees: accuracyDegrees,
      sensorAccuracy: sensorAccuracy,
      interference: interference,
      jitter: jitter,
      pitch: pitch,
    );
  }

  test('a clean reading scores at the top', () {
    expect(score(accuracyDegrees: 5), 100);
  });

  test('a useless reading scores at the bottom', () {
    expect(score(accuracyDegrees: 45), 0);
  });

  test('degrees of error drive the score down smoothly', () {
    expect(score(accuracyDegrees: 25), closeTo(50, 1));
  });

  test('falls back to the coarse level when degrees are missing', () {
    expect(score(sensorAccuracy: CompassSensorAccuracy.high), 90);
    expect(score(sensorAccuracy: CompassSensorAccuracy.medium), 65);
    expect(score(sensorAccuracy: CompassSensorAccuracy.low), 35);
    expect(score(sensorAccuracy: CompassSensorAccuracy.unreliable), 10);
  });

  test('severe interference overrides a confident platform estimate', () {
    // The case every other package misses: the OS says it is calibrated
    // while a magnet is pointing the needle at the wrong wall.
    expect(
      score(
        accuracyDegrees: 5,
        interference: CompassInterference.severe,
      ),
      lessThan(30),
    );
  });

  test('a swinging needle lowers the score', () {
    final int steady = score(accuracyDegrees: 10);
    final int swinging = score(accuracyDegrees: 10, jitter: 20);

    expect(swinging, lessThan(steady));
  });

  test('tilt costs a little, not a lot', () {
    final int flat = score(accuracyDegrees: 10);
    final int upright = score(accuracyDegrees: 10, pitch: 80);

    expect(upright, lessThan(flat));
    expect(upright, greaterThan((flat * 0.8).round()));
  });

  test('never leaves 0..100', () {
    expect(
      score(
        accuracyDegrees: 90,
        interference: CompassInterference.severe,
        jitter: 180,
        pitch: 180,
      ),
      inInclusiveRange(0, 100),
    );
  });
}

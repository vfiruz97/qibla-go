import 'package:compass_max/compass_max.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const InterferenceDetector detector = InterferenceDetector();

  group('with a predicted field strength', () {
    test('a matching reading is clean', () {
      expect(
        detector.classify(fieldStrength: 48, expectedFieldStrength: 48),
        CompassInterference.none,
      );
    });

    test('a small deviation is mild', () {
      expect(
        detector.classify(fieldStrength: 60, expectedFieldStrength: 48),
        CompassInterference.mild,
      );
    });

    test('a laptop sized deviation is severe', () {
      expect(
        detector.classify(fieldStrength: 120, expectedFieldStrength: 48),
        CompassInterference.severe,
      );
    });

    test('shielding that suppresses the field is severe too', () {
      expect(
        detector.classify(fieldStrength: 10, expectedFieldStrength: 48),
        CompassInterference.severe,
      );
    });
  });

  group('without a predicted field strength', () {
    test('a plausible field is clean', () {
      expect(
        detector.classify(fieldStrength: 45, expectedFieldStrength: null),
        CompassInterference.none,
      );
    });

    test('just outside the Earth band is mild', () {
      expect(
        detector.classify(fieldStrength: 68, expectedFieldStrength: null),
        CompassInterference.mild,
      );
    });

    test('far outside the Earth band is severe', () {
      expect(
        detector.classify(fieldStrength: 300, expectedFieldStrength: null),
        CompassInterference.severe,
      );
    });
  });

  test('no reading at all gives no verdict', () {
    expect(
      detector.classify(fieldStrength: null, expectedFieldStrength: 48),
      CompassInterference.unknown,
    );
  });

  test('a zero reading is treated as missing, not as shielding', () {
    expect(
      detector.classify(fieldStrength: 0, expectedFieldStrength: 48),
      CompassInterference.unknown,
    );
  });

  test('thresholds are configurable', () {
    const InterferenceDetector strict = InterferenceDetector(
      thresholds: CompassThresholds(
        mildDeviationMicroTesla: 2,
        severeDeviationMicroTesla: 5,
      ),
    );

    expect(
      strict.classify(fieldStrength: 54, expectedFieldStrength: 48),
      CompassInterference.severe,
    );
  });
}

import 'package:compass_max/compass_max.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final DateTime start = DateTime(2026, 1, 1);

  List<CompassCondition> feed(
    ConditionDebouncer debouncer,
    Set<CompassCondition> candidates,
    Duration after,
  ) {
    return debouncer.update(
      candidates: candidates,
      timestamp: start.add(after),
    );
  }

  test('a single bad sample shows nothing', () {
    final ConditionDebouncer debouncer = ConditionDebouncer();

    final List<CompassCondition> conditions = feed(
      debouncer,
      <CompassCondition>{CompassCondition.magneticInterference},
      const Duration(milliseconds: 100),
    );

    expect(conditions, isEmpty);
  });

  test('a sustained condition appears after the delay', () {
    final ConditionDebouncer debouncer = ConditionDebouncer();

    feed(
      debouncer,
      <CompassCondition>{CompassCondition.magneticInterference},
      Duration.zero,
    );

    expect(
      feed(
        debouncer,
        <CompassCondition>{CompassCondition.magneticInterference},
        const Duration(milliseconds: 1400),
      ),
      isEmpty,
    );

    expect(
      feed(
        debouncer,
        <CompassCondition>{CompassCondition.magneticInterference},
        const Duration(milliseconds: 1600),
      ),
      <CompassCondition>[CompassCondition.magneticInterference],
    );
  });

  test('a gap in a bad run restarts the countdown', () {
    final ConditionDebouncer debouncer = ConditionDebouncer();

    feed(
      debouncer,
      <CompassCondition>{CompassCondition.needsCalibration},
      Duration.zero,
    );
    feed(debouncer, <CompassCondition>{}, const Duration(milliseconds: 1000));

    expect(
      feed(
        debouncer,
        <CompassCondition>{CompassCondition.needsCalibration},
        const Duration(milliseconds: 1600),
      ),
      isEmpty,
    );
  });

  test('clears faster than it appears', () {
    final ConditionDebouncer debouncer = ConditionDebouncer();

    feed(
      debouncer,
      <CompassCondition>{CompassCondition.needsCalibration},
      Duration.zero,
    );
    feed(
      debouncer,
      <CompassCondition>{CompassCondition.needsCalibration},
      const Duration(milliseconds: 2000),
    );
    feed(debouncer, <CompassCondition>{}, const Duration(milliseconds: 2100));

    expect(
      feed(debouncer, <CompassCondition>{}, const Duration(milliseconds: 3200)),
      isEmpty,
    );
  });

  test('conditions are sorted most severe first', () {
    final ConditionDebouncer debouncer = ConditionDebouncer();

    const Set<CompassCondition> candidates = <CompassCondition>{
      CompassCondition.phoneNotFlat,
      CompassCondition.needsCalibration,
      CompassCondition.magneticInterference,
    };

    feed(debouncer, candidates, Duration.zero);

    expect(
      feed(debouncer, candidates, const Duration(milliseconds: 2000)),
      <CompassCondition>[
        CompassCondition.magneticInterference,
        CompassCondition.needsCalibration,
        CompassCondition.phoneNotFlat,
      ],
    );
  });

  test('nothing is ever hidden by another condition', () {
    final ConditionDebouncer debouncer = ConditionDebouncer();

    const Set<CompassCondition> candidates = <CompassCondition>{
      CompassCondition.phoneNotFlat,
      CompassCondition.movingFast,
    };

    feed(debouncer, candidates, Duration.zero);

    expect(
      feed(debouncer, candidates, const Duration(milliseconds: 2000)),
      <CompassCondition>[
        CompassCondition.movingFast,
        CompassCondition.phoneNotFlat,
      ],
    );
  });

  test('each condition is timed independently', () {
    final ConditionDebouncer debouncer = ConditionDebouncer();

    feed(
      debouncer,
      <CompassCondition>{CompassCondition.needsCalibration},
      Duration.zero,
    );
    feed(
      debouncer,
      <CompassCondition>{CompassCondition.needsCalibration},
      const Duration(milliseconds: 1600),
    );

    // Tilt starts its own clock here, so it is not shown yet.
    final List<CompassCondition> conditions = feed(
      debouncer,
      <CompassCondition>{
        CompassCondition.needsCalibration,
        CompassCondition.phoneNotFlat
      },
      const Duration(milliseconds: 1700),
    );

    expect(conditions, <CompassCondition>[CompassCondition.needsCalibration]);
  });

  test('reset forgets everything', () {
    final ConditionDebouncer debouncer = ConditionDebouncer();

    feed(
      debouncer,
      <CompassCondition>{CompassCondition.magneticInterference},
      Duration.zero,
    );
    feed(
      debouncer,
      <CompassCondition>{CompassCondition.magneticInterference},
      const Duration(milliseconds: 2000),
    );
    debouncer.reset();

    expect(
      feed(
        debouncer,
        <CompassCondition>{CompassCondition.magneticInterference},
        const Duration(milliseconds: 2100),
      ),
      isEmpty,
    );
  });
}

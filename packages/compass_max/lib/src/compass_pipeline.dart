import 'helpers/confidence_calculator.dart';
import 'helpers/heading_filter.dart';
import 'helpers/interference_detector.dart';
import 'helpers/condition_debouncer.dart';
import 'helpers/condition_detector.dart';
import 'messages.g.dart';
import 'models/compass_config.dart';
import 'models/compass_diagnostics.dart';
import 'models/compass_event.dart';
import 'models/compass_condition.dart';
import 'models/compass_source.dart';

/// Turns raw platform facts into a [CompassEvent].
///
/// Every judgement the package makes happens here rather than in Kotlin and
/// Swift, so the two platforms cannot drift apart and the whole thing is
/// testable without a device. The native side only reports what it measured.
class CompassPipeline {
  CompassPipeline({
    CompassSmoothing smoothing = CompassSmoothing.medium,
    this.thresholds = const CompassThresholds(),
  })  : _filter = HeadingFilter(smoothing: smoothing),
        _magneticFilter = HeadingFilter(smoothing: smoothing),
        _interference = InterferenceDetector(thresholds: thresholds),
        _detector = ConditionDetector(thresholds: thresholds),
        _debouncer = ConditionDebouncer(thresholds: thresholds);

  final CompassThresholds thresholds;

  final HeadingFilter _filter;
  final HeadingFilter _magneticFilter;
  final HeadingStability _stability = HeadingStability();
  final InterferenceDetector _interference;
  final ConditionDetector _detector;
  final ConditionDebouncer _debouncer;
  final ConfidenceCalculator _confidence = const ConfidenceCalculator();

  CompassEvent process(
    RawCompassReading reading, {
    double? speedMetersPerSecond,
  }) {
    final bool isTrueNorth = reading.trueHeading != null;
    final double rawHeading = reading.trueHeading ?? reading.magneticHeading;

    _stability.add(rawHeading);

    final double heading = _filter.add(rawHeading);
    final double magneticHeading = _magneticFilter.add(reading.magneticHeading);

    final CompassInterference interference = _interference.classify(
      fieldStrength: reading.fieldStrengthMicroTesla,
      expectedFieldStrength: reading.expectedFieldStrengthMicroTesla,
    );

    final CompassSensorAccuracy sensorAccuracy =
        CompassSensorAccuracy.fromRaw(reading.sensorAccuracy);

    final int confidence = _confidence.calculate(
      accuracyDegrees: reading.headingAccuracyDegrees,
      sensorAccuracy: sensorAccuracy,
      interference: interference,
      jitter: _stability.jitter,
      pitch: reading.pitchDegrees,
    );

    final DateTime timestamp =
        DateTime.fromMillisecondsSinceEpoch(reading.timestampMillis);

    final List<CompassCondition> conditions = _debouncer.update(
      candidates: _detector.detect(
        interference: interference,
        sensorAccuracy: sensorAccuracy,
        accuracyDegrees: reading.headingAccuracyDegrees,
        pitch: reading.pitchDegrees,
        speedMetersPerSecond: speedMetersPerSecond,
      ),
      timestamp: timestamp,
    );

    return CompassEvent(
      heading: heading,
      conditions: conditions,
      diagnostics: CompassDiagnostics(
        magneticHeading: magneticHeading,
        isTrueNorth: isTrueNorth,
        accuracyDegrees: reading.headingAccuracyDegrees,
        confidence: confidence,
        interference: interference,
        sensorAccuracy: sensorAccuracy,
        pitch: reading.pitchDegrees,
        roll: reading.rollDegrees,
        jitter: _stability.jitter,
        source: CompassSource.fromRaw(reading.source),
        fieldStrength: reading.fieldStrengthMicroTesla,
        expectedFieldStrength: reading.expectedFieldStrengthMicroTesla,
        timestamp: timestamp,
      ),
    );
  }

  void reset() {
    _filter.reset();
    _magneticFilter.reset();
    _stability.reset();
    _debouncer.reset();
  }
}

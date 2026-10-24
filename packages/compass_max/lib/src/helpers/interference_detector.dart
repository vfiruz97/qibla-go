import '../models/compass_config.dart';
import '../models/compass_condition.dart';

/// Decides whether something magnetic is sitting next to the device.
///
/// This is the only signal in the package solid enough to justify blocking
/// the UI, because it is a measurement rather than a guess: the Earth's field
/// at a given place has a known magnitude, and a laptop, a car body or a
/// magnetic phone case pushes the measured value well outside it.
class InterferenceDetector {
  const InterferenceDetector({
    this.thresholds = const CompassThresholds(),
  });

  final CompassThresholds thresholds;

  CompassInterference classify({
    required double? fieldStrength,
    required double? expectedFieldStrength,
  }) {
    if (fieldStrength == null || fieldStrength <= 0) {
      return CompassInterference.unknown;
    }

    if (expectedFieldStrength != null && expectedFieldStrength > 0) {
      final double deviation = (fieldStrength - expectedFieldStrength).abs();

      if (deviation >= thresholds.severeDeviationMicroTesla) {
        return CompassInterference.severe;
      }

      if (deviation >= thresholds.mildDeviationMicroTesla) {
        return CompassInterference.mild;
      }

      return CompassInterference.none;
    }

    final (double severeLow, double severeHigh) =
        thresholds.severeAbsoluteRange;

    if (fieldStrength < severeLow || fieldStrength > severeHigh) {
      return CompassInterference.severe;
    }

    final (double mildLow, double mildHigh) = thresholds.mildAbsoluteRange;

    if (fieldStrength < mildLow || fieldStrength > mildHigh) {
      return CompassInterference.mild;
    }

    return CompassInterference.none;
  }
}

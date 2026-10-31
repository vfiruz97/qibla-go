import '../messages.g.dart';

/// Which sensor chain produced the reading.
///
/// Diagnostics only, so log it rather than showing it. It is how you answer
/// "why is this one device wrong" from a crash report.
enum CompassSource {
  /// Android 13+ `TYPE_HEADING`, already referenced to true north.
  heading,

  /// Android `TYPE_ROTATION_VECTOR`, fused with the gyroscope. Best case.
  rotationVector,

  /// Android `TYPE_GEOMAGNETIC_ROTATION_VECTOR`. Works without a gyroscope,
  /// which is what most budget devices have.
  geomagneticRotationVector,

  /// Android accelerometer + magnetometer fused by the plugin. Last resort,
  /// noticeably noisier.
  accelerometerMagnetometer,

  /// iOS `CLLocationManager` heading updates.
  coreLocation,

  unknown;

  static CompassSource fromRaw(RawCompassSource raw) {
    switch (raw) {
      case RawCompassSource.heading:
        return CompassSource.heading;
      case RawCompassSource.rotationVector:
        return CompassSource.rotationVector;
      case RawCompassSource.geomagneticRotationVector:
        return CompassSource.geomagneticRotationVector;
      case RawCompassSource.accelerometerMagnetometer:
        return CompassSource.accelerometerMagnetometer;
      case RawCompassSource.coreLocation:
        return CompassSource.coreLocation;
      case RawCompassSource.unknown:
        return CompassSource.unknown;
    }
  }
}

/// How much the platform trusts its own magnetometer calibration.
enum CompassSensorAccuracy {
  unreliable,
  low,
  medium,
  high,
  unknown;

  static CompassSensorAccuracy fromRaw(RawSensorAccuracy raw) {
    switch (raw) {
      case RawSensorAccuracy.unreliable:
        return CompassSensorAccuracy.unreliable;
      case RawSensorAccuracy.low:
        return CompassSensorAccuracy.low;
      case RawSensorAccuracy.medium:
        return CompassSensorAccuracy.medium;
      case RawSensorAccuracy.high:
        return CompassSensorAccuracy.high;
      case RawSensorAccuracy.unknown:
        return CompassSensorAccuracy.unknown;
    }
  }
}

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/messages.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/src/main/kotlin/com/kamranbekirov/compass_max/Messages.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'com.kamranbekirov.compass_max',
    ),
    swiftOut: 'ios/compass_max/Sources/compass_max/Messages.g.swift',
    swiftOptions: SwiftOptions(),
    dartPackageName: 'compass_max',
  ),
)
/// How much the platform trusts its own magnetometer calibration.
///
/// Mirrors Android's `SENSOR_STATUS_ACCURACY_*` constants. iOS has no direct
/// equivalent, so it is derived from `CLHeading.headingAccuracy`.
enum RawSensorAccuracy {
  unreliable,
  low,
  medium,
  high,
  unknown,
}

/// Which sensor chain actually produced the reading.
///
/// Diagnostics only. The heading is normalised regardless of source.
enum RawCompassSource {
  /// Android 13+ `TYPE_HEADING`, already referenced to true north.
  heading,

  /// Android `TYPE_ROTATION_VECTOR`, gyroscope fused, the best case.
  rotationVector,

  /// Android `TYPE_GEOMAGNETIC_ROTATION_VECTOR`, which needs no gyroscope.
  geomagneticRotationVector,

  /// Android accelerometer + magnetometer fused by hand, last resort.
  accelerometerMagnetometer,

  /// iOS `CLLocationManager` heading updates.
  coreLocation,

  unknown,
}

/// A single set of facts from the platform, with no interpretation applied.
///
/// Everything judgemental, meaning smoothing, confidence, interference and
/// calibration state, is derived in Dart so both platforms behave identically.
class RawCompassReading {
  RawCompassReading({
    required this.magneticHeading,
    required this.pitchDegrees,
    required this.rollDegrees,
    required this.sensorAccuracy,
    required this.source,
    required this.timestampMillis,
    this.trueHeading,
    this.headingAccuracyDegrees,
    this.fieldStrengthMicroTesla,
    this.expectedFieldStrengthMicroTesla,
  });

  /// Degrees clockwise from magnetic north, `0..360`.
  double magneticHeading;

  /// Degrees clockwise from true north, or null when declination is unknown.
  double? trueHeading;

  /// Platform estimate of heading error in degrees, when it provides one.
  double? headingAccuracyDegrees;

  /// Degrees the device is tilted away from lying flat, `-180..180`.
  double pitchDegrees;

  double rollDegrees;

  /// Measured magnetic field magnitude in microtesla.
  double? fieldStrengthMicroTesla;

  /// Field magnitude the World Magnetic Model predicts at the configured
  /// location. Null on iOS, which has no equivalent of `GeomagneticField`.
  double? expectedFieldStrengthMicroTesla;

  RawSensorAccuracy sensorAccuracy;

  RawCompassSource source;

  int timestampMillis;
}

/// What the device is physically able to do, checked before subscribing.
class RawCompassCapabilities {
  RawCompassCapabilities({
    required this.hasCompass,
    required this.hasGyroscope,
    required this.hasMagnetometer,
    required this.reportsHeadingAccuracy,
    required this.bestAvailableSource,
  });

  bool hasCompass;
  bool hasGyroscope;
  bool hasMagnetometer;
  bool reportsHeadingAccuracy;
  RawCompassSource bestAvailableSource;
}

/// Where the user is, used for declination and expected field strength.
class RawLocation {
  RawLocation({
    required this.latitude,
    required this.longitude,
    required this.altitudeMeters,
  });

  double latitude;
  double longitude;
  double altitudeMeters;
}

@HostApi()
abstract class CompassMaxHostApi {
  @async
  RawCompassCapabilities capabilities();

  /// Passing null drops back to magnetic north and disables the expected
  /// field strength check.
  void setLocation(RawLocation? location);
}

@EventChannelApi()
abstract class CompassMaxEventApi {
  RawCompassReading streamReadings();
}

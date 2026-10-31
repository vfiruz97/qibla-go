import '../messages.g.dart';
import 'compass_source.dart';

/// What the device can physically do. Check this before subscribing, so a
/// device with no magnetometer gets your fallback UI instead of a dead dial.
class CompassCapabilities {
  const CompassCapabilities({
    required this.hasCompass,
    required this.hasGyroscope,
    required this.hasMagnetometer,
    required this.reportsHeadingAccuracy,
    required this.bestAvailableSource,
  });

  /// False means there is no usable heading on this device at all.
  final bool hasCompass;

  /// False means readings come from the geomagnetic chain: still correct,
  /// but noisier and slower to settle.
  final bool hasGyroscope;

  final bool hasMagnetometer;

  /// False means [CompassEvent.accuracy] will always be null on this device
  /// and confidence falls back to the coarse sensor accuracy level.
  final bool reportsHeadingAccuracy;

  final CompassSource bestAvailableSource;

  static CompassCapabilities fromRaw(RawCompassCapabilities raw) {
    return CompassCapabilities(
      hasCompass: raw.hasCompass,
      hasGyroscope: raw.hasGyroscope,
      hasMagnetometer: raw.hasMagnetometer,
      reportsHeadingAccuracy: raw.reportsHeadingAccuracy,
      bestAvailableSource: CompassSource.fromRaw(raw.bestAvailableSource),
    );
  }

  @override
  String toString() {
    return 'CompassCapabilities(hasCompass: $hasCompass, '
        'hasGyroscope: $hasGyroscope, hasMagnetometer: $hasMagnetometer, '
        'reportsHeadingAccuracy: $reportsHeadingAccuracy, '
        'bestAvailableSource: $bestAvailableSource)';
  }
}

/// Where the user is. Feeds declination on Android and the expected field
/// strength used to detect interference.
class CompassLocation {
  const CompassLocation({
    required this.latitude,
    required this.longitude,
    this.altitude = 0,
  });

  final double latitude;
  final double longitude;
  final double altitude;

  RawLocation toRaw() {
    return RawLocation(
      latitude: latitude,
      longitude: longitude,
      altitudeMeters: altitude,
    );
  }
}

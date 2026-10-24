import '../geo/geo_point.dart';
import 'compass_reading.dart';

/// Why a compass is not (yet) usable.
enum CompassUnavailableReason {
  /// The device or browser has no sensor that can produce a heading.
  noSensor,

  /// The browser needs an explicit permission grant from a user gesture
  /// (iOS Safari).
  permissionRequired,

  /// The user declined the permission.
  permissionDenied,

  /// Sensors exist but produced nothing within a reasonable time.
  noReadings,
}

/// Whether a source can run right now.
final class CompassAvailability {
  const CompassAvailability.available() : isAvailable = true, reason = null;

  const CompassAvailability.unavailable(this.reason) : isAvailable = false;

  final bool isAvailable;
  final CompassUnavailableReason? reason;

  @override
  String toString() => isAvailable ? 'available' : 'unavailable($reason)';
}

/// A stream of headings from somewhere.
///
/// Implementations report facts only. Every judgement about those facts
/// (true north, alignment, whether to trust the needle) belongs to the
/// qibla feature, which is covered by tests that run without a device.
abstract interface class CompassSource {
  CompassSourceKind get kind;

  /// Check before subscribing; a device with no magnetometer gets a
  /// fallback UI rather than a stream that never emits.
  Future<CompassAvailability> availability();

  /// Asks the platform for permission where one is needed (web on iOS).
  /// Returns the availability afterwards.
  Future<CompassAvailability> requestPermission();

  /// Gives the source the user's position. Native sources use it for the
  /// expected field strength that makes interference a measurement rather
  /// than a guess. Cheap; call again whenever the location changes.
  Future<void> configure(GeoPoint? location);

  /// Broadcast stream; sensors run only while someone listens.
  Stream<CompassReading> get readings;
}

/// Emitted on a readings stream when the platform has the API but never
/// delivers a usable sample (desktop browsers, sensors blocked by policy).
final class CompassUnavailableException implements Exception {
  const CompassUnavailableException(this.reason);

  final CompassUnavailableReason reason;

  @override
  String toString() => 'CompassUnavailableException($reason)';
}

import '../geo/geo_point.dart';

/// How a position was obtained. Shown in the UI so a stale or hand-typed
/// location is never mistaken for a live fix.
enum LocationOrigin {
  /// From the device's location services during this session.
  device,

  /// Restored from storage; came from the device in an earlier session.
  cached,

  /// Typed in by the user.
  manual,
}

/// Why no device position is available right now.
enum LocationProblem {
  none,
  servicesDisabled,
  permissionDenied,

  /// Denied with "don't ask again"; only the system settings can fix it.
  permissionDeniedForever,
  timeout,
  unavailable,
}

/// One known position.
final class LocationFix {
  const LocationFix({
    required this.point,
    required this.time,
    required this.origin,
    this.accuracyMeters,
  });

  final GeoPoint point;

  /// When the fix was taken (for a cached fix: originally taken).
  final DateTime time;
  final LocationOrigin origin;
  final double? accuracyMeters;

  LocationFix copyWith({LocationOrigin? origin}) => LocationFix(
    point: point,
    time: time,
    origin: origin ?? this.origin,
    accuracyMeters: accuracyMeters,
  );

  static LocationFix? tryFromJson(Map<String, Object?>? json) {
    if (json == null) return null;
    final point = GeoPoint.tryFromJson(json);
    final time = json['time'];
    final origin = json['origin'];
    if (point == null || time is! String) return null;
    final parsed = DateTime.tryParse(time);
    if (parsed == null) return null;
    final accuracy = json['accuracyMeters'];
    return LocationFix(
      point: point,
      time: parsed,
      origin: origin == LocationOrigin.manual.name
          ? LocationOrigin.manual
          : LocationOrigin.cached,
      accuracyMeters: accuracy is num ? accuracy.toDouble() : null,
    );
  }

  Map<String, Object?> toJson() => {
    ...point.toJson(),
    'time': time.toUtc().toIso8601String(),
    'origin': origin.name,
    if (accuracyMeters != null) 'accuracyMeters': accuracyMeters,
  };
}

/// Permission as the app sees it, independent of the plugin's enums.
enum LocationPermissionState { granted, denied, deniedForever, unknown }

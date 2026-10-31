import 'dart:math' as math;

import 'angles.dart';
import 'geo_point.dart';

/// Points along the shortest path over the sphere from [from] to [to].
///
/// Spherical linear interpolation; [segments] + 1 points including both
/// ends. Used to draw the qibla line on a map so it is the true
/// great-circle path, which on a flat map looks curved at country scale
/// and straight at street scale.
List<GeoPoint> greatCirclePath(
  GeoPoint from,
  GeoPoint to, {
  int segments = 128,
}) {
  assert(segments >= 1);
  final lat1 = Angles.toRadians(from.latitude);
  final lon1 = Angles.toRadians(from.longitude);
  final lat2 = Angles.toRadians(to.latitude);
  final lon2 = Angles.toRadians(to.longitude);

  final d =
      2 *
      math.asin(
        math.sqrt(
          math.pow(math.sin((lat1 - lat2) / 2), 2) +
              math.cos(lat1) *
                  math.cos(lat2) *
                  math.pow(math.sin((lon1 - lon2) / 2), 2),
        ),
      );
  if (d < 1e-12) return [from, to];

  final points = <GeoPoint>[];
  for (var i = 0; i <= segments; i++) {
    final f = i / segments;
    final a = math.sin((1 - f) * d) / math.sin(d);
    final b = math.sin(f * d) / math.sin(d);
    final x =
        a * math.cos(lat1) * math.cos(lon1) +
        b * math.cos(lat2) * math.cos(lon2);
    final y =
        a * math.cos(lat1) * math.sin(lon1) +
        b * math.cos(lat2) * math.sin(lon2);
    final z = a * math.sin(lat1) + b * math.sin(lat2);
    final lat = math.atan2(z, math.sqrt(x * x + y * y));
    final lon = math.atan2(y, x);
    points.add(
      GeoPoint(
        latitude: Angles.toDegrees(lat).clamp(-90, 90),
        longitude: Angles.toDegrees(lon).clamp(-180, 180),
      ),
    );
  }
  return points;
}

import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_go_flutter/core/geo/angles.dart';
import 'package:qibla_go_flutter/core/geo/geo_point.dart';
import 'package:qibla_go_flutter/core/geo/great_circle.dart';
import 'package:qibla_go_flutter/core/geo/qibla_geometry.dart';

/// Plain initial bearing between two points, written independently of the
/// package under test.
double _bearing(GeoPoint a, GeoPoint b) {
  final lat1 = Angles.toRadians(a.latitude);
  final lat2 = Angles.toRadians(b.latitude);
  final dLon = Angles.toRadians(b.longitude - a.longitude);
  final y = math.sin(dLon) * math.cos(lat2);
  final x =
      math.cos(lat1) * math.sin(lat2) -
      math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
  return Angles.normalize(Angles.toDegrees(math.atan2(y, x)));
}

void main() {
  final dushanbe = GeoPoint(latitude: 38.5598, longitude: 68.787);

  test('path starts and ends exactly at the endpoints', () {
    final path = greatCirclePath(dushanbe, kaaba, segments: 10);
    expect(path.length, 11);
    expect(path.first.latitude, closeTo(dushanbe.latitude, 1e-9));
    expect(path.first.longitude, closeTo(dushanbe.longitude, 1e-9));
    expect(path.last.latitude, closeTo(kaaba.latitude, 1e-9));
    expect(path.last.longitude, closeTo(kaaba.longitude, 1e-9));
  });

  test('first segment leaves along the qibla bearing', () {
    final path = greatCirclePath(dushanbe, kaaba, segments: 2000);
    final expected = QiblaGeometry.compute(
      dushanbe,
      DateTime.utc(2026),
    ).bearingFromTrueNorth;
    expect(_bearing(path[0], path[1]), closeTo(expected, 0.05));
  });

  test('midpoint is equidistant from both ends', () {
    final path = greatCirclePath(dushanbe, kaaba, segments: 2);
    final mid = path[1];
    expect(
      mid.distanceMetersTo(dushanbe),
      closeTo(mid.distanceMetersTo(kaaba), 1),
    );
  });

  test('identical points give a two-point path', () {
    expect(greatCirclePath(kaaba, kaaba).length, 2);
  });
}

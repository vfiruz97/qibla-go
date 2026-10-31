import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_go_flutter/core/compass/compass_reading.dart';
import 'package:qibla_go_flutter/core/geo/geo_point.dart';
import 'package:qibla_go_flutter/core/geo/qibla_geometry.dart';
import 'package:qibla_go_flutter/core/compass/compass_source.dart';
import 'package:qibla_go_flutter/features/qibla/domain/qibla_state.dart';

CompassReading _reading({
  double magnetic = 0,
  List<CompassIssue> issues = const [],
  CompassSourceKind kind = CompassSourceKind.native,
  double? accuracy = 3,
  int confidence = 90,
}) => CompassReading(
  magneticHeading: magnetic,
  issues: issues,
  sourceKind: kind,
  sourceLabel: 'test',
  accuracyDegrees: accuracy,
  confidence: confidence,
  timestamp: DateTime.utc(2026),
);

void main() {
  group('needleTrustFor', () {
    test('no reading is blocked', () {
      expect(needleTrustFor(null), NeedleTrust.blocked);
    });

    test('interference and vehicles block the needle', () {
      expect(
        needleTrustFor(_reading(issues: [CompassIssue.magneticInterference])),
        NeedleTrust.blocked,
      );
      expect(
        needleTrustFor(_reading(issues: [CompassIssue.movingFast])),
        NeedleTrust.blocked,
      );
    });

    test('calibration, tilt and browsers degrade but keep the needle', () {
      expect(
        needleTrustFor(_reading(issues: [CompassIssue.needsCalibration])),
        NeedleTrust.degraded,
      );
      expect(
        needleTrustFor(_reading(issues: [CompassIssue.deviceNotFlat])),
        NeedleTrust.degraded,
      );
      expect(
        needleTrustFor(_reading(kind: CompassSourceKind.web)),
        NeedleTrust.degraded,
      );
    });

    test('poor reported accuracy or confidence degrades', () {
      expect(needleTrustFor(_reading(accuracy: 20)), NeedleTrust.degraded);
      expect(needleTrustFor(_reading(confidence: 30)), NeedleTrust.degraded);
    });

    test('a clean native reading is trusted', () {
      expect(needleTrustFor(_reading()), NeedleTrust.trusted);
      expect(needleTrustFor(_reading(accuracy: null)), NeedleTrust.trusted);
    });
  });

  group('QiblaSnapshot', () {
    final geometry = QiblaGeometry.compute(
      GeoPoint(latitude: 51.5085, longitude: -0.1257), // London
      DateTime.utc(2026, 10, 24),
    );

    test('applies declination before comparing with the bearing', () {
      final magnetic = geometry.bearingFromMagneticNorth;
      final s = QiblaSnapshot.from(geometry, _reading(magnetic: magnetic));
      // Facing the qibla on a magnetic compass means facing it for real.
      expect(s.offset, closeTo(0, 1e-6));
      expect(s.needleAngle, closeTo(0, 1e-6));
      expect(s.trueHeading, closeTo(geometry.bearingFromTrueNorth, 1e-6));
    });

    test('with no reading there is no heading and the needle is blocked', () {
      final s = QiblaSnapshot.from(geometry, null);
      expect(s.trueHeading, isNull);
      expect(s.offset, isNull);
      expect(s.trust, NeedleTrust.blocked);
    });
  });

  group('AlignmentTracker', () {
    test('enters at 3° and leaves past 6°', () {
      final t = AlignmentTracker();
      expect(t.update(10), isFalse);
      expect(t.update(3.5), isFalse);
      expect(t.update(2.9), isTrue);
      expect(t.update(5.0), isTrue); // hysteresis
      expect(t.update(-5.9), isTrue);
      expect(t.update(6.1), isFalse);
      expect(t.update(-2.0), isTrue);
    });

    test('blocked trust or missing offset always clears', () {
      final t = AlignmentTracker();
      expect(t.update(0), isTrue);
      expect(t.update(0, trust: NeedleTrust.blocked), isFalse);
      expect(t.update(0), isTrue);
      expect(t.update(null), isFalse);
    });
  });

  group('CompassState.phase', () {
    test('walks checking → waiting → active → stale', () {
      expect(const CompassState().phase, CompassPhase.checking);
      const available = CompassState(
        availability: CompassAvailability.available(),
      );
      expect(available.phase, CompassPhase.waiting);
      final active = available.copyWith(reading: _reading());
      expect(active.phase, CompassPhase.active);
      expect(active.copyWith(isStale: true).phase, CompassPhase.stale);
      expect(active.copyWith(isPaused: true).phase, CompassPhase.paused);
    });
  });
}

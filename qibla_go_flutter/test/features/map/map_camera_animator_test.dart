import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_go_flutter/features/map/presentation/widgets/map_camera_animator.dart';

void main() {
  group('flyZoom', () {
    test('starts and ends exactly at the requested zooms', () {
      expect(MapCameraAnimator.flyZoom(0, 13, 17, 3), 13);
      expect(MapCameraAnimator.flyZoom(1, 13, 17, 3), closeTo(17, 1e-9));
    });

    test('dips by the bump in the middle', () {
      expect(MapCameraAnimator.flyZoom(0.5, 17, 17, 3), closeTo(14, 1e-9));
    });

    test('is a straight blend without a bump', () {
      expect(MapCameraAnimator.flyZoom(0.25, 12, 16, 0), closeTo(13, 1e-9));
    });
  });

  group('bumpFor', () {
    test('no pull-back when the target is already on screen', () {
      expect(
        MapCameraAnimator.bumpFor(
          pixelDistance: 200,
          viewport: 400,
          fromZoom: 17,
          toZoom: 17,
        ),
        0,
      );
    });

    test('grows with the log of the distance', () {
      final near = MapCameraAnimator.bumpFor(
        pixelDistance: 4 * 400,
        viewport: 400,
        fromZoom: 17,
        toZoom: 17,
      );
      final far = MapCameraAnimator.bumpFor(
        pixelDistance: 4096 * 400,
        viewport: 400,
        fromZoom: 17,
        toZoom: 17,
      );
      expect(near, closeTo(2.5, 1e-9));
      expect(far, closeTo(12.5, 1e-9));
    });

    test('never pulls back below zoom 2', () {
      expect(
        MapCameraAnimator.bumpFor(
          pixelDistance: 1e9,
          viewport: 400,
          fromZoom: 5,
          toZoom: 17,
        ),
        3,
      );
    });
  });

  test('durationFor is bounded', () {
    expect(MapCameraAnimator.durationFor(0), MapCameraAnimator.baseDuration);
    expect(MapCameraAnimator.durationFor(100), MapCameraAnimator.maxDuration);
  });
}

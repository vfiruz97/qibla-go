import 'package:compass_max/compass_max.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HeadingFilter', () {
    test('takes the first reading as is', () {
      final HeadingFilter filter = HeadingFilter(
        smoothing: CompassSmoothing.medium,
      );

      expect(filter.add(42), closeTo(42, 0.001));
    });

    test('does not spin the long way round when crossing north', () {
      final HeadingFilter filter = HeadingFilter(
        smoothing: CompassSmoothing.medium,
      );

      filter.add(350);

      final double next = filter.add(10);

      // A naive filter would land somewhere near 180 here.
      expect(next > 350 || next < 20, isTrue);
      expect(Angles.distance(next, 355), lessThan(10));
    });

    test('converges on a steady heading', () {
      final HeadingFilter filter = HeadingFilter(
        smoothing: CompassSmoothing.medium,
      );

      filter.add(0);

      for (int index = 0; index < 60; index++) {
        filter.add(90);
      }

      expect(filter.value, closeTo(90, 0.5));
    });

    test('none passes the value straight through', () {
      final HeadingFilter filter = HeadingFilter(
        smoothing: CompassSmoothing.none,
      );

      filter.add(0);

      expect(filter.add(123), closeTo(123, 0.001));
    });

    test('reset forgets the previous heading', () {
      final HeadingFilter filter = HeadingFilter(
        smoothing: CompassSmoothing.heavy,
      );

      filter.add(10);
      filter.reset();

      expect(filter.add(200), closeTo(200, 0.001));
    });
  });

  group('HeadingStability', () {
    test('reports no jitter for a still device', () {
      final HeadingStability stability = HeadingStability();

      for (int index = 0; index < 10; index++) {
        stability.add(90);
      }

      expect(stability.jitter, closeTo(0, 0.001));
    });

    test('reports jitter for a swinging needle', () {
      final HeadingStability stability = HeadingStability();

      for (int index = 0; index < 10; index++) {
        stability.add(index.isEven ? 80.0 : 100.0);
      }

      expect(stability.jitter, closeTo(20, 0.001));
    });

    test('only keeps the last window of samples', () {
      final HeadingStability stability = HeadingStability(window: 3);

      stability.add(0);
      stability.add(50);
      stability.add(50);
      stability.add(50);
      stability.add(50);

      expect(stability.jitter, closeTo(0, 0.001));
    });
  });
}

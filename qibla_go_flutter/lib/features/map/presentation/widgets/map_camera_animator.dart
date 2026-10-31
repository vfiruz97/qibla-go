import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/animation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '../../../../core/geo/angles.dart';

/// Moves a [MapController] smoothly instead of jumping.
///
/// Short hops glide; long hops fly: the camera zooms out, travels, and zooms
/// back in, so the user keeps track of where they went. A touch from the
/// user cancels the animation at once so the map never fights a finger.
class MapCameraAnimator {
  MapCameraAnimator({required TickerProvider vsync, required this.controller})
    : _c = AnimationController(vsync: vsync, duration: baseDuration) {
    _events = controller.mapEventStream.listen(_onEvent);
  }

  static const baseDuration = Duration(milliseconds: 550);
  static const maxDuration = Duration(milliseconds: 1400);
  static const curve = Curves.easeInOutCubic;

  final MapController controller;
  final AnimationController _c;
  late final StreamSubscription<MapEvent> _events;

  /// Flies to [center] at [zoom]. [screenOffset] shifts where [center] lands
  /// relative to the viewport middle, in logical pixels (positive y = below).
  Future<void> flyTo(
    LatLng center,
    double zoom, {
    Offset screenOffset = Offset.zero,
  }) async {
    final camera = controller.camera;
    final crs = camera.crs;
    final target = screenOffset == Offset.zero
        ? center
        : crs.offsetToLatLng(
            crs.latLngToOffset(center, zoom) - screenOffset,
            zoom,
          );
    final from = camera.center;
    final fromZoom = camera.zoom;
    final pixels =
        (crs.latLngToOffset(target, zoom) - crs.latLngToOffset(from, zoom))
            .distance;
    final bump = bumpFor(
      pixelDistance: pixels,
      viewport: camera.nonRotatedSize.shortestSide,
      fromZoom: fromZoom,
      toZoom: zoom,
    );
    _c.stop();
    _c.duration = durationFor(bump);
    void tick() {
      final t = curve.transform(_c.value);
      controller.move(
        LatLng(
          from.latitude + (target.latitude - from.latitude) * t,
          _wrap(
            from.longitude + Angles.delta(from.longitude, target.longitude) * t,
          ),
        ),
        flyZoom(t, fromZoom, zoom, bump),
      );
    }

    _c.addListener(tick);
    try {
      await _c.forward(from: 0).orCancel;
    } on TickerCanceled {
      // Interrupted by the user or a newer animation: leave the map as is.
    } finally {
      _c.removeListener(tick);
    }
  }

  Future<void> zoomBy(double delta, {double? min, double? max}) {
    final camera = controller.camera;
    var zoom = camera.zoom + delta;
    if (min != null) zoom = math.max(min, zoom);
    if (max != null) zoom = math.min(max, zoom);
    return flyTo(camera.center, zoom);
  }

  Future<void> flyToFit(CameraFit fit) {
    final target = fit.fit(controller.camera);
    return flyTo(target.center, target.zoom);
  }

  void stop() => _c.stop();

  void dispose() {
    _events.cancel();
    _c.dispose();
  }

  void _onEvent(MapEvent event) {
    if (!_c.isAnimating) return;
    switch (event.source) {
      case MapEventSource.dragStart:
      case MapEventSource.onDrag:
      case MapEventSource.multiFingerGestureStart:
      case MapEventSource.onMultiFinger:
      case MapEventSource.scrollWheel:
      case MapEventSource.doubleTap:
      case MapEventSource.doubleTapHold:
      case MapEventSource.keyboard:
        _c.stop(canceled: true);
      default:
        break;
    }
  }

  static double _wrap(double lon) {
    if (lon > 180) return lon - 360;
    if (lon < -180) return lon + 360;
    return lon;
  }

  /// How far (in zoom levels) to pull back mid-flight. Zero when the target
  /// is already on screen; grows with the log of the distance so a hop across
  /// town barely dips and a hop across continents shows the globe.
  static double bumpFor({
    required double pixelDistance,
    required double viewport,
    required double fromZoom,
    required double toZoom,
  }) {
    if (viewport <= 0 || pixelDistance <= viewport) return 0;
    final wanted = math.log(pixelDistance / viewport) / math.ln2 + 0.5;
    final room = math.min(fromZoom, toZoom) - 2;
    return wanted.clamp(0, math.max(0, room)).toDouble();
  }

  static Duration durationFor(double bump) {
    final ms = baseDuration.inMilliseconds + (170 * bump).round();
    return Duration(milliseconds: math.min(ms, maxDuration.inMilliseconds));
  }

  /// Zoom at progress [t] of a flight: a straight blend from [from] to [to],
  /// dipping by [bump] in the middle.
  static double flyZoom(double t, double from, double to, double bump) =>
      from + (to - from) * t - bump * math.sin(math.pi * t);
}

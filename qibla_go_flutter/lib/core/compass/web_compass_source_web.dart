import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:math' as math;

import 'package:web/web.dart' as web;

import '../geo/angles.dart';
import '../geo/geo_point.dart';
import 'compass_reading.dart';
import 'compass_source.dart';

/// Browser compass from `deviceorientation` events.
///
/// Honest about its limits: browsers give a heading with no field-strength
/// data, so interference cannot be detected, and most give no accuracy
/// estimate at all. The reading is labelled accordingly and the UI shows the
/// numeric bearing prominently so the page is useful with a real compass.
///
/// Heading recovery:
/// - iOS Safari exposes `webkitCompassHeading`, the device's heading from
///   magnetic north regardless of tilt, plus `webkitCompassAccuracy`.
/// - Elsewhere the heading is rebuilt from the full alpha/beta/gamma
///   rotation (the W3C "compass heading" derivation), which stays correct
///   when the phone is tilted, and corrected for the screen orientation.
///   Only `absolute` events (Earth frame) are trusted; relative ones are
///   arbitrary and are rejected.
final class WebCompassSource implements CompassSource {
  WebCompassSource();

  static const _tiltIssueDegrees = 35.0;
  static const _firstReadingTimeout = Duration(seconds: 4);

  StreamController<CompassReading>? _controller;
  JSFunction? _absoluteListener;
  JSFunction? _relativeListener;
  Timer? _firstReadingTimer;
  bool _gotAbsolute = false;
  final _smoother = HeadingSmoother(alpha: 0.3);

  @override
  CompassSourceKind get kind => CompassSourceKind.web;

  bool get _needsPermissionCall {
    final ctor = web.window.getProperty<JSAny?>('DeviceOrientationEvent'.toJS);
    if (ctor == null || ctor.isUndefinedOrNull) return false;
    final fn = (ctor as JSObject).getProperty<JSAny?>('requestPermission'.toJS);
    return fn != null && !fn.isUndefinedOrNull;
  }

  bool get _hasOrientationApi {
    final ctor = web.window.getProperty<JSAny?>('DeviceOrientationEvent'.toJS);
    return ctor != null && !ctor.isUndefinedOrNull;
  }

  @override
  Future<CompassAvailability> availability() async {
    if (!_hasOrientationApi) {
      return const CompassAvailability.unavailable(
        CompassUnavailableReason.noSensor,
      );
    }
    if (_needsPermissionCall && !_permissionGranted) {
      return const CompassAvailability.unavailable(
        CompassUnavailableReason.permissionRequired,
      );
    }
    return const CompassAvailability.available();
  }

  bool _permissionGranted = false;

  @override
  Future<CompassAvailability> requestPermission() async {
    if (!_needsPermissionCall) return availability();
    try {
      final ctor = web.window.getProperty<JSObject>(
        'DeviceOrientationEvent'.toJS,
      );
      final result = await ctor
          .callMethod<JSPromise<JSString>>('requestPermission'.toJS)
          .toDart;
      _permissionGranted = result.toDart == 'granted';
      return _permissionGranted
          ? const CompassAvailability.available()
          : const CompassAvailability.unavailable(
              CompassUnavailableReason.permissionDenied,
            );
    } catch (_) {
      return const CompassAvailability.unavailable(
        CompassUnavailableReason.permissionDenied,
      );
    }
  }

  @override
  Future<void> configure(GeoPoint? location) async {}

  @override
  Stream<CompassReading> get readings {
    final existing = _controller;
    if (existing != null) return existing.stream;
    final controller = StreamController<CompassReading>.broadcast(
      onListen: _start,
      onCancel: _stop,
    );
    _controller = controller;
    return controller.stream;
  }

  void _start() {
    _gotAbsolute = false;
    _smoother.reset();
    _absoluteListener = ((web.Event e) => _onEvent(
      e,
      absoluteChannel: true,
    )).toJS;
    _relativeListener = ((web.Event e) => _onEvent(
      e,
      absoluteChannel: false,
    )).toJS;
    web.window.addEventListener(
      'deviceorientationabsolute',
      _absoluteListener,
    );
    web.window.addEventListener('deviceorientation', _relativeListener);
    _firstReadingTimer = Timer(_firstReadingTimeout, () {
      if (_smoother.hasReading) return;
      _controller?.addError(
        const CompassUnavailableException(CompassUnavailableReason.noReadings),
      );
    });
  }

  void _stop() {
    _firstReadingTimer?.cancel();
    _firstReadingTimer = null;
    if (_absoluteListener != null) {
      web.window.removeEventListener(
        'deviceorientationabsolute',
        _absoluteListener,
      );
    }
    if (_relativeListener != null) {
      web.window.removeEventListener('deviceorientation', _relativeListener);
    }
    _absoluteListener = null;
    _relativeListener = null;
    _controller = null;
  }

  void _onEvent(web.Event event, {required bool absoluteChannel}) {
    final controller = _controller;
    if (controller == null || controller.isClosed) return;
    final js = event as JSObject;

    final alpha = _num(js, 'alpha');
    final beta = _num(js, 'beta') ?? 0;
    final gamma = _num(js, 'gamma') ?? 0;
    final webkitHeading = _num(js, 'webkitCompassHeading');
    final webkitAccuracy = _num(js, 'webkitCompassAccuracy');
    final absolute = _bool(js, 'absolute') ?? absoluteChannel;

    double magnetic;
    String label;
    if (webkitHeading != null && webkitHeading >= 0) {
      magnetic = webkitHeading;
      label = 'web:webkitCompassHeading';
    } else if (alpha != null) {
      // Once absolute events flow, ignore the relative channel entirely so
      // the two cannot fight over the needle.
      if (absoluteChannel) _gotAbsolute = true;
      if (!absoluteChannel && _gotAbsolute) return;
      if (!absolute) return;
      magnetic = _headingFromEuler(alpha: alpha, beta: beta, gamma: gamma);
      magnetic = Angles.normalize(magnetic + _screenAngle());
      label = absoluteChannel
          ? 'web:deviceorientationabsolute'
          : 'web:deviceorientation';
    } else {
      return;
    }

    final smoothed = _smoother.add(magnetic);
    final tilt = beta.abs() > 90 ? 180 - beta.abs() : beta.abs();
    final issues = <CompassIssue>[
      if (tilt > _tiltIssueDegrees && webkitHeading == null)
        CompassIssue.deviceNotFlat,
    ];

    controller.add(
      CompassReading(
        magneticHeading: smoothed,
        accuracyDegrees: webkitAccuracy != null && webkitAccuracy >= 0
            ? webkitAccuracy
            : null,
        confidence: _confidence(webkitAccuracy),
        issues: issues,
        pitchDegrees: beta,
        rollDegrees: gamma,
        timestamp: DateTime.now(),
        sourceKind: kind,
        sourceLabel: label,
      ),
    );
  }

  /// Past this much front-back tilt the phone is being held up rather than
  /// laid flat, and the heading is read off a different device axis.
  static const _uprightPitchDegrees = 55.0;

  /// Heading of the direction the user faces, from the W3C ZXY Euler angles.
  ///
  /// The spec's rotation matrix maps device axes into the Earth frame
  /// (X east, Y north, Z up). Flat, the top edge of the phone (device +Y) is
  /// what points somewhere; upright, it is the back of the phone (device -Z),
  /// which is the W3C worked example. Picking the axis by pitch keeps the
  /// heading valid in both grips, the same policy the native plugin uses.
  static double _headingFromEuler({
    required double alpha,
    required double beta,
    required double gamma,
  }) {
    final a = Angles.toRadians(alpha);
    final b = Angles.toRadians(beta);
    final g = Angles.toRadians(gamma);
    final cA = math.cos(a), sA = math.sin(a);
    final cB = math.cos(b), sB = math.sin(b);
    final cG = math.cos(g), sG = math.sin(g);

    final double east;
    final double north;
    if (beta.abs() < _uprightPitchDegrees) {
      // Device +Y axis in the Earth frame: (-cB*sA, cA*cB, sB).
      east = -cB * sA;
      north = cA * cB;
    } else {
      // Device -Z axis in the Earth frame.
      east = -(cA * sG + cG * sA * sB);
      north = -(sA * sG - cA * cG * sB);
    }

    var heading = math.atan2(east, north);
    if (heading < 0) heading += 2 * math.pi;
    return Angles.toDegrees(heading);
  }

  static double _screenAngle() {
    try {
      return web.window.screen.orientation.angle.toDouble();
    } catch (_) {
      return 0;
    }
  }

  static int _confidence(double? webkitAccuracy) {
    if (webkitAccuracy == null || webkitAccuracy < 0) return 45;
    final clamped = webkitAccuracy.clamp(5, 45);
    return (100 - ((clamped - 5) / 40) * 100).round();
  }

  static double? _num(JSObject o, String name) {
    final v = o.getProperty<JSAny?>(name.toJS);
    if (v == null || v.isUndefinedOrNull) return null;
    final d = (v as JSNumber).toDartDouble;
    return d.isNaN ? null : d;
  }

  static bool? _bool(JSObject o, String name) {
    final v = o.getProperty<JSAny?>(name.toJS);
    if (v == null || v.isUndefinedOrNull) return null;
    return (v as JSBoolean).toDart;
  }
}

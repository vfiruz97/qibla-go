import 'dart:async';

import 'package:flutter/foundation.dart';

import 'compass_pipeline.dart';
import 'messages.g.dart';
import 'models/compass_capabilities.dart';
import 'models/compass_config.dart';
import 'models/compass_event.dart';

/// The compass.
///
/// ```dart
/// await CompassMax.configure(
///   location: CompassLocation(latitude: 40.4, longitude: 49.8),
/// );
///
/// CompassMax.events.listen((CompassEvent event) {
///   dial.rotateTo(event.heading);
///   strip.show(event.topCondition);
/// });
/// ```
class CompassMax {
  const CompassMax._();

  static final CompassMaxHostApi _hostApi = CompassMaxHostApi();

  static CompassPipeline _pipeline = CompassPipeline();
  static Stream<CompassEvent>? _events;
  static double? _speedMetersPerSecond;
  static bool _hasLocation = false;
  static bool _hasWarnedAboutLocation = false;

  /// Interpreted readings, one per platform sample.
  ///
  /// Broadcast: several widgets can listen, and the sensors only run while at
  /// least one of them does.
  static Stream<CompassEvent> get events {
    _warnIfLocationMissing();

    return _events ??= streamReadings().map(
      (RawCompassReading reading) {
        return _pipeline.process(
          reading,
          speedMetersPerSecond: _speedMetersPerSecond,
        );
      },
    ).asBroadcastStream(
      onCancel: (StreamSubscription<CompassEvent> subscription) {
        subscription.cancel();
        _events = null;
        _pipeline.reset();
      },
    );
  }

  /// Sets the tuning that applies to every later reading.
  ///
  /// [location] unlocks true north and the expected field strength used to
  /// detect interference. Without it headings stay magnetic and can be off by
  /// up to about 20 degrees. Call it again when the user moves a meaningful
  /// distance; it is cheap.
  static Future<void> configure({
    CompassLocation? location,
    CompassSmoothing smoothing = CompassSmoothing.medium,
    CompassThresholds thresholds = const CompassThresholds(),
  }) async {
    _pipeline = CompassPipeline(
      smoothing: smoothing,
      thresholds: thresholds,
    );
    _hasLocation = location != null;

    await _hostApi.setLocation(location?.toRaw());
  }

  /// Feeds the movement check.
  ///
  /// The plugin deliberately does not ask for location itself, so pass the
  /// speed you already have from your location provider. Null disables the
  /// check, which only means [CompassCondition.movingFast] is never reported.
  static void updateSpeed(double? metersPerSecond) {
    _speedMetersPerSecond = metersPerSecond;
  }

  /// What this device can actually do. Check before subscribing.
  static Future<CompassCapabilities> capabilities() async {
    final RawCompassCapabilities raw = await _hostApi.capabilities();

    return CompassCapabilities.fromRaw(raw);
  }

  /// One reading, for a screen that shows a direction without animating it.
  static Future<CompassEvent> current() {
    return events.first;
  }

  /// Forgetting the location is a wiring mistake rather than a runtime state,
  /// so it is reported where wiring mistakes belong: the debug console.
  static void _warnIfLocationMissing() {
    if (_hasLocation || _hasWarnedAboutLocation || kReleaseMode) {
      return;
    }

    _hasWarnedAboutLocation = true;

    debugPrint(
      'compass_max: no location configured, so headings are magnetic and may '
      'be off by up to 20°. Call CompassMax.configure(location: ...) to get '
      'true north.',
    );
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/compass/compass_reading.dart';
import '../../../core/compass/compass_source.dart';
import '../../../core/compass/compass_source_factory.dart';
import '../../../core/compass/simulated_compass_source.dart';
import '../../../core/geo/geo_point.dart';
import '../domain/qibla_state.dart';
import 'location_controller.dart';

/// Debug-only switch that swaps the platform compass for a hand-driven one.
/// Always false in release builds; the UI never shows the toggle there.
final simulateCompassProvider = NotifierProvider<SimulateCompassToggle, bool>(
  SimulateCompassToggle.new,
);

final class SimulateCompassToggle extends Notifier<bool> {
  static const _fromEnvironment = bool.fromEnvironment(
    'QIBLA_SIMULATE_COMPASS',
  );

  @override
  bool build() => !kReleaseMode && _fromEnvironment;

  void set(bool value) => state = value && !kReleaseMode;
}

final compassSourceProvider = Provider<CompassSource>((ref) {
  if (ref.watch(simulateCompassProvider)) {
    final source = SimulatedCompassSource(initialHeading: 20);
    ref.onDispose(source.dispose);
    return source;
  }
  return createPlatformCompassSource();
});

final compassControllerProvider =
    NotifierProvider<CompassController, CompassState>(CompassController.new);

/// Owns the sensor subscription.
///
/// Subscribes once availability is known, hands the source the user's
/// position whenever it changes, flags a stream that goes quiet, and
/// releases the sensors while the app is in the background.
final class CompassController extends Notifier<CompassState> {
  static const staleAfter = Duration(seconds: 3);

  StreamSubscription<CompassReading>? _subscription;
  Timer? _staleTimer;
  late CompassSource _source;

  @override
  CompassState build() {
    _source = ref.watch(compassSourceProvider);
    ref.listen<GeoPoint?>(
      locationPointProvider,
      (_, point) => unawaited(_source.configure(point)),
      fireImmediately: true,
    );
    ref.onDispose(_teardown);
    Future<void>.microtask(_start);
    return const CompassState();
  }

  Future<void> _start() async {
    final availability = await _source.availability();
    if (!ref.mounted) return;
    state = state.copyWith(availability: availability, clearError: true);
    if (availability.isAvailable && !state.isPaused) _subscribe();
  }

  /// Web on iOS needs this from a tap. Harmless elsewhere.
  Future<void> requestPermission() async {
    final availability = await _source.requestPermission();
    if (!ref.mounted) return;
    state = state.copyWith(availability: availability, clearError: true);
    if (availability.isAvailable) _subscribe();
  }

  Future<void> retry() => _start();

  /// Called from the app lifecycle: false releases the sensors.
  void setActive(bool active) {
    if (active == !state.isPaused) return;
    if (active) {
      state = state.copyWith(isPaused: false, clearReading: true);
      if (state.availability?.isAvailable ?? false) _subscribe();
    } else {
      _cancel();
      state = state.copyWith(isPaused: true, clearReading: true);
    }
  }

  void _subscribe() {
    _cancel();
    _subscription = _source.readings.listen(
      (reading) {
        state = state.copyWith(reading: reading, isStale: false);
        _armStaleTimer();
      },
      onError: (Object error, StackTrace stack) {
        final reason = error is CompassUnavailableException
            ? error.reason
            : CompassUnavailableReason.noReadings;
        state = state.copyWith(
          availability: CompassAvailability.unavailable(reason),
          error: error,
          clearReading: true,
        );
        _cancel();
      },
    );
    _armStaleTimer();
  }

  void _armStaleTimer() {
    _staleTimer?.cancel();
    _staleTimer = Timer(staleAfter, () {
      if (ref.mounted && state.reading != null) {
        state = state.copyWith(isStale: true);
      }
    });
  }

  void _cancel() {
    _staleTimer?.cancel();
    _staleTimer = null;
    unawaited(_subscription?.cancel());
    _subscription = null;
  }

  void _teardown() {
    _cancel();
  }
}

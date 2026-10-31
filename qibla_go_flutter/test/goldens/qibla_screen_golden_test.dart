// Visual regression for the four states of the qibla screen.
//
// Goldens are rendered with the bundled fonts on macOS; on other hosts the
// anti-aliasing differs, so the comparison is skipped there. Regenerate with
// `flutter test --update-goldens test/goldens` and look at the PNGs before
// committing them.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_go_flutter/app/theme/app_theme.dart';
import 'package:qibla_go_flutter/core/compass/compass_reading.dart';
import 'package:qibla_go_flutter/core/compass/simulated_compass_source.dart';
import 'package:qibla_go_flutter/core/geo/geo_point.dart';
import 'package:qibla_go_flutter/core/geo/qibla_geometry.dart';
import 'package:qibla_go_flutter/core/location/location_models.dart';
import 'package:qibla_go_flutter/core/location/location_service.dart';
import 'package:qibla_go_flutter/core/storage/app_preferences.dart';
import 'package:qibla_go_flutter/features/qibla/application/compass_controller.dart';
import 'package:qibla_go_flutter/features/qibla/application/location_controller.dart';
import 'package:qibla_go_flutter/features/qibla/application/qibla_providers.dart';
import 'package:qibla_go_flutter/features/map/application/sky_providers.dart';
import 'package:qibla_go_flutter/features/map/presentation/map_screen.dart';
import 'package:qibla_go_flutter/features/map/presentation/widgets/map_tiles.dart';
import 'package:qibla_go_flutter/features/qibla/presentation/qibla_screen.dart';
import 'package:qibla_go_flutter/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fake_location_service.dart';

final _dushanbe = GeoPoint(latitude: 38.5598, longitude: 68.787);

Future<void> _loadFonts() async {
  Future<void> load(String family, String file) async {
    final bytes = File('assets/fonts/$file').readAsBytesSync();
    final loader = FontLoader(family)
      ..addFont(Future.value(ByteData.view(bytes.buffer)));
    await loader.load();
  }

  await load(AppFonts.display, 'Marcellus-Regular.ttf');
  await load(AppFonts.body, 'Manrope-Variable.ttf');

  // Material icons otherwise render as boxes in goldens.
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  final icons = File(
    '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
  if (flutterRoot != null && icons.existsSync()) {
    final bytes = icons.readAsBytesSync();
    final loader = FontLoader('MaterialIcons')
      ..addFont(Future.value(ByteData.view(bytes.buffer)));
    await loader.load();
  }
}

/// A spring evening in Dushanbe with the sun low in the west.
final _frozenNow = DateTime.utc(2026, 3, 20, 12, 30);

Widget _app({
  required SharedPreferences prefs,
  required LocationService location,
  SimulatedCompassSource? compass,
  Widget home = const QiblaScreen(),
}) => ProviderScope(
  overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
    locationServiceProvider.overrideWithValue(location),
    if (compass != null) compassSourceProvider.overrideWithValue(compass),
    // Pin the sky so the golden does not drift with the real clock:
    // a spring evening in Dushanbe with the sun low in the west.
    minuteClockProvider.overrideWith(
      (ref) => Stream.value(_frozenNow),
    ),
    // Pin the declination date too: the dial rotates by the true heading,
    // which drifts a few thousandths of a degree per week with the magnetic
    // model, enough to move anti-aliased pixels and fail the golden.
    qiblaGeometryProvider.overrideWith((ref) {
      final point = ref.watch(locationPointProvider);
      return point == null ? null : QiblaGeometry.compute(point, _frozenNow);
    }),
  ],
  child: MaterialApp(
    theme: AppTheme.dark(),
    darkTheme: AppTheme.dark(),
    themeMode: ThemeMode.dark,
    debugShowCheckedModeBanner: false,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  ),
);

Future<void> _settle(WidgetTester tester) async {
  // Let the location microtask, the first simulated sample (200 ms) and the
  // dial animation run.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
  for (var i = 0; i < 30; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  final skip = !Platform.isMacOS;

  setUpAll(() async {
    tileCachingEnabled = false;
    await _loadFonts();
  });

  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> run(
    WidgetTester tester, {
    required String name,
    required LocationService location,
    SimulatedCompassSource? compass,
    Size size = const Size(390, 844),
    Widget home = const QiblaScreen(),
  }) async {
    await tester.binding.setSurfaceSize(size);
    tester.view.devicePixelRatio = 2;
    addTearDown(() => tester.binding.setSurfaceSize(null));
    addTearDown(tester.view.resetDevicePixelRatio);
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      _app(prefs: prefs, location: location, compass: compass, home: home),
    );
    await _settle(tester);
    await expectLater(
      find.byType(home.runtimeType),
      matchesGoldenFile('images/$name.png'),
    );
    // Unmount so timers and tickers are disposed before the test ends.
    await tester.pumpWidget(const SizedBox.shrink());
    compass?.dispose();
  }

  final fix = LocationFix(
    point: _dushanbe,
    time: DateTime.now(),
    origin: LocationOrigin.device,
    accuracyMeters: 35,
  );
  final geometry = QiblaGeometry.compute(_dushanbe, _frozenNow);

  testWidgets('needs location', (tester) async {
    await run(
      tester,
      name: 'needs_location',
      location: FakeLocationService(
        permission: LocationPermissionState.denied,
      ),
      compass: SimulatedCompassSource(initialHeading: 10),
    );
  }, skip: skip);

  testWidgets('turning towards the qibla', (tester) async {
    await run(
      tester,
      name: 'turning',
      location: FakeLocationService(fix: fix),
      compass: SimulatedCompassSource(
        initialHeading: geometry.bearingFromMagneticNorth - 23,
      ),
    );
  }, skip: skip);

  testWidgets('aligned', (tester) async {
    await run(
      tester,
      name: 'aligned',
      location: FakeLocationService(fix: fix),
      compass: SimulatedCompassSource(
        initialHeading: geometry.bearingFromMagneticNorth + 1,
      ),
    );
  }, skip: skip);

  testWidgets('blocked by interference', (tester) async {
    await run(
      tester,
      name: 'blocked',
      location: FakeLocationService(fix: fix),
      compass: SimulatedCompassSource(initialHeading: 100)
        ..issues = const [CompassIssue.magneticInterference],
    );
  }, skip: skip);

  testWidgets('wide layout', (tester) async {
    await run(
      tester,
      name: 'wide',
      location: FakeLocationService(fix: fix),
      compass: SimulatedCompassSource(
        initialHeading: geometry.bearingFromMagneticNorth + 40,
      ),
      size: const Size(1100, 720),
    );
  }, skip: skip);

  testWidgets('map screen (tiles do not load offline)', (tester) async {
    await run(
      tester,
      name: 'map',
      location: FakeLocationService(fix: fix),
      compass: SimulatedCompassSource(initialHeading: 10),
      home: const MapScreen(),
    );
  }, skip: skip);
}

# Qibla Go — Flutter app rules

The frontend. Android and web today, iOS next. Read the root `AGENTS.md`
first; this file adds the rules for code under `qibla_go_flutter/`.

## Structure

```
lib/
├── main.dart                 bootstrap only (prefs, ProviderScope, runApp)
├── driver.dart               dev entry used by `serverpod start` (do not change behaviour)
├── app/                      QiblaGoApp, GoRouter table, theme
│   └── theme/                AppTheme (ThemeData) + QiblaPalette (ThemeExtension)
├── core/                     reusable, feature-agnostic, mostly pure Dart
│   ├── geo/                  GeoPoint, Angles/HeadingSmoother/UnwrappedAngle, QiblaGeometry, greatCirclePath
│   ├── astro/                SkyCalculator: sun/moon azimuth, altitude, moon phase
│   ├── platform/             isDesktopBrowser (conditional import)
│   ├── compass/              CompassSource seam + native/web/simulated implementations
│   ├── location/             LocationService seam + models
│   ├── storage/              AppPreferences (typed SharedPreferences)
│   └── serverpod/            serverpodClientProvider (lazy)
├── features/<feature>/
│   ├── domain/               immutable state classes and pure decision functions
│   ├── application/          Riverpod Notifiers/providers (side effects live here)
│   └── presentation/         screen + widgets/ (no business logic)
│   qibla/                    compass screen; map/ map screen with sky overlay; intro/ launch animation + desktop card (map opens beneath it)
└── l10n/                     app_<locale>.arb; app_localizations*.dart are generated
test/                         mirrors lib/ (test/core/geo, test/features/qibla, ...)
```

Add a feature as `features/<name>/{domain,application,presentation}`.
Anything two features share moves to `core/`. Do not create `utils/` or
`helpers/` dumping grounds.

## State and data flow

- Riverpod 3. Use `Notifier`/`AsyncNotifier` with `NotifierProvider`; derive
  read-only values with `Provider`. No `StateProvider`, no `ChangeNotifier`,
  no global singletons besides providers.
- Widgets never import plugins (`geolocator`, `compass_max`, `web`). They
  read providers; providers talk to seams (`LocationService`,
  `CompassSource`); seams wrap plugins. Tests swap seams via
  `ProviderScope(overrides: ...)`.
- Side effects (sensor subscriptions, permission prompts, persistence) only
  in `application/`. `domain/` is pure and synchronous.
- Nothing heavy on the sensor path: a reading arrives ~30×/s. Geometry is
  computed once per location change (`qiblaGeometryProvider`); per-reading
  work is a few trig operations in `QiblaSnapshot.from`.
- Sensors run only while listened to; release them when the app is paused
  (`CompassController.setActive`).

## Accuracy rules (non-negotiable)

1. Never draw the qibla ray without a location. Never draw a heading
   without a reading.
2. True heading = platform **magnetic** heading + WMM2025 declination
   computed on the device (`QiblaGeometry.trueHeadingFrom`). Do not switch
   to platform true north; keep it in diagnostics only.
3. Respect `NeedleTrust`: `blocked` hides the direction (interference,
   vehicle), `degraded` shows it with a warning. Never upgrade trust in the
   UI layer.
4. `SimulatedCompassSource` must stay impossible in release builds
   (asserts on `kReleaseMode`; toggle only rendered under `kDebugMode`).
5. Any change in `core/geo`, `core/compass`, or `features/qibla/domain`
   needs unit tests and a green `flutter test`. Bearing tests pin published
   values; declination tests pin NOAA WMM2025 test points. Do not loosen
   tolerances to make a test pass; find the bug.
6. `qibla_math` is pinned exactly in `pubspec.yaml`. Bump only after running
   its own test suite and ours, and note the diff of its Kaaba coordinates
   and WMM epoch.
7. `packages/compass_max` is vendored. Keep native code "facts only"; every
   judgement stays in Dart and tested. Record every local change in its
   `NOTICE.md`.
8. Angles: always go through `Angles.normalize/delta`. Never subtract two
   headings raw; never animate a wrapped angle (use `UnwrappedAngle`).

## UI rules

- Visual language: "kiswa night" (black cloth, gold thread) with an ivory
  day variant. All colours come from `QiblaPalette.of(context)`; never
  hard-code hex in widgets (the single exception is the Kaaba cloth colour
  inside the dial painter).
- Typography: `Marcellus` for the wordmark and large numerals, `Manrope`
  for everything else, via the `TextTheme` in `AppTheme`. Fonts are bundled
  assets; do not add `google_fonts` or any runtime font download.
- Every user-visible string lives in `lib/l10n/app_en.arb` and is read via
  `AppLocalizations.of(context)`. Run `flutter gen-l10n` (or any build) after
  editing ARB files. New locales: add `app_<code>.arb`, nothing else.
- Numbers use tabular figures and are rounded for display only; keep full
  precision in state.
- Custom painting goes in `CustomPainter`s with a correct `shouldRepaint`.
  Static decorations (backdrop) sit in a `RepaintBoundary`.
- Layout must work from 320 px wide phones to desktop web; `QiblaScreen`
  switches to a two-column layout at 760 px.
- Haptics only for meaningful moments (facing the qibla). No sounds.
- Material widgets under a `Scaffold`; bottom sheets for secondary flows
  (location, details). No dialogs for routine states.

## Map rules

- Tiles come from `qiblaTileLayer()` only (`features/map/presentation/widgets/map_tiles.dart`), URL overridable with `--dart-define=QIBLA_TILE_URL`, optional on-device darkening with `QIBLA_TILE_INVERT` (default false: light tiles show buildings, which is the whole point of the map). Only free providers, never one that needs an API key by default. The map opens at street level (zoom 17) centred on the user and has explicit zoom buttons. Keep the attribution string in the ARB in sync with the provider.
- The qibla line is always `greatCirclePath(user, kaaba)`; never a straight segment in map coordinates.
- Sun and moon are decoration plus a sentence; they never feed the bearing. Hide the moon in daylight (`SkySnapshot.showMoon`).
- Anything inside `FlutterMap(children:)` that needs screen positions reads `MapCamera.of(context)`; nothing else may project coordinates by hand.
- The intro overlay plays once per launch and is skipped under reduced motion; pass `QiblaGoApp(playIntro: false)` in tests.
- **Nothing on the map jumps.** Camera moves go through `MapCameraAnimator` (`flyTo`, `zoomBy`, `flyToFit`); never call `MapController.move`/`fitCamera` directly from the screen. A location change animates the marker and the line from the old point to the new one (`GeoPoint.lerp` over 650 ms); a long-press keeps the camera where the user pressed, every other source flies the camera along. Keep `TileLayer` and `WorldInset`'s map alive across rebuilds: recreating them reloads tiles and flashes.
- A map long-press shows no message: the moving marker is the confirmation. The way back to the real position is the location button.

## Platform notes

- Web: platform-specific code uses the conditional import pattern
  (`x_stub.dart` + `x_web.dart` chosen with `if (dart.library.js_interop)`).
  Use `package:web` + `dart:js_interop`; never `dart:html`.
- Android permissions and features are declared in
  `android/app/src/main/AndroidManifest.xml`; iOS usage strings in
  `ios/Runner/Info.plist`. Keep the wording honest about what is used.
- `applicationId` / bundle id are still the template defaults; change them
  once (before the first store build) and never again.

## Testing

- Unit tests for every pure function and state class.
- Controller tests with fake seams (`LocationService`, `CompassSource`).
- Widget tests for the dial states (no location, blocked, aligned) with
  the simulated source.
- Before release: the device verification protocol in `docs/PLAN.md`.

## Commands

```
flutter pub get            # from the workspace root is fine
dart analyze && dart format lib test
flutter test
flutter gen-l10n
flutter run -d chrome --dart-define=QIBLA_SIMULATE_COMPASS=true
```

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
│   ├── compass/              CompassSource seam + native/web/simulated implementations
│   ├── location/             LocationService seam + models
│   ├── storage/              AppPreferences (typed SharedPreferences)
│   ├── analytics/            Analytics (queue + batches), sinks, navigator + lifecycle observers
│   └── serverpod/            serverpodClientProvider (lazy)
├── features/<feature>/
│   ├── domain/               immutable state classes and pure decision functions
│   ├── application/          Riverpod Notifiers/providers (side effects live here)
│   └── presentation/         screen + widgets/ (no business logic)
│   qibla/                    compass screen; map/ map screen with sky overlay; intro/ launch animation + desktop card (map opens beneath it)
│   rating/                   store rating ask: policy (domain), counters + store seam (application), sheet
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
  editing ARB files and commit the generated `app_localizations*.dart`.
- Seventeen languages ship (en de fr it sv id ru tg uz az tr fa ar ur zh ja
  ko). A
  new key goes into `app_en.arb` with a `description` when its meaning is
  not obvious from the English, and into every other `app_<code>.arb` in
  the same change; `test/l10n/arb_consistency_test.dart` fails on a missing
  key, a changed placeholder, a plural without `other`, or a translation
  that is still the English text. Plurals use each language's CLDR
  categories (`one/few/many/other` for Russian, six forms for Arabic,
  `other` only for Tajik, Turkish, Uzbek, Azerbaijani, Persian, Indonesian
  and East Asian languages). The brand "Qibla Go" stays in Latin letters everywhere.
- Language resolution is `resolveLocale` in `lib/l10n/locale_resolution.dart`
  (the user's list in their order, exact then country then language, English
  when nothing matches). The generator sorts `supportedLocales`
  alphabetically, so Flutter's default fallback would be Arabic; never drop
  the callback. Tajik has no Material strings in Flutter; the ones a user can
  meet are in `tajik_material_localizations.dart`.
- Never compose a sentence from fragments in Dart; the word order differs
  between languages. Add a key with placeholders instead (`skyMarkerLabel`).
- Right-to-left: use `AlignmentDirectional`, `EdgeInsetsDirectional`,
  `TextAlign.start/end` and `Directionality.of(context)` for layout. The
  compass and the sun/moon sentences describe the physical left and right
  of the person; those must never be mirrored.
- Script-aware type lives in `ScriptTypography` (`app/theme`): headlines
  use Manrope outside Latin script (Marcellus has Latin glyphs only), Arabic
  script gets no letter-spacing, Arabic and East Asian text get more line
  height. `ScriptTheme` in `MaterialApp.builder` applies it below
  `Localizations`. Use `ScriptTypography.of(context).tracking(x)` for any
  letter-spacing set directly in a widget.
- Parse numbers typed by the user through `toAsciiDigits` (`core/text`) so
  Persian, Arabic and fullwidth digits are accepted.
- Numbers use tabular figures and are rounded for display only; keep full
  precision in state.
- Custom painting goes in `CustomPainter`s with a correct `shouldRepaint`.
  Static decorations (backdrop) sit in a `RepaintBoundary`.
- Layout must work from 320 px wide phones to desktop web; `QiblaScreen`
  switches to a two-column layout at 760 px.
- Haptics only for meaningful moments (facing the qibla). No sounds.
- Material widgets under a `Scaffold`; bottom sheets for secondary flows
  (location, details). No dialogs for routine states.

## Usage statistics rules

- `Analytics` (`core/analytics`) is the only way to record an event:
  `ref.read(analyticsProvider).track(AnalyticsEventName.x, ...)`. The
  default provider is `Analytics.disabled()`; only `main` installs a live
  one, so tests and tools send nothing unless they override it with a
  `RecordingAnalyticsSink` (`test/support`).
- An event is a name from `AnalyticsEventName` plus at most `screen`,
  `fromScreen`, `durationMs` and `outcome`, all short tokens. Never a
  coordinate, a heading, typed text, a contact, or any id that outlives the
  process. Adding a name means: the enum, the server's
  `AnalyticsGuard.allowedNames`, `README.md` "Usage statistics", and the
  store privacy declarations, in one PR.
- Screens and sheets are counted by `AnalyticsNavigatorObserver` from
  route names: GoRoute `name:` for screens, `routeSettings:
  RouteSettings(name:)` in a sheet's `show`. An unnamed route is not
  counted; name every new screen and sheet.
- `app_launch` is tracked once from `QiblaGoApp` after the first content
  frame, timed from `appLaunchStopwatch` (started first thing in `main`).
  `AnalyticsLifecycleObserver` adds `app_background` with the foreground
  time, flushes on the way out, and `app_resume`.
- Sending is best effort and off the frame: batches after 10 s of quiet,
  at 20 queued, or on background; a failed batch is retried on the next
  flush up to three times, then dropped; nothing is written to disk. The
  Serverpod sink sits behind a deferred import (`LazyAnalyticsSink`) so the
  client library stays out of the initial web bundle; keep it that way.
- `--dart-define=QIBLA_ANALYTICS=false` compiles the feature to no-ops.

## Rating prompt rules

- The ask is one bottom sheet (`RatingSheet`), shown from `QiblaScreen`
  only, when `RatingController.onAlignmentChanged` says so: the needle was
  on the qibla for `RatingPolicy.minAlignmentHold` and has just left it,
  and the install has ≥ 3 launches, ≥ 2 days of age and ≥ 3 sessions with
  the qibla found. Never at launch, never on the first launch, never on
  top of another route, never while the app is not resumed. The numbers
  live in `RatingPolicy` and are reasoned in `docs/DECISIONS.md`; change
  them there and in `README.md` together.
- Every answer is final: "Rate", "Not now", swipe and tap-outside all end
  the asking for good. `markPrompted` is saved before the sheet opens so a
  crash cannot cause a loop; an unanswered sheet is retried once after 30
  days, then never. Do not add a "remind me later" without a decision-log
  entry.
- `ReviewLauncher` is the seam over `in_app_review`; widgets and the
  controller never import the plugin. `accept()` saves the decision
  first, then tries the system review card, then the store listing, and
  reports `RatingOutcome.failed` only when both fail (the user sees one
  snackbar). The store card is quota-limited and silent about the result;
  the permanent link in Details uses `openStoreListing()` only.
- Nothing about rating leaves the device: counters and the decision are
  one JSON string in `AppPreferences` (`qibla.v1.rating`), parsed
  leniently so a corrupt record resets to "not yet" and never to "ask now".
- The iOS listing needs `--dart-define=QIBLA_APP_STORE_ID=<numeric id>`;
  without it the fallback on iOS fails quietly (Android needs nothing).
- Debug builds have "Preview the rating prompt" in Details; it resets the
  counters and opens the sheet. The real Play card cannot be seen from a
  debug install: it needs a build from an internal test track.

## Map rules

- Tiles come from `qiblaTileLayer()` only (`features/map/presentation/widgets/map_tiles.dart`), URL overridable with `--dart-define=QIBLA_TILE_URL`, optional on-device darkening with `QIBLA_TILE_INVERT` (default false: light tiles show buildings, which is the whole point of the map). Only free providers, never one that needs an API key by default. The map opens at street level (zoom 17) centred on the user and has explicit zoom buttons. Keep the attribution string in the ARB in sync with the provider.
- The qibla line is always `greatCirclePath(user, kaaba)`; never a straight segment in map coordinates.
- Sun and moon are decoration plus a sentence; they never feed the bearing. Hide the moon in daylight (`SkySnapshot.showMoon`).
- Anything inside `FlutterMap(children:)` that needs screen positions reads `MapCamera.of(context)`; nothing else may project coordinates by hand.
- The intro overlay plays once per launch and is skipped under reduced motion; pass `QiblaGoApp(playIntro: false)` in tests.
- **Web has no compass screen, and no compass code.** On the web the map is
  the one page at `/` (`/map` redirects there); the compass route comes from
  `app/compass_routes.dart`, which the web build swaps for
  `compass_routes_web.dart` by conditional import, so the dial, sensors and
  `compass_controller` are not compiled into the bundle. Keep it that way:
  the map feature imports `qibla_geometry_provider.dart` and
  `location_controller.dart`, never `qibla_providers.dart` or anything under
  `core/compass`. After `flutter build web`, run `tool/check_web_bundle.sh`;
  it fails if compass code reached `main.dart.js`. Phones keep both screens.
  The browser compass source stays in `core/compass` in case a phone-browser
  mode is ever wanted; do not wire it to a screen without a decision-log
  entry.
- **Lazy features.** "Write to us" (and with it the Serverpod client) is a
  deferred import (`deferred as support` + `loadLibrary()`), so it ships as
  a separate part file loaded on first tap; the analytics sink loads the
  same way on the first batch. Do the same for any future
  feature the first screen does not need; never import `qibla_go_client`
  or `core/serverpod` from a screen directly.
- **Nothing on the map jumps.** Camera moves go through `MapCameraAnimator` (`flyTo`, `zoomBy`, `flyToFit`); never call `MapController.move`/`fitCamera` directly from the screen. A location change animates the marker and the line from the old point to the new one (`GeoPoint.lerp` over 650 ms); a long-press keeps the camera where the user pressed, every other source flies the camera along. Keep `TileLayer` and `WorldInset`'s map alive across rebuilds: recreating them reloads tiles and flashes.
- A map long-press shows no message: the moving marker is the confirmation. The way back to the real position is the location button.

## Platform notes

- Web: platform-specific code uses the conditional import pattern
  (`x_stub.dart` + `x_web.dart` chosen with `if (dart.library.js_interop)`).
  Use `package:web` + `dart:js_interop`; never `dart:html`.
- `web/index.html` is the page search engines read: title, description,
  Open Graph, JSON-LD and a plain-text summary shown until Flutter's first
  frame. It is the one place with user-visible copy outside the ARB; keep
  it honest and in step with `README.md`. `__QIBLA_ORIGIN__` is filled by
  the server from its public address; `{{flutter_js}}` and
  `{{flutter_build_config}}` by `flutter build`. It preloads
  `main.dart.js` and the two fonts; keep those names in sync with
  `pubspec.yaml`. After Flutter's first frame the summary stays in the
  document off screen (`sr-only`), so the rendered page still has text.
- The `Roboto` family in `pubspec.yaml` is an alias of Manrope on purpose:
  without it the web engine downloads Roboto from Google Fonts at start-up.
  Missing glyphs (Arabic, emoji) still trigger Noto fallback downloads from
  Google; bundle those fonts when adding such languages.
- `QiblaGoApp` draws an empty first frame on the web (`_ready`): the
  browser can focus the Flutter view before the first layout, and Flutter's
  search for the first focusable widget then logs "RenderBox was not laid
  out". Keep the first web frame free of focusable widgets.
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
- `test/l10n/locales_smoke_test.dart` builds the map screen in every
  language and checks direction and type; keep it green when adding one.
- Goldens live in `test/goldens` (compass states, map, rating sheet night
  and day) and share `test/support/golden_fonts.dart`.
- Before release: the device verification protocol in `docs/PLAN.md`.

## Commands

```
flutter pub get            # from the workspace root is fine
dart analyze && dart format lib test
flutter test
flutter gen-l10n
flutter run -d chrome --dart-define=QIBLA_SIMULATE_COMPASS=true
flutter build web --release && tool/check_web_bundle.sh   # no compass in the bundle
flutter build apk --release --dart-define=SERVER_URL=https://qibla-go.api.serverpod.space/   # Android, production API
```

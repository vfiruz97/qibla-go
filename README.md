# Qibla Go

A free, ad-free Qibla compass and map for Android and the web (iOS later).
No accounts, no ads, no identifying tracking. Built for the pleasure of God.

Showing a believer the wrong direction is the one failure this project must
not have. Everything below the line in [How the direction is computed](#how-the-direction-is-computed)
is a promise to the user; keep it true.

## What the app does

- **Compass** (phone app). A dial that points to the Kaaba using the
  phone's sensors, corrected for magnetic declination on the device. When
  the sensor cannot be trusted, the direction is hidden and the reason is
  shown. The web version has no compass screen at all; it opens on the map.
- **Map.** The Qibla as a gold line from where you stand, along the great
  circle, to the Kaaba, over a street map with buildings. Find a road or a
  building the line crosses and face it. The sun and the moon are drawn
  along their true azimuths to help you orient yourself.
- **Offline.** Fonts, the magnetic model and the last known location are on
  the device. The server is optional at runtime.
- **Write to us.** A short form on the compass and the map sends a message
  to the maintainers: a wrong-looking direction, a bug, an idea. One small
  sum keeps bots out; no account, no location, no device data.
- **One ask for a rating.** After the app has been used on a few separate
  days and the qibla has been found a few times, a sheet asks once for a
  store rating and says why: the app is free, has no ads, and ratings are
  how others find it. "Not now", a swipe or a tap outside means it is never
  asked again. The answer stays on the phone. Details also has a permanent
  "Rate on Google Play / the App Store" link for those who want it.
- **Prayer times** with offline sync are planned; see `docs/PLAN.md`.

## How the direction is computed

This section is the accuracy statement. It must describe the code exactly.
Any change to the numbers, sources or rules below must update this section
in the same pull request (see `AGENTS.md`, "Accuracy change protocol").

| Item | Current behaviour | Where |
| --- | --- | --- |
| Kaaba position | 21.4225° N, 39.826166667° E | `qibla_math` 0.1.0 (pinned) |
| Qibla bearing | Initial great-circle bearing from the user's position to the Kaaba, measured from true north. The great circle is the convention used by qibla authorities; the difference to an ellipsoid solution is below 0.3°. | `core/geo/qibla_geometry.dart` |
| Magnetic declination | World Magnetic Model 2025 (NOAA/NCEI), computed on the device for the user's position and today's date. Valid 2025.0 to 2030.0; outside that range the value is extrapolated and the app says the model needs an update. | `qibla_math`, `QiblaGeometry.declinationIsExtrapolated` |
| True heading | Platform **magnetic** heading plus the declination above. The platform's own "true heading" is never used for the needle, only shown in diagnostics. | `QiblaGeometry.trueHeadingFrom` |
| Android heading source | Vendored `compass_max` (MIT). Sensor chain in order of preference: `TYPE_HEADING`, rotation vector, geomagnetic rotation vector, accelerometer plus magnetometer. Interference is detected by comparing field strength with the WMM-predicted value, debounced. | `packages/compass_max` |
| Web | No compass screen. Browsers give a rough heading at best and desktop browsers none, so the web version shows the map only (`webRedirect`). A browser heading source exists in the code but is not reachable from any screen. | `core/compass/web_compass_source_web.dart` |
| Trust policy | `trusted`: direction shown. `degraded` (uncalibrated, tilted, browser): shown with a warning. `blocked` (interference, moving vehicle): direction hidden, reason shown. No reading for 3 s: stale, hidden. | `features/qibla/domain/qibla_state.dart`, `CompassController.staleAfter` |
| Facing the Qibla | Counts as aligned within 3° and stays aligned until 6°, with one haptic pulse on entry. | `AlignmentTracker` |
| Location | Medium accuracy is enough (1 km of error is about 0.01° of bearing). The last fix is reused when the user has not moved more than 250 m and it is younger than 7 days. Manual coordinates are allowed and labelled. Within 100 m of the Kaaba the bearing is replaced by "you are here". | `core/location`, `QiblaGeometry.isFreshFor`, `isAtKaaba` |
| Map line | Always the great-circle path sampled in 256 segments, never a straight segment in map coordinates. | `core/geo/great_circle.dart` |
| Sun and moon | Meeus-derived algorithms (suncalc port), refreshed once a minute. Accuracy about 0.5° for the sun and 2° for the moon. They are an orientation aid in words only; the line and the needle never depend on them. | `core/astro/sky_position.dart` |
| Simulated compass | Exists for desk testing in debug builds only; it cannot be constructed in a release build. | `core/compass/simulated_compass_source.dart` |

### How this is verified

- `flutter test` in `qibla_go_flutter` pins the bearing for six cities to
  published values, the declination to NOAA WMM2025 test points, angle
  arithmetic, great-circle sampling, sun and moon reference values, and the
  trust state machine. Tolerances are never loosened to make a test pass.
- `flutter test` in `packages/compass_max` covers the sensor pipeline.
- Before every release, the device verification protocol in `docs/PLAN.md`
  is run outdoors on a real phone and the results are noted in the release
  pull request.

## Repository layout

```
qibla_go_flutter/      Flutter app              rules: qibla_go_flutter/AGENTS.md
qibla_go_server/       Serverpod server         rules: qibla_go_server/AGENTS.md
qibla_go_client/       generated client         never edited by hand
packages/compass_max/  vendored sensor plugin   changes logged in NOTICE.md
docs/PLAN.md           roadmap, accuracy charter, verification protocol
docs/DECISIONS.md      why things are the way they are (append only)
AGENTS.md              working rules for people and agents
```

## Running it

Requirements: Flutter 3.47 or newer, Dart 3.12 or newer, the Serverpod CLI.

```
flutter pub get                       # from the repository root
cd qibla_go_server && serverpod start # server plus the Flutter app, with hot reload
```

The web version is built into the server and served by it:

```
cd qibla_go_server && serverpod run flutter_build   # builds into web/app
cd qibla_go_flutter && tool/check_web_bundle.sh ../qibla_go_server/web/app/main.dart.js
```

Useful flags for the Flutter app:

```
--dart-define=QIBLA_SIMULATE_COMPASS=true   # desk testing, debug builds only
--dart-define=QIBLA_TILE_URL=https://.../{z}/{x}/{y}.png   # another free tile provider
--dart-define=QIBLA_TILE_INVERT=true        # darken tiles on the device
```

Checks before a pull request:

```
dart analyze && dart format .
cd qibla_go_flutter && flutter test
cd qibla_go_server && dart test
```

## Map tiles

The map uses OpenStreetMap's standard tiles, which need no API key. The
project only ever uses free providers. OpenStreetMap allows light use by a
small app but not heavy traffic, so before a public release the tile URL
should point at a free-tier provider whose terms cover the load.

## Languages

The app speaks English, German, French, Italian, Swedish, Indonesian,
Russian, Tajik, Uzbek, Azerbaijani, Turkish, Persian, Arabic, Urdu, Chinese
(Simplified), Japanese and Korean. It follows the phone's language list, or the browser's
on the web, taking the first language it has; when none matches it uses
English. Persian, Arabic and Urdu lay out right to left. Digits typed on a
Persian, Arabic, Chinese or Japanese keyboard are accepted in the
coordinate and check fields. Compass directions in the text ("turn
left", "to the right of the sun") are physical directions and are never
mirrored.

Fonts: Latin and Cyrillic text uses the bundled Marcellus and Manrope. For
the six Tajik letters, Azerbaijani ə, Arabic, Persian, Urdu, Chinese,
Japanese and Korean the phone's system fonts fill in; on the web the Flutter engine
fetches Google's Noto fallback fonts for those scripts when they are first
needed, which is the one case where the web version talks to Google Fonts.

## Usage statistics

The app counts how it is used, so the maintainers know which screens and
languages matter and whether launches are slow. What is sent, in small
batches a few seconds after it happens and again when the app goes to the
background:

- the event: `app_launch` (with the time from start to the first frame),
  `app_resume`, `app_background` (with the time spent in the foreground),
  `screen_view` and `sheet_view` (which screen or sheet, and from which),
  `support_sent` (that a message was sent and whether the server accepted
  it; never the message), `rating_prompt` and `rating_answer`;
- the moment it happened, the platform (`android`, `ios`, `web`, …), the
  app version and the language the app is shown in;
- a random session id drawn at launch and forgotten at exit, so the events
  of one launch can be grouped and two launches cannot be linked.

Never sent: any location, any text the user typed, any device or
advertising identifier, any account (there are none). The server keeps the
caller's address in memory only, for rate limiting, and never stores or
logs it. Events are deleted after 90 days. Nothing is kept on the device:
a launch that never reaches the server leaves no trace. There is no
third-party analytics SDK; the endpoint is this project's own
(`analytics.record`). The feature compiles out with
`--dart-define=QIBLA_ANALYTICS=false`.

## Rating prompt

The phone app asks for a store rating exactly as described above and never
on the first launch: at least three launches, two days since the first one
and three sessions in which the qibla was found and held for a few seconds.
The ask comes after the user turns away from the qibla, never while they
are facing it, and never over another sheet or while the app is in the
background. Google Play's in-app review card or Apple's StoreKit prompt is
used where available; otherwise the store listing opens. Both stores limit
how often their card appears and never report whether a review was written,
so the app treats a tap on "Rate" as final too. The counters and the answer
live in the app's preferences on the device and are not sent anywhere. The
iOS listing needs the App Store id passed at build time as
`--dart-define=QIBLA_APP_STORE_ID=…`.

## Web version

One page at `/` (old `/map` links redirect there), served by the Serverpod
web server. The compass code is not compiled into the web bundle at all
(`tool/check_web_bundle.sh` proves it after every build). The page's HTML
carries the title, description and a plain-text summary of what the app
does, so search engines and screen readers get real content before Flutter
loads; the server fills in absolute links from its configured public
address, answers old `/map` links with a permanent redirect, and serves
`robots.txt` and `sitemap.xml`. Scripts and fonts go out gzipped, and
"Write to us" loads on first tap rather than at start-up. The Flutter
rendering engine (CanvasKit) is loaded from Google's CDN, which is the only
third-party request besides map tiles; build with `--no-web-resources-cdn`
to self-host it. The Latin and Cyrillic fonts are bundled; see Languages
for the scripts that still fetch a fallback font.

## Licenses and credits

- Qibla Go source: see `LICENSE` once chosen (open decision in `docs/PLAN.md`).
- `compass_max`: MIT, Kamran Bekirov. Vendored; provenance and local changes
  in `packages/compass_max/NOTICE.md`.
- `qibla_math`: MIT, Abdeldjalil Chougui. WMM2025 coefficients are public
  domain (NOAA/NCEI).
- Fonts Marcellus (Astigmatic) and Manrope (Mikhail Sharanda): SIL OFL 1.1.
- `in_app_review`: MIT, Britannio Jarrett. Store rating prompt.
- `package_info_plus`: BSD-3-Clause, Flutter Community. App version for the
  usage statistics.
- Map data © OpenStreetMap contributors (ODbL).

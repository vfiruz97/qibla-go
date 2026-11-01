# Qibla Go — Plan

> A free, ad-free Qibla compass and prayer-times app for Android and the web
> (iOS later). Built for the pleasure of God. No accounts, no tracking.

## 1. Principles

1. **Accuracy before everything.** Showing a believer the wrong direction is
   the one failure we must not have. Every number on screen must be
   traceable: where it came from, how good it is, and what could be wrong.
2. **Honest UI.** When the sensor is unreliable, say so and hide the needle.
   A dimmed dial with a reason is better than a confident wrong arrow.
3. **Offline first.** The compass must work with no network, in a desert, on
   a plane. Fonts are bundled, the magnetic model runs on the device, the
   last location is remembered.
4. **Private by design.** Location never leaves the device. The server never
   receives coordinates finer than a city when prayer times arrive (and even
   that is computed locally where possible).
5. **Free forever.** No ads, no paywall, no analytics SDKs.
6. **Long-term code.** Feature-first structure, pure logic in testable Dart,
   platform code behind narrow seams.

## 2. Architecture

```
qibla_go/
├── qibla_go_flutter/      Flutter app (Android, web, iOS later)
│   └── lib/
│       ├── app/           MaterialApp, router, theme tokens
│       ├── core/          platform-agnostic building blocks
│       │   ├── geo/       GeoPoint, angles, QiblaGeometry (bearing, WMM2025)
│       │   ├── compass/   CompassSource seam: native (compass_max), web, simulated
│       │   ├── location/  LocationService seam (geolocator), models
│       │   ├── storage/   typed SharedPreferences access
│       │   └── serverpod/ generated client provider (lazy, optional)
│       ├── features/<name>/{application,domain,presentation}
│       │   └── qibla/     controllers (Riverpod), QiblaState, dial UI
│       └── l10n/          ARB strings (+ generated AppLocalizations)
├── qibla_go_server/       Serverpod backend (no auth, public read-mostly API)
├── qibla_go_client/       generated client (never edited)
├── packages/compass_max/  vendored sensor plugin (MIT), see NOTICE.md
└── docs/                  this plan and future design notes
```

Data flow on the qibla screen:

```
LocationController ──point──► QiblaGeometry (bearing, distance, declination)
                                      │
CompassController ──reading──► QiblaSnapshot ──► CompassDial / Readout / StatusStrip
       ▲                       (true heading = magnetic + WMM2025 declination,
  CompassSource                 needle angle, offset, NeedleTrust)
  (native | web | simulated)
```

### Accuracy charter

| Error source | Size | Mitigation |
| --- | --- | --- |
| Magnetic declination ignored | up to ±20° | Always add WMM2025 declination computed on-device (`qibla_math`, verified against NOAA test points). Platform "true heading" is kept only for diagnostics. |
| Wrong/old magnetic model | ~0.5°/yr drift | Model epoch 2025–2030; past validity the app extrapolates and asks for an update. Bump the model with each WMM release. |
| Magnetic interference | arbitrary | Field-strength check against the WMM-predicted value (Android) or the 25–65 µT band. Severe → needle hidden, reason shown. |
| Uncalibrated magnetometer | 5–30° | Platform accuracy flags → "calibrate" prompt with figure-8 animation. Never asked for while interference is present. |
| Tilt | grows past ~25° | Rotation-vector fusion on Android; axis switch when upright; prompt to hold flat. |
| Moving vehicle | useless | Flagged when speed is known (future: feed speed from the location stream). |
| Location error | 1 km ≈ 0.01° | Medium accuracy is enough; cached and manual positions allowed and labelled. Inside 100 m of the Kaaba the bearing is replaced by "you are here". |
| Great-circle vs. ellipsoid | ≤ 0.3° | Great-circle is the convention used by qibla authorities; documented in Details. |
| Browser sensors | unknown accuracy | Not used: the web version has no compass screen and opens on the map. The browser source stays in the code, unreachable, pending a decision. |
| Sun/moon azimuth | ≤ 0.5° sun, ≤ 2° moon | Only used as an orientation aid in words; the line itself never depends on them. Minute-level clock refresh. |

Any change to `core/geo` or the trust policy must keep `flutter test` green;
the tests pin published bearings and NOAA declination values. The
user-facing version of this table is "How the direction is computed" in
`README.md`; the two are updated together (see the accuracy change protocol
in the root `AGENTS.md`). The reasoning behind each choice is logged in
`docs/DECISIONS.md`.

## 3. Milestones

### M0 — Compass (this iteration) ✅
- Qibla dial with true-north heading, Kaaba marker, alignment feedback
  (gold halo + haptic), turn instructions, distance, accuracy pill.
- Location: live, cached, manual; permission and problem states.
- Trust policy and issue messages; details sheet with every number.
- Web fallback (browser orientation, iOS permission flow, desktop message).
- Map view (`/map`): great-circle qibla line from the user to the Kaaba on
  a dark basemap, world inset, long-press to set a location, and a
  plain-language guide (landmarks along the line).
- Sun and moon drawn on the map along their true azimuths, computed on
  device (Meeus/suncalc algorithms, tested against reference values), with
  "the qibla is N° to the right of the sun" guidance. Moon shown only when
  it is up and the sun is low.
- Intro animation on launch; the web version has no compass screen, opens on the map, and shows a one-time explanation card over it.
- Vendored `compass_max`; `qibla_math` pinned; unit tests for geometry.
- Server stripped to a public `health.ping`; auth removed.

### M0.5 — Write to us ✅

- `support.challenge` / `support.submit`: server-issued arithmetic challenge,
  single use, 10 min; 5 messages and 30 challenges per client per hour;
  message 10–2000 chars, optional contact. Stored in `support_message`;
  content never logged. Entry points: compass footer, map guide.
- Later: forward new messages by email; a tiny admin page in Insights.

### M1 — Release readiness
- App icon, splash, store listing, privacy policy page (served by the
  Serverpod web server).
- Decide and set `applicationId` / bundle id and the domain.
- Physical-device verification protocol (see §5) on at least three Android
  phones (one without a gyroscope) and one iPhone via Safari.
- Build pipelines: `flutter build appbundle`, `serverpod run flutter_build`
  plus `tool/check_web_bundle.sh`, GitHub Actions running `dart analyze`,
  `flutter test`, `dart test` (server).
- Web load time, further options (2026-10-31, Lighthouse 12 against the
  local dev server, release build: mobile simulation performance 29 → 76,
  desktop 91 → 92, console errors 2 → 0; what remains is Flutter web's
  script evaluation on a throttled phone, TBT 610 ms, TTI 14 s): `--wasm` with skwasm needs COOP/COEP
  headers, which also require tile images to be served with CORS, so test
  tiles first; content-hashed asset names would allow `immutable` caching
  instead of revalidation; a Content-Security-Policy needs a nonce for the
  inline loader; the location permission is requested at start-up, which
  Lighthouse flags, and a web-only "tap to use my location" start would
  change the first-run flow (decide with the UX).
- Settings: theme (night/day/system), units, compass smoothing.

### M2 — Prayer times with offline sync
- On-device calculation (astronomical algorithms; evaluate `adhan` package
  vs. own implementation with reference tests against published timetables).
- Server: `PrayerSettingsDataset` (calculation method defaults per country,
  high-latitude rules, madhab) versioned and synced; optional official
  timetables for cities that publish them (e.g. national authorities),
  delivered as signed, versioned bundles cached on device.
- Sync protocol: `datasets.manifest(version)` → download changed bundles;
  works days-to-weeks offline; no user identifier sent.
- Notifications (local), next-prayer card on the compass screen.

### M3 — Languages and RTL ✅ (2026-11-01, first pass)
- Shipped: English, German, French, Italian, Swedish, Indonesian, Russian,
  Tajik, Uzbek, Azerbaijani, Turkish, Persian, Arabic, Urdu, Chinese
  (Simplified), Japanese, Korean. Resolution follows the device or browser language
  list, English as the fallback. Right-to-left layout for Persian, Arabic
  and Urdu; script-aware typography; Persian/Arabic/fullwidth digits
  accepted in input fields; Tajik strings for Flutter's own widget chrome.
- Open: Traditional Chinese (zh-TW users get
  Simplified today); a native-speaker review pass per language (the first
  pass was written in one sitting, see DECISIONS); bundling fallback fonts
  for Tajik Cyrillic, Azerbaijani ə and Arabic script (Urdu would want a
  Nastaliq face) instead of relying on
  system fonts and the engine's Noto download on the web (Noto Sans and
  Noto Naskh Arabic are OFL; load them with `FontLoader` per script so they
  do not join the initial web download); Eastern Arabic-Indic digits as a
  display option; Hijri date; `hreflang` on the web page once content is
  served per language.

### M4 — iOS and polish
- iOS build via the vendored plugin (CoreLocation heading), App Store.
- Home-screen widget / live activity (next prayer), wear OS tile (later).
- Accessibility: screen-reader announcements of the turn instruction,
  large-text layouts, reduced-motion mode for the dial.

### Later ideas (not committed)
- Mosque finder (OpenStreetMap data, offline tiles).
- Sun-based calibration check (compare sensor heading with the computed
  solar azimuth when the user points at the sun).
- Feed vehicle speed into the compass from the location stream.

## 4. Engineering rules (summary; details in each package's AGENTS.md)

- Pure logic lives in `core/` and `features/*/domain` and is unit tested.
- Platform access only through seams (`CompassSource`, `LocationService`).
- State with Riverpod 3 `Notifier`s; UI never talks to plugins directly.
- All user-facing strings in ARB; all colours from `QiblaPalette`.
- `dart analyze` and `dart format` clean; no generated code edited by hand.
- Dependencies that influence the direction (`qibla_math`, `compass_max`)
  are pinned or vendored and only changed with the geometry tests passing.

## 5. Device verification protocol (before every release)

1. Outdoors, away from cars and buildings, phone flat, calibrated.
2. Compare the app's **true heading** with a known landmark bearing from a
   map (or the solar azimuth from a solar calculator at that minute).
   Pass: within ±3°.
3. Compare the displayed **qibla bearing** for the test location with two
   independent calculators (e.g. al-habib.info, Islamic Finder). Pass:
   within ±0.5°.
4. Bring a magnet near the phone: the needle must hide with the
   interference message within two seconds, and return within a few seconds
   after removal.
5. Hold the phone upright: heading must stay consistent (±5°) with flat.
6. Deny location, then enter coordinates by hand: the bearing must match
   step 3.
7. Airplane mode, restart the app: the last location and the dial must
   appear immediately.

## 6. Open decisions

| Decision | Status |
| --- | --- |
| Source license for Qibla Go itself | Open; pick one (MIT or Apache 2.0 suggested) and add `LICENSE` before the first public release. |
| Android `applicationId` / iOS bundle id | TODO before first store build (currently `com.example.qibla_go_flutter`). |
| Domain and hosting (Serverpod Cloud vs. own VPS) | Open; server has no state yet so either works. The domain goes into `webServer.publicHost` in `production.yaml`; every SEO link derives from it. |
| Prayer-time engine (package vs. own) | Decide in M2 with reference tests. |
| Fonts | Marcellus (display) + Manrope (body), both OFL, bundled. |
| Map tiles | OpenStreetMap standard tiles in their light style (no key; buildings visible from zoom 16). CARTO was dropped on 2026-10-24 because it now requires an API key, and the inverted dark style was dropped the same day because it hid buildings. Decision: always a free provider. The OSM usage policy forbids heavy app traffic, so before release move to a free-tier provider whose terms cover the load (MapTiler/Stadia/Thunderforest/self-hosted) via `QIBLA_TILE_URL`. |

## 7. Licenses and credits

- `compass_max` — MIT, Kamran Bekirov (vendored in `packages/compass_max`).
- `qibla_math` — MIT, Abdeldjalil Chougui (WMM2025 coefficients © NOAA/NCEI, public domain).
- Fonts Marcellus (Astigmatic) and Manrope (Mikhail Sharanda) — SIL OFL 1.1.

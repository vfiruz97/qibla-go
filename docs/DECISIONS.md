# Decisions

Append-only log of decisions that are not obvious from the code. Newest at
the bottom. Never edit an old entry; add a new one that supersedes it.

Format: date, decision, why, what it rules out.

---

## 2026-10-24 No authentication, ever

The server has no user accounts. The serverpod_auth modules were removed and
the auth tables dropped. Prayer-time data will be public and read-mostly.
Rules out: any feature that needs a per-user server record.

## 2026-10-24 Free forever, no ads, no analytics

The app is a gift. No ad SDKs, no analytics SDKs, no paywall, no paid map
providers. Any third-party service must have a free tier whose terms cover
the expected use, with a documented fallback if it goes away.

## 2026-10-24 Declination is computed on the device, not taken from the platform

True heading = platform magnetic heading + WMM2025 declination from
`qibla_math`. Android and browsers report "true heading" inconsistently;
computing it ourselves gives one audited path on every platform and lets the
tests pin NOAA values. The platform value stays in diagnostics only.

## 2026-10-24 compass_max is vendored, not depended on

The plugin is not on pub.dev and the compass is the most accuracy-critical
code in the app. A full copy lives in `packages/compass_max` under MIT, so
the build does not depend on the upstream repository existing. Upstream
fixes are ported by hand and recorded in its `NOTICE.md`.

## 2026-10-24 qibla_math is pinned exactly

A bump can change the Kaaba coordinates or the magnetic model. It is bumped
only after running its own test suite and ours, with the diff noted in the
pull request.

## 2026-10-24 Hide the needle rather than guess

Under interference, in a vehicle, or without a recent reading the direction
is hidden and the reason shown. A dimmed dial with a reason beats a confident
wrong arrow. The UI layer may never upgrade a trust level.

## 2026-10-24 Map tiles: free providers only, light OpenStreetMap style

CARTO's dark basemap was the first choice and was dropped the same day
because it started requiring an API key. An inverted dark rendering of
OpenStreetMap tiles was tried next and dropped because it hid buildings,
and matching the line to buildings is the whole point of the map. Current:
OpenStreetMap standard tiles in their light style, street-level initial
zoom. Before public release, move to a free-tier provider whose terms cover
the traffic via `QIBLA_TILE_URL`.

## 2026-10-24 Desktop browsers go straight to the map

Desktop browsers have no orientation sensors. After the intro the map opens
and a one-time card explains why; there is no "stay on the compass" option.

## 2026-10-31 README is the user-facing accuracy statement

`README.md` carries a table describing exactly how the direction is
computed. It is updated in the same pull request as any accuracy-relevant
code change, together with the charter in `PLAN.md`. See the accuracy change
protocol in the root `AGENTS.md`.

## 2026-10-31 Location changes are motion, not cuts

A new position (long-press, typed coordinates, "Use my location") used to
rebuild the world inset, jump the camera twice and redraw the line in one
frame, which read as a flash. Now the marker and line glide to the new point,
the camera flies (zooming out and back in for long hops), the inset refits
in place, and a long-press never moves the map away from the finger. A
"location set" snackbar was tried and dropped: it drew the eye away from the
map and on web it did not always dismiss. Rule in `qibla_go_flutter/AGENTS.md`: nothing on
the map jumps.

## 2026-10-31 "Write to us" with a server-issued sum, no account

Users need a way to report a wrong-looking direction, and the app has no
accounts by design. The form asks one small addition or subtraction. The sum
is issued and checked by the server, single use and short-lived, and backed
by per-connection rate limits, because the sum alone would not stop a bot
that reads the page. The caller address is used in memory only. Contact is
optional and only for replying. Message content is never logged. Reading
messages happens in the database or Insights; an email forwarder can come
later.

## 2026-10-31 No compass screen on the web

Supersedes "Desktop browsers go straight to the map" (2026-10-24). Phone
browsers were still offered the browser compass, which is rough, needs a
permission tap on iOS Safari, and cannot detect interference; it risked
showing a confident wrong needle. The web version now has no compass screen
at all: `/` redirects to `/map`, the map has no compass button, and a card
explains once that the live compass is in the phone app. The browser heading
source stays in the code, unreachable, in case a clearly labelled
phone-browser mode is wanted later.

## 2026-10-31 Web: one page, compass compiled out, gzip and SEO on the server

- The web app is a single page at `/`; `/map` redirects there. Supersedes
  the `/` → `/map` redirect of the same day: one canonical URL is better for
  sharing and indexing than a client-side hop.
- The compass route is swapped out by conditional import
  (`compass_routes_web.dart`), so no sensor or dial code is compiled into
  the web bundle. `kIsWeb` branches would mostly be tree-shaken too, but the
  import makes it structural and `tool/check_web_bundle.sh` checks it.
  `LocationState` and `qiblaGeometryProvider` moved to their own files so the
  map can depend on location and geometry without the compass controller;
  no behaviour changed.
- Search engines cannot read a Flutter canvas, so `web/index.html` carries
  the indexable text (shown until Flutter's first frame, and if Flutter
  fails to load), with canonical, Open Graph and JSON-LD built from the
  server's configured public address. `robots.txt` and `sitemap.xml` come
  from the server. No prerendering service: nothing third-party, nothing
  that costs money.
- Relic sent `main.dart.js` uncompressed (3.3 MB). A small gzip middleware
  on the Serverpod web server brings it to under 1 MB. HTML is excluded
  because the dev watcher's reload injection reads HTML bodies as text.
  Brotli was not added: Dart has no built-in encoder and it would mean a
  native dependency for a modest extra gain.
- CanvasKit stays on Google's CDN (the Flutter default): it is likely
  already cached in the visitor's browser from other Flutter sites and is
  served brotli-compressed. Documented in the README as the one third-party
  request besides map tiles; `--no-web-resources-cdn` self-hosts it if that
  ever changes.

## 2026-10-31 Web pass two: redirects, lazy support, no Google Fonts, no first-focus

- `/map` and `/index.html` now answer `301` to `/` on the server; the
  client-side redirect stays as a fallback. One URL for crawlers.
- The indexable text in `index.html` is no longer removed after Flutter's
  first frame; it moves off screen. Google indexes the rendered DOM, and a
  Flutter canvas has no text.
- "Write to us" is a deferred import, which also moves the Serverpod client
  and protocol out of the initial bundle into a part file loaded on first
  tap. Measured on the release build (see the PR).
- `Roboto` is declared in `pubspec.yaml` as an alias of Manrope. The web
  engine otherwise downloads Roboto from fonts.gstatic.com at start-up
  whether or not it is used; the app promises no third-party requests
  beyond tiles and the engine CDN.
- The first web frame is an empty box. Headless Chrome (so Lighthouse, and
  any user whose browser focuses the page before Flutter's first layout)
  hands the Flutter view focus with direction "forward"; the framework
  then sorts focusable widgets by position and reads the navigator
  overlay's size before it exists, logging "RenderBox was not laid out".
  With nothing focusable in the first frame the search is empty. Traced in
  an unminified build; `GoRouter(requestFocus: false)` was tried first and
  did not help, since the request comes from the view, not the route.
- HTML is gzipped in every run mode except development, where the dev
  watcher's reload injection reads HTML bodies as text.

## 2026-11-01 Seventeen languages: resolution, fallback, type and chrome

- Language comes from the device or browser language list, in the user's
  order, with English as the fallback. Flutter's default fallback is the
  first entry of `supportedLocales`, which the code generator sorts
  alphabetically, so without `resolveLocale` an unsupported language would
  have landed on Arabic. The callback is tested, including the generator's
  ordering, so the assumption is checked rather than remembered.
- Translations were written in one pass by the maintainer with the
  assistant, not by native speakers per language. The ARB test enforces
  completeness and placeholders, not quality. A native review pass is an
  open item in the plan; "Write to us" is the channel for wrong wording.
- Terminology: Qibla / Kaaba / Makkah transliterated as each language's
  established form (Kıble, Kâbe, Mekke; Кибла, Кааба, Мекка; Қибла, Каъба,
  Макка; 朝向, 克尔白, 麦加; キブラ, カアバ, マッカ; 키블라, 카바, 메카;
  La Mecque, Mecca, Mekka; Kiblat, Ka'bah, Makkah; قبلہ, کعبہ, مکہ). The brand "Qibla Go" stays in Latin letters.
  Chinese is Simplified only; Traditional readers get it by language match.
- Tajik has no strings in Flutter's own localizations. Rather than the
  English the framework falls back to, the strings a user of this app can
  meet (back tooltip, text-selection menu, sheet and scrim labels) are
  provided in `tajik_material_localizations.dart` over the English
  defaults. Date and time pickers, licence pages and keyboard key names
  stay English until the app uses them.
- Fonts: Marcellus has Latin glyphs only and Manrope lacks the six Tajik
  letters, ə and every non-Latin, non-Cyrillic script. Headlines switch to
  Manrope outside Latin script; missing glyphs fall back to system fonts
  on phones and to the engine's Noto download on the web. Bundling script
  fonts was deferred because Flutter web loads every font in the manifest
  at start-up, which would undo the load-time work for everyone; the plan
  records the `FontLoader` route for a later pass.
- Urdu shares the Arabic-script rules (right to left, no tracking, taller
  lines) and renders in the Naskh fallback until a Nastaliq face is bundled.
- The dial's cardinal letters inherit the theme's display face instead of
  pinning Marcellus, so С В Ю З and ش ق ج غ render in a bundled font.
- Arabic script gets no letter-spacing anywhere: tracking pulls the joined
  letters apart. Arabic and East Asian text get taller lines. Both live in
  `ScriptTypography` so the rule is in one place.
- The sun and moon labels were composed in Dart as name plus number; they
  are now one template, because word order is the translator's call.
- Digits from Persian, Arabic, Chinese and Japanese keyboards are mapped to
  ASCII before parsing coordinates and the arithmetic check. Output keeps
  Western digits in every language for now.
- The sky overlay's label box had a fixed height sized for English; it now
  takes the height it needs, since a translated label may need two lines.

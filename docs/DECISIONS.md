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

# Qibla Go — server rules

Serverpod 4 backend. Today it answers `health.ping`, stores "Write to us"
messages (`support.*`) and anonymous usage events (`analytics.record`); its
main purpose will be to deliver prayer-time datasets for offline sync (see
`docs/PLAN.md`, M2). Read the root `AGENTS.md`
first for the MCP workflow and checklist.

## Principles

- **No authentication, no accounts.** The auth modules were removed on
  purpose. Every endpoint is public, read-mostly, and must be safe to call
  anonymously. Do not add `serverpod_auth_*` back; if a future feature seems
  to need identity, design it without one (device-generated opaque ids at
  most, never personal data).
- **Privacy.** Never log or store coordinates finer than a city/region.
  Prayer-time requests carry a dataset id or a city id, not a GPS fix.
  `session.log` must not include request payloads with locations.
- **Offline-first clients.** Design every data endpoint for sync, not for
  live queries: versioned datasets, cheap manifest calls, stable ids, and
  payloads the app can cache for weeks.
- **Boring and cheap.** One Postgres, no Redis unless a feature proves it,
  no future calls for things a cron on the dataset importer can do.

## Layout

```
lib/
├── server.dart                 routes + pod.start(); no business logic
└── src/
    ├── generated/              NEVER edit
    ├── health/                 health_endpoint.dart
    ├── support/                support_endpoint.dart, SupportGuard (challenge + rate limits), models
    ├── analytics/              analytics_endpoint.dart (write-only), AnalyticsGuard (allowlists,
    │                           bounds, hourly budget), AnalyticsRetention (90-day purge), models
    ├── <feature>/              <feature>_endpoint.dart + <model>.spy.yaml + logic
    └── web/                    Relic routes and middleware for the web app:
                                gzip_middleware, seo (robots/sitemap/index),
                                public_origin, routes/web_app_routes
config/                         development/staging/production/test yaml
migrations/                     generated; see root AGENTS.md for the SQL exception
test/integration/               withServerpod endpoint tests (embedded Postgres)
```

Group by feature, not by kind: a model and the endpoint that serves it live
in the same folder. Keep endpoint classes thin; put logic in plain Dart
classes that can be unit tested without a `Session`.

## Endpoints and models

- Endpoint classes end in `Endpoint`; methods are verbs (`ping`,
  `listDatasets`, `downloadBundle`). Public is the default, so there is no
  `requireLogin`; think about abuse instead: bound every list, cap payload
  sizes, and prefer static, cacheable responses.
- Models in `.spy.yaml` with `###` doc comments on every field. Prefer
  immutable, versioned records (`version`, `publishedAt`) over mutable rows
  so clients can sync by version.
- Datetimes are UTC. Coordinates, if ever stored, are city centroids.
- After changing a model with a `table`: `create_migration` →
  `apply_migrations` (MCP). Destructive changes need `force` and a sentence
  in the PR about data impact.

## Public write endpoints

`support.submit` is the only endpoint that writes user content;
`analytics.record` writes anonymous counters. The pattern for any future one:

- A server-issued, single-use, short-lived challenge (`SupportGuard`), checked
  before anything touches the database.
- Per-client counters keyed by the caller address (first `X-Forwarded-For`
  hop behind a proxy, else the socket address). The address lives in memory
  only; it is never stored, never logged.
- Bounds on every field, enforced server-side even though the app checks
  first. Content and contact details are never written to `session.log`.
- Reading what users sent happens in the database or Serverpod Insights; no
  endpoint ever returns stored messages.

`analytics.record` has no challenge (it runs in the background and a bogus
row costs nothing), so everything rests on `AnalyticsGuard`: event names and
platforms from an allowlist, every string a short token, numbers bounded,
device clocks clamped to a day, 1000 events per client address per hour, and
a refused batch answers 0 instead of throwing so the app never retries or
reports. The table holds no identifier beyond the per-launch session id and
no free text; `AnalyticsRetention.purge` deletes rows after 90 days, run
opportunistically from the endpoint (once an hour per process). A new event
name goes into `AnalyticsGuard.allowedNames`, the app's
`AnalyticsEventName` and the README in the same change. Counting happens in
SQL, e.g. launches per platform and day:

```sql
select date_trunc('day', "occurredAt") d, platform, count(*)
from analytics_event where name = 'app_launch' group by 1, 2 order by 1;
```

## Web app serving

`serverpod run flutter_build` builds the Flutter web app into `web/app`
(git-ignored); `server.dart` serves it when the folder exists.

- `/` goes through `IndexPageRoute`, which fills `__QIBLA_ORIGIN__` in
  `index.html` with the public address from the web server config
  (`publicScheme`/`publicHost`/`publicPort`). `/map` and `/index.html`
  answer `301` to `/`, so crawlers see one URL.
  `production.yaml` must carry the real domain; canonical links, Open Graph
  and the sitemap all derive from it.
- `robots.txt` and `sitemap.xml` are generated (`seo.dart`); the sitemap
  lists the single page.
- `gzipMiddleware` compresses scripts, styles, fonts, JSON and WASM when the
  client accepts gzip, keeps `ETag`, adds `Vary: Accept-Encoding` and skips
  anything under 1 KB. HTML is compressed too, except in the `development`
  run mode, because the dev watcher injects its reload script into HTML
  bodies outside the middleware. Everything else is `FlutterRoute` with its
  `private, no-cache` + `ETag` revalidation.
- Verify after a change: `curl -sI -H 'Accept-Encoding: gzip'
  localhost:8082/main.dart.js` shows `content-encoding: gzip`, and `curl -s
  localhost:8082/ | grep canonical` shows the origin, no placeholder.

## Tests

- Every endpoint gets a `withServerpod` test in `test/integration/`.
- Pure logic gets plain `test/` unit tests.
- `dart test` runs with the embedded database from `config/test.yaml`; no
  Docker needed.

## Running

The user runs `serverpod start` (watch mode, auto code generation, hot
reload, launches the Flutter app). Never start it from an agent. Use the MCP
tools for logs, migrations and restarts.

# Qibla Go — server rules

Serverpod 4 backend. Today it answers `health.ping` and stores "Write to us"
messages (`support.*`); its main purpose will be to deliver prayer-time
datasets for offline sync (see `docs/PLAN.md`, M2). Read the root `AGENTS.md`
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
    ├── <feature>/              <feature>_endpoint.dart + <model>.spy.yaml + logic
    └── web/                    Relic routes (config route, Flutter web app)
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

`support.submit` is the only endpoint that writes user content. The pattern
for any future one:

- A server-issued, single-use, short-lived challenge (`SupportGuard`), checked
  before anything touches the database.
- Per-client counters keyed by the caller address (first `X-Forwarded-For`
  hop behind a proxy, else the socket address). The address lives in memory
  only; it is never stored, never logged.
- Bounds on every field, enforced server-side even though the app checks
  first. Content and contact details are never written to `session.log`.
- Reading what users sent happens in the database or Serverpod Insights; no
  endpoint ever returns stored messages.

## Tests

- Every endpoint gets a `withServerpod` test in `test/integration/`.
- Pure logic gets plain `test/` unit tests.
- `dart test` runs with the embedded database from `config/test.yaml`; no
  Docker needed.

## Running

The user runs `serverpod start` (watch mode, auto code generation, hot
reload, launches the Flutter app). Never start it from an agent. Use the MCP
tools for logs, migrations and restarts.

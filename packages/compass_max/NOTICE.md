# Vendored package notice

This directory is a vendored copy of **compass_max** by Kamran Bekirov,
licensed under the MIT License (see `LICENSE`).

- Upstream: https://github.com/kamranbekirovyz/compass-max
- Vendored from commit `627d1b39f3552b7f63d589b2260f8c1f86ef9a00` (2026-08-14)
- The package was not published on pub.dev at the time, and the compass is the
  most accuracy-critical part of Qibla Go, so we own this code inside the repo.

## Local changes

Keep this list current so upstream can be diffed and merged later.

1. `pubspec.yaml`: added `resolution: workspace`, raised the SDK constraints
   to the workspace's, added a `+qiblago.N` version suffix; removed the `pigeon` dev dependency to keep the workspace resolvable
   (add it back temporarily when regenerating from `pigeons/messages.dart`).
2. Dropped the `example/` app.

## Rules

- Native code reports facts only (heading, tilt, field strength, accuracy).
  Every judgement stays in Dart so Android and iOS cannot drift apart, and
  stays covered by `flutter test` in this package.
- Run `flutter test` in this directory after touching anything under `lib/`.

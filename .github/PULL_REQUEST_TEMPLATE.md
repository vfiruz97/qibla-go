## What and why

<!-- One or two sentences. Link the decision in docs/DECISIONS.md if there is one. -->

## Accuracy

<!-- Delete this section only if the PR touches none of:
     qibla_go_flutter/lib/core/geo, core/compass, core/location, core/astro,
     features/qibla/domain, packages/compass_max, qibla_math version,
     map line / tile code, or any threshold named in README.md. -->

- [ ] README.md "How the direction is computed" updated to match the code
- [ ] docs/PLAN.md accuracy charter updated
- [ ] Tests added or updated; no tolerance loosened
- [ ] How the numbers were re-verified (published values, NOAA points, device run):

## Checks

- [ ] `dart analyze` and `dart format` clean in every package touched
- [ ] `flutter test` in `qibla_go_flutter` green
- [ ] `dart test` in `qibla_go_server` green (if the server changed)
- [ ] `flutter test` in `packages/compass_max` green (if it changed) and `NOTICE.md` updated
- [ ] Goldens regenerated on purpose, images reviewed, listed here:
- [ ] New strings in `app_en.arb`; new colours from `QiblaPalette`
- [ ] No auth, analytics, ads, paid services or API keys introduced
- [ ] Decision worth remembering appended to `docs/DECISIONS.md`

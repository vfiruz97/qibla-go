#!/bin/sh
# Checks a web build: no compass code in the bundle, and the sizes the
# browser actually downloads. Run after `flutter build web`.
#
#   tool/check_web_bundle.sh [path/to/main.dart.js]
set -e
JS="${1:-build/web/main.dart.js}"
[ -f "$JS" ] || { echo "no bundle at $JS; run flutter build web first"; exit 2; }
for marker in deviceorientationabsolute webkitCompassHeading dev.flutter.pigeon.compass_max compass_max; do
  if grep -q "$marker" "$JS"; then
    echo "FAIL: compass code reached the web bundle ($marker found)"
    exit 1
  fi
done
printf 'main.dart.js: %s bytes raw, %s bytes gzip\n' \
  "$(wc -c < "$JS" | tr -d ' ')" "$(gzip -6 -c "$JS" | wc -c | tr -d ' ')"
DIR="$(dirname "$JS")"
for part in "$DIR"/main.dart.js_*.part.js; do
  [ -f "$part" ] && printf '%s: %s bytes raw (loaded on demand)\n' "$(basename "$part")" "$(wc -c < "$part" | tr -d ' ')"
done
echo "OK: no compass code in the web bundle"

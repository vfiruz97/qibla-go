<h1 align="center">compass_max</h1>

<p align="center">Flutter compass at max: heading, magnetic interference, calibration, accuracy and more.</p>

## Features

- 🧭 **Says when it is wrong.** Each reading carries a list of what is off.
- 🧲 **Detects magnets and metal.** Compares the measured field against what it should be here.
- 📱 **Runs without a gyroscope.** Falls back through whatever sensors the phone has.
- 🚗 **Detects travel.** Reports when the user is moving faster than walking pace.
- ✨ **Three fields.** A heading, a list, and diagnostics.
- 🔬 **Tested without a phone.** The logic lives in Dart.

Also:

- 🌍 **True north.** Given a location.
- 🎯 **Never null.** A heading always arrives.
- 🪶 **Smoothed.** No wrapper package needed.
- 🔒 **No permissions.** None requested, none required.
- 🛠 **Current tooling.** Pigeon, Kotlin, Swift, and Android 13's heading sensor.

## Install

```yaml
dependencies:
  compass_max: ^0.1.0
```

Android needs no permission for a magnetic heading. True north needs a location, which you pass in yourself. The plugin never asks for the permission. On iOS add `NSLocationWhenInUseUsageDescription` if you want true north. Without it, headings stay magnetic.

## Use

```dart
final CompassCapabilities capabilities = await CompassMax.capabilities();

if (!capabilities.hasCompass) {
  return showYourFallback();
}

await CompassMax.configure(
  location: CompassLocation(
    latitude: 40.4093, 
    longitude: 49.8671,
  ),
  smoothing: CompassSmoothing.medium,
);

CompassMax.updateSpeed(position.speed);  // optional, enables the movingFast issue

_subscription = CompassMax.events.listen((CompassEvent event) { ... });
```

`configure` is what unlocks true north and interference detection. Call it again when the user moves a meaningful distance. It is cheap.

### Why you pass the speed

`updateSpeed` is what tells the difference between someone standing next to a fridge and someone sitting in a moving car. Both look identical to the magnetometer, and only the second one is hopeless.

The plugin does not read the speed itself on purpose. Reading it means running location updates, which means the plugin would need the location permission, and every app that added this package would inherit that permission even if it only ever wanted a magnetic heading. Your app already has a location provider, so passing the number keeps the package free of permissions entirely.

Feed it from a stream rather than a single reading, or the value goes stale the moment the user starts moving:

```dart
_subscription = Geolocator.getPositionStream().listen(
  (Position position) => CompassMax.updateSpeed(position.speed),
);
```

Skip it and nothing breaks. You simply never see `movingFast`.

## The event

```dart
class CompassEvent {
  final double heading;              // 0 to 360, already true north
  final List<CompassIssue> issues;   // empty means nothing to report
  final CompassDiagnostics diagnostics;

  CompassIssue? get topIssue;        // the one worth a sentence of UI
}
```

## The issues

Four of them, sorted by how much each one distorts the heading, so showing `issues.first` and nothing else is a complete UI.

| Issue | What it means |
| --- | --- |
| `magneticInterference` | The field here is not the Earth's, so the heading is wrong rather than imprecise |
| `movingFast` | Travelling faster than walking pace, usually a vehicle |
| `needsCalibration` | The platform is unsure of its own calibration |
| `phoneNotFlat` | Tilted far enough that readings degrade |

Issues are debounced. An issue has to hold for 1.5 seconds before it appears and one second before it goes, so you can bind them straight to a widget without a timer of your own.

The list is observations, not verdicts. Every issue that is true is reported, and what to do about each one is your app's call. A navigation app keeps drawing the heading in a car; a Qibla app dims it.

One exception. Calibration is never asked for while there is interference, because calibrating inside a polluted field stores a worse estimate than the one it replaces.

## Why the magnet check is the strong one

The Earth's magnetic field has a known strength at any given place, between 25 and 65 microtesla depending on how far north you are. Android can tell us the exact figure predicted for the user's coordinates. If the phone measures something far from that, there is metal or a magnet nearby, and no amount of figure 8 waving will fix it.

That is a measurement rather than a guess, which is what makes it safe to dim the compass over. It also catches the case every accuracy flag misses, where the platform reports itself calibrated while a magnetic case quietly points the needle at the wrong wall.

iOS has no equivalent of Android's prediction, so there the check falls back to the 25 to 65 band. Coarser, but it still catches laptops and cars. Every threshold is configurable through `CompassThresholds`.

## The Android sensor chain

Tried in order, best first, stopping at the first one the device has.

1. `TYPE_HEADING` on Android 13 and up. True north with its own error estimate. Layered on top of the chain below, since it says nothing about tilt.
2. `TYPE_ROTATION_VECTOR`, fused with the gyroscope. The best case.
3. `TYPE_GEOMAGNETIC_ROTATION_VECTOR`, which needs no gyroscope. **This is the step other packages skip, and why they are dead on budget phones.**
4. Accelerometer and magnetometer, fused here. Noisy, but alive.

On iOS, CoreLocation is the fusion layer, so there is nothing to choose. The system calibration sheet is allowed to appear, because it is Apple's own figure 8 prompt and it dismisses itself.

## Architecture

The native side reports facts only. Heading, tilt, field strength, and whatever accuracy the platform admits to. Every judgement happens in Dart.

So the two platforms cannot drift apart, and all of the logic is covered by tests that run without a device.

```
flutter test
```

The platform channel is generated by [pigeon](https://pub.dev/packages/pigeon) from `pigeons/messages.dart`. After editing it:

```
dart run pigeon --input pigeons/messages.dart
```

## Known limits

- The predicted field strength is Android only. iOS uses the wider band.
- No web or desktop.
- The iOS simulator has no magnetometer, so `capabilities().hasCompass` is false there. Branch on it instead of waiting for a stream that never emits.
- `movingFast` needs `updateSpeed`. Without it, it is never reported.
- A compass that reports itself healthy while the needle wanders on a still table is not detected. Telling that apart from a user turning their phone needs the gyroscope, which is a separate job.

## Credit

The Android sensor fallback strategy follows the approach in [andromeda](https://github.com/kylecorry31/andromeda) and [Trail Sense](https://github.com/kylecorry31/Trail-Sense) by Kyle Corry, both MIT licensed, and the best open source compass work on Android by a distance.

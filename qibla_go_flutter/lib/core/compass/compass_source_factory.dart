import 'package:flutter/foundation.dart';

import 'compass_source.dart';
import 'native_compass_source.dart';
import 'web_compass_source_stub.dart'
    if (dart.library.js_interop) 'web_compass_source_web.dart';

/// Picks the compass implementation for the platform the app runs on.
///
/// Desktop builds get the web stub, which reports "no sensor": there is no
/// desktop compass hardware worth pretending about.
CompassSource createPlatformCompassSource() {
  if (kIsWeb) return WebCompassSource();
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
    case TargetPlatform.iOS:
      return NativeCompassSource();
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
      return WebCompassSource();
  }
}

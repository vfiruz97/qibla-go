// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Qibla Go';

  @override
  String get qiblaLabel => 'QIBLA';

  @override
  String get fromTrueNorth => 'from true north';

  @override
  String get fromMagneticNorth => 'from magnetic north';

  @override
  String get facingQibla => 'You are facing the Qibla';

  @override
  String turnRight(int degrees) {
    return 'Turn right $degrees°';
  }

  @override
  String turnLeft(int degrees) {
    return 'Turn left $degrees°';
  }

  @override
  String get turnAround => 'Turn around';

  @override
  String distanceToMakkah(String distance) {
    return '$distance km to Makkah';
  }

  @override
  String get atKaabaTitle => 'You are at the Kaaba';

  @override
  String get atKaabaBody =>
      'Face it directly; a bearing has no meaning this close.';

  @override
  String accuracyPlusMinus(int degrees) {
    return '±$degrees°';
  }

  @override
  String get accuracyUnknown => 'Accuracy unknown';

  @override
  String get qualityGood => 'Good';

  @override
  String get qualityFair => 'Fair';

  @override
  String get qualityPoor => 'Poor';

  @override
  String get headingLabel => 'Heading';

  @override
  String bearingSummary(int bearing, int magnetic) {
    return 'Qibla is $bearing° from true north ($magnetic° on a magnetic compass). Valid with any compass or map.';
  }

  @override
  String get locationSetLocation => 'Set location';

  @override
  String get locationLocating => 'Locating…';

  @override
  String get locationOriginDevice => 'Live location';

  @override
  String get locationOriginCached => 'Last known location';

  @override
  String get locationOriginManual => 'Entered by hand';

  @override
  String locationAccuracyMeters(int meters) {
    return '±$meters m';
  }

  @override
  String get locationAgeJustNow => 'just now';

  @override
  String locationAgeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String locationAgeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String locationAgeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get locationNeededTitle => 'Where are you?';

  @override
  String get locationNeededBody =>
      'The Qibla direction depends on where you stand. Allow location access, or enter your coordinates. Your location never leaves this device.';

  @override
  String get locationUseMyLocation => 'Use my location';

  @override
  String get locationEnterCoordinates => 'Enter coordinates';

  @override
  String get locationLatitude => 'Latitude';

  @override
  String get locationLongitude => 'Longitude';

  @override
  String get locationLatitudeHint => 'e.g. 38.5598';

  @override
  String get locationLongitudeHint => 'e.g. 68.7870';

  @override
  String get locationInvalidLatitude => 'Latitude must be between -90 and 90';

  @override
  String get locationInvalidLongitude =>
      'Longitude must be between -180 and 180';

  @override
  String get locationSave => 'Use these coordinates';

  @override
  String get locationOpenSettings => 'Open settings';

  @override
  String get locationProblemServicesDisabled =>
      'Location services are turned off on this device.';

  @override
  String get locationProblemPermissionDenied =>
      'Location permission was not granted.';

  @override
  String get locationProblemPermissionDeniedForever =>
      'Location permission is blocked. Allow it in the system settings.';

  @override
  String get locationProblemTimeout =>
      'Could not get a position in time. Try near a window or outdoors.';

  @override
  String get locationProblemUnavailable => 'Could not determine your position.';

  @override
  String get locationStaleNote =>
      'Using a saved position. If you have travelled since, refresh it.';

  @override
  String get locationSheetTitle => 'Your location';

  @override
  String locationCoordinates(String latitude, String longitude) {
    return '$latitude, $longitude';
  }

  @override
  String get compassCheckingTitle => 'Checking the compass…';

  @override
  String get compassWaitingTitle => 'Waiting for the sensor…';

  @override
  String get compassWaitingBody =>
      'Move the phone gently if this takes more than a moment.';

  @override
  String get compassStaleTitle => 'The compass stopped responding';

  @override
  String get compassStaleBody =>
      'Readings have paused. Move the phone a little, or restart the app.';

  @override
  String get compassNoSensorTitle => 'No compass on this device';

  @override
  String get compassNoSensorBody =>
      'This device has no magnetometer, so it cannot show a live direction. The bearing below still works with any physical compass or a map.';

  @override
  String get compassBrowserNoSensorTitle => 'No compass in this browser';

  @override
  String get compassBrowserNoSensorBody =>
      'Desktop browsers have no orientation sensors. Open Qibla Go on a phone, or use the bearing below with a compass or a map.';

  @override
  String get compassPermissionTitle => 'Allow motion access';

  @override
  String get compassPermissionBody =>
      'Your browser needs permission to read the phone\'s orientation.';

  @override
  String get compassPermissionButton => 'Enable compass';

  @override
  String get compassPermissionDeniedBody =>
      'Motion access was declined. Allow it in the browser settings and reload.';

  @override
  String get compassRetry => 'Try again';

  @override
  String get compassPausedTitle => 'Compass paused';

  @override
  String get issueInterferenceTitle => 'Magnetic interference';

  @override
  String get issueInterferenceBody =>
      'Something magnetic or metal is nearby: a laptop, a car, a phone case with a magnet. The direction is hidden until the field is clean. Step away and try again.';

  @override
  String get issueMovingFastTitle => 'You seem to be in a vehicle';

  @override
  String get issueMovingFastBody =>
      'A compass cannot be trusted inside a moving car or train. Stop and step outside to check the direction.';

  @override
  String get issueCalibrationTitle => 'Calibrate your compass';

  @override
  String get issueCalibrationBody =>
      'Move the phone in a figure of eight a few times, away from metal.';

  @override
  String get issueNotFlatTitle => 'Hold the phone flat';

  @override
  String get issueNotFlatBody =>
      'Keep the screen facing the sky for the steadiest reading.';

  @override
  String get issueBrowserTitle => 'Browser compass';

  @override
  String get issueBrowserBody =>
      'Browsers give a rough heading and cannot detect interference. Before praying, confirm with the bearing below and a real compass if you can.';

  @override
  String get issueLowAccuracyTitle => 'Low accuracy';

  @override
  String get issueLowAccuracyBody =>
      'The sensor reports a large error right now. Calibrate, then check again.';

  @override
  String get declinationExtrapolatedNote =>
      'This app\'s magnetic model has expired. Update the app for the best accuracy.';

  @override
  String get detailsButton => 'Details';

  @override
  String get detailsTitle => 'How this direction was computed';

  @override
  String get detailsSource => 'Sensor';

  @override
  String get detailsMagneticHeading => 'Magnetic heading';

  @override
  String get detailsDeclination => 'Declination (WMM2025)';

  @override
  String get detailsTrueHeading => 'True heading';

  @override
  String get detailsPlatformTrueHeading => 'Platform true heading';

  @override
  String get detailsAccuracy => 'Reported accuracy';

  @override
  String get detailsConfidence => 'Confidence';

  @override
  String get detailsPitch => 'Tilt';

  @override
  String get detailsField => 'Field strength';

  @override
  String get detailsFieldExpected => 'Expected field';

  @override
  String get detailsBearing => 'Qibla bearing (true)';

  @override
  String get detailsBearingMagnetic => 'Qibla bearing (magnetic)';

  @override
  String get detailsDistance => 'Distance to the Kaaba';

  @override
  String get detailsLocation => 'Position';

  @override
  String get detailsKaaba => 'Kaaba';

  @override
  String get detailsMethod =>
      'Great-circle initial bearing on WGS-84 coordinates; true north from the magnetic heading plus WMM2025 declination computed on this device.';

  @override
  String get detailsNotAvailable => '—';

  @override
  String get detailsSimulateToggle => 'Simulate compass (debug build only)';

  @override
  String get detailsSimulateHeading => 'Simulated heading';

  @override
  String get footerFree => 'Free, forever. No ads, no accounts.';

  @override
  String get footerIntention => 'Made for the pleasure of God.';

  @override
  String get cardinalN => 'N';

  @override
  String get cardinalE => 'E';

  @override
  String get cardinalS => 'S';

  @override
  String get cardinalW => 'W';

  @override
  String get introTagline => 'Face the Kaaba, wherever you are';

  @override
  String get introSkip => 'Skip';

  @override
  String get desktopPromptTitle => 'Best experience on a phone';

  @override
  String get desktopPromptBody =>
      'The live compass needs a phone\'s motion sensors. On this computer, Qibla Go shows the direction on a map instead, with the sun and the moon to help you orient yourself.';

  @override
  String get desktopPromptContinue => 'Continue to the map';

  @override
  String get navCompass => 'Compass';

  @override
  String get navMap => 'Map';

  @override
  String get mapTitle => 'Qibla on the map';

  @override
  String get mapYourLocation => 'You';

  @override
  String get mapKaaba => 'Kaaba, Makkah';

  @override
  String get mapQiblaLine => 'Qibla line';

  @override
  String get mapSun => 'Sun';

  @override
  String get mapMoon => 'Moon';

  @override
  String get mapRecenter => 'Back to my location';

  @override
  String get mapZoomIn => 'Closer';

  @override
  String get mapZoomOut => 'Farther';

  @override
  String get mapLongPressHint =>
      'Long-press anywhere on the map to set your location there.';

  @override
  String get mapLocationSet => 'Location set from the map.';

  @override
  String get mapHowTitle => 'How to use this map';

  @override
  String get mapHowStep1 =>
      'The gold line starts where you are and runs straight to the Kaaba. Prayer faces along this line.';

  @override
  String get mapHowStep2 =>
      'Find something the line crosses near you: a road, a tall building, a hill, a bridge. Stand so that you face it, and you face the Qibla.';

  @override
  String get mapHowStep3 =>
      'Zoom in to check which side of a building the line passes, and zoom out to see that the line really ends in Makkah.';

  @override
  String mapHowSunAbove(
    int azimuth,
    String direction,
    int offset,
    String side,
  ) {
    return 'The sun is now at $azimuth° (about $direction). The Qibla is $offset° to the $side of the sun: stand facing the sun, then turn that much.';
  }

  @override
  String mapHowMoonAbove(String phase, int azimuth, int offset, String side) {
    return 'The moon ($phase) is at $azimuth°. The Qibla is $offset° to the $side of it.';
  }

  @override
  String get mapHowSkyNone =>
      'Neither the sun nor the moon is up right now; use landmarks on the map.';

  @override
  String get sideLeft => 'left';

  @override
  String get sideRight => 'right';

  @override
  String get compassPointNorth => 'north';

  @override
  String get compassPointNortheast => 'north-east';

  @override
  String get compassPointEast => 'east';

  @override
  String get compassPointSoutheast => 'south-east';

  @override
  String get compassPointSouth => 'south';

  @override
  String get compassPointSouthwest => 'south-west';

  @override
  String get compassPointWest => 'west';

  @override
  String get compassPointNorthwest => 'north-west';

  @override
  String get moonPhaseNew => 'new moon';

  @override
  String get moonPhaseWaxingCrescent => 'waxing crescent';

  @override
  String get moonPhaseFirstQuarter => 'first quarter';

  @override
  String get moonPhaseWaxingGibbous => 'waxing gibbous';

  @override
  String get moonPhaseFull => 'full moon';

  @override
  String get moonPhaseWaningGibbous => 'waning gibbous';

  @override
  String get moonPhaseLastQuarter => 'last quarter';

  @override
  String get moonPhaseWaningCrescent => 'waning crescent';

  @override
  String get mapAttribution => '© OpenStreetMap contributors';

  @override
  String get mapNeedsLocation => 'Set your location to draw the Qibla line.';
}

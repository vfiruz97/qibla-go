import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_az.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_tg.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_uz.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('az'),
    Locale('de'),
    Locale('en'),
    Locale('fa'),
    Locale('fr'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('ru'),
    Locale('sv'),
    Locale('tg'),
    Locale('tr'),
    Locale('ur'),
    Locale('uz'),
    Locale('zh'),
  ];

  /// Brand name; keep in Latin letters in every language.
  ///
  /// In en, this message translates to:
  /// **'Qibla Go'**
  String get appName;

  /// Caption over the compass dial, in capitals where the script has them.
  ///
  /// In en, this message translates to:
  /// **'QIBLA'**
  String get qiblaLabel;

  /// No description provided for @fromTrueNorth.
  ///
  /// In en, this message translates to:
  /// **'from true north'**
  String get fromTrueNorth;

  /// No description provided for @fromMagneticNorth.
  ///
  /// In en, this message translates to:
  /// **'from magnetic north'**
  String get fromMagneticNorth;

  /// No description provided for @facingQibla.
  ///
  /// In en, this message translates to:
  /// **'You are facing the Qibla'**
  String get facingQibla;

  /// No description provided for @turnRight.
  ///
  /// In en, this message translates to:
  /// **'Turn right {degrees}°'**
  String turnRight(int degrees);

  /// No description provided for @turnLeft.
  ///
  /// In en, this message translates to:
  /// **'Turn left {degrees}°'**
  String turnLeft(int degrees);

  /// No description provided for @turnAround.
  ///
  /// In en, this message translates to:
  /// **'Turn around'**
  String get turnAround;

  /// No description provided for @distanceToMakkah.
  ///
  /// In en, this message translates to:
  /// **'{distance} km to Makkah'**
  String distanceToMakkah(String distance);

  /// No description provided for @atKaabaTitle.
  ///
  /// In en, this message translates to:
  /// **'You are at the Kaaba'**
  String get atKaabaTitle;

  /// No description provided for @atKaabaBody.
  ///
  /// In en, this message translates to:
  /// **'Face it directly; a bearing has no meaning this close.'**
  String get atKaabaBody;

  /// No description provided for @accuracyPlusMinus.
  ///
  /// In en, this message translates to:
  /// **'±{degrees}°'**
  String accuracyPlusMinus(int degrees);

  /// No description provided for @accuracyUnknown.
  ///
  /// In en, this message translates to:
  /// **'Accuracy unknown'**
  String get accuracyUnknown;

  /// Sensor quality grade shown next to the accuracy.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get qualityGood;

  /// Sensor quality grade: middling.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get qualityFair;

  /// Sensor quality grade: bad.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get qualityPoor;

  /// The direction the phone is pointing (compass heading), not a title.
  ///
  /// In en, this message translates to:
  /// **'Heading'**
  String get headingLabel;

  /// No description provided for @bearingSummary.
  ///
  /// In en, this message translates to:
  /// **'Qibla is {bearing}° from true north ({magnetic}° on a magnetic compass). Valid with any compass or map.'**
  String bearingSummary(int bearing, int magnetic);

  /// No description provided for @locationSetLocation.
  ///
  /// In en, this message translates to:
  /// **'Set location'**
  String get locationSetLocation;

  /// No description provided for @locationLocating.
  ///
  /// In en, this message translates to:
  /// **'Locating…'**
  String get locationLocating;

  /// No description provided for @locationOriginDevice.
  ///
  /// In en, this message translates to:
  /// **'Live location'**
  String get locationOriginDevice;

  /// No description provided for @locationOriginCached.
  ///
  /// In en, this message translates to:
  /// **'Last known location'**
  String get locationOriginCached;

  /// No description provided for @locationOriginManual.
  ///
  /// In en, this message translates to:
  /// **'Entered by hand'**
  String get locationOriginManual;

  /// No description provided for @locationAccuracyMeters.
  ///
  /// In en, this message translates to:
  /// **'±{meters} m'**
  String locationAccuracyMeters(int meters);

  /// No description provided for @locationAgeJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get locationAgeJustNow;

  /// No description provided for @locationAgeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute ago} other{{count} minutes ago}}'**
  String locationAgeMinutes(int count);

  /// No description provided for @locationAgeHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String locationAgeHours(int count);

  /// No description provided for @locationAgeDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String locationAgeDays(int count);

  /// No description provided for @locationNeededTitle.
  ///
  /// In en, this message translates to:
  /// **'Where are you?'**
  String get locationNeededTitle;

  /// No description provided for @locationNeededBody.
  ///
  /// In en, this message translates to:
  /// **'The Qibla direction depends on where you stand. Allow location access, or enter your coordinates. Your location never leaves this device.'**
  String get locationNeededBody;

  /// No description provided for @locationUseMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get locationUseMyLocation;

  /// No description provided for @locationEnterCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Enter coordinates'**
  String get locationEnterCoordinates;

  /// No description provided for @locationLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get locationLatitude;

  /// No description provided for @locationLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get locationLongitude;

  /// No description provided for @locationLatitudeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 38.5598'**
  String get locationLatitudeHint;

  /// No description provided for @locationLongitudeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 68.7870'**
  String get locationLongitudeHint;

  /// No description provided for @locationInvalidLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude must be between -90 and 90'**
  String get locationInvalidLatitude;

  /// No description provided for @locationInvalidLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude must be between -180 and 180'**
  String get locationInvalidLongitude;

  /// Button that applies hand-entered coordinates.
  ///
  /// In en, this message translates to:
  /// **'Use these coordinates'**
  String get locationSave;

  /// No description provided for @locationOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get locationOpenSettings;

  /// No description provided for @locationProblemServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are turned off on this device.'**
  String get locationProblemServicesDisabled;

  /// No description provided for @locationProblemPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission was not granted.'**
  String get locationProblemPermissionDenied;

  /// No description provided for @locationProblemPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission is blocked. Allow it in the system settings.'**
  String get locationProblemPermissionDeniedForever;

  /// No description provided for @locationProblemTimeout.
  ///
  /// In en, this message translates to:
  /// **'Could not get a position in time. Try near a window or outdoors.'**
  String get locationProblemTimeout;

  /// No description provided for @locationProblemUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not determine your position.'**
  String get locationProblemUnavailable;

  /// No description provided for @locationStaleNote.
  ///
  /// In en, this message translates to:
  /// **'Using a saved position. If you have travelled since, refresh it.'**
  String get locationStaleNote;

  /// No description provided for @locationSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Your location'**
  String get locationSheetTitle;

  /// No description provided for @locationCoordinates.
  ///
  /// In en, this message translates to:
  /// **'{latitude}, {longitude}'**
  String locationCoordinates(String latitude, String longitude);

  /// No description provided for @compassCheckingTitle.
  ///
  /// In en, this message translates to:
  /// **'Checking the compass…'**
  String get compassCheckingTitle;

  /// No description provided for @compassWaitingTitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the sensor…'**
  String get compassWaitingTitle;

  /// No description provided for @compassWaitingBody.
  ///
  /// In en, this message translates to:
  /// **'Move the phone gently if this takes more than a moment.'**
  String get compassWaitingBody;

  /// No description provided for @compassStaleTitle.
  ///
  /// In en, this message translates to:
  /// **'The compass stopped responding'**
  String get compassStaleTitle;

  /// No description provided for @compassStaleBody.
  ///
  /// In en, this message translates to:
  /// **'Readings have paused. Move the phone a little, or restart the app.'**
  String get compassStaleBody;

  /// No description provided for @compassNoSensorTitle.
  ///
  /// In en, this message translates to:
  /// **'No compass on this device'**
  String get compassNoSensorTitle;

  /// No description provided for @compassNoSensorBody.
  ///
  /// In en, this message translates to:
  /// **'This device has no magnetometer, so it cannot show a live direction. The bearing below still works with any physical compass or a map.'**
  String get compassNoSensorBody;

  /// No description provided for @compassBrowserNoSensorTitle.
  ///
  /// In en, this message translates to:
  /// **'No compass in this browser'**
  String get compassBrowserNoSensorTitle;

  /// No description provided for @compassBrowserNoSensorBody.
  ///
  /// In en, this message translates to:
  /// **'Desktop browsers have no orientation sensors. Open Qibla Go on a phone, or use the bearing below with a compass or a map.'**
  String get compassBrowserNoSensorBody;

  /// No description provided for @compassPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow motion access'**
  String get compassPermissionTitle;

  /// No description provided for @compassPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Your browser needs permission to read the phone\'s orientation.'**
  String get compassPermissionBody;

  /// No description provided for @compassPermissionButton.
  ///
  /// In en, this message translates to:
  /// **'Enable compass'**
  String get compassPermissionButton;

  /// No description provided for @compassPermissionDeniedBody.
  ///
  /// In en, this message translates to:
  /// **'Motion access was declined. Allow it in the browser settings and reload.'**
  String get compassPermissionDeniedBody;

  /// No description provided for @compassRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get compassRetry;

  /// No description provided for @compassPausedTitle.
  ///
  /// In en, this message translates to:
  /// **'Compass paused'**
  String get compassPausedTitle;

  /// No description provided for @issueInterferenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Magnetic interference'**
  String get issueInterferenceTitle;

  /// No description provided for @issueInterferenceBody.
  ///
  /// In en, this message translates to:
  /// **'Something magnetic or metal is nearby: a laptop, a car, a phone case with a magnet. The direction is hidden until the field is clean. Step away and try again.'**
  String get issueInterferenceBody;

  /// No description provided for @issueMovingFastTitle.
  ///
  /// In en, this message translates to:
  /// **'You seem to be in a vehicle'**
  String get issueMovingFastTitle;

  /// No description provided for @issueMovingFastBody.
  ///
  /// In en, this message translates to:
  /// **'A compass cannot be trusted inside a moving car or train. Stop and step outside to check the direction.'**
  String get issueMovingFastBody;

  /// No description provided for @issueCalibrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Calibrate your compass'**
  String get issueCalibrationTitle;

  /// No description provided for @issueCalibrationBody.
  ///
  /// In en, this message translates to:
  /// **'Move the phone in a figure of eight a few times, away from metal.'**
  String get issueCalibrationBody;

  /// No description provided for @issueNotFlatTitle.
  ///
  /// In en, this message translates to:
  /// **'Hold the phone flat'**
  String get issueNotFlatTitle;

  /// No description provided for @issueNotFlatBody.
  ///
  /// In en, this message translates to:
  /// **'Keep the screen facing the sky for the steadiest reading.'**
  String get issueNotFlatBody;

  /// No description provided for @issueBrowserTitle.
  ///
  /// In en, this message translates to:
  /// **'Browser compass'**
  String get issueBrowserTitle;

  /// No description provided for @issueBrowserBody.
  ///
  /// In en, this message translates to:
  /// **'Browsers give a rough heading and cannot detect interference. Before praying, confirm with the bearing below and a real compass if you can.'**
  String get issueBrowserBody;

  /// No description provided for @issueLowAccuracyTitle.
  ///
  /// In en, this message translates to:
  /// **'Low accuracy'**
  String get issueLowAccuracyTitle;

  /// No description provided for @issueLowAccuracyBody.
  ///
  /// In en, this message translates to:
  /// **'The sensor reports a large error right now. Calibrate, then check again.'**
  String get issueLowAccuracyBody;

  /// No description provided for @declinationExtrapolatedNote.
  ///
  /// In en, this message translates to:
  /// **'This app\'s magnetic model has expired. Update the app for the best accuracy.'**
  String get declinationExtrapolatedNote;

  /// No description provided for @detailsButton.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsButton;

  /// No description provided for @detailsTitle.
  ///
  /// In en, this message translates to:
  /// **'How this direction was computed'**
  String get detailsTitle;

  /// No description provided for @detailsSource.
  ///
  /// In en, this message translates to:
  /// **'Sensor'**
  String get detailsSource;

  /// No description provided for @detailsMagneticHeading.
  ///
  /// In en, this message translates to:
  /// **'Magnetic heading'**
  String get detailsMagneticHeading;

  /// No description provided for @detailsDeclination.
  ///
  /// In en, this message translates to:
  /// **'Declination (WMM2025)'**
  String get detailsDeclination;

  /// No description provided for @detailsTrueHeading.
  ///
  /// In en, this message translates to:
  /// **'True heading'**
  String get detailsTrueHeading;

  /// No description provided for @detailsPlatformTrueHeading.
  ///
  /// In en, this message translates to:
  /// **'Platform true heading'**
  String get detailsPlatformTrueHeading;

  /// No description provided for @detailsAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Reported accuracy'**
  String get detailsAccuracy;

  /// No description provided for @detailsConfidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get detailsConfidence;

  /// No description provided for @detailsPitch.
  ///
  /// In en, this message translates to:
  /// **'Tilt'**
  String get detailsPitch;

  /// No description provided for @detailsField.
  ///
  /// In en, this message translates to:
  /// **'Field strength'**
  String get detailsField;

  /// No description provided for @detailsFieldExpected.
  ///
  /// In en, this message translates to:
  /// **'Expected field'**
  String get detailsFieldExpected;

  /// No description provided for @detailsBearing.
  ///
  /// In en, this message translates to:
  /// **'Qibla bearing (true)'**
  String get detailsBearing;

  /// No description provided for @detailsBearingMagnetic.
  ///
  /// In en, this message translates to:
  /// **'Qibla bearing (magnetic)'**
  String get detailsBearingMagnetic;

  /// No description provided for @detailsDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance to the Kaaba'**
  String get detailsDistance;

  /// No description provided for @detailsLocation.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get detailsLocation;

  /// No description provided for @detailsKaaba.
  ///
  /// In en, this message translates to:
  /// **'Kaaba'**
  String get detailsKaaba;

  /// No description provided for @detailsMethod.
  ///
  /// In en, this message translates to:
  /// **'Great-circle initial bearing on WGS-84 coordinates; true north from the magnetic heading plus WMM2025 declination computed on this device.'**
  String get detailsMethod;

  /// Shown in place of a value that is not available; keep the dash.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get detailsNotAvailable;

  /// No description provided for @detailsSimulateToggle.
  ///
  /// In en, this message translates to:
  /// **'Simulate compass (debug build only)'**
  String get detailsSimulateToggle;

  /// No description provided for @detailsSimulateHeading.
  ///
  /// In en, this message translates to:
  /// **'Simulated heading'**
  String get detailsSimulateHeading;

  /// Debug-only button in Details that shows the rating sheet on demand.
  ///
  /// In en, this message translates to:
  /// **'Preview the rating prompt (debug build only)'**
  String get detailsPreviewRating;

  /// No description provided for @footerFree.
  ///
  /// In en, this message translates to:
  /// **'Free, forever. No ads, no accounts.'**
  String get footerFree;

  /// Statement of intention: the app is made seeking God's pleasure.
  ///
  /// In en, this message translates to:
  /// **'Made for the pleasure of God.'**
  String get footerIntention;

  /// Single-letter compass point painted on the dial: north.
  ///
  /// In en, this message translates to:
  /// **'N'**
  String get cardinalN;

  /// Single-letter compass point painted on the dial: east.
  ///
  /// In en, this message translates to:
  /// **'E'**
  String get cardinalE;

  /// Single-letter compass point painted on the dial: south.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get cardinalS;

  /// Single-letter compass point painted on the dial: west.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get cardinalW;

  /// No description provided for @introTagline.
  ///
  /// In en, this message translates to:
  /// **'Face the Kaaba, wherever you are'**
  String get introTagline;

  /// Button that skips the opening animation.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get introSkip;

  /// No description provided for @desktopPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'On the web, the map'**
  String get desktopPromptTitle;

  /// No description provided for @desktopPromptBody.
  ///
  /// In en, this message translates to:
  /// **'The live compass is in the phone app, where it can use the motion sensors. On the web, Qibla Go shows the direction on a map instead, with the sun and the moon to help you orient yourself.'**
  String get desktopPromptBody;

  /// No description provided for @desktopPromptContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue to the map'**
  String get desktopPromptContinue;

  /// No description provided for @navCompass.
  ///
  /// In en, this message translates to:
  /// **'Compass'**
  String get navCompass;

  /// No description provided for @navMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get navMap;

  /// No description provided for @mapTitle.
  ///
  /// In en, this message translates to:
  /// **'Qibla on the map'**
  String get mapTitle;

  /// Label on the marker that stands for the user on the map.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get mapYourLocation;

  /// No description provided for @mapKaaba.
  ///
  /// In en, this message translates to:
  /// **'Kaaba, Makkah'**
  String get mapKaaba;

  /// No description provided for @mapQiblaLine.
  ///
  /// In en, this message translates to:
  /// **'Qibla line'**
  String get mapQiblaLine;

  /// No description provided for @mapSun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get mapSun;

  /// No description provided for @mapMoon.
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get mapMoon;

  /// Label beside the sun or moon marker on the map: name is mapSun or mapMoon, azimuth in degrees.
  ///
  /// In en, this message translates to:
  /// **'{name} {azimuth}°'**
  String skyMarkerLabel(String name, int azimuth);

  /// No description provided for @mapRecenter.
  ///
  /// In en, this message translates to:
  /// **'Use my real location'**
  String get mapRecenter;

  /// Tooltip of the zoom-in button.
  ///
  /// In en, this message translates to:
  /// **'Closer'**
  String get mapZoomIn;

  /// Tooltip of the zoom-out button.
  ///
  /// In en, this message translates to:
  /// **'Farther'**
  String get mapZoomOut;

  /// No description provided for @mapLongPressHint.
  ///
  /// In en, this message translates to:
  /// **'Long-press anywhere on the map to set your location there.'**
  String get mapLongPressHint;

  /// No description provided for @mapHowTitle.
  ///
  /// In en, this message translates to:
  /// **'How to use this map'**
  String get mapHowTitle;

  /// No description provided for @mapHowStep1.
  ///
  /// In en, this message translates to:
  /// **'The gold line starts where you are and runs straight to the Kaaba. Prayer faces along this line.'**
  String get mapHowStep1;

  /// No description provided for @mapHowStep2.
  ///
  /// In en, this message translates to:
  /// **'Find something the line crosses near you: a road, a tall building, a hill, a bridge. Stand so that you face it, and you face the Qibla.'**
  String get mapHowStep2;

  /// No description provided for @mapHowStep3.
  ///
  /// In en, this message translates to:
  /// **'Zoom in to check which side of a building the line passes, and zoom out to see that the line really ends in Makkah.'**
  String get mapHowStep3;

  /// direction is one of the compassPoint* strings, side is sideLeft or sideRight.
  ///
  /// In en, this message translates to:
  /// **'The sun is now at {azimuth}° (about {direction}). The Qibla is {offset}° to the {side} of the sun: stand facing the sun, then turn that much.'**
  String mapHowSunAbove(int azimuth, String direction, int offset, String side);

  /// phase is one of the moonPhase* strings, side is sideLeft or sideRight.
  ///
  /// In en, this message translates to:
  /// **'The moon ({phase}) is at {azimuth}°. The Qibla is {offset}° to the {side} of it.'**
  String mapHowMoonAbove(String phase, int azimuth, int offset, String side);

  /// No description provided for @mapHowSkyNone.
  ///
  /// In en, this message translates to:
  /// **'Neither the sun nor the moon is up right now; use landmarks on the map.'**
  String get mapHowSkyNone;

  /// Physical left of the person, inserted into mapHowSunAbove and mapHowMoonAbove.
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get sideLeft;

  /// Physical right of the person, inserted into mapHowSunAbove and mapHowMoonAbove.
  ///
  /// In en, this message translates to:
  /// **'right'**
  String get sideRight;

  /// Lower-case compass point used inside a sentence (mapHowSunAbove).
  ///
  /// In en, this message translates to:
  /// **'north'**
  String get compassPointNorth;

  /// No description provided for @compassPointNortheast.
  ///
  /// In en, this message translates to:
  /// **'north-east'**
  String get compassPointNortheast;

  /// No description provided for @compassPointEast.
  ///
  /// In en, this message translates to:
  /// **'east'**
  String get compassPointEast;

  /// No description provided for @compassPointSoutheast.
  ///
  /// In en, this message translates to:
  /// **'south-east'**
  String get compassPointSoutheast;

  /// No description provided for @compassPointSouth.
  ///
  /// In en, this message translates to:
  /// **'south'**
  String get compassPointSouth;

  /// No description provided for @compassPointSouthwest.
  ///
  /// In en, this message translates to:
  /// **'south-west'**
  String get compassPointSouthwest;

  /// No description provided for @compassPointWest.
  ///
  /// In en, this message translates to:
  /// **'west'**
  String get compassPointWest;

  /// No description provided for @compassPointNorthwest.
  ///
  /// In en, this message translates to:
  /// **'north-west'**
  String get compassPointNorthwest;

  /// No description provided for @moonPhaseNew.
  ///
  /// In en, this message translates to:
  /// **'new moon'**
  String get moonPhaseNew;

  /// No description provided for @moonPhaseWaxingCrescent.
  ///
  /// In en, this message translates to:
  /// **'waxing crescent'**
  String get moonPhaseWaxingCrescent;

  /// No description provided for @moonPhaseFirstQuarter.
  ///
  /// In en, this message translates to:
  /// **'first quarter'**
  String get moonPhaseFirstQuarter;

  /// No description provided for @moonPhaseWaxingGibbous.
  ///
  /// In en, this message translates to:
  /// **'waxing gibbous'**
  String get moonPhaseWaxingGibbous;

  /// No description provided for @moonPhaseFull.
  ///
  /// In en, this message translates to:
  /// **'full moon'**
  String get moonPhaseFull;

  /// No description provided for @moonPhaseWaningGibbous.
  ///
  /// In en, this message translates to:
  /// **'waning gibbous'**
  String get moonPhaseWaningGibbous;

  /// No description provided for @moonPhaseLastQuarter.
  ///
  /// In en, this message translates to:
  /// **'last quarter'**
  String get moonPhaseLastQuarter;

  /// No description provided for @moonPhaseWaningCrescent.
  ///
  /// In en, this message translates to:
  /// **'waning crescent'**
  String get moonPhaseWaningCrescent;

  /// No description provided for @mapAttribution.
  ///
  /// In en, this message translates to:
  /// **'© OpenStreetMap contributors'**
  String get mapAttribution;

  /// No description provided for @mapNeedsLocation.
  ///
  /// In en, this message translates to:
  /// **'Set your location to draw the Qibla line.'**
  String get mapNeedsLocation;

  /// No description provided for @supportButton.
  ///
  /// In en, this message translates to:
  /// **'Write to us'**
  String get supportButton;

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Write to us'**
  String get supportTitle;

  /// No description provided for @supportIntro.
  ///
  /// In en, this message translates to:
  /// **'A direction that looks wrong somewhere, a bug, an idea, or just a salam. Every message is read.'**
  String get supportIntro;

  /// No description provided for @supportMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get supportMessageLabel;

  /// No description provided for @supportMessageHint.
  ///
  /// In en, this message translates to:
  /// **'What happened, and where?'**
  String get supportMessageHint;

  /// No description provided for @supportContactLabel.
  ///
  /// In en, this message translates to:
  /// **'How to reach you (optional)'**
  String get supportContactLabel;

  /// No description provided for @supportContactHint.
  ///
  /// In en, this message translates to:
  /// **'Email or anything you like, only if you want a reply'**
  String get supportContactHint;

  /// No description provided for @supportChallengeLabel.
  ///
  /// In en, this message translates to:
  /// **'Quick check: what is {question}?'**
  String supportChallengeLabel(String question);

  /// No description provided for @supportChallengeLoading.
  ///
  /// In en, this message translates to:
  /// **'Getting a question…'**
  String get supportChallengeLoading;

  /// No description provided for @supportChallengeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No question available right now.'**
  String get supportChallengeUnavailable;

  /// Hint in the answer field of the arithmetic check; keep the equals sign.
  ///
  /// In en, this message translates to:
  /// **'='**
  String get supportAnswerHint;

  /// No description provided for @supportNewQuestion.
  ///
  /// In en, this message translates to:
  /// **'New question'**
  String get supportNewQuestion;

  /// No description provided for @supportSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get supportSend;

  /// No description provided for @supportSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get supportSending;

  /// Title after a message was delivered.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get supportSentTitle;

  /// No description provided for @supportSentBody.
  ///
  /// In en, this message translates to:
  /// **'Thank you for writing. JazakAllahu khairan.'**
  String get supportSentBody;

  /// No description provided for @supportClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get supportClose;

  /// No description provided for @supportPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'No location or device data is sent with your message.'**
  String get supportPrivacyNote;

  /// No description provided for @supportErrorOffline.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server. Check your connection and try again; your text is kept.'**
  String get supportErrorOffline;

  /// No description provided for @supportErrorTooMany.
  ///
  /// In en, this message translates to:
  /// **'Too many messages from this connection in the last hour. Please try again later.'**
  String get supportErrorTooMany;

  /// No description provided for @supportErrorWrongAnswer.
  ///
  /// In en, this message translates to:
  /// **'That answer was not right. Please try the new question.'**
  String get supportErrorWrongAnswer;

  /// No description provided for @supportErrorExpired.
  ///
  /// In en, this message translates to:
  /// **'That question expired. Please try the new one.'**
  String get supportErrorExpired;

  /// No description provided for @supportErrorInvalid.
  ///
  /// In en, this message translates to:
  /// **'The server could not accept this message. Please shorten it and try again.'**
  String get supportErrorInvalid;

  /// No description provided for @supportErrorTooShort.
  ///
  /// In en, this message translates to:
  /// **'Please write at least 10 characters.'**
  String get supportErrorTooShort;

  /// No description provided for @supportErrorTooLong.
  ///
  /// In en, this message translates to:
  /// **'Please keep it under 2000 characters.'**
  String get supportErrorTooLong;

  /// No description provided for @supportErrorAnswerMissing.
  ///
  /// In en, this message translates to:
  /// **'Please answer the quick check with a number.'**
  String get supportErrorAnswerMissing;

  /// Headline of the one-time sheet asking for a store rating.
  ///
  /// In en, this message translates to:
  /// **'Enjoying Qibla Go?'**
  String get ratingTitle;

  /// Why a rating matters, Android wording. Keep the three facts: free, no ads, helps others find and trust the app.
  ///
  /// In en, this message translates to:
  /// **'Qibla Go is free and has no ads. A rating on Google Play helps other people find it and trust it.'**
  String get ratingBodyGooglePlay;

  /// Same as ratingBodyGooglePlay for iPhone and Mac, naming the App Store.
  ///
  /// In en, this message translates to:
  /// **'Qibla Go is free and has no ads. A rating on the App Store helps other people find it and trust it.'**
  String get ratingBodyAppStore;

  /// No description provided for @ratingRate.
  ///
  /// In en, this message translates to:
  /// **'Rate Qibla Go'**
  String get ratingRate;

  /// No description provided for @ratingNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get ratingNotNow;

  /// Small print under the buttons: the sheet is shown once and never after a no.
  ///
  /// In en, this message translates to:
  /// **'We ask once. If you say no, we will not ask again.'**
  String get ratingFootnote;

  /// Shown when neither the review card nor the store listing could be opened.
  ///
  /// In en, this message translates to:
  /// **'Could not open the store. Please try again later.'**
  String get ratingOpenFailed;

  /// Link in Details that opens the store listing; Android wording.
  ///
  /// In en, this message translates to:
  /// **'Rate on Google Play'**
  String get ratingStoreLinkGooglePlay;

  /// Link in Details that opens the store listing; iPhone and Mac wording.
  ///
  /// In en, this message translates to:
  /// **'Rate on the App Store'**
  String get ratingStoreLinkAppStore;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'az',
    'de',
    'en',
    'fa',
    'fr',
    'id',
    'it',
    'ja',
    'ko',
    'ru',
    'sv',
    'tg',
    'tr',
    'ur',
    'uz',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'az':
      return AppLocalizationsAz();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
    case 'fr':
      return AppLocalizationsFr();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sv':
      return AppLocalizationsSv();
    case 'tg':
      return AppLocalizationsTg();
    case 'tr':
      return AppLocalizationsTr();
    case 'ur':
      return AppLocalizationsUr();
    case 'uz':
      return AppLocalizationsUz();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

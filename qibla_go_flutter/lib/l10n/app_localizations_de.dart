// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Qibla Go';

  @override
  String get qiblaLabel => 'QIBLA';

  @override
  String get fromTrueNorth => 'ab geografisch Nord';

  @override
  String get fromMagneticNorth => 'ab magnetisch Nord';

  @override
  String get facingQibla => 'Sie blicken zur Qibla';

  @override
  String turnRight(int degrees) {
    return '$degrees° nach rechts drehen';
  }

  @override
  String turnLeft(int degrees) {
    return '$degrees° nach links drehen';
  }

  @override
  String get turnAround => 'Umdrehen';

  @override
  String distanceToMakkah(String distance) {
    return '$distance km bis Mekka';
  }

  @override
  String get atKaabaTitle => 'Sie sind an der Kaaba';

  @override
  String get atKaabaBody =>
      'Wenden Sie sich ihr direkt zu; so nah hat eine Richtung keine Bedeutung.';

  @override
  String accuracyPlusMinus(int degrees) {
    return '±$degrees°';
  }

  @override
  String get accuracyUnknown => 'Genauigkeit unbekannt';

  @override
  String get qualityGood => 'Gut';

  @override
  String get qualityFair => 'Mäßig';

  @override
  String get qualityPoor => 'Schlecht';

  @override
  String get headingLabel => 'Blickrichtung';

  @override
  String bearingSummary(int bearing, int magnetic) {
    return 'Die Qibla liegt $bearing° ab geografisch Nord ($magnetic° auf einem Magnetkompass). Gilt für jeden Kompass und jede Karte.';
  }

  @override
  String get locationSetLocation => 'Standort festlegen';

  @override
  String get locationLocating => 'Standort wird bestimmt…';

  @override
  String get locationOriginDevice => 'Aktueller Standort';

  @override
  String get locationOriginCached => 'Letzter bekannter Standort';

  @override
  String get locationOriginManual => 'Von Hand eingegeben';

  @override
  String locationAccuracyMeters(int meters) {
    return '±$meters m';
  }

  @override
  String get locationAgeJustNow => 'gerade eben';

  @override
  String locationAgeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Minuten',
      one: 'vor 1 Minute',
    );
    return '$_temp0';
  }

  @override
  String locationAgeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Stunden',
      one: 'vor 1 Stunde',
    );
    return '$_temp0';
  }

  @override
  String locationAgeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Tagen',
      one: 'vor 1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get locationNeededTitle => 'Wo sind Sie?';

  @override
  String get locationNeededBody =>
      'Die Qibla-Richtung hängt davon ab, wo Sie stehen. Erlauben Sie den Standortzugriff oder geben Sie Ihre Koordinaten ein. Ihr Standort verlässt dieses Gerät nie.';

  @override
  String get locationUseMyLocation => 'Meinen Standort verwenden';

  @override
  String get locationEnterCoordinates => 'Koordinaten eingeben';

  @override
  String get locationLatitude => 'Breitengrad';

  @override
  String get locationLongitude => 'Längengrad';

  @override
  String get locationLatitudeHint => 'z. B. 38,5598';

  @override
  String get locationLongitudeHint => 'z. B. 68,7870';

  @override
  String get locationInvalidLatitude =>
      'Der Breitengrad muss zwischen -90 und 90 liegen';

  @override
  String get locationInvalidLongitude =>
      'Der Längengrad muss zwischen -180 und 180 liegen';

  @override
  String get locationSave => 'Diese Koordinaten verwenden';

  @override
  String get locationOpenSettings => 'Einstellungen öffnen';

  @override
  String get locationProblemServicesDisabled =>
      'Die Ortungsdienste sind auf diesem Gerät ausgeschaltet.';

  @override
  String get locationProblemPermissionDenied =>
      'Die Standortberechtigung wurde nicht erteilt.';

  @override
  String get locationProblemPermissionDeniedForever =>
      'Die Standortberechtigung ist blockiert. Erlauben Sie sie in den Systemeinstellungen.';

  @override
  String get locationProblemTimeout =>
      'Die Position konnte nicht rechtzeitig bestimmt werden. Versuchen Sie es am Fenster oder im Freien.';

  @override
  String get locationProblemUnavailable =>
      'Ihre Position konnte nicht bestimmt werden.';

  @override
  String get locationStaleNote =>
      'Es wird eine gespeicherte Position verwendet. Wenn Sie seitdem gereist sind, aktualisieren Sie sie.';

  @override
  String get locationSheetTitle => 'Ihr Standort';

  @override
  String locationCoordinates(String latitude, String longitude) {
    return '$latitude, $longitude';
  }

  @override
  String get compassCheckingTitle => 'Kompass wird geprüft…';

  @override
  String get compassWaitingTitle => 'Warten auf den Sensor…';

  @override
  String get compassWaitingBody =>
      'Bewegen Sie das Telefon leicht, wenn es länger als einen Moment dauert.';

  @override
  String get compassStaleTitle => 'Der Kompass reagiert nicht mehr';

  @override
  String get compassStaleBody =>
      'Die Messwerte sind ausgeblieben. Bewegen Sie das Telefon ein wenig oder starten Sie die App neu.';

  @override
  String get compassNoSensorTitle => 'Kein Kompass auf diesem Gerät';

  @override
  String get compassNoSensorBody =>
      'Dieses Gerät hat kein Magnetometer und kann daher keine Live-Richtung anzeigen. Die Gradzahl unten funktioniert trotzdem mit jedem echten Kompass oder einer Karte.';

  @override
  String get compassBrowserNoSensorTitle => 'Kein Kompass in diesem Browser';

  @override
  String get compassBrowserNoSensorBody =>
      'Desktop-Browser haben keine Lagesensoren. Öffnen Sie Qibla Go auf einem Telefon oder nutzen Sie die Gradzahl unten mit einem Kompass oder einer Karte.';

  @override
  String get compassPermissionTitle => 'Bewegungszugriff erlauben';

  @override
  String get compassPermissionBody =>
      'Ihr Browser braucht die Berechtigung, die Ausrichtung des Telefons zu lesen.';

  @override
  String get compassPermissionButton => 'Kompass aktivieren';

  @override
  String get compassPermissionDeniedBody =>
      'Der Bewegungszugriff wurde abgelehnt. Erlauben Sie ihn in den Browser-Einstellungen und laden Sie die Seite neu.';

  @override
  String get compassRetry => 'Erneut versuchen';

  @override
  String get compassPausedTitle => 'Kompass pausiert';

  @override
  String get issueInterferenceTitle => 'Magnetische Störung';

  @override
  String get issueInterferenceBody =>
      'Etwas Magnetisches oder Metallisches ist in der Nähe: ein Laptop, ein Auto, eine Handyhülle mit Magnet. Die Richtung bleibt verborgen, bis das Feld sauber ist. Gehen Sie ein paar Schritte weg und versuchen Sie es erneut.';

  @override
  String get issueMovingFastTitle => 'Sie scheinen in einem Fahrzeug zu sein';

  @override
  String get issueMovingFastBody =>
      'In einem fahrenden Auto oder Zug ist ein Kompass nicht verlässlich. Halten Sie an und prüfen Sie die Richtung draußen.';

  @override
  String get issueCalibrationTitle => 'Kompass kalibrieren';

  @override
  String get issueCalibrationBody =>
      'Bewegen Sie das Telefon einige Male in einer Acht, fern von Metall.';

  @override
  String get issueNotFlatTitle => 'Telefon flach halten';

  @override
  String get issueNotFlatBody =>
      'Richten Sie den Bildschirm zum Himmel, dann ist die Messung am ruhigsten.';

  @override
  String get issueBrowserTitle => 'Browser-Kompass';

  @override
  String get issueBrowserBody =>
      'Browser liefern nur eine grobe Richtung und erkennen keine Störungen. Prüfen Sie vor dem Gebet mit der Gradzahl unten und, wenn möglich, mit einem echten Kompass.';

  @override
  String get issueLowAccuracyTitle => 'Geringe Genauigkeit';

  @override
  String get issueLowAccuracyBody =>
      'Der Sensor meldet gerade einen großen Fehler. Kalibrieren Sie und prüfen Sie erneut.';

  @override
  String get declinationExtrapolatedNote =>
      'Das Magnetfeldmodell dieser App ist abgelaufen. Aktualisieren Sie die App für die beste Genauigkeit.';

  @override
  String get detailsButton => 'Details';

  @override
  String get detailsTitle => 'So wurde diese Richtung berechnet';

  @override
  String get detailsSource => 'Sensor';

  @override
  String get detailsMagneticHeading => 'Magnetische Richtung';

  @override
  String get detailsDeclination => 'Deklination (WMM2025)';

  @override
  String get detailsTrueHeading => 'Geografische Richtung';

  @override
  String get detailsPlatformTrueHeading => 'Geografische Richtung (System)';

  @override
  String get detailsAccuracy => 'Gemeldete Genauigkeit';

  @override
  String get detailsConfidence => 'Vertrauen';

  @override
  String get detailsPitch => 'Neigung';

  @override
  String get detailsField => 'Feldstärke';

  @override
  String get detailsFieldExpected => 'Erwartetes Feld';

  @override
  String get detailsBearing => 'Qibla-Peilung (geografisch)';

  @override
  String get detailsBearingMagnetic => 'Qibla-Peilung (magnetisch)';

  @override
  String get detailsDistance => 'Entfernung zur Kaaba';

  @override
  String get detailsLocation => 'Position';

  @override
  String get detailsKaaba => 'Kaaba';

  @override
  String get detailsMethod =>
      'Anfangskurs des Großkreises auf WGS-84-Koordinaten; geografisch Nord aus der magnetischen Richtung plus der auf diesem Gerät berechneten WMM2025-Deklination.';

  @override
  String get detailsNotAvailable => '—';

  @override
  String get detailsSimulateToggle => 'Kompass simulieren (nur Debug-Build)';

  @override
  String get detailsSimulateHeading => 'Simulierte Richtung';

  @override
  String get detailsPreviewRating =>
      'Bewertungsabfrage ansehen (nur Debug-Build)';

  @override
  String get footerFree => 'Kostenlos, für immer. Keine Werbung, keine Konten.';

  @override
  String get footerIntention => 'Gemacht um Gottes Wohlgefallen willen.';

  @override
  String get cardinalN => 'N';

  @override
  String get cardinalE => 'O';

  @override
  String get cardinalS => 'S';

  @override
  String get cardinalW => 'W';

  @override
  String get introTagline => 'Zur Kaaba blicken, wo immer Sie sind';

  @override
  String get introSkip => 'Überspringen';

  @override
  String get desktopPromptTitle => 'Im Web: die Karte';

  @override
  String get desktopPromptBody =>
      'Der Live-Kompass ist in der Telefon-App, wo er die Bewegungssensoren nutzen kann. Im Web zeigt Qibla Go die Richtung stattdessen auf einer Karte, mit Sonne und Mond zur Orientierung.';

  @override
  String get desktopPromptContinue => 'Weiter zur Karte';

  @override
  String get navCompass => 'Kompass';

  @override
  String get navMap => 'Karte';

  @override
  String get mapTitle => 'Qibla auf der Karte';

  @override
  String get mapYourLocation => 'Sie';

  @override
  String get mapKaaba => 'Kaaba, Mekka';

  @override
  String get mapQiblaLine => 'Qibla-Linie';

  @override
  String get mapSun => 'Sonne';

  @override
  String get mapMoon => 'Mond';

  @override
  String skyMarkerLabel(String name, int azimuth) {
    return '$name $azimuth°';
  }

  @override
  String get mapRecenter => 'Meinen echten Standort verwenden';

  @override
  String get mapZoomIn => 'Näher';

  @override
  String get mapZoomOut => 'Weiter weg';

  @override
  String get mapLongPressHint =>
      'Halten Sie eine Stelle auf der Karte gedrückt, um Ihren Standort dort festzulegen.';

  @override
  String get mapHowTitle => 'So nutzen Sie diese Karte';

  @override
  String get mapHowStep1 =>
      'Die goldene Linie beginnt bei Ihnen und führt gerade zur Kaaba. Das Gebet richtet sich entlang dieser Linie.';

  @override
  String get mapHowStep2 =>
      'Suchen Sie etwas in Ihrer Nähe, das die Linie kreuzt: eine Straße, ein hohes Gebäude, einen Hügel, eine Brücke. Stellen Sie sich so hin, dass Sie darauf blicken, dann blicken Sie zur Qibla.';

  @override
  String get mapHowStep3 =>
      'Zoomen Sie hinein, um zu sehen, an welcher Seite eines Gebäudes die Linie vorbeiführt, und hinaus, um zu sehen, dass die Linie wirklich in Mekka endet.';

  @override
  String mapHowSunAbove(
    int azimuth,
    String direction,
    int offset,
    String side,
  ) {
    return 'Die Sonne steht jetzt bei $azimuth° (etwa $direction). Die Qibla liegt $offset° $side von der Sonne: Blicken Sie zur Sonne und drehen Sie sich dann um so viel.';
  }

  @override
  String mapHowMoonAbove(String phase, int azimuth, int offset, String side) {
    return 'Der Mond ($phase) steht bei $azimuth°. Die Qibla liegt $offset° $side von ihm.';
  }

  @override
  String get mapHowSkyNone =>
      'Weder Sonne noch Mond sind gerade zu sehen; nutzen Sie Orientierungspunkte auf der Karte.';

  @override
  String get sideLeft => 'links';

  @override
  String get sideRight => 'rechts';

  @override
  String get compassPointNorth => 'Norden';

  @override
  String get compassPointNortheast => 'Nordosten';

  @override
  String get compassPointEast => 'Osten';

  @override
  String get compassPointSoutheast => 'Südosten';

  @override
  String get compassPointSouth => 'Süden';

  @override
  String get compassPointSouthwest => 'Südwesten';

  @override
  String get compassPointWest => 'Westen';

  @override
  String get compassPointNorthwest => 'Nordwesten';

  @override
  String get moonPhaseNew => 'Neumond';

  @override
  String get moonPhaseWaxingCrescent => 'zunehmende Sichel';

  @override
  String get moonPhaseFirstQuarter => 'erstes Viertel';

  @override
  String get moonPhaseWaxingGibbous => 'zunehmender Mond';

  @override
  String get moonPhaseFull => 'Vollmond';

  @override
  String get moonPhaseWaningGibbous => 'abnehmender Mond';

  @override
  String get moonPhaseLastQuarter => 'letztes Viertel';

  @override
  String get moonPhaseWaningCrescent => 'abnehmende Sichel';

  @override
  String get mapAttribution => '© OpenStreetMap-Mitwirkende';

  @override
  String get mapNeedsLocation =>
      'Legen Sie Ihren Standort fest, um die Qibla-Linie zu zeichnen.';

  @override
  String get supportButton => 'Schreiben Sie uns';

  @override
  String get supportTitle => 'Schreiben Sie uns';

  @override
  String get supportIntro =>
      'Eine Richtung, die irgendwo falsch aussieht, ein Fehler, eine Idee oder einfach ein Salam. Jede Nachricht wird gelesen.';

  @override
  String get supportMessageLabel => 'Ihre Nachricht';

  @override
  String get supportMessageHint => 'Was ist passiert, und wo?';

  @override
  String get supportContactLabel => 'Wie wir Sie erreichen (optional)';

  @override
  String get supportContactHint =>
      'E-Mail oder was Sie möchten, nur wenn Sie eine Antwort wünschen';

  @override
  String supportChallengeLabel(String question) {
    return 'Kurze Prüfung: Was ergibt $question?';
  }

  @override
  String get supportChallengeLoading => 'Frage wird geladen…';

  @override
  String get supportChallengeUnavailable => 'Gerade ist keine Frage verfügbar.';

  @override
  String get supportAnswerHint => '=';

  @override
  String get supportNewQuestion => 'Neue Frage';

  @override
  String get supportSend => 'Senden';

  @override
  String get supportSending => 'Wird gesendet…';

  @override
  String get supportSentTitle => 'Angekommen';

  @override
  String get supportSentBody =>
      'Danke für Ihre Nachricht. JazakAllahu khairan.';

  @override
  String get supportClose => 'Schließen';

  @override
  String get supportPrivacyNote =>
      'Mit Ihrer Nachricht werden keine Standort- oder Gerätedaten gesendet.';

  @override
  String get supportErrorOffline =>
      'Der Server war nicht erreichbar. Prüfen Sie Ihre Verbindung und versuchen Sie es erneut; Ihr Text bleibt erhalten.';

  @override
  String get supportErrorTooMany =>
      'Zu viele Nachrichten von dieser Verbindung in der letzten Stunde. Bitte versuchen Sie es später erneut.';

  @override
  String get supportErrorWrongAnswer =>
      'Die Antwort war nicht richtig. Bitte versuchen Sie es mit der neuen Frage.';

  @override
  String get supportErrorExpired =>
      'Diese Frage ist abgelaufen. Bitte versuchen Sie es mit der neuen.';

  @override
  String get supportErrorInvalid =>
      'Der Server konnte diese Nachricht nicht annehmen. Bitte kürzen Sie sie und versuchen Sie es erneut.';

  @override
  String get supportErrorTooShort =>
      'Bitte schreiben Sie mindestens 10 Zeichen.';

  @override
  String get supportErrorTooLong => 'Bitte bleiben Sie unter 2000 Zeichen.';

  @override
  String get supportErrorAnswerMissing =>
      'Bitte beantworten Sie die kurze Prüfung mit einer Zahl.';

  @override
  String get ratingTitle => 'Gefällt Ihnen Qibla Go?';

  @override
  String get ratingBodyGooglePlay =>
      'Qibla Go ist kostenlos und werbefrei. Eine Bewertung bei Google Play hilft anderen, die App zu finden und ihr zu vertrauen.';

  @override
  String get ratingBodyAppStore =>
      'Qibla Go ist kostenlos und werbefrei. Eine Bewertung im App Store hilft anderen, die App zu finden und ihr zu vertrauen.';

  @override
  String get ratingRate => 'Qibla Go bewerten';

  @override
  String get ratingNotNow => 'Jetzt nicht';

  @override
  String get ratingFootnote =>
      'Wir fragen nur einmal. Wenn Sie Nein sagen, fragen wir nicht noch einmal.';

  @override
  String get ratingOpenFailed =>
      'Der Store konnte nicht geöffnet werden. Bitte versuchen Sie es später noch einmal.';

  @override
  String get ratingStoreLinkGooglePlay => 'Bei Google Play bewerten';

  @override
  String get ratingStoreLinkAppStore => 'Im App Store bewerten';
}

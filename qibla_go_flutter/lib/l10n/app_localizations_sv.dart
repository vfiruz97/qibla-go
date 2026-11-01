// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appName => 'Qibla Go';

  @override
  String get qiblaLabel => 'QIBLA';

  @override
  String get fromTrueNorth => 'från geografisk nord';

  @override
  String get fromMagneticNorth => 'från magnetisk nord';

  @override
  String get facingQibla => 'Du är vänd mot Qibla';

  @override
  String turnRight(int degrees) {
    return 'Vrid $degrees° åt höger';
  }

  @override
  String turnLeft(int degrees) {
    return 'Vrid $degrees° åt vänster';
  }

  @override
  String get turnAround => 'Vänd dig om';

  @override
  String distanceToMakkah(String distance) {
    return '$distance km till Mekka';
  }

  @override
  String get atKaabaTitle => 'Du är vid Kaba';

  @override
  String get atKaabaBody =>
      'Vänd dig direkt mot den; så här nära har en riktning ingen betydelse.';

  @override
  String accuracyPlusMinus(int degrees) {
    return '±$degrees°';
  }

  @override
  String get accuracyUnknown => 'Okänd noggrannhet';

  @override
  String get qualityGood => 'Bra';

  @override
  String get qualityFair => 'Måttlig';

  @override
  String get qualityPoor => 'Dålig';

  @override
  String get headingLabel => 'Kurs';

  @override
  String bearingSummary(int bearing, int magnetic) {
    return 'Qibla ligger $bearing° från geografisk nord ($magnetic° på en magnetkompass). Gäller med vilken kompass eller karta som helst.';
  }

  @override
  String get locationSetLocation => 'Ange plats';

  @override
  String get locationLocating => 'Söker plats…';

  @override
  String get locationOriginDevice => 'Aktuell plats';

  @override
  String get locationOriginCached => 'Senast kända plats';

  @override
  String get locationOriginManual => 'Angiven för hand';

  @override
  String locationAccuracyMeters(int meters) {
    return '±$meters m';
  }

  @override
  String get locationAgeJustNow => 'just nu';

  @override
  String locationAgeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuter sedan',
      one: '1 minut sedan',
    );
    return '$_temp0';
  }

  @override
  String locationAgeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count timmar sedan',
      one: '1 timme sedan',
    );
    return '$_temp0';
  }

  @override
  String locationAgeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagar sedan',
      one: '1 dag sedan',
    );
    return '$_temp0';
  }

  @override
  String get locationNeededTitle => 'Var är du?';

  @override
  String get locationNeededBody =>
      'Qiblariktningen beror på var du står. Tillåt platsåtkomst eller ange dina koordinater. Din plats lämnar aldrig den här enheten.';

  @override
  String get locationUseMyLocation => 'Använd min plats';

  @override
  String get locationEnterCoordinates => 'Ange koordinater';

  @override
  String get locationLatitude => 'Latitud';

  @override
  String get locationLongitude => 'Longitud';

  @override
  String get locationLatitudeHint => 't.ex. 38,5598';

  @override
  String get locationLongitudeHint => 't.ex. 68,7870';

  @override
  String get locationInvalidLatitude =>
      'Latituden måste vara mellan -90 och 90';

  @override
  String get locationInvalidLongitude =>
      'Longituden måste vara mellan -180 och 180';

  @override
  String get locationSave => 'Använd dessa koordinater';

  @override
  String get locationOpenSettings => 'Öppna inställningar';

  @override
  String get locationProblemServicesDisabled =>
      'Platstjänster är avstängda på den här enheten.';

  @override
  String get locationProblemPermissionDenied =>
      'Platsbehörighet beviljades inte.';

  @override
  String get locationProblemPermissionDeniedForever =>
      'Platsbehörigheten är blockerad. Tillåt den i systeminställningarna.';

  @override
  String get locationProblemTimeout =>
      'Kunde inte få en position i tid. Försök nära ett fönster eller utomhus.';

  @override
  String get locationProblemUnavailable =>
      'Kunde inte fastställa din position.';

  @override
  String get locationStaleNote =>
      'En sparad position används. Om du har rest sedan dess, uppdatera den.';

  @override
  String get locationSheetTitle => 'Din plats';

  @override
  String locationCoordinates(String latitude, String longitude) {
    return '$latitude, $longitude';
  }

  @override
  String get compassCheckingTitle => 'Kontrollerar kompassen…';

  @override
  String get compassWaitingTitle => 'Väntar på sensorn…';

  @override
  String get compassWaitingBody =>
      'Rör telefonen försiktigt om det tar mer än en liten stund.';

  @override
  String get compassStaleTitle => 'Kompassen svarar inte längre';

  @override
  String get compassStaleBody =>
      'Mätvärdena har stannat. Rör telefonen lite, eller starta om appen.';

  @override
  String get compassNoSensorTitle => 'Ingen kompass i den här enheten';

  @override
  String get compassNoSensorBody =>
      'Den här enheten har ingen magnetometer och kan därför inte visa en riktning i realtid. Bäringen nedan fungerar ändå med vilken fysisk kompass eller karta som helst.';

  @override
  String get compassBrowserNoSensorTitle =>
      'Ingen kompass i den här webbläsaren';

  @override
  String get compassBrowserNoSensorBody =>
      'Webbläsare på datorer har inga orienteringssensorer. Öppna Qibla Go på en telefon, eller använd bäringen nedan med en kompass eller en karta.';

  @override
  String get compassPermissionTitle => 'Tillåt rörelseåtkomst';

  @override
  String get compassPermissionBody =>
      'Webbläsaren behöver tillstånd för att läsa telefonens orientering.';

  @override
  String get compassPermissionButton => 'Aktivera kompassen';

  @override
  String get compassPermissionDeniedBody =>
      'Rörelseåtkomst nekades. Tillåt den i webbläsarens inställningar och ladda om sidan.';

  @override
  String get compassRetry => 'Försök igen';

  @override
  String get compassPausedTitle => 'Kompassen pausad';

  @override
  String get issueInterferenceTitle => 'Magnetisk störning';

  @override
  String get issueInterferenceBody =>
      'Något magnetiskt eller av metall finns i närheten: en laptop, en bil, ett mobilskal med magnet. Riktningen döljs tills fältet är rent. Flytta dig en bit och försök igen.';

  @override
  String get issueMovingFastTitle => 'Du verkar sitta i ett fordon';

  @override
  String get issueMovingFastBody =>
      'En kompass går inte att lita på i en bil eller ett tåg i rörelse. Stanna och gå ut för att kontrollera riktningen.';

  @override
  String get issueCalibrationTitle => 'Kalibrera kompassen';

  @override
  String get issueCalibrationBody =>
      'Rör telefonen i en åtta några gånger, borta från metall.';

  @override
  String get issueNotFlatTitle => 'Håll telefonen plant';

  @override
  String get issueNotFlatBody =>
      'Håll skärmen vänd mot himlen för den stadigaste mätningen.';

  @override
  String get issueBrowserTitle => 'Webbläsarkompass';

  @override
  String get issueBrowserBody =>
      'Webbläsare ger en ungefärlig kurs och kan inte upptäcka störningar. Bekräfta med bäringen nedan och en riktig kompass om du kan, innan du ber.';

  @override
  String get issueLowAccuracyTitle => 'Låg noggrannhet';

  @override
  String get issueLowAccuracyBody =>
      'Sensorn rapporterar ett stort fel just nu. Kalibrera och kontrollera sedan igen.';

  @override
  String get declinationExtrapolatedNote =>
      'Appens magnetiska modell har gått ut. Uppdatera appen för bästa noggrannhet.';

  @override
  String get detailsButton => 'Detaljer';

  @override
  String get detailsTitle => 'Så beräknades den här riktningen';

  @override
  String get detailsSource => 'Sensor';

  @override
  String get detailsMagneticHeading => 'Magnetisk kurs';

  @override
  String get detailsDeclination => 'Deklination (WMM2025)';

  @override
  String get detailsTrueHeading => 'Geografisk kurs';

  @override
  String get detailsPlatformTrueHeading => 'Geografisk kurs (system)';

  @override
  String get detailsAccuracy => 'Rapporterad noggrannhet';

  @override
  String get detailsConfidence => 'Tillförlitlighet';

  @override
  String get detailsPitch => 'Lutning';

  @override
  String get detailsField => 'Fältstyrka';

  @override
  String get detailsFieldExpected => 'Förväntat fält';

  @override
  String get detailsBearing => 'Qiblabäring (geografisk)';

  @override
  String get detailsBearingMagnetic => 'Qiblabäring (magnetisk)';

  @override
  String get detailsDistance => 'Avstånd till Kaba';

  @override
  String get detailsLocation => 'Position';

  @override
  String get detailsKaaba => 'Kaba';

  @override
  String get detailsMethod =>
      'Storcirkelns initialbäring på WGS-84-koordinater; geografisk nord från den magnetiska kursen plus WMM2025-deklinationen beräknad på den här enheten.';

  @override
  String get detailsNotAvailable => '—';

  @override
  String get detailsSimulateToggle =>
      'Simulera kompass (endast felsökningsbygge)';

  @override
  String get detailsSimulateHeading => 'Simulerad kurs';

  @override
  String get footerFree => 'Gratis, för alltid. Inga annonser, inga konton.';

  @override
  String get footerIntention => 'Gjord för Guds välbehag.';

  @override
  String get cardinalN => 'N';

  @override
  String get cardinalE => 'Ö';

  @override
  String get cardinalS => 'S';

  @override
  String get cardinalW => 'V';

  @override
  String get introTagline => 'Vänd dig mot Kaba, var du än är';

  @override
  String get introSkip => 'Hoppa över';

  @override
  String get desktopPromptTitle => 'På webben: kartan';

  @override
  String get desktopPromptBody =>
      'Realtidskompassen finns i telefonappen, där den kan använda rörelsesensorerna. På webben visar Qibla Go i stället riktningen på en karta, med solen och månen som hjälp att orientera dig.';

  @override
  String get desktopPromptContinue => 'Fortsätt till kartan';

  @override
  String get navCompass => 'Kompass';

  @override
  String get navMap => 'Karta';

  @override
  String get mapTitle => 'Qibla på kartan';

  @override
  String get mapYourLocation => 'Du';

  @override
  String get mapKaaba => 'Kaba, Mekka';

  @override
  String get mapQiblaLine => 'Qiblalinje';

  @override
  String get mapSun => 'Solen';

  @override
  String get mapMoon => 'Månen';

  @override
  String skyMarkerLabel(String name, int azimuth) {
    return '$name $azimuth°';
  }

  @override
  String get mapRecenter => 'Använd min riktiga plats';

  @override
  String get mapZoomIn => 'Närmare';

  @override
  String get mapZoomOut => 'Längre bort';

  @override
  String get mapLongPressHint =>
      'Håll ned var som helst på kartan för att ange din plats där.';

  @override
  String get mapHowTitle => 'Så använder du kartan';

  @override
  String get mapHowStep1 =>
      'Den guldfärgade linjen börjar där du är och går rakt till Kaba. Bönen riktas längs den här linjen.';

  @override
  String get mapHowStep2 =>
      'Hitta något nära dig som linjen korsar: en väg, en hög byggnad, en kulle, en bro. Ställ dig vänd mot det, så är du vänd mot Qibla.';

  @override
  String get mapHowStep3 =>
      'Zooma in för att se vilken sida av en byggnad linjen passerar, och zooma ut för att se att linjen verkligen slutar i Mekka.';

  @override
  String mapHowSunAbove(
    int azimuth,
    String direction,
    int offset,
    String side,
  ) {
    return 'Solen står nu på $azimuth° (ungefär $direction). Qibla är $offset° till $side om solen: ställ dig vänd mot solen och vrid dig sedan så mycket.';
  }

  @override
  String mapHowMoonAbove(String phase, int azimuth, int offset, String side) {
    return 'Månen ($phase) står på $azimuth°. Qibla är $offset° till $side om den.';
  }

  @override
  String get mapHowSkyNone =>
      'Varken solen eller månen är uppe just nu; använd landmärken på kartan.';

  @override
  String get sideLeft => 'vänster';

  @override
  String get sideRight => 'höger';

  @override
  String get compassPointNorth => 'norr';

  @override
  String get compassPointNortheast => 'nordost';

  @override
  String get compassPointEast => 'öster';

  @override
  String get compassPointSoutheast => 'sydost';

  @override
  String get compassPointSouth => 'söder';

  @override
  String get compassPointSouthwest => 'sydväst';

  @override
  String get compassPointWest => 'väster';

  @override
  String get compassPointNorthwest => 'nordväst';

  @override
  String get moonPhaseNew => 'nymåne';

  @override
  String get moonPhaseWaxingCrescent => 'växande skära';

  @override
  String get moonPhaseFirstQuarter => 'första kvarteret';

  @override
  String get moonPhaseWaxingGibbous => 'växande halvmåne';

  @override
  String get moonPhaseFull => 'fullmåne';

  @override
  String get moonPhaseWaningGibbous => 'avtagande halvmåne';

  @override
  String get moonPhaseLastQuarter => 'sista kvarteret';

  @override
  String get moonPhaseWaningCrescent => 'avtagande skära';

  @override
  String get mapAttribution => '© OpenStreetMaps bidragsgivare';

  @override
  String get mapNeedsLocation => 'Ange din plats för att rita Qiblalinjen.';

  @override
  String get supportButton => 'Skriv till oss';

  @override
  String get supportTitle => 'Skriv till oss';

  @override
  String get supportIntro =>
      'En riktning som ser fel ut någonstans, en bugg, en idé, eller bara en salam. Varje meddelande läses.';

  @override
  String get supportMessageLabel => 'Ditt meddelande';

  @override
  String get supportMessageHint => 'Vad hände, och var?';

  @override
  String get supportContactLabel => 'Hur vi når dig (valfritt)';

  @override
  String get supportContactHint =>
      'E-post eller vad du vill, bara om du vill ha svar';

  @override
  String supportChallengeLabel(String question) {
    return 'Snabb kontroll: vad är $question?';
  }

  @override
  String get supportChallengeLoading => 'Hämtar en fråga…';

  @override
  String get supportChallengeUnavailable => 'Ingen fråga tillgänglig just nu.';

  @override
  String get supportAnswerHint => '=';

  @override
  String get supportNewQuestion => 'Ny fråga';

  @override
  String get supportSend => 'Skicka';

  @override
  String get supportSending => 'Skickar…';

  @override
  String get supportSentTitle => 'Mottaget';

  @override
  String get supportSentBody => 'Tack för att du skrev. JazakAllahu khairan.';

  @override
  String get supportClose => 'Stäng';

  @override
  String get supportPrivacyNote =>
      'Inga plats- eller enhetsdata skickas med ditt meddelande.';

  @override
  String get supportErrorOffline =>
      'Kunde inte nå servern. Kontrollera anslutningen och försök igen; din text finns kvar.';

  @override
  String get supportErrorTooMany =>
      'För många meddelanden från den här anslutningen den senaste timmen. Försök igen senare.';

  @override
  String get supportErrorWrongAnswer =>
      'Svaret var inte rätt. Försök med den nya frågan.';

  @override
  String get supportErrorExpired =>
      'Den frågan har gått ut. Försök med den nya.';

  @override
  String get supportErrorInvalid =>
      'Servern kunde inte ta emot meddelandet. Korta ned det och försök igen.';

  @override
  String get supportErrorTooShort => 'Skriv minst 10 tecken.';

  @override
  String get supportErrorTooLong => 'Håll dig under 2000 tecken.';

  @override
  String get supportErrorAnswerMissing =>
      'Svara på snabbkontrollen med ett tal.';
}

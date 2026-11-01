// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'Qibla Go';

  @override
  String get qiblaLabel => 'QIBLA';

  @override
  String get fromTrueNorth => 'dal nord geografico';

  @override
  String get fromMagneticNorth => 'dal nord magnetico';

  @override
  String get facingQibla => 'Sei rivolto verso la Qibla';

  @override
  String turnRight(int degrees) {
    return 'Gira a destra di $degrees°';
  }

  @override
  String turnLeft(int degrees) {
    return 'Gira a sinistra di $degrees°';
  }

  @override
  String get turnAround => 'Girati';

  @override
  String distanceToMakkah(String distance) {
    return '$distance km alla Mecca';
  }

  @override
  String get atKaabaTitle => 'Sei alla Kaaba';

  @override
  String get atKaabaBody =>
      'Rivolgiti direttamente a lei; così vicino una direzione non ha significato.';

  @override
  String accuracyPlusMinus(int degrees) {
    return '±$degrees°';
  }

  @override
  String get accuracyUnknown => 'Precisione sconosciuta';

  @override
  String get qualityGood => 'Buona';

  @override
  String get qualityFair => 'Discreta';

  @override
  String get qualityPoor => 'Scarsa';

  @override
  String get headingLabel => 'Direzione';

  @override
  String bearingSummary(int bearing, int magnetic) {
    return 'La Qibla è a $bearing° dal nord geografico ($magnetic° su una bussola magnetica). Vale con qualsiasi bussola o mappa.';
  }

  @override
  String get locationSetLocation => 'Imposta posizione';

  @override
  String get locationLocating => 'Localizzazione…';

  @override
  String get locationOriginDevice => 'Posizione attuale';

  @override
  String get locationOriginCached => 'Ultima posizione nota';

  @override
  String get locationOriginManual => 'Inserita a mano';

  @override
  String locationAccuracyMeters(int meters) {
    return '±$meters m';
  }

  @override
  String get locationAgeJustNow => 'proprio ora';

  @override
  String locationAgeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuti fa',
      one: '1 minuto fa',
    );
    return '$_temp0';
  }

  @override
  String locationAgeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ore fa',
      one: '1 ora fa',
    );
    return '$_temp0';
  }

  @override
  String locationAgeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giorni fa',
      one: '1 giorno fa',
    );
    return '$_temp0';
  }

  @override
  String get locationNeededTitle => 'Dove sei?';

  @override
  String get locationNeededBody =>
      'La direzione della Qibla dipende da dove ti trovi. Consenti l\'accesso alla posizione oppure inserisci le tue coordinate. La tua posizione non lascia mai questo dispositivo.';

  @override
  String get locationUseMyLocation => 'Usa la mia posizione';

  @override
  String get locationEnterCoordinates => 'Inserisci le coordinate';

  @override
  String get locationLatitude => 'Latitudine';

  @override
  String get locationLongitude => 'Longitudine';

  @override
  String get locationLatitudeHint => 'es. 38,5598';

  @override
  String get locationLongitudeHint => 'es. 68,7870';

  @override
  String get locationInvalidLatitude =>
      'La latitudine deve essere compresa tra -90 e 90';

  @override
  String get locationInvalidLongitude =>
      'La longitudine deve essere compresa tra -180 e 180';

  @override
  String get locationSave => 'Usa queste coordinate';

  @override
  String get locationOpenSettings => 'Apri impostazioni';

  @override
  String get locationProblemServicesDisabled =>
      'I servizi di localizzazione sono disattivati su questo dispositivo.';

  @override
  String get locationProblemPermissionDenied =>
      'Il permesso di localizzazione non è stato concesso.';

  @override
  String get locationProblemPermissionDeniedForever =>
      'Il permesso di localizzazione è bloccato. Concedilo nelle impostazioni di sistema.';

  @override
  String get locationProblemTimeout =>
      'Impossibile ottenere una posizione in tempo. Prova vicino a una finestra o all\'aperto.';

  @override
  String get locationProblemUnavailable =>
      'Impossibile determinare la tua posizione.';

  @override
  String get locationStaleNote =>
      'Viene usata una posizione salvata. Se da allora ti sei spostato, aggiornala.';

  @override
  String get locationSheetTitle => 'La tua posizione';

  @override
  String locationCoordinates(String latitude, String longitude) {
    return '$latitude, $longitude';
  }

  @override
  String get compassCheckingTitle => 'Controllo della bussola…';

  @override
  String get compassWaitingTitle => 'In attesa del sensore…';

  @override
  String get compassWaitingBody =>
      'Muovi delicatamente il telefono se ci vuole più di un attimo.';

  @override
  String get compassStaleTitle => 'La bussola non risponde più';

  @override
  String get compassStaleBody =>
      'Le letture si sono interrotte. Muovi un po\' il telefono oppure riavvia l\'app.';

  @override
  String get compassNoSensorTitle => 'Nessuna bussola su questo dispositivo';

  @override
  String get compassNoSensorBody =>
      'Questo dispositivo non ha un magnetometro, quindi non può mostrare una direzione dal vivo. Il rilevamento qui sotto funziona comunque con qualsiasi bussola fisica o una mappa.';

  @override
  String get compassBrowserNoSensorTitle => 'Nessuna bussola in questo browser';

  @override
  String get compassBrowserNoSensorBody =>
      'I browser desktop non hanno sensori di orientamento. Apri Qibla Go su un telefono, oppure usa il rilevamento qui sotto con una bussola o una mappa.';

  @override
  String get compassPermissionTitle => 'Consenti l\'accesso al movimento';

  @override
  String get compassPermissionBody =>
      'Il browser ha bisogno del permesso per leggere l\'orientamento del telefono.';

  @override
  String get compassPermissionButton => 'Attiva la bussola';

  @override
  String get compassPermissionDeniedBody =>
      'L\'accesso al movimento è stato rifiutato. Consentilo nelle impostazioni del browser e ricarica la pagina.';

  @override
  String get compassRetry => 'Riprova';

  @override
  String get compassPausedTitle => 'Bussola in pausa';

  @override
  String get issueInterferenceTitle => 'Interferenza magnetica';

  @override
  String get issueInterferenceBody =>
      'C\'è qualcosa di magnetico o metallico nelle vicinanze: un portatile, un\'auto, una custodia con magnete. La direzione resta nascosta finché il campo non è pulito. Allontanati e riprova.';

  @override
  String get issueMovingFastTitle => 'Sembra che tu sia in un veicolo';

  @override
  String get issueMovingFastBody =>
      'Non ci si può fidare di una bussola in un\'auto o in un treno in movimento. Fermati e scendi per controllare la direzione.';

  @override
  String get issueCalibrationTitle => 'Calibra la bussola';

  @override
  String get issueCalibrationBody =>
      'Muovi il telefono disegnando un otto alcune volte, lontano dal metallo.';

  @override
  String get issueNotFlatTitle => 'Tieni il telefono in piano';

  @override
  String get issueNotFlatBody =>
      'Tieni lo schermo rivolto verso il cielo per la lettura più stabile.';

  @override
  String get issueBrowserTitle => 'Bussola del browser';

  @override
  String get issueBrowserBody =>
      'I browser danno una direzione approssimativa e non rilevano le interferenze. Prima di pregare, conferma con il rilevamento qui sotto e, se puoi, con una vera bussola.';

  @override
  String get issueLowAccuracyTitle => 'Precisione bassa';

  @override
  String get issueLowAccuracyBody =>
      'Il sensore segnala un errore grande in questo momento. Calibra, poi controlla di nuovo.';

  @override
  String get declinationExtrapolatedNote =>
      'Il modello magnetico di questa app è scaduto. Aggiorna l\'app per la massima precisione.';

  @override
  String get detailsButton => 'Dettagli';

  @override
  String get detailsTitle => 'Come è stata calcolata questa direzione';

  @override
  String get detailsSource => 'Sensore';

  @override
  String get detailsMagneticHeading => 'Direzione magnetica';

  @override
  String get detailsDeclination => 'Declinazione (WMM2025)';

  @override
  String get detailsTrueHeading => 'Direzione geografica';

  @override
  String get detailsPlatformTrueHeading => 'Direzione geografica (sistema)';

  @override
  String get detailsAccuracy => 'Precisione riportata';

  @override
  String get detailsConfidence => 'Affidabilità';

  @override
  String get detailsPitch => 'Inclinazione';

  @override
  String get detailsField => 'Intensità del campo';

  @override
  String get detailsFieldExpected => 'Campo atteso';

  @override
  String get detailsBearing => 'Rilevamento della Qibla (geografico)';

  @override
  String get detailsBearingMagnetic => 'Rilevamento della Qibla (magnetico)';

  @override
  String get detailsDistance => 'Distanza dalla Kaaba';

  @override
  String get detailsLocation => 'Posizione';

  @override
  String get detailsKaaba => 'Kaaba';

  @override
  String get detailsMethod =>
      'Rilevamento iniziale di cerchio massimo su coordinate WGS-84; nord geografico dalla direzione magnetica più la declinazione WMM2025 calcolata su questo dispositivo.';

  @override
  String get detailsNotAvailable => '—';

  @override
  String get detailsSimulateToggle => 'Simula bussola (solo build di debug)';

  @override
  String get detailsSimulateHeading => 'Direzione simulata';

  @override
  String get detailsPreviewRating =>
      'Anteprima della richiesta di valutazione (solo build di debug)';

  @override
  String get footerFree =>
      'Gratis, per sempre. Senza pubblicità, senza account.';

  @override
  String get footerIntention => 'Fatto per il compiacimento di Dio.';

  @override
  String get cardinalN => 'N';

  @override
  String get cardinalE => 'E';

  @override
  String get cardinalS => 'S';

  @override
  String get cardinalW => 'O';

  @override
  String get introTagline => 'Rivolgiti alla Kaaba, ovunque tu sia';

  @override
  String get introSkip => 'Salta';

  @override
  String get desktopPromptTitle => 'Sul web, la mappa';

  @override
  String get desktopPromptBody =>
      'La bussola dal vivo è nell\'app per telefono, dove può usare i sensori di movimento. Sul web, Qibla Go mostra invece la direzione su una mappa, con il sole e la luna per aiutarti a orientarti.';

  @override
  String get desktopPromptContinue => 'Continua alla mappa';

  @override
  String get navCompass => 'Bussola';

  @override
  String get navMap => 'Mappa';

  @override
  String get mapTitle => 'La Qibla sulla mappa';

  @override
  String get mapYourLocation => 'Tu';

  @override
  String get mapKaaba => 'Kaaba, Mecca';

  @override
  String get mapQiblaLine => 'Linea della Qibla';

  @override
  String get mapSun => 'Sole';

  @override
  String get mapMoon => 'Luna';

  @override
  String skyMarkerLabel(String name, int azimuth) {
    return '$name $azimuth°';
  }

  @override
  String get mapRecenter => 'Usa la mia posizione reale';

  @override
  String get mapZoomIn => 'Più vicino';

  @override
  String get mapZoomOut => 'Più lontano';

  @override
  String get mapLongPressHint =>
      'Tieni premuto un punto qualsiasi della mappa per impostare lì la tua posizione.';

  @override
  String get mapHowTitle => 'Come usare questa mappa';

  @override
  String get mapHowStep1 =>
      'La linea dorata parte da dove sei e arriva dritta alla Kaaba. La preghiera si fa rivolti lungo questa linea.';

  @override
  String get mapHowStep2 =>
      'Trova qualcosa vicino a te che la linea attraversa: una strada, un edificio alto, una collina, un ponte. Mettiti rivolto verso di esso, e sarai rivolto verso la Qibla.';

  @override
  String get mapHowStep3 =>
      'Ingrandisci per controllare da quale lato di un edificio passa la linea, e riduci per vedere che la linea finisce davvero alla Mecca.';

  @override
  String mapHowSunAbove(
    int azimuth,
    String direction,
    int offset,
    String side,
  ) {
    return 'Il sole è ora a $azimuth° (circa $direction). La Qibla è $offset° a $side del sole: mettiti rivolto verso il sole, poi gira di tanto.';
  }

  @override
  String mapHowMoonAbove(String phase, int azimuth, int offset, String side) {
    return 'La luna ($phase) è a $azimuth°. La Qibla è $offset° a $side della luna.';
  }

  @override
  String get mapHowSkyNone =>
      'Né il sole né la luna sono visibili ora; usa i punti di riferimento sulla mappa.';

  @override
  String get sideLeft => 'sinistra';

  @override
  String get sideRight => 'destra';

  @override
  String get compassPointNorth => 'nord';

  @override
  String get compassPointNortheast => 'nord-est';

  @override
  String get compassPointEast => 'est';

  @override
  String get compassPointSoutheast => 'sud-est';

  @override
  String get compassPointSouth => 'sud';

  @override
  String get compassPointSouthwest => 'sud-ovest';

  @override
  String get compassPointWest => 'ovest';

  @override
  String get compassPointNorthwest => 'nord-ovest';

  @override
  String get moonPhaseNew => 'luna nuova';

  @override
  String get moonPhaseWaxingCrescent => 'falce crescente';

  @override
  String get moonPhaseFirstQuarter => 'primo quarto';

  @override
  String get moonPhaseWaxingGibbous => 'gibbosa crescente';

  @override
  String get moonPhaseFull => 'luna piena';

  @override
  String get moonPhaseWaningGibbous => 'gibbosa calante';

  @override
  String get moonPhaseLastQuarter => 'ultimo quarto';

  @override
  String get moonPhaseWaningCrescent => 'falce calante';

  @override
  String get mapAttribution => '© Collaboratori di OpenStreetMap';

  @override
  String get mapNeedsLocation =>
      'Imposta la tua posizione per tracciare la linea della Qibla.';

  @override
  String get supportButton => 'Scrivici';

  @override
  String get supportTitle => 'Scrivici';

  @override
  String get supportIntro =>
      'Una direzione che sembra sbagliata da qualche parte, un bug, un\'idea, o semplicemente un salam. Ogni messaggio viene letto.';

  @override
  String get supportMessageLabel => 'Il tuo messaggio';

  @override
  String get supportMessageHint => 'Cosa è successo, e dove?';

  @override
  String get supportContactLabel => 'Come raggiungerti (facoltativo)';

  @override
  String get supportContactHint =>
      'E-mail o quello che preferisci, solo se vuoi una risposta';

  @override
  String supportChallengeLabel(String question) {
    return 'Verifica rapida: quanto fa $question?';
  }

  @override
  String get supportChallengeLoading => 'Caricamento di una domanda…';

  @override
  String get supportChallengeUnavailable =>
      'Nessuna domanda disponibile al momento.';

  @override
  String get supportAnswerHint => '=';

  @override
  String get supportNewQuestion => 'Nuova domanda';

  @override
  String get supportSend => 'Invia';

  @override
  String get supportSending => 'Invio…';

  @override
  String get supportSentTitle => 'Ricevuto';

  @override
  String get supportSentBody =>
      'Grazie per averci scritto. JazakAllahu khairan.';

  @override
  String get supportClose => 'Chiudi';

  @override
  String get supportPrivacyNote =>
      'Con il tuo messaggio non vengono inviati dati di posizione o del dispositivo.';

  @override
  String get supportErrorOffline =>
      'Impossibile raggiungere il server. Controlla la connessione e riprova; il tuo testo è conservato.';

  @override
  String get supportErrorTooMany =>
      'Troppi messaggi da questa connessione nell\'ultima ora. Riprova più tardi.';

  @override
  String get supportErrorWrongAnswer =>
      'La risposta non era corretta. Prova con la nuova domanda.';

  @override
  String get supportErrorExpired =>
      'Quella domanda è scaduta. Prova con quella nuova.';

  @override
  String get supportErrorInvalid =>
      'Il server non ha potuto accettare questo messaggio. Accorcialo e riprova.';

  @override
  String get supportErrorTooShort => 'Scrivi almeno 10 caratteri.';

  @override
  String get supportErrorTooLong => 'Resta sotto i 2000 caratteri.';

  @override
  String get supportErrorAnswerMissing =>
      'Rispondi alla verifica rapida con un numero.';

  @override
  String get ratingTitle => 'Ti piace Qibla Go?';

  @override
  String get ratingBodyGooglePlay =>
      'Qibla Go è gratuita e senza pubblicità. Una valutazione su Google Play aiuta altre persone a trovarla e a fidarsi.';

  @override
  String get ratingBodyAppStore =>
      'Qibla Go è gratuita e senza pubblicità. Una valutazione sull\'App Store aiuta altre persone a trovarla e a fidarsi.';

  @override
  String get ratingRate => 'Valuta Qibla Go';

  @override
  String get ratingNotNow => 'Non ora';

  @override
  String get ratingFootnote =>
      'Lo chiediamo una sola volta. Se dici no, non lo chiederemo più.';

  @override
  String get ratingOpenFailed =>
      'Impossibile aprire lo store. Riprova più tardi.';

  @override
  String get ratingStoreLinkGooglePlay => 'Valuta su Google Play';

  @override
  String get ratingStoreLinkAppStore => 'Valuta sull\'App Store';
}

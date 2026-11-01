// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Qibla Go';

  @override
  String get qiblaLabel => 'QIBLA';

  @override
  String get fromTrueNorth => 'depuis le nord géographique';

  @override
  String get fromMagneticNorth => 'depuis le nord magnétique';

  @override
  String get facingQibla => 'Vous faites face à la Qibla';

  @override
  String turnRight(int degrees) {
    return 'Tournez de $degrees° vers la droite';
  }

  @override
  String turnLeft(int degrees) {
    return 'Tournez de $degrees° vers la gauche';
  }

  @override
  String get turnAround => 'Faites demi-tour';

  @override
  String distanceToMakkah(String distance) {
    return '$distance km jusqu\'à La Mecque';
  }

  @override
  String get atKaabaTitle => 'Vous êtes à la Kaaba';

  @override
  String get atKaabaBody =>
      'Tournez-vous directement vers elle ; une direction n\'a plus de sens d\'aussi près.';

  @override
  String accuracyPlusMinus(int degrees) {
    return '±$degrees°';
  }

  @override
  String get accuracyUnknown => 'Précision inconnue';

  @override
  String get qualityGood => 'Bonne';

  @override
  String get qualityFair => 'Moyenne';

  @override
  String get qualityPoor => 'Faible';

  @override
  String get headingLabel => 'Cap';

  @override
  String bearingSummary(int bearing, int magnetic) {
    return 'La Qibla est à $bearing° du nord géographique ($magnetic° sur une boussole magnétique). Valable avec n\'importe quelle boussole ou carte.';
  }

  @override
  String get locationSetLocation => 'Définir la position';

  @override
  String get locationLocating => 'Localisation…';

  @override
  String get locationOriginDevice => 'Position actuelle';

  @override
  String get locationOriginCached => 'Dernière position connue';

  @override
  String get locationOriginManual => 'Saisie à la main';

  @override
  String locationAccuracyMeters(int meters) {
    return '±$meters m';
  }

  @override
  String get locationAgeJustNow => 'à l\'instant';

  @override
  String locationAgeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count minutes',
      one: 'il y a 1 minute',
    );
    return '$_temp0';
  }

  @override
  String locationAgeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count heures',
      one: 'il y a 1 heure',
    );
    return '$_temp0';
  }

  @override
  String locationAgeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count jours',
      one: 'il y a 1 jour',
    );
    return '$_temp0';
  }

  @override
  String get locationNeededTitle => 'Où êtes-vous ?';

  @override
  String get locationNeededBody =>
      'La direction de la Qibla dépend de l\'endroit où vous vous trouvez. Autorisez l\'accès à la position ou saisissez vos coordonnées. Votre position ne quitte jamais cet appareil.';

  @override
  String get locationUseMyLocation => 'Utiliser ma position';

  @override
  String get locationEnterCoordinates => 'Saisir des coordonnées';

  @override
  String get locationLatitude => 'Latitude';

  @override
  String get locationLongitude => 'Longitude';

  @override
  String get locationLatitudeHint => 'p. ex. 38,5598';

  @override
  String get locationLongitudeHint => 'p. ex. 68,7870';

  @override
  String get locationInvalidLatitude =>
      'La latitude doit être comprise entre -90 et 90';

  @override
  String get locationInvalidLongitude =>
      'La longitude doit être comprise entre -180 et 180';

  @override
  String get locationSave => 'Utiliser ces coordonnées';

  @override
  String get locationOpenSettings => 'Ouvrir les réglages';

  @override
  String get locationProblemServicesDisabled =>
      'Les services de localisation sont désactivés sur cet appareil.';

  @override
  String get locationProblemPermissionDenied =>
      'L\'autorisation de localisation n\'a pas été accordée.';

  @override
  String get locationProblemPermissionDeniedForever =>
      'L\'autorisation de localisation est bloquée. Accordez-la dans les réglages du système.';

  @override
  String get locationProblemTimeout =>
      'Impossible d\'obtenir une position à temps. Essayez près d\'une fenêtre ou à l\'extérieur.';

  @override
  String get locationProblemUnavailable =>
      'Impossible de déterminer votre position.';

  @override
  String get locationStaleNote =>
      'Une position enregistrée est utilisée. Si vous vous êtes déplacé depuis, actualisez-la.';

  @override
  String get locationSheetTitle => 'Votre position';

  @override
  String locationCoordinates(String latitude, String longitude) {
    return '$latitude, $longitude';
  }

  @override
  String get compassCheckingTitle => 'Vérification de la boussole…';

  @override
  String get compassWaitingTitle => 'En attente du capteur…';

  @override
  String get compassWaitingBody =>
      'Bougez doucement le téléphone si cela prend plus d\'un instant.';

  @override
  String get compassStaleTitle => 'La boussole ne répond plus';

  @override
  String get compassStaleBody =>
      'Les mesures se sont interrompues. Bougez un peu le téléphone ou relancez l\'application.';

  @override
  String get compassNoSensorTitle => 'Pas de boussole sur cet appareil';

  @override
  String get compassNoSensorBody =>
      'Cet appareil n\'a pas de magnétomètre et ne peut donc pas afficher une direction en direct. Le relèvement ci-dessous fonctionne quand même avec n\'importe quelle boussole physique ou une carte.';

  @override
  String get compassBrowserNoSensorTitle =>
      'Pas de boussole dans ce navigateur';

  @override
  String get compassBrowserNoSensorBody =>
      'Les navigateurs de bureau n\'ont pas de capteurs d\'orientation. Ouvrez Qibla Go sur un téléphone, ou utilisez le relèvement ci-dessous avec une boussole ou une carte.';

  @override
  String get compassPermissionTitle => 'Autoriser l\'accès aux mouvements';

  @override
  String get compassPermissionBody =>
      'Votre navigateur a besoin d\'une autorisation pour lire l\'orientation du téléphone.';

  @override
  String get compassPermissionButton => 'Activer la boussole';

  @override
  String get compassPermissionDeniedBody =>
      'L\'accès aux mouvements a été refusé. Autorisez-le dans les réglages du navigateur et rechargez la page.';

  @override
  String get compassRetry => 'Réessayer';

  @override
  String get compassPausedTitle => 'Boussole en pause';

  @override
  String get issueInterferenceTitle => 'Interférence magnétique';

  @override
  String get issueInterferenceBody =>
      'Quelque chose de magnétique ou de métallique est à proximité : un ordinateur portable, une voiture, une coque de téléphone avec aimant. La direction reste masquée tant que le champ n\'est pas propre. Éloignez-vous et réessayez.';

  @override
  String get issueMovingFastTitle => 'Vous semblez être dans un véhicule';

  @override
  String get issueMovingFastBody =>
      'On ne peut pas se fier à une boussole dans une voiture ou un train en mouvement. Arrêtez-vous et sortez pour vérifier la direction.';

  @override
  String get issueCalibrationTitle => 'Calibrez votre boussole';

  @override
  String get issueCalibrationBody =>
      'Déplacez le téléphone en formant un huit plusieurs fois, loin de tout métal.';

  @override
  String get issueNotFlatTitle => 'Tenez le téléphone à plat';

  @override
  String get issueNotFlatBody =>
      'Gardez l\'écran tourné vers le ciel pour la mesure la plus stable.';

  @override
  String get issueBrowserTitle => 'Boussole du navigateur';

  @override
  String get issueBrowserBody =>
      'Les navigateurs donnent un cap approximatif et ne détectent pas les interférences. Avant de prier, confirmez avec le relèvement ci-dessous et, si possible, une vraie boussole.';

  @override
  String get issueLowAccuracyTitle => 'Précision faible';

  @override
  String get issueLowAccuracyBody =>
      'Le capteur signale une grande erreur en ce moment. Calibrez, puis vérifiez à nouveau.';

  @override
  String get declinationExtrapolatedNote =>
      'Le modèle magnétique de cette application a expiré. Mettez l\'application à jour pour une précision optimale.';

  @override
  String get detailsButton => 'Détails';

  @override
  String get detailsTitle => 'Comment cette direction a été calculée';

  @override
  String get detailsSource => 'Capteur';

  @override
  String get detailsMagneticHeading => 'Cap magnétique';

  @override
  String get detailsDeclination => 'Déclinaison (WMM2025)';

  @override
  String get detailsTrueHeading => 'Cap géographique';

  @override
  String get detailsPlatformTrueHeading => 'Cap géographique (système)';

  @override
  String get detailsAccuracy => 'Précision annoncée';

  @override
  String get detailsConfidence => 'Confiance';

  @override
  String get detailsPitch => 'Inclinaison';

  @override
  String get detailsField => 'Intensité du champ';

  @override
  String get detailsFieldExpected => 'Champ attendu';

  @override
  String get detailsBearing => 'Relèvement de la Qibla (géographique)';

  @override
  String get detailsBearingMagnetic => 'Relèvement de la Qibla (magnétique)';

  @override
  String get detailsDistance => 'Distance jusqu\'à la Kaaba';

  @override
  String get detailsLocation => 'Position';

  @override
  String get detailsKaaba => 'Kaaba';

  @override
  String get detailsMethod =>
      'Relèvement initial du grand cercle sur des coordonnées WGS-84 ; nord géographique obtenu à partir du cap magnétique plus la déclinaison WMM2025 calculée sur cet appareil.';

  @override
  String get detailsNotAvailable => '—';

  @override
  String get detailsSimulateToggle =>
      'Simuler la boussole (version de débogage uniquement)';

  @override
  String get detailsSimulateHeading => 'Cap simulé';

  @override
  String get footerFree =>
      'Gratuit, pour toujours. Sans publicité, sans compte.';

  @override
  String get footerIntention => 'Fait pour la satisfaction de Dieu.';

  @override
  String get cardinalN => 'N';

  @override
  String get cardinalE => 'E';

  @override
  String get cardinalS => 'S';

  @override
  String get cardinalW => 'O';

  @override
  String get introTagline => 'Face à la Kaaba, où que vous soyez';

  @override
  String get introSkip => 'Passer';

  @override
  String get desktopPromptTitle => 'Sur le web, la carte';

  @override
  String get desktopPromptBody =>
      'La boussole en direct est dans l\'application pour téléphone, où elle peut utiliser les capteurs de mouvement. Sur le web, Qibla Go montre plutôt la direction sur une carte, avec le soleil et la lune pour vous aider à vous orienter.';

  @override
  String get desktopPromptContinue => 'Continuer vers la carte';

  @override
  String get navCompass => 'Boussole';

  @override
  String get navMap => 'Carte';

  @override
  String get mapTitle => 'La Qibla sur la carte';

  @override
  String get mapYourLocation => 'Vous';

  @override
  String get mapKaaba => 'Kaaba, La Mecque';

  @override
  String get mapQiblaLine => 'Ligne de la Qibla';

  @override
  String get mapSun => 'Soleil';

  @override
  String get mapMoon => 'Lune';

  @override
  String skyMarkerLabel(String name, int azimuth) {
    return '$name $azimuth°';
  }

  @override
  String get mapRecenter => 'Utiliser ma vraie position';

  @override
  String get mapZoomIn => 'Plus près';

  @override
  String get mapZoomOut => 'Plus loin';

  @override
  String get mapLongPressHint =>
      'Appuyez longuement n\'importe où sur la carte pour y placer votre position.';

  @override
  String get mapHowTitle => 'Comment utiliser cette carte';

  @override
  String get mapHowStep1 =>
      'La ligne dorée part de l\'endroit où vous êtes et va tout droit jusqu\'à la Kaaba. La prière se fait face à cette ligne.';

  @override
  String get mapHowStep2 =>
      'Repérez près de vous quelque chose que la ligne traverse : une route, un grand bâtiment, une colline, un pont. Placez-vous face à cet élément, et vous faites face à la Qibla.';

  @override
  String get mapHowStep3 =>
      'Zoomez pour vérifier de quel côté d\'un bâtiment passe la ligne, et dézoomez pour voir que la ligne se termine bien à La Mecque.';

  @override
  String mapHowSunAbove(
    int azimuth,
    String direction,
    int offset,
    String side,
  ) {
    return 'Le soleil est maintenant à $azimuth° (environ $direction). La Qibla est à $offset° à $side du soleil : placez-vous face au soleil, puis tournez d\'autant.';
  }

  @override
  String mapHowMoonAbove(String phase, int azimuth, int offset, String side) {
    return 'La lune ($phase) est à $azimuth°. La Qibla est à $offset° à $side de celle-ci.';
  }

  @override
  String get mapHowSkyNone =>
      'Ni le soleil ni la lune ne sont visibles en ce moment ; utilisez les repères de la carte.';

  @override
  String get sideLeft => 'gauche';

  @override
  String get sideRight => 'droite';

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
  String get compassPointSouthwest => 'sud-ouest';

  @override
  String get compassPointWest => 'ouest';

  @override
  String get compassPointNorthwest => 'nord-ouest';

  @override
  String get moonPhaseNew => 'nouvelle lune';

  @override
  String get moonPhaseWaxingCrescent => 'premier croissant';

  @override
  String get moonPhaseFirstQuarter => 'premier quartier';

  @override
  String get moonPhaseWaxingGibbous => 'gibbeuse croissante';

  @override
  String get moonPhaseFull => 'pleine lune';

  @override
  String get moonPhaseWaningGibbous => 'gibbeuse décroissante';

  @override
  String get moonPhaseLastQuarter => 'dernier quartier';

  @override
  String get moonPhaseWaningCrescent => 'dernier croissant';

  @override
  String get mapAttribution => '© les contributeurs d\'OpenStreetMap';

  @override
  String get mapNeedsLocation =>
      'Définissez votre position pour tracer la ligne de la Qibla.';

  @override
  String get supportButton => 'Écrivez-nous';

  @override
  String get supportTitle => 'Écrivez-nous';

  @override
  String get supportIntro =>
      'Une direction qui semble fausse quelque part, un bug, une idée, ou simplement un salam. Chaque message est lu.';

  @override
  String get supportMessageLabel => 'Votre message';

  @override
  String get supportMessageHint => 'Que s\'est-il passé, et où ?';

  @override
  String get supportContactLabel => 'Comment vous joindre (facultatif)';

  @override
  String get supportContactHint =>
      'E-mail ou ce que vous voulez, seulement si vous souhaitez une réponse';

  @override
  String supportChallengeLabel(String question) {
    return 'Petite vérification : combien font $question ?';
  }

  @override
  String get supportChallengeLoading => 'Chargement d\'une question…';

  @override
  String get supportChallengeUnavailable =>
      'Aucune question disponible pour le moment.';

  @override
  String get supportAnswerHint => '=';

  @override
  String get supportNewQuestion => 'Nouvelle question';

  @override
  String get supportSend => 'Envoyer';

  @override
  String get supportSending => 'Envoi…';

  @override
  String get supportSentTitle => 'Bien reçu';

  @override
  String get supportSentBody =>
      'Merci de nous avoir écrit. JazakAllahu khairan.';

  @override
  String get supportClose => 'Fermer';

  @override
  String get supportPrivacyNote =>
      'Aucune donnée de position ou d\'appareil n\'est envoyée avec votre message.';

  @override
  String get supportErrorOffline =>
      'Impossible de joindre le serveur. Vérifiez votre connexion et réessayez ; votre texte est conservé.';

  @override
  String get supportErrorTooMany =>
      'Trop de messages depuis cette connexion au cours de la dernière heure. Veuillez réessayer plus tard.';

  @override
  String get supportErrorWrongAnswer =>
      'Cette réponse n\'était pas correcte. Veuillez essayer la nouvelle question.';

  @override
  String get supportErrorExpired =>
      'Cette question a expiré. Veuillez essayer la nouvelle.';

  @override
  String get supportErrorInvalid =>
      'Le serveur n\'a pas pu accepter ce message. Veuillez le raccourcir et réessayer.';

  @override
  String get supportErrorTooShort => 'Veuillez écrire au moins 10 caractères.';

  @override
  String get supportErrorTooLong => 'Veuillez rester sous 2000 caractères.';

  @override
  String get supportErrorAnswerMissing =>
      'Veuillez répondre à la petite vérification par un nombre.';
}

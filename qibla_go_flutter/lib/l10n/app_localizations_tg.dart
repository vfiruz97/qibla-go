// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tajik (`tg`).
class AppLocalizationsTg extends AppLocalizations {
  AppLocalizationsTg([String locale = 'tg']) : super(locale);

  @override
  String get appName => 'Qibla Go';

  @override
  String get qiblaLabel => 'ҚИБЛА';

  @override
  String get fromTrueNorth => 'аз шимоли ҳақиқӣ';

  @override
  String get fromMagneticNorth => 'аз шимоли магнитӣ';

  @override
  String get facingQibla => 'Шумо рӯ ба Қибла истодаед';

  @override
  String turnRight(int degrees) {
    return 'Ба рост $degrees° гардед';
  }

  @override
  String turnLeft(int degrees) {
    return 'Ба чап $degrees° гардед';
  }

  @override
  String get turnAround => 'Пушт гардед';

  @override
  String distanceToMakkah(String distance) {
    return '$distance км то Макка';
  }

  @override
  String get atKaabaTitle => 'Шумо дар назди Каъба ҳастед';

  @override
  String get atKaabaBody =>
      'Рост ба он рӯ оваред; дар ин қадар наздикӣ самт маъно надорад.';

  @override
  String accuracyPlusMinus(int degrees) {
    return '±$degrees°';
  }

  @override
  String get accuracyUnknown => 'Дақиқӣ номаълум';

  @override
  String get qualityGood => 'Хуб';

  @override
  String get qualityFair => 'Миёна';

  @override
  String get qualityPoor => 'Бад';

  @override
  String get headingLabel => 'Самт';

  @override
  String bearingSummary(int bearing, int magnetic) {
    return 'Қибла дар $bearing° аз шимоли ҳақиқӣ ($magnetic° бо қутбнамои магнитӣ) аст. Бо ҳар қутбнамо ё харита дуруст аст.';
  }

  @override
  String get locationSetLocation => 'Ҷойгиршавиро муайян кардан';

  @override
  String get locationLocating => 'Ҷойгиршавӣ муайян мешавад…';

  @override
  String get locationOriginDevice => 'Ҷойгиршавии ҷорӣ';

  @override
  String get locationOriginCached => 'Ҷойгиршавии охирини маълум';

  @override
  String get locationOriginManual => 'Дастӣ ворид шуд';

  @override
  String locationAccuracyMeters(int meters) {
    return '±$meters м';
  }

  @override
  String get locationAgeJustNow => 'ҳозир';

  @override
  String locationAgeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дақиқа пеш',
    );
    return '$_temp0';
  }

  @override
  String locationAgeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count соат пеш',
    );
    return '$_temp0';
  }

  @override
  String locationAgeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count рӯз пеш',
    );
    return '$_temp0';
  }

  @override
  String get locationNeededTitle => 'Шумо дар куҷоед?';

  @override
  String get locationNeededBody =>
      'Самти Қибла аз он вобаста аст, ки шумо дар куҷо истодаед. Ба ҷойгиршавӣ дастрасӣ диҳед ё координатҳои худро ворид кунед. Ҷойгиршавии шумо ҳеҷ гоҳ аз ин дастгоҳ берун намеравад.';

  @override
  String get locationUseMyLocation => 'Ҷойгиршавии ман';

  @override
  String get locationEnterCoordinates => 'Координатҳоро ворид кардан';

  @override
  String get locationLatitude => 'Арз (паҳнӣ)';

  @override
  String get locationLongitude => 'Тӯл (дарозӣ)';

  @override
  String get locationLatitudeHint => 'масалан 38,5598';

  @override
  String get locationLongitudeHint => 'масалан 68,7870';

  @override
  String get locationInvalidLatitude => 'Арз бояд аз -90 то 90 бошад';

  @override
  String get locationInvalidLongitude => 'Тӯл бояд аз -180 то 180 бошад';

  @override
  String get locationSave => 'Ин координатҳоро истифода бурдан';

  @override
  String get locationOpenSettings => 'Танзимотро кушодан';

  @override
  String get locationProblemServicesDisabled =>
      'Хидматҳои ҷойгиршавӣ дар ин дастгоҳ хомӯш аст.';

  @override
  String get locationProblemPermissionDenied =>
      'Иҷозат ба ҷойгиршавӣ дода нашуд.';

  @override
  String get locationProblemPermissionDeniedForever =>
      'Иҷозат ба ҷойгиршавӣ баста шудааст. Онро дар танзимоти система иҷозат диҳед.';

  @override
  String get locationProblemTimeout =>
      'Мавқеъ сари вақт муайян нашуд. Дар назди тиреза ё дар кӯча кӯшиш кунед.';

  @override
  String get locationProblemUnavailable => 'Мавқеи шумо муайян нашуд.';

  @override
  String get locationStaleNote =>
      'Мавқеи нигоҳдошташуда истифода мешавад. Агар аз он вақт ҷои худро иваз карда бошед, онро нав кунед.';

  @override
  String get locationSheetTitle => 'Ҷойгиршавии шумо';

  @override
  String locationCoordinates(String latitude, String longitude) {
    return '$latitude, $longitude';
  }

  @override
  String get compassCheckingTitle => 'Қутбнамо санҷида мешавад…';

  @override
  String get compassWaitingTitle => 'Интизори сенсор…';

  @override
  String get compassWaitingBody =>
      'Агар ин бештар аз як лаҳза давом кунад, телефонро оҳиста ҷунбонед.';

  @override
  String get compassStaleTitle => 'Қутбнамо ҷавоб намедиҳад';

  @override
  String get compassStaleBody =>
      'Нишондодҳо қатъ шуданд. Телефонро каме ҷунбонед ё барномаро аз нав оғоз кунед.';

  @override
  String get compassNoSensorTitle => 'Дар ин дастгоҳ қутбнамо нест';

  @override
  String get compassNoSensorBody =>
      'Ин дастгоҳ магнитометр надорад, бинобар ин самтро дар вақти воқеӣ нишон дода наметавонад. Азимути поён бо ҳар қутбнамои оддӣ ё харита кор мекунад.';

  @override
  String get compassBrowserNoSensorTitle => 'Дар ин браузер қутбнамо нест';

  @override
  String get compassBrowserNoSensorBody =>
      'Браузерҳои компютер сенсорҳои самт надоранд. Qibla Go-ро дар телефон кушоед ё азимути поёнро бо қутбнамо ё харита истифода баред.';

  @override
  String get compassPermissionTitle => 'Ба ҳаракат дастрасӣ диҳед';

  @override
  String get compassPermissionBody =>
      'Браузери шумо барои хондани самти телефон иҷозат мехоҳад.';

  @override
  String get compassPermissionButton => 'Қутбнаморо фаъол кардан';

  @override
  String get compassPermissionDeniedBody =>
      'Дастрасӣ ба ҳаракат рад шуд. Онро дар танзимоти браузер иҷозат диҳед ва саҳифаро аз нав бор кунед.';

  @override
  String get compassRetry => 'Боз кӯшиш кунед';

  @override
  String get compassPausedTitle => 'Қутбнамо таваққуф шуд';

  @override
  String get issueInterferenceTitle => 'Халали магнитӣ';

  @override
  String get issueInterferenceBody =>
      'Дар наздикӣ чизи магнитӣ ё металлӣ ҳаст: ноутбук, мошин, ғилофи телефон бо магнит. То пок шудани майдон самт пинҳон аст. Дуртар равед ва боз кӯшиш кунед.';

  @override
  String get issueMovingFastTitle =>
      'Чунин менамояд, ки шумо дар нақлиёт ҳастед';

  @override
  String get issueMovingFastBody =>
      'Ба қутбнамо дар мошин ё қатораи ҳаракаткунанда бовар кардан мумкин нест. Истед ва барои санҷидани самт берун бароед.';

  @override
  String get issueCalibrationTitle => 'Қутбнаморо калибр кунед';

  @override
  String get issueCalibrationBody =>
      'Телефонро чанд маротиба ба шакли ҳашт ҳаракат диҳед, дур аз металл.';

  @override
  String get issueNotFlatTitle => 'Телефонро ҳамвор доред';

  @override
  String get issueNotFlatBody =>
      'Экранро ба сӯи осмон нигоҳ доред, то нишондод устувортар бошад.';

  @override
  String get issueBrowserTitle => 'Қутбнамои браузер';

  @override
  String get issueBrowserBody =>
      'Браузерҳо самти тахминӣ медиҳанд ва халалро пай намебаранд. Пеш аз намоз бо азимути поён ва, агар тавонед, бо қутбнамои воқеӣ санҷед.';

  @override
  String get issueLowAccuracyTitle => 'Дақиқии кам';

  @override
  String get issueLowAccuracyBody =>
      'Сенсор ҳозир хатогии калон нишон медиҳад. Калибр кунед ва боз санҷед.';

  @override
  String get declinationExtrapolatedNote =>
      'Модели магнитии ин барнома кӯҳна шудааст. Барои дақиқии беҳтар барномаро нав кунед.';

  @override
  String get detailsButton => 'Тафсилот';

  @override
  String get detailsTitle => 'Ин самт чӣ тавр ҳисоб шудааст';

  @override
  String get detailsSource => 'Сенсор';

  @override
  String get detailsMagneticHeading => 'Самти магнитӣ';

  @override
  String get detailsDeclination => 'Инҳироф (WMM2025)';

  @override
  String get detailsTrueHeading => 'Самти ҳақиқӣ';

  @override
  String get detailsPlatformTrueHeading => 'Самти ҳақиқӣ (система)';

  @override
  String get detailsAccuracy => 'Дақиқии эълоншуда';

  @override
  String get detailsConfidence => 'Эътимод';

  @override
  String get detailsPitch => 'Моилӣ';

  @override
  String get detailsField => 'Қувваи майдон';

  @override
  String get detailsFieldExpected => 'Майдони чашмдошт';

  @override
  String get detailsBearing => 'Азимути Қибла (ҳақиқӣ)';

  @override
  String get detailsBearingMagnetic => 'Азимути Қибла (магнитӣ)';

  @override
  String get detailsDistance => 'Масофа то Каъба';

  @override
  String get detailsLocation => 'Мавқеъ';

  @override
  String get detailsKaaba => 'Каъба';

  @override
  String get detailsMethod =>
      'Азимути ибтидоии доираи бузург бо координатҳои WGS-84; шимоли ҳақиқӣ аз самти магнитӣ ва инҳирофи WMM2025, ки дар ин дастгоҳ ҳисоб шудааст.';

  @override
  String get detailsNotAvailable => '—';

  @override
  String get detailsSimulateToggle =>
      'Қутбнаморо тақлид кардан (танҳо нусхаи ислоҳӣ)';

  @override
  String get detailsSimulateHeading => 'Самти тақлидӣ';

  @override
  String get footerFree => 'Бепул, ҳамеша. Бе реклама, бе ҳисоб.';

  @override
  String get footerIntention => 'Барои ризои Худо сохта шудааст.';

  @override
  String get cardinalN => 'Ш';

  @override
  String get cardinalE => 'Шқ';

  @override
  String get cardinalS => 'Ҷ';

  @override
  String get cardinalW => 'Ғ';

  @override
  String get introTagline => 'Рӯ ба Каъба, дар ҳар ҷое ки ҳастед';

  @override
  String get introSkip => 'Гузаштан';

  @override
  String get desktopPromptTitle => 'Дар веб — харита';

  @override
  String get desktopPromptBody =>
      'Қутбнамои зинда дар барномаи телефон аст, ки сенсорҳои ҳаракатро истифода мебарад. Дар веб Qibla Go самтро дар харита нишон медиҳад, ва офтоб ва моҳ барои самтгирӣ кӯмак мекунанд.';

  @override
  String get desktopPromptContinue => 'Ба харита гузаштан';

  @override
  String get navCompass => 'Қутбнамо';

  @override
  String get navMap => 'Харита';

  @override
  String get mapTitle => 'Қибла дар харита';

  @override
  String get mapYourLocation => 'Шумо';

  @override
  String get mapKaaba => 'Каъба, Макка';

  @override
  String get mapQiblaLine => 'Хати Қибла';

  @override
  String get mapSun => 'Офтоб';

  @override
  String get mapMoon => 'Моҳ';

  @override
  String skyMarkerLabel(String name, int azimuth) {
    return '$name $azimuth°';
  }

  @override
  String get mapRecenter => 'Ҷойгиршавии воқеии ман';

  @override
  String get mapZoomIn => 'Наздиктар';

  @override
  String get mapZoomOut => 'Дуртар';

  @override
  String get mapLongPressHint =>
      'Ҷои дилхоҳи харитаро пахш карда доред, то ҷойгиршавии худро он ҷо муайян кунед.';

  @override
  String get mapHowTitle => 'Чӣ тавр ин харитаро истифода бурдан';

  @override
  String get mapHowStep1 =>
      'Хати тиллоӣ аз ҷои шумо сар мешавад ва рост ба Каъба меравад. Намоз рӯ ба ин хат хонда мешавад.';

  @override
  String get mapHowStep2 =>
      'Дар наздикии худ чизеро ёбед, ки хат аз он мегузарад: роҳ, бинои баланд, теппа, пул. Рӯ ба он истед — ва шумо рӯ ба Қибла ҳастед.';

  @override
  String get mapHowStep3 =>
      'Харитаро наздик кунед, то бинед, ки хат аз кадом тарафи бино мегузарад, ва дур кунед, то бинед, ки хат дар ҳақиқат дар Макка тамом мешавад.';

  @override
  String mapHowSunAbove(
    int azimuth,
    String direction,
    int offset,
    String side,
  ) {
    return 'Офтоб ҳозир дар $azimuth° аст (тақрибан $direction). Қибла $offset° ба $side аз офтоб аст: рӯ ба офтоб истед ва ҳамин қадар гардед.';
  }

  @override
  String mapHowMoonAbove(String phase, int azimuth, int offset, String side) {
    return 'Моҳ ($phase) дар $azimuth° аст. Қибла $offset° ба $side аз он аст.';
  }

  @override
  String get mapHowSkyNone =>
      'Ҳозир на офтоб ва на моҳ дида намешавад; аз нишонаҳои харита истифода баред.';

  @override
  String get sideLeft => 'чап';

  @override
  String get sideRight => 'рост';

  @override
  String get compassPointNorth => 'шимол';

  @override
  String get compassPointNortheast => 'шимолу шарқ';

  @override
  String get compassPointEast => 'шарқ';

  @override
  String get compassPointSoutheast => 'ҷанубу шарқ';

  @override
  String get compassPointSouth => 'ҷануб';

  @override
  String get compassPointSouthwest => 'ҷанубу ғарб';

  @override
  String get compassPointWest => 'ғарб';

  @override
  String get compassPointNorthwest => 'шимолу ғарб';

  @override
  String get moonPhaseNew => 'моҳи нав';

  @override
  String get moonPhaseWaxingCrescent => 'ҳилоли афзоянда';

  @override
  String get moonPhaseFirstQuarter => 'чоряки аввал';

  @override
  String get moonPhaseWaxingGibbous => 'моҳи афзоянда';

  @override
  String get moonPhaseFull => 'моҳи пурра';

  @override
  String get moonPhaseWaningGibbous => 'моҳи камшаванда';

  @override
  String get moonPhaseLastQuarter => 'чоряки охир';

  @override
  String get moonPhaseWaningCrescent => 'ҳилоли камшаванда';

  @override
  String get mapAttribution => '© Иштирокчиёни OpenStreetMap';

  @override
  String get mapNeedsLocation =>
      'Барои кашидани хати Қибла ҷойгиршавии худро муайян кунед.';

  @override
  String get supportButton => 'Ба мо нависед';

  @override
  String get supportTitle => 'Ба мо нависед';

  @override
  String get supportIntro =>
      'Самте, ки дар ҷое нодуруст менамояд, хатогӣ, фикр ё танҳо салом. Ҳар паём хонда мешавад.';

  @override
  String get supportMessageLabel => 'Паёми шумо';

  @override
  String get supportMessageHint => 'Чӣ рӯй дод ва дар куҷо?';

  @override
  String get supportContactLabel => 'Чӣ тавр бо шумо тамос гирем (ихтиёрӣ)';

  @override
  String get supportContactHint => 'Почта ё чизи дигар, танҳо агар ҷавоб хоҳед';

  @override
  String supportChallengeLabel(String question) {
    return 'Санҷиши зуд: $question чанд мешавад?';
  }

  @override
  String get supportChallengeLoading => 'Савол бор мешавад…';

  @override
  String get supportChallengeUnavailable => 'Ҳозир савол дастрас нест.';

  @override
  String get supportAnswerHint => '=';

  @override
  String get supportNewQuestion => 'Саволи нав';

  @override
  String get supportSend => 'Фиристодан';

  @override
  String get supportSending => 'Фиристода мешавад…';

  @override
  String get supportSentTitle => 'Қабул шуд';

  @override
  String get supportSentBody => 'Барои паёматон ташаккур. ҶазокаЛлоҳу хайран.';

  @override
  String get supportClose => 'Пӯшидан';

  @override
  String get supportPrivacyNote =>
      'Бо паёми шумо ҷойгиршавӣ ва маълумоти дастгоҳ фиристода намешавад.';

  @override
  String get supportErrorOffline =>
      'Ба сервер пайваст нашуд. Пайвастро санҷед ва боз кӯшиш кунед; матни шумо нигоҳ дошта мешавад.';

  @override
  String get supportErrorTooMany =>
      'Дар соати охир аз ин пайваст паёмҳои аз ҳад зиёд. Лутфан дертар кӯшиш кунед.';

  @override
  String get supportErrorWrongAnswer =>
      'Ҷавоб нодуруст буд. Лутфан ба саволи нав ҷавоб диҳед.';

  @override
  String get supportErrorExpired =>
      'Мӯҳлати ин савол гузашт. Лутфан саволи навро кӯшиш кунед.';

  @override
  String get supportErrorInvalid =>
      'Сервер ин паёмро қабул карда натавонист. Лутфан онро кӯтоҳ кунед ва боз кӯшиш кунед.';

  @override
  String get supportErrorTooShort => 'Лутфан ҳадди аққал 10 аломат нависед.';

  @override
  String get supportErrorTooLong => 'Лутфан аз 2000 аломат зиёд нанависед.';

  @override
  String get supportErrorAnswerMissing =>
      'Лутфан ба санҷиши зуд бо рақам ҷавоб диҳед.';
}

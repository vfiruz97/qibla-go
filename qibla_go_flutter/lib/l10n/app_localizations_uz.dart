// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appName => 'Qibla Go';

  @override
  String get qiblaLabel => 'QIBLA';

  @override
  String get fromTrueNorth => 'haqiqiy shimoldan';

  @override
  String get fromMagneticNorth => 'magnit shimolidan';

  @override
  String get facingQibla => 'Siz Qiblaga qarab turibsiz';

  @override
  String turnRight(int degrees) {
    return 'Oʻngga $degrees° buriling';
  }

  @override
  String turnLeft(int degrees) {
    return 'Chapga $degrees° buriling';
  }

  @override
  String get turnAround => 'Orqaga buriling';

  @override
  String distanceToMakkah(String distance) {
    return 'Makkagacha $distance km';
  }

  @override
  String get atKaabaTitle => 'Siz Kaʼba yonidasiz';

  @override
  String get atKaabaBody =>
      'Toʻgʻridan-toʻgʻri unga qarang; bunchalik yaqinda yoʻnalishning maʼnosi yoʻq.';

  @override
  String accuracyPlusMinus(int degrees) {
    return '±$degrees°';
  }

  @override
  String get accuracyUnknown => 'Aniqlik nomaʼlum';

  @override
  String get qualityGood => 'Yaxshi';

  @override
  String get qualityFair => 'Oʻrtacha';

  @override
  String get qualityPoor => 'Yomon';

  @override
  String get headingLabel => 'Yoʻnalish';

  @override
  String bearingSummary(int bearing, int magnetic) {
    return 'Qibla haqiqiy shimoldan $bearing° (magnit kompasda $magnetic°). Har qanday kompas yoki xarita bilan toʻgʻri.';
  }

  @override
  String get locationSetLocation => 'Joylashuvni belgilash';

  @override
  String get locationLocating => 'Joylashuv aniqlanmoqda…';

  @override
  String get locationOriginDevice => 'Joriy joylashuv';

  @override
  String get locationOriginCached => 'Oxirgi maʼlum joylashuv';

  @override
  String get locationOriginManual => 'Qoʻlda kiritilgan';

  @override
  String locationAccuracyMeters(int meters) {
    return '±$meters m';
  }

  @override
  String get locationAgeJustNow => 'hozirgina';

  @override
  String locationAgeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count daqiqa oldin',
    );
    return '$_temp0';
  }

  @override
  String locationAgeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count soat oldin',
    );
    return '$_temp0';
  }

  @override
  String locationAgeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kun oldin',
    );
    return '$_temp0';
  }

  @override
  String get locationNeededTitle => 'Qayerdasiz?';

  @override
  String get locationNeededBody =>
      'Qibla yoʻnalishi qayerda turganingizga bogʻliq. Joylashuvga ruxsat bering yoki koordinatalaringizni kiriting. Joylashuvingiz bu qurilmadan hech qachon chiqmaydi.';

  @override
  String get locationUseMyLocation => 'Joylashuvimdan foydalanish';

  @override
  String get locationEnterCoordinates => 'Koordinatalarni kiritish';

  @override
  String get locationLatitude => 'Kenglik';

  @override
  String get locationLongitude => 'Uzunlik';

  @override
  String get locationLatitudeHint => 'masalan 38,5598';

  @override
  String get locationLongitudeHint => 'masalan 68,7870';

  @override
  String get locationInvalidLatitude =>
      'Kenglik -90 va 90 orasida boʻlishi kerak';

  @override
  String get locationInvalidLongitude =>
      'Uzunlik -180 va 180 orasida boʻlishi kerak';

  @override
  String get locationSave => 'Shu koordinatalardan foydalanish';

  @override
  String get locationOpenSettings => 'Sozlamalarni ochish';

  @override
  String get locationProblemServicesDisabled =>
      'Bu qurilmada joylashuv xizmatlari oʻchirilgan.';

  @override
  String get locationProblemPermissionDenied => 'Joylashuvga ruxsat berilmadi.';

  @override
  String get locationProblemPermissionDeniedForever =>
      'Joylashuvga ruxsat bloklangan. Tizim sozlamalarida ruxsat bering.';

  @override
  String get locationProblemTimeout =>
      'Joylashuv vaqtida aniqlanmadi. Deraza yonida yoki ochiq havoda urinib koʻring.';

  @override
  String get locationProblemUnavailable => 'Joylashuvingiz aniqlanmadi.';

  @override
  String get locationStaleNote =>
      'Saqlangan joylashuv ishlatilmoqda. Shundan beri joy oʻzgartirgan boʻlsangiz, yangilang.';

  @override
  String get locationSheetTitle => 'Joylashuvingiz';

  @override
  String locationCoordinates(String latitude, String longitude) {
    return '$latitude, $longitude';
  }

  @override
  String get compassCheckingTitle => 'Kompas tekshirilmoqda…';

  @override
  String get compassWaitingTitle => 'Sensor kutilmoqda…';

  @override
  String get compassWaitingBody =>
      'Bir lahzadan koʻp vaqt olsa, telefonni ohista qimirlating.';

  @override
  String get compassStaleTitle => 'Kompas javob bermayapti';

  @override
  String get compassStaleBody =>
      'Koʻrsatkichlar toʻxtab qoldi. Telefonni biroz qimirlating yoki ilovani qayta ishga tushiring.';

  @override
  String get compassNoSensorTitle => 'Bu qurilmada kompas yoʻq';

  @override
  String get compassNoSensorBody =>
      'Bu qurilmada magnitometr yoʻq, shuning uchun u jonli yoʻnalishni koʻrsata olmaydi. Quyidagi azimut har qanday oddiy kompas yoki xarita bilan ishlaydi.';

  @override
  String get compassBrowserNoSensorTitle => 'Bu brauzerda kompas yoʻq';

  @override
  String get compassBrowserNoSensorBody =>
      'Kompyuter brauzerlarida yoʻnalish sensorlari yoʻq. Qibla Go-ni telefonda oching yoki quyidagi azimutni kompas yoki xarita bilan ishlating.';

  @override
  String get compassPermissionTitle => 'Harakatga ruxsat bering';

  @override
  String get compassPermissionBody =>
      'Brauzeringiz telefon yoʻnalishini oʻqish uchun ruxsat soʻraydi.';

  @override
  String get compassPermissionButton => 'Kompasni yoqish';

  @override
  String get compassPermissionDeniedBody =>
      'Harakatga ruxsat rad etildi. Brauzer sozlamalarida ruxsat bering va sahifani qayta yuklang.';

  @override
  String get compassRetry => 'Qayta urinish';

  @override
  String get compassPausedTitle => 'Kompas toʻxtatildi';

  @override
  String get issueInterferenceTitle => 'Magnit xalaqiti';

  @override
  String get issueInterferenceBody =>
      'Yaqinda magnitli yoki metall narsa bor: noutbuk, avtomobil, magnitli telefon gʻilofi. Maydon tozalanmaguncha yoʻnalish yashirin. Nariroq boring va qayta urinib koʻring.';

  @override
  String get issueMovingFastTitle => 'Siz transportda ketayotganga oʻxshaysiz';

  @override
  String get issueMovingFastBody =>
      'Harakatdagi avtomobil yoki poyezdda kompasga ishonib boʻlmaydi. Toʻxtang va yoʻnalishni tekshirish uchun tashqariga chiqing.';

  @override
  String get issueCalibrationTitle => 'Kompasni kalibrlang';

  @override
  String get issueCalibrationBody =>
      'Telefonni metalldan uzoqda bir necha marta sakkiz shaklida aylantiring.';

  @override
  String get issueNotFlatTitle => 'Telefonni tekis tuting';

  @override
  String get issueNotFlatBody =>
      'Eng barqaror koʻrsatkich uchun ekranni osmonga qaratib tuting.';

  @override
  String get issueBrowserTitle => 'Brauzer kompasi';

  @override
  String get issueBrowserBody =>
      'Brauzerlar taxminiy yoʻnalish beradi va xalaqitni sezmaydi. Namozdan oldin quyidagi azimut va iloji boʻlsa haqiqiy kompas bilan tekshiring.';

  @override
  String get issueLowAccuracyTitle => 'Aniqlik past';

  @override
  String get issueLowAccuracyBody =>
      'Sensor hozir katta xatolik koʻrsatmoqda. Kalibrlang, keyin qayta tekshiring.';

  @override
  String get declinationExtrapolatedNote =>
      'Bu ilovaning magnit modeli eskirgan. Eng yaxshi aniqlik uchun ilovani yangilang.';

  @override
  String get detailsButton => 'Tafsilotlar';

  @override
  String get detailsTitle => 'Bu yoʻnalish qanday hisoblangan';

  @override
  String get detailsSource => 'Sensor';

  @override
  String get detailsMagneticHeading => 'Magnit yoʻnalishi';

  @override
  String get detailsDeclination => 'Ogʻish (WMM2025)';

  @override
  String get detailsTrueHeading => 'Haqiqiy yoʻnalish';

  @override
  String get detailsPlatformTrueHeading => 'Haqiqiy yoʻnalish (tizim)';

  @override
  String get detailsAccuracy => 'Bildirilgan aniqlik';

  @override
  String get detailsConfidence => 'Ishonchlilik';

  @override
  String get detailsPitch => 'Qiyalik';

  @override
  String get detailsField => 'Maydon kuchi';

  @override
  String get detailsFieldExpected => 'Kutilgan maydon';

  @override
  String get detailsBearing => 'Qibla azimuti (haqiqiy)';

  @override
  String get detailsBearingMagnetic => 'Qibla azimuti (magnit)';

  @override
  String get detailsDistance => 'Kaʼbagacha masofa';

  @override
  String get detailsLocation => 'Joylashuv';

  @override
  String get detailsKaaba => 'Kaʼba';

  @override
  String get detailsMethod =>
      'WGS-84 koordinatalarida katta doiraning boshlangʻich azimuti; haqiqiy shimol magnit yoʻnalishi va shu qurilmada hisoblangan WMM2025 ogʻishidan olingan.';

  @override
  String get detailsNotAvailable => '—';

  @override
  String get detailsSimulateToggle =>
      'Kompasni simulyatsiya qilish (faqat nosozlik tuzatish nashri)';

  @override
  String get detailsSimulateHeading => 'Simulyatsiya qilingan yoʻnalish';

  @override
  String get footerFree => 'Bepul, abadiy. Reklamasiz, hisobsiz.';

  @override
  String get footerIntention => 'Alloh roziligi uchun yaratilgan.';

  @override
  String get cardinalN => 'Sh';

  @override
  String get cardinalE => 'Sq';

  @override
  String get cardinalS => 'J';

  @override
  String get cardinalW => 'Gʻ';

  @override
  String get introTagline => 'Qayerda boʻlsangiz ham, Kaʼbaga qarab';

  @override
  String get introSkip => 'Oʻtkazib yuborish';

  @override
  String get desktopPromptTitle => 'Vebda — xarita';

  @override
  String get desktopPromptBody =>
      'Jonli kompas harakat sensorlaridan foydalana oladigan telefon ilovasida. Vebda Qibla Go yoʻnalishni xaritada koʻrsatadi, quyosh va oy yoʻnalish topishga yordam beradi.';

  @override
  String get desktopPromptContinue => 'Xaritaga oʻtish';

  @override
  String get navCompass => 'Kompas';

  @override
  String get navMap => 'Xarita';

  @override
  String get mapTitle => 'Xaritada Qibla';

  @override
  String get mapYourLocation => 'Siz';

  @override
  String get mapKaaba => 'Kaʼba, Makka';

  @override
  String get mapQiblaLine => 'Qibla chizigʻi';

  @override
  String get mapSun => 'Quyosh';

  @override
  String get mapMoon => 'Oy';

  @override
  String skyMarkerLabel(String name, int azimuth) {
    return '$name $azimuth°';
  }

  @override
  String get mapRecenter => 'Haqiqiy joylashuvimdan foydalanish';

  @override
  String get mapZoomIn => 'Yaqinroq';

  @override
  String get mapZoomOut => 'Uzoqroq';

  @override
  String get mapLongPressHint =>
      'Joylashuvingizni belgilash uchun xaritaning istalgan joyini bosib turing.';

  @override
  String get mapHowTitle => 'Bu xaritadan qanday foydalanish';

  @override
  String get mapHowStep1 =>
      'Tilla rang chiziq siz turgan joydan boshlanib, toʻgʻri Kaʼbaga boradi. Namoz shu chiziq boʻylab oʻqiladi.';

  @override
  String get mapHowStep2 =>
      'Yaqiningizda chiziq kesib oʻtgan narsani toping: yoʻl, baland bino, tepalik, koʻprik. Unga qarab turing — Qiblaga qarab turgan boʻlasiz.';

  @override
  String get mapHowStep3 =>
      'Chiziq binoning qaysi tomonidan oʻtishini koʻrish uchun yaqinlashtiring, chiziq haqiqatan Makkada tugashini koʻrish uchun uzoqlashtiring.';

  @override
  String mapHowSunAbove(
    int azimuth,
    String direction,
    int offset,
    String side,
  ) {
    return 'Quyosh hozir $azimuth° da (taxminan $direction). Qibla quyoshdan $offset° $side: quyoshga qarab turing, keyin shuncha buriling.';
  }

  @override
  String mapHowMoonAbove(String phase, int azimuth, int offset, String side) {
    return 'Oy ($phase) $azimuth° da. Qibla oydan $offset° $side.';
  }

  @override
  String get mapHowSkyNone =>
      'Hozir quyosh ham, oy ham koʻrinmaydi; xaritadagi moʻljallardan foydalaning.';

  @override
  String get sideLeft => 'chapda';

  @override
  String get sideRight => 'oʻngda';

  @override
  String get compassPointNorth => 'shimol';

  @override
  String get compassPointNortheast => 'shimoli-sharq';

  @override
  String get compassPointEast => 'sharq';

  @override
  String get compassPointSoutheast => 'janubi-sharq';

  @override
  String get compassPointSouth => 'janub';

  @override
  String get compassPointSouthwest => 'janubi-gʻarb';

  @override
  String get compassPointWest => 'gʻarb';

  @override
  String get compassPointNorthwest => 'shimoli-gʻarb';

  @override
  String get moonPhaseNew => 'yangi oy';

  @override
  String get moonPhaseWaxingCrescent => 'oʻsib borayotgan hilol';

  @override
  String get moonPhaseFirstQuarter => 'birinchi chorak';

  @override
  String get moonPhaseWaxingGibbous => 'oʻsib borayotgan oy';

  @override
  String get moonPhaseFull => 'toʻlin oy';

  @override
  String get moonPhaseWaningGibbous => 'kamayib borayotgan oy';

  @override
  String get moonPhaseLastQuarter => 'oxirgi chorak';

  @override
  String get moonPhaseWaningCrescent => 'kamayib borayotgan hilol';

  @override
  String get mapAttribution => '© OpenStreetMap ishtirokchilari';

  @override
  String get mapNeedsLocation =>
      'Qibla chizigʻini chizish uchun joylashuvingizni belgilang.';

  @override
  String get supportButton => 'Bizga yozing';

  @override
  String get supportTitle => 'Bizga yozing';

  @override
  String get supportIntro =>
      'Qayerdadir notoʻgʻri koʻringan yoʻnalish, xato, fikr yoki shunchaki salom. Har bir xabar oʻqiladi.';

  @override
  String get supportMessageLabel => 'Xabaringiz';

  @override
  String get supportMessageHint => 'Nima boʻldi va qayerda?';

  @override
  String get supportContactLabel => 'Siz bilan qanday bogʻlanish (ixtiyoriy)';

  @override
  String get supportContactHint =>
      'Pochta yoki istalgan narsa, faqat javob xohlasangiz';

  @override
  String supportChallengeLabel(String question) {
    return 'Tez tekshiruv: $question nechaga teng?';
  }

  @override
  String get supportChallengeLoading => 'Savol olinmoqda…';

  @override
  String get supportChallengeUnavailable => 'Hozir savol mavjud emas.';

  @override
  String get supportAnswerHint => '=';

  @override
  String get supportNewQuestion => 'Yangi savol';

  @override
  String get supportSend => 'Yuborish';

  @override
  String get supportSending => 'Yuborilmoqda…';

  @override
  String get supportSentTitle => 'Qabul qilindi';

  @override
  String get supportSentBody => 'Yozganingiz uchun rahmat. Jazokallohu xayran.';

  @override
  String get supportClose => 'Yopish';

  @override
  String get supportPrivacyNote =>
      'Xabaringiz bilan joylashuv yoki qurilma maʼlumotlari yuborilmaydi.';

  @override
  String get supportErrorOffline =>
      'Serverga ulanib boʻlmadi. Ulanishni tekshirib, qayta urinib koʻring; matningiz saqlanadi.';

  @override
  String get supportErrorTooMany =>
      'Oxirgi soatda bu ulanishdan juda koʻp xabar keldi. Keyinroq qayta urinib koʻring.';

  @override
  String get supportErrorWrongAnswer =>
      'Javob toʻgʻri emas edi. Yangi savolga javob bering.';

  @override
  String get supportErrorExpired =>
      'Bu savol muddati tugadi. Yangisiga javob bering.';

  @override
  String get supportErrorInvalid =>
      'Server bu xabarni qabul qila olmadi. Qisqartirib, qayta urinib koʻring.';

  @override
  String get supportErrorTooShort => 'Kamida 10 ta belgi yozing.';

  @override
  String get supportErrorTooLong => '2000 belgidan oshirmang.';

  @override
  String get supportErrorAnswerMissing =>
      'Tez tekshiruvga raqam bilan javob bering.';
}

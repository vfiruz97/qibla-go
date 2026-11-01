// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Azerbaijani (`az`).
class AppLocalizationsAz extends AppLocalizations {
  AppLocalizationsAz([String locale = 'az']) : super(locale);

  @override
  String get appName => 'Qibla Go';

  @override
  String get qiblaLabel => 'QİBLƏ';

  @override
  String get fromTrueNorth => 'həqiqi şimaldan';

  @override
  String get fromMagneticNorth => 'maqnit şimalından';

  @override
  String get facingQibla => 'Qibləyə tərəf dayanmısınız';

  @override
  String turnRight(int degrees) {
    return 'Sağa $degrees° dönün';
  }

  @override
  String turnLeft(int degrees) {
    return 'Sola $degrees° dönün';
  }

  @override
  String get turnAround => 'Arxaya dönün';

  @override
  String distanceToMakkah(String distance) {
    return 'Məkkəyə $distance km';
  }

  @override
  String get atKaabaTitle => 'Kəbənin yanındasınız';

  @override
  String get atKaabaBody =>
      'Birbaşa ona tərəf dönün; bu qədər yaxında istiqamətin mənası yoxdur.';

  @override
  String accuracyPlusMinus(int degrees) {
    return '±$degrees°';
  }

  @override
  String get accuracyUnknown => 'Dəqiqlik bilinmir';

  @override
  String get qualityGood => 'Yaxşı';

  @override
  String get qualityFair => 'Orta';

  @override
  String get qualityPoor => 'Zəif';

  @override
  String get headingLabel => 'İstiqamət';

  @override
  String bearingSummary(int bearing, int magnetic) {
    return 'Qiblə həqiqi şimaldan $bearing° (maqnit kompasında $magnetic°). İstənilən kompas və ya xəritə ilə keçərlidir.';
  }

  @override
  String get locationSetLocation => 'Məkanı təyin et';

  @override
  String get locationLocating => 'Məkan təyin olunur…';

  @override
  String get locationOriginDevice => 'Cari məkan';

  @override
  String get locationOriginCached => 'Son bilinən məkan';

  @override
  String get locationOriginManual => 'Əl ilə daxil edilib';

  @override
  String locationAccuracyMeters(int meters) {
    return '±$meters m';
  }

  @override
  String get locationAgeJustNow => 'indicə';

  @override
  String locationAgeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dəqiqə əvvəl',
    );
    return '$_temp0';
  }

  @override
  String locationAgeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saat əvvəl',
    );
    return '$_temp0';
  }

  @override
  String locationAgeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün əvvəl',
    );
    return '$_temp0';
  }

  @override
  String get locationNeededTitle => 'Haradasınız?';

  @override
  String get locationNeededBody =>
      'Qiblə istiqaməti dayandığınız yerdən asılıdır. Məkana girişə icazə verin və ya koordinatlarınızı daxil edin. Məkanınız bu cihazdan heç vaxt çıxmır.';

  @override
  String get locationUseMyLocation => 'Məkanımı istifadə et';

  @override
  String get locationEnterCoordinates => 'Koordinatları daxil et';

  @override
  String get locationLatitude => 'Enlik';

  @override
  String get locationLongitude => 'Uzunluq';

  @override
  String get locationLatitudeHint => 'məs. 38,5598';

  @override
  String get locationLongitudeHint => 'məs. 68,7870';

  @override
  String get locationInvalidLatitude => 'Enlik -90 ilə 90 arasında olmalıdır';

  @override
  String get locationInvalidLongitude =>
      'Uzunluq -180 ilə 180 arasında olmalıdır';

  @override
  String get locationSave => 'Bu koordinatları istifadə et';

  @override
  String get locationOpenSettings => 'Ayarları aç';

  @override
  String get locationProblemServicesDisabled =>
      'Bu cihazda məkan xidmətləri söndürülüb.';

  @override
  String get locationProblemPermissionDenied => 'Məkan icazəsi verilməyib.';

  @override
  String get locationProblemPermissionDeniedForever =>
      'Məkan icazəsi bloklanıb. Sistem ayarlarında icazə verin.';

  @override
  String get locationProblemTimeout =>
      'Mövqe vaxtında alınmadı. Pəncərə yanında və ya açıq havada yoxlayın.';

  @override
  String get locationProblemUnavailable => 'Mövqeyiniz təyin edilə bilmədi.';

  @override
  String get locationStaleNote =>
      'Yadda saxlanılmış mövqe istifadə olunur. O vaxtdan yerinizi dəyişmisinizsə, yeniləyin.';

  @override
  String get locationSheetTitle => 'Məkanınız';

  @override
  String locationCoordinates(String latitude, String longitude) {
    return '$latitude, $longitude';
  }

  @override
  String get compassCheckingTitle => 'Kompas yoxlanılır…';

  @override
  String get compassWaitingTitle => 'Sensor gözlənilir…';

  @override
  String get compassWaitingBody =>
      'Bir andan çox çəkirsə, telefonu yavaşca hərəkət etdirin.';

  @override
  String get compassStaleTitle => 'Kompas cavab vermir';

  @override
  String get compassStaleBody =>
      'Ölçmələr dayandı. Telefonu bir az hərəkət etdirin və ya tətbiqi yenidən başladın.';

  @override
  String get compassNoSensorTitle => 'Bu cihazda kompas yoxdur';

  @override
  String get compassNoSensorBody =>
      'Bu cihazda maqnitometr yoxdur, ona görə canlı istiqamət göstərə bilməz. Aşağıdakı bucaq yenə də istənilən fiziki kompas və ya xəritə ilə işləyir.';

  @override
  String get compassBrowserNoSensorTitle => 'Bu brauzerdə kompas yoxdur';

  @override
  String get compassBrowserNoSensorBody =>
      'Masaüstü brauzerlərdə istiqamət sensorları yoxdur. Qibla Go-nu telefonda açın və ya aşağıdakı bucağı kompas ya xəritə ilə istifadə edin.';

  @override
  String get compassPermissionTitle => 'Hərəkətə girişə icazə verin';

  @override
  String get compassPermissionBody =>
      'Brauzerinizin telefonun istiqamətini oxumaq üçün icazəyə ehtiyacı var.';

  @override
  String get compassPermissionButton => 'Kompası aktivləşdir';

  @override
  String get compassPermissionDeniedBody =>
      'Hərəkətə giriş rədd edildi. Brauzer ayarlarında icazə verin və səhifəni yeniləyin.';

  @override
  String get compassRetry => 'Yenidən yoxla';

  @override
  String get compassPausedTitle => 'Kompas dayandırılıb';

  @override
  String get issueInterferenceTitle => 'Maqnit müdaxiləsi';

  @override
  String get issueInterferenceBody =>
      'Yaxınlıqda maqnit və ya metal bir şey var: noutbuk, avtomobil, maqnitli telefon qabı. Sahə təmizlənənədək istiqamət gizlədilir. Uzaqlaşın və yenidən yoxlayın.';

  @override
  String get issueMovingFastTitle => 'Deyəsən, nəqliyyatdasınız';

  @override
  String get issueMovingFastBody =>
      'Hərəkət edən avtomobil və ya qatarda kompasa etibar etmək olmaz. Dayanın və istiqaməti yoxlamaq üçün bayıra çıxın.';

  @override
  String get issueCalibrationTitle => 'Kompası kalibrləyin';

  @override
  String get issueCalibrationBody =>
      'Telefonu metaldan uzaqda bir neçə dəfə səkkiz şəklində hərəkət etdirin.';

  @override
  String get issueNotFlatTitle => 'Telefonu düz tutun';

  @override
  String get issueNotFlatBody => 'Ən sabit ölçmə üçün ekranı göyə tərəf tutun.';

  @override
  String get issueBrowserTitle => 'Brauzer kompası';

  @override
  String get issueBrowserBody =>
      'Brauzerlər təxmini istiqamət verir və müdaxiləni aşkar edə bilmir. Namazdan əvvəl aşağıdakı bucaqla və mümkünsə həqiqi kompasla yoxlayın.';

  @override
  String get issueLowAccuracyTitle => 'Aşağı dəqiqlik';

  @override
  String get issueLowAccuracyBody =>
      'Sensor hazırda böyük xəta bildirir. Kalibrləyin, sonra yenidən yoxlayın.';

  @override
  String get declinationExtrapolatedNote =>
      'Bu tətbiqin maqnit modelinin müddəti bitib. Ən yaxşı dəqiqlik üçün tətbiqi yeniləyin.';

  @override
  String get detailsButton => 'Təfərrüatlar';

  @override
  String get detailsTitle => 'Bu istiqamət necə hesablanıb';

  @override
  String get detailsSource => 'Sensor';

  @override
  String get detailsMagneticHeading => 'Maqnit istiqaməti';

  @override
  String get detailsDeclination => 'Meyl (WMM2025)';

  @override
  String get detailsTrueHeading => 'Həqiqi istiqamət';

  @override
  String get detailsPlatformTrueHeading => 'Həqiqi istiqamət (sistem)';

  @override
  String get detailsAccuracy => 'Bildirilən dəqiqlik';

  @override
  String get detailsConfidence => 'Etibarlılıq';

  @override
  String get detailsPitch => 'Əyilmə';

  @override
  String get detailsField => 'Sahə gücü';

  @override
  String get detailsFieldExpected => 'Gözlənilən sahə';

  @override
  String get detailsBearing => 'Qiblə bucağı (həqiqi)';

  @override
  String get detailsBearingMagnetic => 'Qiblə bucağı (maqnit)';

  @override
  String get detailsDistance => 'Kəbəyə məsafə';

  @override
  String get detailsLocation => 'Mövqe';

  @override
  String get detailsKaaba => 'Kəbə';

  @override
  String get detailsMethod =>
      'WGS-84 koordinatlarında böyük dairənin başlanğıc bucağı; həqiqi şimal maqnit istiqaməti ilə bu cihazda hesablanan WMM2025 meylinin cəmidir.';

  @override
  String get detailsNotAvailable => '—';

  @override
  String get detailsSimulateToggle =>
      'Kompası simulyasiya et (yalnız sazlama quruluşu)';

  @override
  String get detailsSimulateHeading => 'Simulyasiya edilən istiqamət';

  @override
  String get detailsPreviewRating =>
      'Qiymət sorğusuna önbaxış (yalnız sazlama qurulması)';

  @override
  String get footerFree => 'Pulsuz, həmişəlik. Reklamsız, hesabsız.';

  @override
  String get footerIntention => 'Allah rizası üçün hazırlanıb.';

  @override
  String get cardinalN => 'Ş';

  @override
  String get cardinalE => 'Şq';

  @override
  String get cardinalS => 'C';

  @override
  String get cardinalW => 'Q';

  @override
  String get introTagline => 'Harada olsanız da, Kəbəyə tərəf';

  @override
  String get introSkip => 'Keç';

  @override
  String get desktopPromptTitle => 'Vebdə xəritə';

  @override
  String get desktopPromptBody =>
      'Canlı kompas hərəkət sensorlarından istifadə edə bildiyi telefon tətbiqindədir. Vebdə Qibla Go istiqaməti xəritədə göstərir; günəş və ay yönünüzü tapmağa kömək edir.';

  @override
  String get desktopPromptContinue => 'Xəritəyə keç';

  @override
  String get navCompass => 'Kompas';

  @override
  String get navMap => 'Xəritə';

  @override
  String get mapTitle => 'Xəritədə Qiblə';

  @override
  String get mapYourLocation => 'Siz';

  @override
  String get mapKaaba => 'Kəbə, Məkkə';

  @override
  String get mapQiblaLine => 'Qiblə xətti';

  @override
  String get mapSun => 'Günəş';

  @override
  String get mapMoon => 'Ay';

  @override
  String skyMarkerLabel(String name, int azimuth) {
    return '$name $azimuth°';
  }

  @override
  String get mapRecenter => 'Həqiqi məkanımı istifadə et';

  @override
  String get mapZoomIn => 'Yaxınlaşdır';

  @override
  String get mapZoomOut => 'Uzaqlaşdır';

  @override
  String get mapLongPressHint =>
      'Məkanınızı təyin etmək üçün xəritədə istənilən yerə uzun basın.';

  @override
  String get mapHowTitle => 'Bu xəritədən necə istifadə etmək';

  @override
  String get mapHowStep1 =>
      'Qızılı xətt dayandığınız yerdən başlayır və düz Kəbəyə gedir. Namaz bu xətt boyunca qılınır.';

  @override
  String get mapHowStep2 =>
      'Yaxınlığınızda xəttin kəsdiyi bir şey tapın: yol, hündür bina, təpə, körpü. Ona tərəf dayanın, Qibləyə tərəf dayanmış olarsınız.';

  @override
  String get mapHowStep3 =>
      'Xəttin binanın hansı tərəfindən keçdiyini görmək üçün yaxınlaşdırın, xəttin həqiqətən Məkkədə bitdiyini görmək üçün uzaqlaşdırın.';

  @override
  String mapHowSunAbove(
    int azimuth,
    String direction,
    int offset,
    String side,
  ) {
    return 'Günəş indi $azimuth° istiqamətindədir (təxminən $direction). Qiblə günəşin $offset° $side: günəşə tərəf dayanın, sonra o qədər dönün.';
  }

  @override
  String mapHowMoonAbove(String phase, int azimuth, int offset, String side) {
    return 'Ay ($phase) $azimuth° istiqamətindədir. Qiblə ayın $offset° $side.';
  }

  @override
  String get mapHowSkyNone =>
      'İndi nə günəş, nə də ay görünür; xəritədəki nişanlardan istifadə edin.';

  @override
  String get sideLeft => 'solundadır';

  @override
  String get sideRight => 'sağındadır';

  @override
  String get compassPointNorth => 'şimal';

  @override
  String get compassPointNortheast => 'şimal-şərq';

  @override
  String get compassPointEast => 'şərq';

  @override
  String get compassPointSoutheast => 'cənub-şərq';

  @override
  String get compassPointSouth => 'cənub';

  @override
  String get compassPointSouthwest => 'cənub-qərb';

  @override
  String get compassPointWest => 'qərb';

  @override
  String get compassPointNorthwest => 'şimal-qərb';

  @override
  String get moonPhaseNew => 'yeni ay';

  @override
  String get moonPhaseWaxingCrescent => 'böyüyən aypara';

  @override
  String get moonPhaseFirstQuarter => 'birinci rüb';

  @override
  String get moonPhaseWaxingGibbous => 'böyüyən ay';

  @override
  String get moonPhaseFull => 'bədirlənmiş ay';

  @override
  String get moonPhaseWaningGibbous => 'azalan ay';

  @override
  String get moonPhaseLastQuarter => 'son rüb';

  @override
  String get moonPhaseWaningCrescent => 'azalan aypara';

  @override
  String get mapAttribution => '© OpenStreetMap iştirakçıları';

  @override
  String get mapNeedsLocation =>
      'Qiblə xəttini çəkmək üçün məkanınızı təyin edin.';

  @override
  String get supportButton => 'Bizə yazın';

  @override
  String get supportTitle => 'Bizə yazın';

  @override
  String get supportIntro =>
      'Hardasa yanlış görünən istiqamət, xəta, ideya və ya sadəcə salam. Hər mesaj oxunur.';

  @override
  String get supportMessageLabel => 'Mesajınız';

  @override
  String get supportMessageHint => 'Nə oldu və harada?';

  @override
  String get supportContactLabel => 'Sizə necə çatmaq olar (istəyə bağlı)';

  @override
  String get supportContactHint =>
      'E-poçt və ya istədiyiniz bir şey, yalnız cavab istəyirsinizsə';

  @override
  String supportChallengeLabel(String question) {
    return 'Qısa yoxlama: $question neçə edir?';
  }

  @override
  String get supportChallengeLoading => 'Sual alınır…';

  @override
  String get supportChallengeUnavailable => 'Hazırda sual yoxdur.';

  @override
  String get supportAnswerHint => '=';

  @override
  String get supportNewQuestion => 'Yeni sual';

  @override
  String get supportSend => 'Göndər';

  @override
  String get supportSending => 'Göndərilir…';

  @override
  String get supportSentTitle => 'Alındı';

  @override
  String get supportSentBody =>
      'Yazdığınız üçün təşəkkürlər. Cəzakəllahu xeyran.';

  @override
  String get supportClose => 'Bağla';

  @override
  String get supportPrivacyNote =>
      'Mesajınızla birlikdə məkan və ya cihaz məlumatı göndərilmir.';

  @override
  String get supportErrorOffline =>
      'Serverə qoşulmaq mümkün olmadı. Bağlantınızı yoxlayıb yenidən cəhd edin; mətniniz saxlanılır.';

  @override
  String get supportErrorTooMany =>
      'Son bir saatda bu bağlantıdan həddən çox mesaj gəlib. Zəhmət olmasa, sonra yenidən cəhd edin.';

  @override
  String get supportErrorWrongAnswer =>
      'Cavab düzgün deyildi. Zəhmət olmasa, yeni sualı cavablandırın.';

  @override
  String get supportErrorExpired =>
      'Bu sualın vaxtı bitdi. Zəhmət olmasa, yenisini cavablandırın.';

  @override
  String get supportErrorInvalid =>
      'Server bu mesajı qəbul edə bilmədi. Zəhmət olmasa, qısaldıb yenidən cəhd edin.';

  @override
  String get supportErrorTooShort => 'Zəhmət olmasa, ən azı 10 simvol yazın.';

  @override
  String get supportErrorTooLong => 'Zəhmət olmasa, 2000 simvoldan az yazın.';

  @override
  String get supportErrorAnswerMissing =>
      'Zəhmət olmasa, qısa yoxlamaya rəqəmlə cavab verin.';

  @override
  String get ratingTitle => 'Qibla Go xoşunuza gəlir?';

  @override
  String get ratingBodyGooglePlay =>
      'Qibla Go pulsuzdur və reklamsızdır. Google Play-də verdiyiniz qiymət başqalarına tətbiqi tapmağa və ona güvənməyə kömək edir.';

  @override
  String get ratingBodyAppStore =>
      'Qibla Go pulsuzdur və reklamsızdır. App Store-da verdiyiniz qiymət başqalarına tətbiqi tapmağa və ona güvənməyə kömək edir.';

  @override
  String get ratingRate => 'Qibla Go-nu qiymətləndirin';

  @override
  String get ratingNotNow => 'İndi yox';

  @override
  String get ratingFootnote =>
      'Yalnız bir dəfə soruşuruq. Yox desəniz, bir daha soruşmayacağıq.';

  @override
  String get ratingOpenFailed =>
      'Mağazanı açmaq mümkün olmadı. Zəhmət olmasa, sonra yenidən cəhd edin.';

  @override
  String get ratingStoreLinkGooglePlay => 'Google Play-də qiymətləndirin';

  @override
  String get ratingStoreLinkAppStore => 'App Store-da qiymətləndirin';
}

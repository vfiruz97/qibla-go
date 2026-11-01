// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Qibla Go';

  @override
  String get qiblaLabel => 'KIBLE';

  @override
  String get fromTrueNorth => 'gerçek kuzeyden';

  @override
  String get fromMagneticNorth => 'manyetik kuzeyden';

  @override
  String get facingQibla => 'Kıbleye dönüksünüz';

  @override
  String turnRight(int degrees) {
    return 'Sağa $degrees° dönün';
  }

  @override
  String turnLeft(int degrees) {
    return 'Sola $degrees° dönün';
  }

  @override
  String get turnAround => 'Arkanıza dönün';

  @override
  String distanceToMakkah(String distance) {
    return 'Mekke\'ye $distance km';
  }

  @override
  String get atKaabaTitle => 'Kâbe\'desiniz';

  @override
  String get atKaabaBody =>
      'Doğrudan ona dönün; bu kadar yakında bir yön anlamını yitirir.';

  @override
  String accuracyPlusMinus(int degrees) {
    return '±$degrees°';
  }

  @override
  String get accuracyUnknown => 'Doğruluk bilinmiyor';

  @override
  String get qualityGood => 'İyi';

  @override
  String get qualityFair => 'Orta';

  @override
  String get qualityPoor => 'Zayıf';

  @override
  String get headingLabel => 'Yön';

  @override
  String bearingSummary(int bearing, int magnetic) {
    return 'Kıble gerçek kuzeyden $bearing° (manyetik pusulada $magnetic°). Her pusula veya haritayla geçerlidir.';
  }

  @override
  String get locationSetLocation => 'Konum belirle';

  @override
  String get locationLocating => 'Konum bulunuyor…';

  @override
  String get locationOriginDevice => 'Anlık konum';

  @override
  String get locationOriginCached => 'Bilinen son konum';

  @override
  String get locationOriginManual => 'Elle girildi';

  @override
  String locationAccuracyMeters(int meters) {
    return '±$meters m';
  }

  @override
  String get locationAgeJustNow => 'az önce';

  @override
  String locationAgeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dakika önce',
    );
    return '$_temp0';
  }

  @override
  String locationAgeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saat önce',
    );
    return '$_temp0';
  }

  @override
  String locationAgeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün önce',
    );
    return '$_temp0';
  }

  @override
  String get locationNeededTitle => 'Neredesiniz?';

  @override
  String get locationNeededBody =>
      'Kıble yönü bulunduğunuz yere bağlıdır. Konum erişimine izin verin ya da koordinatlarınızı girin. Konumunuz bu cihazdan asla çıkmaz.';

  @override
  String get locationUseMyLocation => 'Konumumu kullan';

  @override
  String get locationEnterCoordinates => 'Koordinat gir';

  @override
  String get locationLatitude => 'Enlem';

  @override
  String get locationLongitude => 'Boylam';

  @override
  String get locationLatitudeHint => 'örn. 38,5598';

  @override
  String get locationLongitudeHint => 'örn. 68,7870';

  @override
  String get locationInvalidLatitude => 'Enlem -90 ile 90 arasında olmalı';

  @override
  String get locationInvalidLongitude => 'Boylam -180 ile 180 arasında olmalı';

  @override
  String get locationSave => 'Bu koordinatları kullan';

  @override
  String get locationOpenSettings => 'Ayarları aç';

  @override
  String get locationProblemServicesDisabled =>
      'Bu cihazda konum hizmetleri kapalı.';

  @override
  String get locationProblemPermissionDenied => 'Konum izni verilmedi.';

  @override
  String get locationProblemPermissionDeniedForever =>
      'Konum izni engellenmiş. Sistem ayarlarından izin verin.';

  @override
  String get locationProblemTimeout =>
      'Konum zamanında alınamadı. Pencere kenarında veya açık havada deneyin.';

  @override
  String get locationProblemUnavailable => 'Konumunuz belirlenemedi.';

  @override
  String get locationStaleNote =>
      'Kayıtlı bir konum kullanılıyor. O zamandan beri yer değiştirdiyseniz yenileyin.';

  @override
  String get locationSheetTitle => 'Konumunuz';

  @override
  String locationCoordinates(String latitude, String longitude) {
    return '$latitude, $longitude';
  }

  @override
  String get compassCheckingTitle => 'Pusula kontrol ediliyor…';

  @override
  String get compassWaitingTitle => 'Sensör bekleniyor…';

  @override
  String get compassWaitingBody =>
      'Bir andan uzun sürerse telefonu hafifçe hareket ettirin.';

  @override
  String get compassStaleTitle => 'Pusula yanıt vermiyor';

  @override
  String get compassStaleBody =>
      'Ölçümler durdu. Telefonu biraz hareket ettirin veya uygulamayı yeniden başlatın.';

  @override
  String get compassNoSensorTitle => 'Bu cihazda pusula yok';

  @override
  String get compassNoSensorBody =>
      'Bu cihazda manyetometre yok, bu yüzden canlı yön gösteremez. Aşağıdaki açı yine de her fiziksel pusula veya haritayla kullanılabilir.';

  @override
  String get compassBrowserNoSensorTitle => 'Bu tarayıcıda pusula yok';

  @override
  String get compassBrowserNoSensorBody =>
      'Masaüstü tarayıcılarda yön sensörü yoktur. Qibla Go\'yu telefonda açın ya da aşağıdaki açıyı bir pusula veya haritayla kullanın.';

  @override
  String get compassPermissionTitle => 'Hareket erişimine izin verin';

  @override
  String get compassPermissionBody =>
      'Tarayıcınızın telefonun yönünü okumak için izne ihtiyacı var.';

  @override
  String get compassPermissionButton => 'Pusulayı etkinleştir';

  @override
  String get compassPermissionDeniedBody =>
      'Hareket erişimi reddedildi. Tarayıcı ayarlarından izin verip sayfayı yenileyin.';

  @override
  String get compassRetry => 'Tekrar dene';

  @override
  String get compassPausedTitle => 'Pusula duraklatıldı';

  @override
  String get issueInterferenceTitle => 'Manyetik parazit';

  @override
  String get issueInterferenceBody =>
      'Yakınınızda manyetik veya metal bir şey var: dizüstü bilgisayar, araba, mıknatıslı telefon kılıfı. Alan temizlenene kadar yön gizli kalır. Uzaklaşıp tekrar deneyin.';

  @override
  String get issueMovingFastTitle => 'Bir araçta görünüyorsunuz';

  @override
  String get issueMovingFastBody =>
      'Hareket eden bir araba veya trende pusulaya güvenilmez. Durun ve yönü kontrol etmek için dışarı çıkın.';

  @override
  String get issueCalibrationTitle => 'Pusulanızı kalibre edin';

  @override
  String get issueCalibrationBody =>
      'Telefonu metalden uzakta birkaç kez sekiz çizerek hareket ettirin.';

  @override
  String get issueNotFlatTitle => 'Telefonu düz tutun';

  @override
  String get issueNotFlatBody =>
      'En kararlı ölçüm için ekranı gökyüzüne bakacak şekilde tutun.';

  @override
  String get issueBrowserTitle => 'Tarayıcı pusulası';

  @override
  String get issueBrowserBody =>
      'Tarayıcılar yaklaşık bir yön verir ve paraziti algılayamaz. Namazdan önce aşağıdaki açıyla ve mümkünse gerçek bir pusulayla doğrulayın.';

  @override
  String get issueLowAccuracyTitle => 'Düşük doğruluk';

  @override
  String get issueLowAccuracyBody =>
      'Sensör şu anda büyük bir hata bildiriyor. Kalibre edin, sonra tekrar kontrol edin.';

  @override
  String get declinationExtrapolatedNote =>
      'Bu uygulamanın manyetik modelinin süresi dolmuş. En iyi doğruluk için uygulamayı güncelleyin.';

  @override
  String get detailsButton => 'Ayrıntılar';

  @override
  String get detailsTitle => 'Bu yön nasıl hesaplandı';

  @override
  String get detailsSource => 'Sensör';

  @override
  String get detailsMagneticHeading => 'Manyetik yön';

  @override
  String get detailsDeclination => 'Sapma (WMM2025)';

  @override
  String get detailsTrueHeading => 'Gerçek yön';

  @override
  String get detailsPlatformTrueHeading => 'Gerçek yön (sistem)';

  @override
  String get detailsAccuracy => 'Bildirilen doğruluk';

  @override
  String get detailsConfidence => 'Güven';

  @override
  String get detailsPitch => 'Eğim';

  @override
  String get detailsField => 'Alan şiddeti';

  @override
  String get detailsFieldExpected => 'Beklenen alan';

  @override
  String get detailsBearing => 'Kıble açısı (gerçek)';

  @override
  String get detailsBearingMagnetic => 'Kıble açısı (manyetik)';

  @override
  String get detailsDistance => 'Kâbe\'ye uzaklık';

  @override
  String get detailsLocation => 'Konum';

  @override
  String get detailsKaaba => 'Kâbe';

  @override
  String get detailsMethod =>
      'WGS-84 koordinatlarında büyük daire başlangıç açısı; gerçek kuzey, manyetik yön ile bu cihazda hesaplanan WMM2025 sapmasının toplamıdır.';

  @override
  String get detailsNotAvailable => '—';

  @override
  String get detailsSimulateToggle =>
      'Pusulayı simüle et (yalnızca hata ayıklama derlemesi)';

  @override
  String get detailsSimulateHeading => 'Simüle edilen yön';

  @override
  String get footerFree => 'Ücretsiz, sonsuza dek. Reklam yok, hesap yok.';

  @override
  String get footerIntention => 'Allah rızası için yapıldı.';

  @override
  String get cardinalN => 'K';

  @override
  String get cardinalE => 'D';

  @override
  String get cardinalS => 'G';

  @override
  String get cardinalW => 'B';

  @override
  String get introTagline => 'Nerede olsanız da Kâbe\'ye dönün';

  @override
  String get introSkip => 'Geç';

  @override
  String get desktopPromptTitle => 'Web\'de harita';

  @override
  String get desktopPromptBody =>
      'Canlı pusula, hareket sensörlerini kullanabildiği telefon uygulamasındadır. Web\'de Qibla Go yönü harita üzerinde gösterir; güneş ve ay yönünüzü bulmanıza yardım eder.';

  @override
  String get desktopPromptContinue => 'Haritaya devam et';

  @override
  String get navCompass => 'Pusula';

  @override
  String get navMap => 'Harita';

  @override
  String get mapTitle => 'Haritada Kıble';

  @override
  String get mapYourLocation => 'Siz';

  @override
  String get mapKaaba => 'Kâbe, Mekke';

  @override
  String get mapQiblaLine => 'Kıble çizgisi';

  @override
  String get mapSun => 'Güneş';

  @override
  String get mapMoon => 'Ay';

  @override
  String skyMarkerLabel(String name, int azimuth) {
    return '$name $azimuth°';
  }

  @override
  String get mapRecenter => 'Gerçek konumumu kullan';

  @override
  String get mapZoomIn => 'Yaklaştır';

  @override
  String get mapZoomOut => 'Uzaklaştır';

  @override
  String get mapLongPressHint =>
      'Konumunuzu belirlemek için haritada herhangi bir yere uzun basın.';

  @override
  String get mapHowTitle => 'Bu harita nasıl kullanılır';

  @override
  String get mapHowStep1 =>
      'Altın çizgi bulunduğunuz yerden başlar ve dümdüz Kâbe\'ye gider. Namaz bu çizgi boyunca kılınır.';

  @override
  String get mapHowStep2 =>
      'Yakınınızda çizginin kestiği bir şey bulun: bir yol, yüksek bir bina, bir tepe, bir köprü. Ona dönük durun, Kıbleye dönük olursunuz.';

  @override
  String get mapHowStep3 =>
      'Çizginin bir binanın hangi yanından geçtiğini görmek için yaklaştırın; çizginin gerçekten Mekke\'de bittiğini görmek için uzaklaştırın.';

  @override
  String mapHowSunAbove(
    int azimuth,
    String direction,
    int offset,
    String side,
  ) {
    return 'Güneş şu anda $azimuth° yönünde (yaklaşık $direction). Kıble, güneşin $offset° $side: güneşe dönük durun, sonra o kadar dönün.';
  }

  @override
  String mapHowMoonAbove(String phase, int azimuth, int offset, String side) {
    return 'Ay ($phase) $azimuth° yönünde. Kıble, ayın $offset° $side.';
  }

  @override
  String get mapHowSkyNone =>
      'Şu anda ne güneş ne ay görünüyor; haritadaki yer işaretlerini kullanın.';

  @override
  String get sideLeft => 'solunda';

  @override
  String get sideRight => 'sağında';

  @override
  String get compassPointNorth => 'kuzey';

  @override
  String get compassPointNortheast => 'kuzeydoğu';

  @override
  String get compassPointEast => 'doğu';

  @override
  String get compassPointSoutheast => 'güneydoğu';

  @override
  String get compassPointSouth => 'güney';

  @override
  String get compassPointSouthwest => 'güneybatı';

  @override
  String get compassPointWest => 'batı';

  @override
  String get compassPointNorthwest => 'kuzeybatı';

  @override
  String get moonPhaseNew => 'yeni ay';

  @override
  String get moonPhaseWaxingCrescent => 'hilal';

  @override
  String get moonPhaseFirstQuarter => 'ilk dördün';

  @override
  String get moonPhaseWaxingGibbous => 'şişkin ay (büyüyen)';

  @override
  String get moonPhaseFull => 'dolunay';

  @override
  String get moonPhaseWaningGibbous => 'şişkin ay (küçülen)';

  @override
  String get moonPhaseLastQuarter => 'son dördün';

  @override
  String get moonPhaseWaningCrescent => 'küçülen hilal';

  @override
  String get mapAttribution => '© OpenStreetMap katkıda bulunanlar';

  @override
  String get mapNeedsLocation =>
      'Kıble çizgisini çizmek için konumunuzu belirleyin.';

  @override
  String get supportButton => 'Bize yazın';

  @override
  String get supportTitle => 'Bize yazın';

  @override
  String get supportIntro =>
      'Bir yerde yanlış görünen bir yön, bir hata, bir fikir ya da sadece bir selam. Her mesaj okunur.';

  @override
  String get supportMessageLabel => 'Mesajınız';

  @override
  String get supportMessageHint => 'Ne oldu ve nerede?';

  @override
  String get supportContactLabel => 'Size nasıl ulaşalım (isteğe bağlı)';

  @override
  String get supportContactHint =>
      'E-posta veya dilediğiniz bir şey, yalnızca yanıt istiyorsanız';

  @override
  String supportChallengeLabel(String question) {
    return 'Hızlı kontrol: $question kaç eder?';
  }

  @override
  String get supportChallengeLoading => 'Soru alınıyor…';

  @override
  String get supportChallengeUnavailable => 'Şu anda soru yok.';

  @override
  String get supportAnswerHint => '=';

  @override
  String get supportNewQuestion => 'Yeni soru';

  @override
  String get supportSend => 'Gönder';

  @override
  String get supportSending => 'Gönderiliyor…';

  @override
  String get supportSentTitle => 'Alındı';

  @override
  String get supportSentBody =>
      'Yazdığınız için teşekkürler. Cezakallahu hayran.';

  @override
  String get supportClose => 'Kapat';

  @override
  String get supportPrivacyNote =>
      'Mesajınızla birlikte konum veya cihaz verisi gönderilmez.';

  @override
  String get supportErrorOffline =>
      'Sunucuya ulaşılamadı. Bağlantınızı kontrol edip tekrar deneyin; metniniz saklanıyor.';

  @override
  String get supportErrorTooMany =>
      'Son bir saatte bu bağlantıdan çok fazla mesaj geldi. Lütfen daha sonra tekrar deneyin.';

  @override
  String get supportErrorWrongAnswer =>
      'Yanıt doğru değildi. Lütfen yeni soruyu deneyin.';

  @override
  String get supportErrorExpired =>
      'Bu sorunun süresi doldu. Lütfen yenisini deneyin.';

  @override
  String get supportErrorInvalid =>
      'Sunucu bu mesajı kabul edemedi. Lütfen kısaltıp tekrar deneyin.';

  @override
  String get supportErrorTooShort => 'Lütfen en az 10 karakter yazın.';

  @override
  String get supportErrorTooLong => 'Lütfen 2000 karakterin altında kalın.';

  @override
  String get supportErrorAnswerMissing =>
      'Lütfen hızlı kontrolü bir sayıyla yanıtlayın.';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appName => 'Qibla Go';

  @override
  String get qiblaLabel => 'قبله';

  @override
  String get fromTrueNorth => 'از شمال حقیقی';

  @override
  String get fromMagneticNorth => 'از شمال مغناطیسی';

  @override
  String get facingQibla => 'شما رو به قبله هستید';

  @override
  String turnRight(int degrees) {
    return '$degrees° به راست بچرخید';
  }

  @override
  String turnLeft(int degrees) {
    return '$degrees° به چپ بچرخید';
  }

  @override
  String get turnAround => 'برگردید';

  @override
  String distanceToMakkah(String distance) {
    return '$distance کیلومتر تا مکه';
  }

  @override
  String get atKaabaTitle => 'شما کنار کعبه هستید';

  @override
  String get atKaabaBody =>
      'مستقیم رو به آن بایستید؛ در این فاصله جهت معنایی ندارد.';

  @override
  String accuracyPlusMinus(int degrees) {
    return '±$degrees°';
  }

  @override
  String get accuracyUnknown => 'دقت نامشخص';

  @override
  String get qualityGood => 'خوب';

  @override
  String get qualityFair => 'متوسط';

  @override
  String get qualityPoor => 'ضعیف';

  @override
  String get headingLabel => 'جهت';

  @override
  String bearingSummary(int bearing, int magnetic) {
    return 'قبله $bearing° از شمال حقیقی است ($magnetic° روی قطب‌نمای مغناطیسی). با هر قطب‌نما یا نقشه‌ای معتبر است.';
  }

  @override
  String get locationSetLocation => 'تعیین موقعیت';

  @override
  String get locationLocating => 'در حال مکان‌یابی…';

  @override
  String get locationOriginDevice => 'موقعیت فعلی';

  @override
  String get locationOriginCached => 'آخرین موقعیت شناخته‌شده';

  @override
  String get locationOriginManual => 'دستی وارد شده';

  @override
  String locationAccuracyMeters(int meters) {
    return '±$meters متر';
  }

  @override
  String get locationAgeJustNow => 'هم‌اکنون';

  @override
  String locationAgeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دقیقه پیش',
    );
    return '$_temp0';
  }

  @override
  String locationAgeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ساعت پیش',
    );
    return '$_temp0';
  }

  @override
  String locationAgeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count روز پیش',
    );
    return '$_temp0';
  }

  @override
  String get locationNeededTitle => 'کجا هستید؟';

  @override
  String get locationNeededBody =>
      'جهت قبله به جایی که ایستاده‌اید بستگی دارد. دسترسی به موقعیت را مجاز کنید یا مختصات خود را وارد کنید. موقعیت شما هرگز از این دستگاه خارج نمی‌شود.';

  @override
  String get locationUseMyLocation => 'استفاده از موقعیت من';

  @override
  String get locationEnterCoordinates => 'وارد کردن مختصات';

  @override
  String get locationLatitude => 'عرض جغرافیایی';

  @override
  String get locationLongitude => 'طول جغرافیایی';

  @override
  String get locationLatitudeHint => 'مثلاً 35.6892';

  @override
  String get locationLongitudeHint => 'مثلاً 51.3890';

  @override
  String get locationInvalidLatitude => 'عرض جغرافیایی باید بین -90 و 90 باشد';

  @override
  String get locationInvalidLongitude =>
      'طول جغرافیایی باید بین -180 و 180 باشد';

  @override
  String get locationSave => 'استفاده از این مختصات';

  @override
  String get locationOpenSettings => 'باز کردن تنظیمات';

  @override
  String get locationProblemServicesDisabled =>
      'سرویس‌های موقعیت مکانی در این دستگاه خاموش است.';

  @override
  String get locationProblemPermissionDenied =>
      'اجازهٴ دسترسی به موقعیت داده نشد.';

  @override
  String get locationProblemPermissionDeniedForever =>
      'دسترسی به موقعیت مسدود شده است. آن را در تنظیمات سیستم مجاز کنید.';

  @override
  String get locationProblemTimeout =>
      'موقعیت به‌موقع دریافت نشد. کنار پنجره یا در فضای باز تلاش کنید.';

  @override
  String get locationProblemUnavailable => 'موقعیت شما مشخص نشد.';

  @override
  String get locationStaleNote =>
      'از موقعیت ذخیره‌شده استفاده می‌شود. اگر از آن زمان جابه‌جا شده‌اید، آن را تازه کنید.';

  @override
  String get locationSheetTitle => 'موقعیت شما';

  @override
  String locationCoordinates(String latitude, String longitude) {
    return '$latitude، $longitude';
  }

  @override
  String get compassCheckingTitle => 'بررسی قطب‌نما…';

  @override
  String get compassWaitingTitle => 'در انتظار حسگر…';

  @override
  String get compassWaitingBody =>
      'اگر بیش از چند لحظه طول کشید، گوشی را به‌آرامی حرکت دهید.';

  @override
  String get compassStaleTitle => 'قطب‌نما پاسخ نمی‌دهد';

  @override
  String get compassStaleBody =>
      'داده‌ها متوقف شده‌اند. گوشی را کمی حرکت دهید یا برنامه را دوباره باز کنید.';

  @override
  String get compassNoSensorTitle => 'این دستگاه قطب‌نما ندارد';

  @override
  String get compassNoSensorBody =>
      'این دستگاه مغناطیس‌سنج ندارد، بنابراین نمی‌تواند جهت زنده را نشان دهد. زاویهٴ زیر همچنان با هر قطب‌نمای واقعی یا نقشه کار می‌کند.';

  @override
  String get compassBrowserNoSensorTitle => 'این مرورگر قطب‌نما ندارد';

  @override
  String get compassBrowserNoSensorBody =>
      'مرورگرهای رایانه حسگر جهت ندارند. Qibla Go را روی گوشی باز کنید، یا زاویهٴ زیر را با قطب‌نما یا نقشه به کار ببرید.';

  @override
  String get compassPermissionTitle => 'اجازهٴ دسترسی به حرکت';

  @override
  String get compassPermissionBody =>
      'مرورگر شما برای خواندن جهت گوشی به اجازه نیاز دارد.';

  @override
  String get compassPermissionButton => 'فعال کردن قطب‌نما';

  @override
  String get compassPermissionDeniedBody =>
      'دسترسی به حرکت رد شد. آن را در تنظیمات مرورگر مجاز کنید و صفحه را دوباره بارگیری کنید.';

  @override
  String get compassRetry => 'تلاش دوباره';

  @override
  String get compassPausedTitle => 'قطب‌نما متوقف شد';

  @override
  String get issueInterferenceTitle => 'تداخل مغناطیسی';

  @override
  String get issueInterferenceBody =>
      'چیزی مغناطیسی یا فلزی نزدیک است: لپ‌تاپ، خودرو، قاب گوشی با آهن‌ربا. تا پاک شدن میدان، جهت پنهان می‌ماند. دورتر بروید و دوباره تلاش کنید.';

  @override
  String get issueMovingFastTitle => 'به نظر می‌رسد در وسیلهٴ نقلیه هستید';

  @override
  String get issueMovingFastBody =>
      'در خودرو یا قطار در حال حرکت نمی‌توان به قطب‌نما اعتماد کرد. توقف کنید و برای بررسی جهت بیرون بیایید.';

  @override
  String get issueCalibrationTitle => 'قطب‌نما را کالیبره کنید';

  @override
  String get issueCalibrationBody =>
      'گوشی را چند بار به شکل عدد هشت حرکت دهید، دور از فلز.';

  @override
  String get issueNotFlatTitle => 'گوشی را صاف نگه دارید';

  @override
  String get issueNotFlatBody =>
      'برای پایدارترین خوانش، صفحه را رو به آسمان نگه دارید.';

  @override
  String get issueBrowserTitle => 'قطب‌نمای مرورگر';

  @override
  String get issueBrowserBody =>
      'مرورگرها جهت تقریبی می‌دهند و تداخل را تشخیص نمی‌دهند. پیش از نماز با زاویهٴ زیر و اگر می‌توانید با یک قطب‌نمای واقعی تأیید کنید.';

  @override
  String get issueLowAccuracyTitle => 'دقت کم';

  @override
  String get issueLowAccuracyBody =>
      'حسگر اکنون خطای بزرگی گزارش می‌دهد. کالیبره کنید و دوباره بررسی کنید.';

  @override
  String get declinationExtrapolatedNote =>
      'مدل مغناطیسی این برنامه منقضی شده است. برای بهترین دقت، برنامه را به‌روز کنید.';

  @override
  String get detailsButton => 'جزئیات';

  @override
  String get detailsTitle => 'این جهت چگونه محاسبه شد';

  @override
  String get detailsSource => 'حسگر';

  @override
  String get detailsMagneticHeading => 'جهت مغناطیسی';

  @override
  String get detailsDeclination => 'انحراف مغناطیسی (WMM2025)';

  @override
  String get detailsTrueHeading => 'جهت حقیقی';

  @override
  String get detailsPlatformTrueHeading => 'جهت حقیقی (سیستم)';

  @override
  String get detailsAccuracy => 'دقت گزارش‌شده';

  @override
  String get detailsConfidence => 'اطمینان';

  @override
  String get detailsPitch => 'شیب';

  @override
  String get detailsField => 'شدت میدان';

  @override
  String get detailsFieldExpected => 'میدان مورد انتظار';

  @override
  String get detailsBearing => 'زاویهٴ قبله (حقیقی)';

  @override
  String get detailsBearingMagnetic => 'زاویهٴ قبله (مغناطیسی)';

  @override
  String get detailsDistance => 'فاصله تا کعبه';

  @override
  String get detailsLocation => 'موقعیت';

  @override
  String get detailsKaaba => 'کعبه';

  @override
  String get detailsMethod =>
      'زاویهٴ آغازین دایرهٴ عظیمه روی مختصات WGS-84؛ شمال حقیقی از جهت مغناطیسی به‌علاوهٴ انحراف WMM2025 که روی این دستگاه محاسبه شده است.';

  @override
  String get detailsNotAvailable => '—';

  @override
  String get detailsSimulateToggle =>
      'شبیه‌سازی قطب‌نما (فقط نسخهٴ اشکال‌زدایی)';

  @override
  String get detailsSimulateHeading => 'جهت شبیه‌سازی‌شده';

  @override
  String get footerFree => 'رایگان، برای همیشه. بدون تبلیغ، بدون حساب کاربری.';

  @override
  String get footerIntention => 'برای رضای خدا ساخته شده است.';

  @override
  String get cardinalN => 'ش';

  @override
  String get cardinalE => 'شر';

  @override
  String get cardinalS => 'ج';

  @override
  String get cardinalW => 'غ';

  @override
  String get introTagline => 'رو به کعبه، هر جا که هستید';

  @override
  String get introSkip => 'رد کردن';

  @override
  String get desktopPromptTitle => 'در وب، نقشه';

  @override
  String get desktopPromptBody =>
      'قطب‌نمای زنده در برنامهٴ گوشی است، جایی که می‌تواند از حسگرهای حرکتی استفاده کند. در وب، Qibla Go جهت را روی نقشه نشان می‌دهد و خورشید و ماه به جهت‌یابی کمک می‌کنند.';

  @override
  String get desktopPromptContinue => 'ادامه به نقشه';

  @override
  String get navCompass => 'قطب‌نما';

  @override
  String get navMap => 'نقشه';

  @override
  String get mapTitle => 'قبله روی نقشه';

  @override
  String get mapYourLocation => 'شما';

  @override
  String get mapKaaba => 'کعبه، مکه';

  @override
  String get mapQiblaLine => 'خط قبله';

  @override
  String get mapSun => 'خورشید';

  @override
  String get mapMoon => 'ماه';

  @override
  String skyMarkerLabel(String name, int azimuth) {
    return '$name $azimuth°';
  }

  @override
  String get mapRecenter => 'استفاده از موقعیت واقعی من';

  @override
  String get mapZoomIn => 'نزدیک‌تر';

  @override
  String get mapZoomOut => 'دورتر';

  @override
  String get mapLongPressHint =>
      'هر نقطه‌ای از نقشه را لمس کنید و نگه دارید تا موقعیت شما آنجا تعیین شود.';

  @override
  String get mapHowTitle => 'راهنمای استفاده از نقشه';

  @override
  String get mapHowStep1 =>
      'خط طلایی از جای شما شروع می‌شود و مستقیم به کعبه می‌رسد. نماز رو به همین خط خوانده می‌شود.';

  @override
  String get mapHowStep2 =>
      'نزدیک خود چیزی را پیدا کنید که خط از آن می‌گذرد: جاده، ساختمان بلند، تپه، پل. رو به آن بایستید؛ آنگاه رو به قبله هستید.';

  @override
  String get mapHowStep3 =>
      'نقشه را بزرگ کنید تا ببینید خط از کدام سمت یک ساختمان می‌گذرد، و کوچک کنید تا ببینید خط واقعاً در مکه تمام می‌شود.';

  @override
  String mapHowSunAbove(
    int azimuth,
    String direction,
    int offset,
    String side,
  ) {
    return 'خورشید اکنون در $azimuth° است (حدوداً $direction). قبله $offset° در سمت $side خورشید است: رو به خورشید بایستید، سپس همان‌قدر بچرخید.';
  }

  @override
  String mapHowMoonAbove(String phase, int azimuth, int offset, String side) {
    return 'ماه ($phase) در $azimuth° است. قبله $offset° در سمت $side آن است.';
  }

  @override
  String get mapHowSkyNone =>
      'اکنون نه خورشید و نه ماه در آسمان است؛ از نشانه‌های روی نقشه استفاده کنید.';

  @override
  String get sideLeft => 'چپ';

  @override
  String get sideRight => 'راست';

  @override
  String get compassPointNorth => 'شمال';

  @override
  String get compassPointNortheast => 'شمال شرقی';

  @override
  String get compassPointEast => 'شرق';

  @override
  String get compassPointSoutheast => 'جنوب شرقی';

  @override
  String get compassPointSouth => 'جنوب';

  @override
  String get compassPointSouthwest => 'جنوب غربی';

  @override
  String get compassPointWest => 'غرب';

  @override
  String get compassPointNorthwest => 'شمال غربی';

  @override
  String get moonPhaseNew => 'ماه نو';

  @override
  String get moonPhaseWaxingCrescent => 'هلال فزاینده';

  @override
  String get moonPhaseFirstQuarter => 'تربیع اول';

  @override
  String get moonPhaseWaxingGibbous => 'ماه فزاینده';

  @override
  String get moonPhaseFull => 'ماه کامل';

  @override
  String get moonPhaseWaningGibbous => 'ماه کاهنده';

  @override
  String get moonPhaseLastQuarter => 'تربیع دوم';

  @override
  String get moonPhaseWaningCrescent => 'هلال کاهنده';

  @override
  String get mapAttribution => '© مشارکت‌کنندگان OpenStreetMap';

  @override
  String get mapNeedsLocation => 'برای رسم خط قبله، موقعیت خود را تعیین کنید.';

  @override
  String get supportButton => 'برای ما بنویسید';

  @override
  String get supportTitle => 'برای ما بنویسید';

  @override
  String get supportIntro =>
      'جهتی که جایی اشتباه به نظر می‌رسد، یک خطا، یک ایده یا فقط یک سلام. هر پیام خوانده می‌شود.';

  @override
  String get supportMessageLabel => 'پیام شما';

  @override
  String get supportMessageHint => 'چه اتفاقی افتاد و کجا؟';

  @override
  String get supportContactLabel => 'راه ارتباط با شما (اختیاری)';

  @override
  String get supportContactHint =>
      'ایمیل یا هر چیز دیگر، فقط اگر پاسخ می‌خواهید';

  @override
  String supportChallengeLabel(String question) {
    return 'بررسی سریع: $question چند می‌شود؟';
  }

  @override
  String get supportChallengeLoading => 'دریافت سؤال…';

  @override
  String get supportChallengeUnavailable => 'اکنون سؤالی در دسترس نیست.';

  @override
  String get supportAnswerHint => '=';

  @override
  String get supportNewQuestion => 'سؤال جدید';

  @override
  String get supportSend => 'ارسال';

  @override
  String get supportSending => 'در حال ارسال…';

  @override
  String get supportSentTitle => 'دریافت شد';

  @override
  String get supportSentBody => 'از پیام شما سپاسگزاریم. جزاک‌الله خیراً.';

  @override
  String get supportClose => 'بستن';

  @override
  String get supportPrivacyNote =>
      'همراه پیام شما هیچ دادهٴ موقعیت یا دستگاه ارسال نمی‌شود.';

  @override
  String get supportErrorOffline =>
      'دسترسی به سرور ممکن نشد. اتصال خود را بررسی کنید و دوباره تلاش کنید؛ متن شما نگه داشته می‌شود.';

  @override
  String get supportErrorTooMany =>
      'در ساعت گذشته پیام‌های زیادی از این اتصال فرستاده شده است. لطفاً بعداً دوباره تلاش کنید.';

  @override
  String get supportErrorWrongAnswer =>
      'پاسخ درست نبود. لطفاً به سؤال جدید پاسخ دهید.';

  @override
  String get supportErrorExpired =>
      'آن سؤال منقضی شد. لطفاً سؤال جدید را پاسخ دهید.';

  @override
  String get supportErrorInvalid =>
      'سرور این پیام را نپذیرفت. لطفاً آن را کوتاه‌تر کنید و دوباره تلاش کنید.';

  @override
  String get supportErrorTooShort => 'لطفاً دست‌کم 10 نویسه بنویسید.';

  @override
  String get supportErrorTooLong => 'لطفاً کمتر از 2000 نویسه بنویسید.';

  @override
  String get supportErrorAnswerMissing =>
      'لطفاً به بررسی سریع با یک عدد پاسخ دهید.';
}

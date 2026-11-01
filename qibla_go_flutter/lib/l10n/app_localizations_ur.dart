// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appName => 'Qibla Go';

  @override
  String get qiblaLabel => 'قبلہ';

  @override
  String get fromTrueNorth => 'حقیقی شمال سے';

  @override
  String get fromMagneticNorth => 'مقناطیسی شمال سے';

  @override
  String get facingQibla => 'آپ کا رخ قبلے کی طرف ہے';

  @override
  String turnRight(int degrees) {
    return 'دائیں $degrees° مڑیں';
  }

  @override
  String turnLeft(int degrees) {
    return 'بائیں $degrees° مڑیں';
  }

  @override
  String get turnAround => 'پیچھے مڑیں';

  @override
  String distanceToMakkah(String distance) {
    return 'مکہ تک $distance کلومیٹر';
  }

  @override
  String get atKaabaTitle => 'آپ کعبہ کے پاس ہیں';

  @override
  String get atKaabaBody =>
      'سیدھا اس کی طرف رخ کریں؛ اتنے قریب سمت کا کوئی مطلب نہیں رہتا۔';

  @override
  String accuracyPlusMinus(int degrees) {
    return '±$degrees°';
  }

  @override
  String get accuracyUnknown => 'درستگی معلوم نہیں';

  @override
  String get qualityGood => 'اچھی';

  @override
  String get qualityFair => 'درمیانی';

  @override
  String get qualityPoor => 'خراب';

  @override
  String get headingLabel => 'رخ';

  @override
  String bearingSummary(int bearing, int magnetic) {
    return 'قبلہ حقیقی شمال سے $bearing° پر ہے (مقناطیسی قطب نما پر $magnetic°)۔ کسی بھی قطب نما یا نقشے کے ساتھ درست ہے۔';
  }

  @override
  String get locationSetLocation => 'مقام مقرر کریں';

  @override
  String get locationLocating => 'مقام معلوم کیا جا رہا ہے…';

  @override
  String get locationOriginDevice => 'موجودہ مقام';

  @override
  String get locationOriginCached => 'آخری معلوم مقام';

  @override
  String get locationOriginManual => 'ہاتھ سے درج کیا گیا';

  @override
  String locationAccuracyMeters(int meters) {
    return '±$meters میٹر';
  }

  @override
  String get locationAgeJustNow => 'ابھی ابھی';

  @override
  String locationAgeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منٹ پہلے',
      one: '$count منٹ پہلے',
    );
    return '$_temp0';
  }

  @override
  String locationAgeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count گھنٹے پہلے',
      one: '$count گھنٹہ پہلے',
    );
    return '$_temp0';
  }

  @override
  String locationAgeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دن پہلے',
      one: '$count دن پہلے',
    );
    return '$_temp0';
  }

  @override
  String get locationNeededTitle => 'آپ کہاں ہیں؟';

  @override
  String get locationNeededBody =>
      'قبلے کی سمت اس بات پر منحصر ہے کہ آپ کہاں کھڑے ہیں۔ مقام تک رسائی کی اجازت دیں، یا اپنے کوآرڈینیٹس درج کریں۔ آپ کا مقام کبھی اس آلے سے باہر نہیں جاتا۔';

  @override
  String get locationUseMyLocation => 'میرا مقام استعمال کریں';

  @override
  String get locationEnterCoordinates => 'کوآرڈینیٹس درج کریں';

  @override
  String get locationLatitude => 'عرض بلد';

  @override
  String get locationLongitude => 'طول بلد';

  @override
  String get locationLatitudeHint => 'مثلاً 24.8607';

  @override
  String get locationLongitudeHint => 'مثلاً 67.0011';

  @override
  String get locationInvalidLatitude =>
      'عرض بلد -90 اور 90 کے درمیان ہونا چاہیے';

  @override
  String get locationInvalidLongitude =>
      'طول بلد -180 اور 180 کے درمیان ہونا چاہیے';

  @override
  String get locationSave => 'یہ کوآرڈینیٹس استعمال کریں';

  @override
  String get locationOpenSettings => 'ترتیبات کھولیں';

  @override
  String get locationProblemServicesDisabled =>
      'اس آلے پر مقام کی سروس بند ہے۔';

  @override
  String get locationProblemPermissionDenied => 'مقام کی اجازت نہیں دی گئی۔';

  @override
  String get locationProblemPermissionDeniedForever =>
      'مقام کی اجازت بلاک ہے۔ سسٹم کی ترتیبات میں اجازت دیں۔';

  @override
  String get locationProblemTimeout =>
      'وقت پر مقام نہیں مل سکا۔ کھڑکی کے پاس یا کھلی جگہ پر کوشش کریں۔';

  @override
  String get locationProblemUnavailable => 'آپ کا مقام معلوم نہیں ہو سکا۔';

  @override
  String get locationStaleNote =>
      'محفوظ شدہ مقام استعمال ہو رہا ہے۔ اگر آپ تب سے کہیں اور گئے ہیں تو اسے تازہ کریں۔';

  @override
  String get locationSheetTitle => 'آپ کا مقام';

  @override
  String locationCoordinates(String latitude, String longitude) {
    return '$latitude، $longitude';
  }

  @override
  String get compassCheckingTitle => 'قطب نما جانچا جا رہا ہے…';

  @override
  String get compassWaitingTitle => 'سینسر کا انتظار…';

  @override
  String get compassWaitingBody =>
      'اگر اس میں ایک لمحے سے زیادہ لگے تو فون کو آہستہ سے حرکت دیں۔';

  @override
  String get compassStaleTitle => 'قطب نما جواب نہیں دے رہا';

  @override
  String get compassStaleBody =>
      'پیمائش رک گئی ہے۔ فون کو ذرا حرکت دیں، یا ایپ دوبارہ کھولیں۔';

  @override
  String get compassNoSensorTitle => 'اس آلے میں قطب نما نہیں';

  @override
  String get compassNoSensorBody =>
      'اس آلے میں مقناطیسی سینسر نہیں، اس لیے یہ براہِ راست سمت نہیں دکھا سکتا۔ نیچے دیا گیا زاویہ کسی بھی اصلی قطب نما یا نقشے کے ساتھ کام کرتا ہے۔';

  @override
  String get compassBrowserNoSensorTitle => 'اس براؤزر میں قطب نما نہیں';

  @override
  String get compassBrowserNoSensorBody =>
      'کمپیوٹر کے براؤزروں میں سمت کے سینسر نہیں ہوتے۔ Qibla Go فون پر کھولیں، یا نیچے دیا گیا زاویہ قطب نما یا نقشے کے ساتھ استعمال کریں۔';

  @override
  String get compassPermissionTitle => 'حرکت تک رسائی کی اجازت دیں';

  @override
  String get compassPermissionBody =>
      'فون کا رخ پڑھنے کے لیے آپ کے براؤزر کو اجازت درکار ہے۔';

  @override
  String get compassPermissionButton => 'قطب نما فعال کریں';

  @override
  String get compassPermissionDeniedBody =>
      'حرکت تک رسائی مسترد کر دی گئی۔ براؤزر کی ترتیبات میں اجازت دیں اور صفحہ دوبارہ لوڈ کریں۔';

  @override
  String get compassRetry => 'دوبارہ کوشش کریں';

  @override
  String get compassPausedTitle => 'قطب نما رکا ہوا ہے';

  @override
  String get issueInterferenceTitle => 'مقناطیسی مداخلت';

  @override
  String get issueInterferenceBody =>
      'قریب کوئی مقناطیسی یا دھاتی چیز ہے: لیپ ٹاپ، گاڑی، مقناطیس والا فون کور۔ جب تک میدان صاف نہ ہو سمت پوشیدہ رہے گی۔ دور ہٹیں اور دوبارہ کوشش کریں۔';

  @override
  String get issueMovingFastTitle => 'لگتا ہے آپ کسی گاڑی میں ہیں';

  @override
  String get issueMovingFastBody =>
      'چلتی گاڑی یا ٹرین میں قطب نما پر بھروسہ نہیں کیا جا سکتا۔ رکیں اور سمت جانچنے کے لیے باہر نکلیں۔';

  @override
  String get issueCalibrationTitle => 'قطب نما کیلیبریٹ کریں';

  @override
  String get issueCalibrationBody =>
      'دھات سے دور، فون کو چند بار آٹھ کی شکل میں حرکت دیں۔';

  @override
  String get issueNotFlatTitle => 'فون کو سیدھا رکھیں';

  @override
  String get issueNotFlatBody =>
      'سب سے مستحکم پیمائش کے لیے اسکرین کا رخ آسمان کی طرف رکھیں۔';

  @override
  String get issueBrowserTitle => 'براؤزر کا قطب نما';

  @override
  String get issueBrowserBody =>
      'براؤزر صرف اندازاً سمت دیتے ہیں اور مداخلت نہیں پکڑ سکتے۔ نماز سے پہلے نیچے دیے گئے زاویے سے، اور ہو سکے تو اصلی قطب نما سے تصدیق کریں۔';

  @override
  String get issueLowAccuracyTitle => 'کم درستگی';

  @override
  String get issueLowAccuracyBody =>
      'سینسر ابھی بڑی غلطی کی اطلاع دے رہا ہے۔ کیلیبریٹ کریں، پھر دوبارہ جانچیں۔';

  @override
  String get declinationExtrapolatedNote =>
      'اس ایپ کا مقناطیسی ماڈل زائد المیعاد ہو گیا ہے۔ بہترین درستگی کے لیے ایپ اپ ڈیٹ کریں۔';

  @override
  String get detailsButton => 'تفصیلات';

  @override
  String get detailsTitle => 'یہ سمت کیسے نکالی گئی';

  @override
  String get detailsSource => 'سینسر';

  @override
  String get detailsMagneticHeading => 'مقناطیسی رخ';

  @override
  String get detailsDeclination => 'مقناطیسی انحراف (WMM2025)';

  @override
  String get detailsTrueHeading => 'حقیقی رخ';

  @override
  String get detailsPlatformTrueHeading => 'حقیقی رخ (سسٹم)';

  @override
  String get detailsAccuracy => 'بتائی گئی درستگی';

  @override
  String get detailsConfidence => 'اعتماد';

  @override
  String get detailsPitch => 'جھکاؤ';

  @override
  String get detailsField => 'میدان کی شدت';

  @override
  String get detailsFieldExpected => 'متوقع میدان';

  @override
  String get detailsBearing => 'قبلے کا زاویہ (حقیقی)';

  @override
  String get detailsBearingMagnetic => 'قبلے کا زاویہ (مقناطیسی)';

  @override
  String get detailsDistance => 'کعبہ تک فاصلہ';

  @override
  String get detailsLocation => 'مقام';

  @override
  String get detailsKaaba => 'کعبہ';

  @override
  String get detailsMethod =>
      'WGS-84 کوآرڈینیٹس پر دائرۂ عظیم کا ابتدائی زاویہ؛ حقیقی شمال مقناطیسی رخ اور اس آلے پر حساب کیے گئے WMM2025 انحراف کے مجموعے سے۔';

  @override
  String get detailsNotAvailable => '—';

  @override
  String get detailsSimulateToggle => 'قطب نما کی نقل (صرف ڈیبگ بلڈ)';

  @override
  String get detailsSimulateHeading => 'نقلی رخ';

  @override
  String get footerFree => 'مفت، ہمیشہ کے لیے۔ نہ اشتہار، نہ اکاؤنٹ۔';

  @override
  String get footerIntention => 'اللہ کی رضا کے لیے بنایا گیا۔';

  @override
  String get cardinalN => 'ش';

  @override
  String get cardinalE => 'م';

  @override
  String get cardinalS => 'ج';

  @override
  String get cardinalW => 'مغ';

  @override
  String get introTagline => 'آپ جہاں بھی ہوں، کعبہ کی طرف رخ کریں';

  @override
  String get introSkip => 'چھوڑیں';

  @override
  String get desktopPromptTitle => 'ویب پر، نقشہ';

  @override
  String get desktopPromptBody =>
      'براہِ راست قطب نما فون ایپ میں ہے، جہاں یہ حرکت کے سینسر استعمال کر سکتا ہے۔ ویب پر Qibla Go سمت نقشے پر دکھاتا ہے، اور سورج و چاند رخ پہچاننے میں مدد دیتے ہیں۔';

  @override
  String get desktopPromptContinue => 'نقشے پر جائیں';

  @override
  String get navCompass => 'قطب نما';

  @override
  String get navMap => 'نقشہ';

  @override
  String get mapTitle => 'نقشے پر قبلہ';

  @override
  String get mapYourLocation => 'آپ';

  @override
  String get mapKaaba => 'کعبہ، مکہ';

  @override
  String get mapQiblaLine => 'قبلے کی لکیر';

  @override
  String get mapSun => 'سورج';

  @override
  String get mapMoon => 'چاند';

  @override
  String skyMarkerLabel(String name, int azimuth) {
    return '$name $azimuth°';
  }

  @override
  String get mapRecenter => 'میرا اصل مقام استعمال کریں';

  @override
  String get mapZoomIn => 'قریب';

  @override
  String get mapZoomOut => 'دور';

  @override
  String get mapLongPressHint =>
      'نقشے پر کہیں بھی دیر تک دبائیں تاکہ آپ کا مقام وہاں مقرر ہو جائے۔';

  @override
  String get mapHowTitle => 'یہ نقشہ کیسے استعمال کریں';

  @override
  String get mapHowStep1 =>
      'سنہری لکیر آپ کے مقام سے شروع ہو کر سیدھی کعبہ تک جاتی ہے۔ نماز اسی لکیر کے رخ پر پڑھی جاتی ہے۔';

  @override
  String get mapHowStep2 =>
      'اپنے قریب کوئی چیز تلاش کریں جس سے یہ لکیر گزرتی ہو: سڑک، اونچی عمارت، پہاڑی، پل۔ اس کی طرف رخ کر کے کھڑے ہوں، تو آپ کا رخ قبلے کی طرف ہو گا۔';

  @override
  String get mapHowStep3 =>
      'زوم اِن کر کے دیکھیں کہ لکیر عمارت کے کس طرف سے گزرتی ہے، اور زوم آؤٹ کر کے دیکھیں کہ لکیر واقعی مکہ پر ختم ہوتی ہے۔';

  @override
  String mapHowSunAbove(
    int azimuth,
    String direction,
    int offset,
    String side,
  ) {
    return 'سورج ابھی $azimuth° پر ہے (تقریباً $direction)۔ قبلہ سورج کے $side $offset° پر ہے: سورج کی طرف رخ کریں، پھر اتنا مڑیں۔';
  }

  @override
  String mapHowMoonAbove(String phase, int azimuth, int offset, String side) {
    return 'چاند ($phase) $azimuth° پر ہے۔ قبلہ چاند کے $side $offset° پر ہے۔';
  }

  @override
  String get mapHowSkyNone =>
      'ابھی نہ سورج نکلا ہے نہ چاند؛ نقشے پر نشانیوں سے مدد لیں۔';

  @override
  String get sideLeft => 'بائیں';

  @override
  String get sideRight => 'دائیں';

  @override
  String get compassPointNorth => 'شمال';

  @override
  String get compassPointNortheast => 'شمال مشرق';

  @override
  String get compassPointEast => 'مشرق';

  @override
  String get compassPointSoutheast => 'جنوب مشرق';

  @override
  String get compassPointSouth => 'جنوب';

  @override
  String get compassPointSouthwest => 'جنوب مغرب';

  @override
  String get compassPointWest => 'مغرب';

  @override
  String get compassPointNorthwest => 'شمال مغرب';

  @override
  String get moonPhaseNew => 'نیا چاند';

  @override
  String get moonPhaseWaxingCrescent => 'بڑھتا ہلال';

  @override
  String get moonPhaseFirstQuarter => 'پہلی چوتھائی';

  @override
  String get moonPhaseWaxingGibbous => 'بڑھتا چاند';

  @override
  String get moonPhaseFull => 'پورا چاند';

  @override
  String get moonPhaseWaningGibbous => 'گھٹتا چاند';

  @override
  String get moonPhaseLastQuarter => 'آخری چوتھائی';

  @override
  String get moonPhaseWaningCrescent => 'گھٹتا ہلال';

  @override
  String get mapAttribution => '© OpenStreetMap کے معاونین';

  @override
  String get mapNeedsLocation =>
      'قبلے کی لکیر بنانے کے لیے اپنا مقام مقرر کریں۔';

  @override
  String get supportButton => 'ہمیں لکھیں';

  @override
  String get supportTitle => 'ہمیں لکھیں';

  @override
  String get supportIntro =>
      'کوئی سمت جو کہیں غلط لگے، کوئی خرابی، کوئی تجویز، یا بس ایک سلام۔ ہر پیغام پڑھا جاتا ہے۔';

  @override
  String get supportMessageLabel => 'آپ کا پیغام';

  @override
  String get supportMessageHint => 'کیا ہوا، اور کہاں؟';

  @override
  String get supportContactLabel => 'آپ سے رابطے کا ذریعہ (اختیاری)';

  @override
  String get supportContactHint => 'ای میل یا جو چاہیں، صرف اگر جواب چاہتے ہوں';

  @override
  String supportChallengeLabel(String question) {
    return 'فوری جانچ: $question کتنا ہوتا ہے؟';
  }

  @override
  String get supportChallengeLoading => 'سوال لایا جا رہا ہے…';

  @override
  String get supportChallengeUnavailable => 'ابھی کوئی سوال دستیاب نہیں۔';

  @override
  String get supportAnswerHint => '=';

  @override
  String get supportNewQuestion => 'نیا سوال';

  @override
  String get supportSend => 'بھیجیں';

  @override
  String get supportSending => 'بھیجا جا رہا ہے…';

  @override
  String get supportSentTitle => 'موصول ہو گیا';

  @override
  String get supportSentBody => 'لکھنے کا شکریہ۔ جزاک اللہ خیراً۔';

  @override
  String get supportClose => 'بند کریں';

  @override
  String get supportPrivacyNote =>
      'آپ کے پیغام کے ساتھ مقام یا آلے کا کوئی ڈیٹا نہیں بھیجا جاتا۔';

  @override
  String get supportErrorOffline =>
      'سرور تک رسائی نہیں ہو سکی۔ اپنا کنکشن جانچیں اور دوبارہ کوشش کریں؛ آپ کی تحریر محفوظ ہے۔';

  @override
  String get supportErrorTooMany =>
      'پچھلے ایک گھنٹے میں اس کنکشن سے بہت زیادہ پیغامات آئے ہیں۔ براہِ کرم بعد میں دوبارہ کوشش کریں۔';

  @override
  String get supportErrorWrongAnswer =>
      'جواب درست نہیں تھا۔ براہِ کرم نئے سوال کی کوشش کریں۔';

  @override
  String get supportErrorExpired =>
      'اس سوال کی مدت ختم ہو گئی۔ براہِ کرم نئے سوال کی کوشش کریں۔';

  @override
  String get supportErrorInvalid =>
      'سرور یہ پیغام قبول نہیں کر سکا۔ براہِ کرم اسے مختصر کریں اور دوبارہ کوشش کریں۔';

  @override
  String get supportErrorTooShort => 'براہِ کرم کم از کم 10 حروف لکھیں۔';

  @override
  String get supportErrorTooLong => 'براہِ کرم 2000 حروف سے کم رکھیں۔';

  @override
  String get supportErrorAnswerMissing =>
      'براہِ کرم فوری جانچ کا جواب عدد میں دیں۔';
}

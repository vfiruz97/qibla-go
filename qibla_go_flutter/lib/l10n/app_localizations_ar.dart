// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Qibla Go';

  @override
  String get qiblaLabel => 'القبلة';

  @override
  String get fromTrueNorth => 'من الشمال الحقيقي';

  @override
  String get fromMagneticNorth => 'من الشمال المغناطيسي';

  @override
  String get facingQibla => 'أنت تواجه القبلة';

  @override
  String turnRight(int degrees) {
    return 'استدر يمينًا $degrees°';
  }

  @override
  String turnLeft(int degrees) {
    return 'استدر يسارًا $degrees°';
  }

  @override
  String get turnAround => 'استدر للخلف';

  @override
  String distanceToMakkah(String distance) {
    return '$distance كم إلى مكة';
  }

  @override
  String get atKaabaTitle => 'أنت عند الكعبة';

  @override
  String get atKaabaBody => 'واجهها مباشرة؛ فعلى هذا القرب لا معنى للاتجاه.';

  @override
  String accuracyPlusMinus(int degrees) {
    return '±$degrees°';
  }

  @override
  String get accuracyUnknown => 'الدقة غير معروفة';

  @override
  String get qualityGood => 'جيدة';

  @override
  String get qualityFair => 'متوسطة';

  @override
  String get qualityPoor => 'ضعيفة';

  @override
  String get headingLabel => 'الاتجاه';

  @override
  String bearingSummary(int bearing, int magnetic) {
    return 'القبلة على $bearing° من الشمال الحقيقي ($magnetic° على بوصلة مغناطيسية). صالحة مع أي بوصلة أو خريطة.';
  }

  @override
  String get locationSetLocation => 'تحديد الموقع';

  @override
  String get locationLocating => 'جارٍ تحديد الموقع…';

  @override
  String get locationOriginDevice => 'الموقع الحالي';

  @override
  String get locationOriginCached => 'آخر موقع معروف';

  @override
  String get locationOriginManual => 'أُدخل يدويًا';

  @override
  String locationAccuracyMeters(int meters) {
    return '±$meters م';
  }

  @override
  String get locationAgeJustNow => 'الآن';

  @override
  String locationAgeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'قبل $count دقيقة',
      many: 'قبل $count دقيقة',
      few: 'قبل $count دقائق',
      two: 'قبل دقيقتين',
      one: 'قبل دقيقة واحدة',
      zero: 'قبل $count دقيقة',
    );
    return '$_temp0';
  }

  @override
  String locationAgeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'قبل $count ساعة',
      many: 'قبل $count ساعة',
      few: 'قبل $count ساعات',
      two: 'قبل ساعتين',
      one: 'قبل ساعة واحدة',
      zero: 'قبل $count ساعة',
    );
    return '$_temp0';
  }

  @override
  String locationAgeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'قبل $count يوم',
      many: 'قبل $count يومًا',
      few: 'قبل $count أيام',
      two: 'قبل يومين',
      one: 'قبل يوم واحد',
      zero: 'قبل $count يوم',
    );
    return '$_temp0';
  }

  @override
  String get locationNeededTitle => 'أين أنت؟';

  @override
  String get locationNeededBody =>
      'اتجاه القبلة يعتمد على مكانك. اسمح بالوصول إلى الموقع، أو أدخل إحداثياتك. موقعك لا يغادر هذا الجهاز أبدًا.';

  @override
  String get locationUseMyLocation => 'استخدام موقعي';

  @override
  String get locationEnterCoordinates => 'إدخال الإحداثيات';

  @override
  String get locationLatitude => 'خط العرض';

  @override
  String get locationLongitude => 'خط الطول';

  @override
  String get locationLatitudeHint => 'مثلًا 24.7136';

  @override
  String get locationLongitudeHint => 'مثلًا 46.6753';

  @override
  String get locationInvalidLatitude => 'يجب أن يكون خط العرض بين -90 و90';

  @override
  String get locationInvalidLongitude => 'يجب أن يكون خط الطول بين -180 و180';

  @override
  String get locationSave => 'استخدام هذه الإحداثيات';

  @override
  String get locationOpenSettings => 'فتح الإعدادات';

  @override
  String get locationProblemServicesDisabled =>
      'خدمات الموقع متوقفة على هذا الجهاز.';

  @override
  String get locationProblemPermissionDenied =>
      'لم يُمنح إذن الوصول إلى الموقع.';

  @override
  String get locationProblemPermissionDeniedForever =>
      'إذن الموقع محظور. اسمح به من إعدادات النظام.';

  @override
  String get locationProblemTimeout =>
      'تعذر الحصول على الموقع في الوقت المناسب. جرّب قرب نافذة أو في الهواء الطلق.';

  @override
  String get locationProblemUnavailable => 'تعذر تحديد موقعك.';

  @override
  String get locationStaleNote =>
      'يُستخدم موقع محفوظ. إن كنت قد انتقلت منذ ذلك الوقت، فحدّثه.';

  @override
  String get locationSheetTitle => 'موقعك';

  @override
  String locationCoordinates(String latitude, String longitude) {
    return '$latitude، $longitude';
  }

  @override
  String get compassCheckingTitle => 'جارٍ فحص البوصلة…';

  @override
  String get compassWaitingTitle => 'في انتظار المستشعر…';

  @override
  String get compassWaitingBody =>
      'حرّك الهاتف بلطف إن استغرق هذا أكثر من لحظة.';

  @override
  String get compassStaleTitle => 'توقفت البوصلة عن الاستجابة';

  @override
  String get compassStaleBody =>
      'توقفت القراءات. حرّك الهاتف قليلًا، أو أعد تشغيل التطبيق.';

  @override
  String get compassNoSensorTitle => 'لا بوصلة في هذا الجهاز';

  @override
  String get compassNoSensorBody =>
      'هذا الجهاز بلا مقياس مغناطيسي، فلا يمكنه إظهار اتجاه مباشر. الزاوية أدناه تعمل مع أي بوصلة حقيقية أو خريطة.';

  @override
  String get compassBrowserNoSensorTitle => 'لا بوصلة في هذا المتصفح';

  @override
  String get compassBrowserNoSensorBody =>
      'متصفحات الحاسوب بلا مستشعرات اتجاه. افتح Qibla Go على هاتف، أو استخدم الزاوية أدناه مع بوصلة أو خريطة.';

  @override
  String get compassPermissionTitle => 'السماح بالوصول إلى الحركة';

  @override
  String get compassPermissionBody =>
      'يحتاج متصفحك إلى إذن لقراءة اتجاه الهاتف.';

  @override
  String get compassPermissionButton => 'تفعيل البوصلة';

  @override
  String get compassPermissionDeniedBody =>
      'رُفض الوصول إلى الحركة. اسمح به من إعدادات المتصفح وأعد تحميل الصفحة.';

  @override
  String get compassRetry => 'إعادة المحاولة';

  @override
  String get compassPausedTitle => 'البوصلة متوقفة';

  @override
  String get issueInterferenceTitle => 'تداخل مغناطيسي';

  @override
  String get issueInterferenceBody =>
      'ثمة شيء مغناطيسي أو معدني قريب: حاسوب محمول، سيارة، غطاء هاتف بمغناطيس. يبقى الاتجاه مخفيًا حتى يصفو المجال. ابتعد وحاول مجددًا.';

  @override
  String get issueMovingFastTitle => 'يبدو أنك في مركبة';

  @override
  String get issueMovingFastBody =>
      'لا يمكن الاعتماد على البوصلة داخل سيارة أو قطار متحرك. توقف واخرج للتحقق من الاتجاه.';

  @override
  String get issueCalibrationTitle => 'عايِر بوصلتك';

  @override
  String get issueCalibrationBody =>
      'حرّك الهاتف على شكل الرقم ثمانية عدة مرات، بعيدًا عن المعادن.';

  @override
  String get issueNotFlatTitle => 'أمسك الهاتف أفقيًا';

  @override
  String get issueNotFlatBody => 'أبقِ الشاشة نحو السماء لأثبت قراءة.';

  @override
  String get issueBrowserTitle => 'بوصلة المتصفح';

  @override
  String get issueBrowserBody =>
      'تعطي المتصفحات اتجاهًا تقريبيًا ولا تكشف التداخل. قبل الصلاة، تأكد بالزاوية أدناه وببوصلة حقيقية إن أمكن.';

  @override
  String get issueLowAccuracyTitle => 'دقة منخفضة';

  @override
  String get issueLowAccuracyBody =>
      'يبلّغ المستشعر عن خطأ كبير الآن. عايِر ثم تحقق مجددًا.';

  @override
  String get declinationExtrapolatedNote =>
      'انتهت صلاحية النموذج المغناطيسي لهذا التطبيق. حدّث التطبيق لأفضل دقة.';

  @override
  String get detailsButton => 'التفاصيل';

  @override
  String get detailsTitle => 'كيف حُسب هذا الاتجاه';

  @override
  String get detailsSource => 'المستشعر';

  @override
  String get detailsMagneticHeading => 'الاتجاه المغناطيسي';

  @override
  String get detailsDeclination => 'الانحراف المغناطيسي (WMM2025)';

  @override
  String get detailsTrueHeading => 'الاتجاه الحقيقي';

  @override
  String get detailsPlatformTrueHeading => 'الاتجاه الحقيقي (النظام)';

  @override
  String get detailsAccuracy => 'الدقة المبلّغ عنها';

  @override
  String get detailsConfidence => 'الثقة';

  @override
  String get detailsPitch => 'الميل';

  @override
  String get detailsField => 'شدة المجال';

  @override
  String get detailsFieldExpected => 'المجال المتوقع';

  @override
  String get detailsBearing => 'زاوية القبلة (حقيقية)';

  @override
  String get detailsBearingMagnetic => 'زاوية القبلة (مغناطيسية)';

  @override
  String get detailsDistance => 'المسافة إلى الكعبة';

  @override
  String get detailsLocation => 'الموقع';

  @override
  String get detailsKaaba => 'الكعبة';

  @override
  String get detailsMethod =>
      'الزاوية الابتدائية للدائرة العظمى على إحداثيات WGS-84؛ الشمال الحقيقي من الاتجاه المغناطيسي مضافًا إليه انحراف WMM2025 المحسوب على هذا الجهاز.';

  @override
  String get detailsNotAvailable => '—';

  @override
  String get detailsSimulateToggle => 'محاكاة البوصلة (إصدار التصحيح فقط)';

  @override
  String get detailsSimulateHeading => 'اتجاه محاكى';

  @override
  String get detailsPreviewRating => 'معاينة طلب التقييم (إصدار التصحيح فقط)';

  @override
  String get footerFree => 'مجاني، للأبد. بلا إعلانات، بلا حسابات.';

  @override
  String get footerIntention => 'صُنع ابتغاءَ مرضاة الله.';

  @override
  String get cardinalN => 'ش';

  @override
  String get cardinalE => 'ق';

  @override
  String get cardinalS => 'ج';

  @override
  String get cardinalW => 'غ';

  @override
  String get introTagline => 'واجه الكعبة أينما كنت';

  @override
  String get introSkip => 'تخطٍّ';

  @override
  String get desktopPromptTitle => 'على الويب: الخريطة';

  @override
  String get desktopPromptBody =>
      'البوصلة المباشرة في تطبيق الهاتف، حيث يمكنها استخدام مستشعرات الحركة. على الويب يعرض Qibla Go الاتجاه على خريطة بدلًا من ذلك، مع الشمس والقمر لمساعدتك على التوجه.';

  @override
  String get desktopPromptContinue => 'المتابعة إلى الخريطة';

  @override
  String get navCompass => 'البوصلة';

  @override
  String get navMap => 'الخريطة';

  @override
  String get mapTitle => 'القبلة على الخريطة';

  @override
  String get mapYourLocation => 'أنت';

  @override
  String get mapKaaba => 'الكعبة، مكة';

  @override
  String get mapQiblaLine => 'خط القبلة';

  @override
  String get mapSun => 'الشمس';

  @override
  String get mapMoon => 'القمر';

  @override
  String skyMarkerLabel(String name, int azimuth) {
    return '$name $azimuth°';
  }

  @override
  String get mapRecenter => 'استخدام موقعي الحقيقي';

  @override
  String get mapZoomIn => 'تقريب';

  @override
  String get mapZoomOut => 'تبعيد';

  @override
  String get mapLongPressHint =>
      'اضغط مطولًا على أي مكان في الخريطة لتحديد موقعك هناك.';

  @override
  String get mapHowTitle => 'كيفية استخدام هذه الخريطة';

  @override
  String get mapHowStep1 =>
      'يبدأ الخط الذهبي من مكانك ويمتد مستقيمًا إلى الكعبة. تكون الصلاة باتجاه هذا الخط.';

  @override
  String get mapHowStep2 =>
      'ابحث قربك عن شيء يمرّ به الخط: طريق، بناء مرتفع، تلّة، جسر. قف مواجهًا له، فتكون مواجهًا للقبلة.';

  @override
  String get mapHowStep3 =>
      'قرّب لترى من أي جانب من البناء يمرّ الخط، وبعّد لترى أن الخط ينتهي فعلًا في مكة.';

  @override
  String mapHowSunAbove(
    int azimuth,
    String direction,
    int offset,
    String side,
  ) {
    return 'الشمس الآن على $azimuth° (نحو $direction). القبلة على $offset° إلى $side الشمس: قف مواجهًا للشمس ثم استدر بهذا القدر.';
  }

  @override
  String mapHowMoonAbove(String phase, int azimuth, int offset, String side) {
    return 'القمر ($phase) على $azimuth°. القبلة على $offset° إلى $side القمر.';
  }

  @override
  String get mapHowSkyNone =>
      'لا الشمس ولا القمر ظاهر الآن؛ استعن بالمعالم على الخريطة.';

  @override
  String get sideLeft => 'يسار';

  @override
  String get sideRight => 'يمين';

  @override
  String get compassPointNorth => 'الشمال';

  @override
  String get compassPointNortheast => 'الشمال الشرقي';

  @override
  String get compassPointEast => 'الشرق';

  @override
  String get compassPointSoutheast => 'الجنوب الشرقي';

  @override
  String get compassPointSouth => 'الجنوب';

  @override
  String get compassPointSouthwest => 'الجنوب الغربي';

  @override
  String get compassPointWest => 'الغرب';

  @override
  String get compassPointNorthwest => 'الشمال الغربي';

  @override
  String get moonPhaseNew => 'محاق';

  @override
  String get moonPhaseWaxingCrescent => 'هلال متزايد';

  @override
  String get moonPhaseFirstQuarter => 'تربيع أول';

  @override
  String get moonPhaseWaxingGibbous => 'أحدب متزايد';

  @override
  String get moonPhaseFull => 'بدر';

  @override
  String get moonPhaseWaningGibbous => 'أحدب متناقص';

  @override
  String get moonPhaseLastQuarter => 'تربيع أخير';

  @override
  String get moonPhaseWaningCrescent => 'هلال متناقص';

  @override
  String get mapAttribution => '© المساهمون في OpenStreetMap';

  @override
  String get mapNeedsLocation => 'حدّد موقعك لرسم خط القبلة.';

  @override
  String get supportButton => 'اكتب لنا';

  @override
  String get supportTitle => 'اكتب لنا';

  @override
  String get supportIntro =>
      'اتجاه يبدو خاطئًا في مكان ما، خلل، فكرة، أو مجرد سلام. كل رسالة تُقرأ.';

  @override
  String get supportMessageLabel => 'رسالتك';

  @override
  String get supportMessageHint => 'ما الذي حدث، وأين؟';

  @override
  String get supportContactLabel => 'كيف نتواصل معك (اختياري)';

  @override
  String get supportContactHint => 'بريد إلكتروني أو ما تشاء، فقط إن أردت ردًا';

  @override
  String supportChallengeLabel(String question) {
    return 'تحقق سريع: ما ناتج $question؟';
  }

  @override
  String get supportChallengeLoading => 'جارٍ جلب سؤال…';

  @override
  String get supportChallengeUnavailable => 'لا يوجد سؤال متاح الآن.';

  @override
  String get supportAnswerHint => '=';

  @override
  String get supportNewQuestion => 'سؤال جديد';

  @override
  String get supportSend => 'إرسال';

  @override
  String get supportSending => 'جارٍ الإرسال…';

  @override
  String get supportSentTitle => 'وصلت';

  @override
  String get supportSentBody => 'شكرًا لرسالتك. جزاك الله خيرًا.';

  @override
  String get supportClose => 'إغلاق';

  @override
  String get supportPrivacyNote =>
      'لا تُرسل أي بيانات عن الموقع أو الجهاز مع رسالتك.';

  @override
  String get supportErrorOffline =>
      'تعذر الوصول إلى الخادم. تحقق من اتصالك وحاول مجددًا؛ نصك محفوظ.';

  @override
  String get supportErrorTooMany =>
      'رسائل كثيرة جدًا من هذا الاتصال خلال الساعة الأخيرة. يرجى المحاولة لاحقًا.';

  @override
  String get supportErrorWrongAnswer =>
      'تلك الإجابة لم تكن صحيحة. يرجى تجربة السؤال الجديد.';

  @override
  String get supportErrorExpired =>
      'انتهت صلاحية ذلك السؤال. يرجى تجربة السؤال الجديد.';

  @override
  String get supportErrorInvalid =>
      'لم يستطع الخادم قبول هذه الرسالة. يرجى اختصارها والمحاولة مجددًا.';

  @override
  String get supportErrorTooShort => 'يرجى كتابة 10 أحرف على الأقل.';

  @override
  String get supportErrorTooLong => 'يرجى ألا تتجاوز 2000 حرف.';

  @override
  String get supportErrorAnswerMissing => 'يرجى الإجابة عن التحقق السريع برقم.';

  @override
  String get ratingTitle => 'هل يعجبك Qibla Go؟';

  @override
  String get ratingBodyGooglePlay =>
      'Qibla Go مجاني وبلا إعلانات. تقييمك على Google Play يساعد الآخرين على إيجاد التطبيق والثقة به.';

  @override
  String get ratingBodyAppStore =>
      'Qibla Go مجاني وبلا إعلانات. تقييمك على App Store يساعد الآخرين على إيجاد التطبيق والثقة به.';

  @override
  String get ratingRate => 'قيّم Qibla Go';

  @override
  String get ratingNotNow => 'ليس الآن';

  @override
  String get ratingFootnote =>
      'نسأل مرة واحدة فقط. إن رفضت، فلن نسأل مرة أخرى.';

  @override
  String get ratingOpenFailed => 'تعذّر فتح المتجر. يُرجى المحاولة لاحقًا.';

  @override
  String get ratingStoreLinkGooglePlay => 'قيّم على Google Play';

  @override
  String get ratingStoreLinkAppStore => 'قيّم على App Store';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Qibla Go';

  @override
  String get qiblaLabel => 'КИБЛА';

  @override
  String get fromTrueNorth => 'от истинного севера';

  @override
  String get fromMagneticNorth => 'от магнитного севера';

  @override
  String get facingQibla => 'Вы стоите лицом к Кибле';

  @override
  String turnRight(int degrees) {
    return 'Повернитесь вправо на $degrees°';
  }

  @override
  String turnLeft(int degrees) {
    return 'Повернитесь влево на $degrees°';
  }

  @override
  String get turnAround => 'Развернитесь';

  @override
  String distanceToMakkah(String distance) {
    return '$distance км до Мекки';
  }

  @override
  String get atKaabaTitle => 'Вы у Каабы';

  @override
  String get atKaabaBody =>
      'Встаньте прямо к ней; на таком расстоянии направление не имеет смысла.';

  @override
  String accuracyPlusMinus(int degrees) {
    return '±$degrees°';
  }

  @override
  String get accuracyUnknown => 'Точность неизвестна';

  @override
  String get qualityGood => 'Хорошо';

  @override
  String get qualityFair => 'Средне';

  @override
  String get qualityPoor => 'Плохо';

  @override
  String get headingLabel => 'Курс';

  @override
  String bearingSummary(int bearing, int magnetic) {
    return 'Кибла находится в $bearing° от истинного севера ($magnetic° по магнитному компасу). Подходит для любого компаса или карты.';
  }

  @override
  String get locationSetLocation => 'Указать местоположение';

  @override
  String get locationLocating => 'Определение местоположения…';

  @override
  String get locationOriginDevice => 'Текущее местоположение';

  @override
  String get locationOriginCached => 'Последнее известное местоположение';

  @override
  String get locationOriginManual => 'Введено вручную';

  @override
  String locationAccuracyMeters(int meters) {
    return '±$meters м';
  }

  @override
  String get locationAgeJustNow => 'только что';

  @override
  String locationAgeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count минуты назад',
      many: '$count минут назад',
      few: '$count минуты назад',
      one: '$count минуту назад',
    );
    return '$_temp0';
  }

  @override
  String locationAgeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count часа назад',
      many: '$count часов назад',
      few: '$count часа назад',
      one: '$count час назад',
    );
    return '$_temp0';
  }

  @override
  String locationAgeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня назад',
      many: '$count дней назад',
      few: '$count дня назад',
      one: '$count день назад',
    );
    return '$_temp0';
  }

  @override
  String get locationNeededTitle => 'Где вы находитесь?';

  @override
  String get locationNeededBody =>
      'Направление на Киблу зависит от того, где вы стоите. Разрешите доступ к местоположению или введите координаты. Ваше местоположение никогда не покидает это устройство.';

  @override
  String get locationUseMyLocation => 'Использовать моё местоположение';

  @override
  String get locationEnterCoordinates => 'Ввести координаты';

  @override
  String get locationLatitude => 'Широта';

  @override
  String get locationLongitude => 'Долгота';

  @override
  String get locationLatitudeHint => 'напр. 38,5598';

  @override
  String get locationLongitudeHint => 'напр. 68,7870';

  @override
  String get locationInvalidLatitude => 'Широта должна быть от -90 до 90';

  @override
  String get locationInvalidLongitude => 'Долгота должна быть от -180 до 180';

  @override
  String get locationSave => 'Использовать эти координаты';

  @override
  String get locationOpenSettings => 'Открыть настройки';

  @override
  String get locationProblemServicesDisabled =>
      'Службы геолокации на этом устройстве выключены.';

  @override
  String get locationProblemPermissionDenied =>
      'Разрешение на доступ к местоположению не предоставлено.';

  @override
  String get locationProblemPermissionDeniedForever =>
      'Доступ к местоположению заблокирован. Разрешите его в настройках системы.';

  @override
  String get locationProblemTimeout =>
      'Не удалось вовремя определить положение. Попробуйте у окна или на улице.';

  @override
  String get locationProblemUnavailable =>
      'Не удалось определить ваше положение.';

  @override
  String get locationStaleNote =>
      'Используется сохранённое положение. Если вы с тех пор переместились, обновите его.';

  @override
  String get locationSheetTitle => 'Ваше местоположение';

  @override
  String locationCoordinates(String latitude, String longitude) {
    return '$latitude, $longitude';
  }

  @override
  String get compassCheckingTitle => 'Проверка компаса…';

  @override
  String get compassWaitingTitle => 'Ожидание датчика…';

  @override
  String get compassWaitingBody =>
      'Слегка подвигайте телефон, если это занимает больше пары секунд.';

  @override
  String get compassStaleTitle => 'Компас перестал отвечать';

  @override
  String get compassStaleBody =>
      'Показания прекратились. Немного подвигайте телефон или перезапустите приложение.';

  @override
  String get compassNoSensorTitle => 'На этом устройстве нет компаса';

  @override
  String get compassNoSensorBody =>
      'В этом устройстве нет магнитометра, поэтому оно не может показывать направление в реальном времени. Азимут ниже всё равно работает с любым обычным компасом или картой.';

  @override
  String get compassBrowserNoSensorTitle => 'В этом браузере нет компаса';

  @override
  String get compassBrowserNoSensorBody =>
      'В браузерах на компьютере нет датчиков ориентации. Откройте Qibla Go на телефоне или используйте азимут ниже с компасом или картой.';

  @override
  String get compassPermissionTitle => 'Разрешить доступ к движению';

  @override
  String get compassPermissionBody =>
      'Браузеру нужно разрешение, чтобы считывать ориентацию телефона.';

  @override
  String get compassPermissionButton => 'Включить компас';

  @override
  String get compassPermissionDeniedBody =>
      'Доступ к движению отклонён. Разрешите его в настройках браузера и перезагрузите страницу.';

  @override
  String get compassRetry => 'Повторить';

  @override
  String get compassPausedTitle => 'Компас приостановлен';

  @override
  String get issueInterferenceTitle => 'Магнитные помехи';

  @override
  String get issueInterferenceBody =>
      'Рядом что-то магнитное или металлическое: ноутбук, автомобиль, чехол с магнитом. Направление скрыто, пока поле не станет чистым. Отойдите и попробуйте снова.';

  @override
  String get issueMovingFastTitle => 'Похоже, вы в транспорте';

  @override
  String get issueMovingFastBody =>
      'Компасу нельзя доверять в движущейся машине или поезде. Остановитесь и выйдите, чтобы проверить направление.';

  @override
  String get issueCalibrationTitle => 'Откалибруйте компас';

  @override
  String get issueCalibrationBody =>
      'Несколько раз проведите телефоном в воздухе по восьмёрке, подальше от металла.';

  @override
  String get issueNotFlatTitle => 'Держите телефон горизонтально';

  @override
  String get issueNotFlatBody =>
      'Направьте экран к небу — так показания устойчивее всего.';

  @override
  String get issueBrowserTitle => 'Компас браузера';

  @override
  String get issueBrowserBody =>
      'Браузеры дают приблизительный курс и не замечают помех. Перед молитвой сверьтесь с азимутом ниже и, если можете, с настоящим компасом.';

  @override
  String get issueLowAccuracyTitle => 'Низкая точность';

  @override
  String get issueLowAccuracyBody =>
      'Датчик сейчас сообщает о большой погрешности. Откалибруйте и проверьте снова.';

  @override
  String get declinationExtrapolatedNote =>
      'Магнитная модель этого приложения устарела. Обновите приложение для лучшей точности.';

  @override
  String get detailsButton => 'Подробности';

  @override
  String get detailsTitle => 'Как вычислено это направление';

  @override
  String get detailsSource => 'Датчик';

  @override
  String get detailsMagneticHeading => 'Магнитный курс';

  @override
  String get detailsDeclination => 'Склонение (WMM2025)';

  @override
  String get detailsTrueHeading => 'Истинный курс';

  @override
  String get detailsPlatformTrueHeading => 'Истинный курс (система)';

  @override
  String get detailsAccuracy => 'Заявленная точность';

  @override
  String get detailsConfidence => 'Достоверность';

  @override
  String get detailsPitch => 'Наклон';

  @override
  String get detailsField => 'Напряжённость поля';

  @override
  String get detailsFieldExpected => 'Ожидаемое поле';

  @override
  String get detailsBearing => 'Азимут Киблы (истинный)';

  @override
  String get detailsBearingMagnetic => 'Азимут Киблы (магнитный)';

  @override
  String get detailsDistance => 'Расстояние до Каабы';

  @override
  String get detailsLocation => 'Положение';

  @override
  String get detailsKaaba => 'Кааба';

  @override
  String get detailsMethod =>
      'Начальный азимут большого круга по координатам WGS-84; истинный север получен из магнитного курса и склонения WMM2025, вычисленного на этом устройстве.';

  @override
  String get detailsNotAvailable => '—';

  @override
  String get detailsSimulateToggle =>
      'Имитировать компас (только отладочная сборка)';

  @override
  String get detailsSimulateHeading => 'Имитируемый курс';

  @override
  String get footerFree => 'Бесплатно, навсегда. Без рекламы и без аккаунтов.';

  @override
  String get footerIntention => 'Сделано ради довольства Аллаха.';

  @override
  String get cardinalN => 'С';

  @override
  String get cardinalE => 'В';

  @override
  String get cardinalS => 'Ю';

  @override
  String get cardinalW => 'З';

  @override
  String get introTagline => 'Лицом к Каабе, где бы вы ни были';

  @override
  String get introSkip => 'Пропустить';

  @override
  String get desktopPromptTitle => 'В браузере — карта';

  @override
  String get desktopPromptBody =>
      'Живой компас есть в приложении для телефона, где он может использовать датчики движения. В браузере Qibla Go показывает направление на карте, а солнце и луна помогают сориентироваться.';

  @override
  String get desktopPromptContinue => 'Перейти к карте';

  @override
  String get navCompass => 'Компас';

  @override
  String get navMap => 'Карта';

  @override
  String get mapTitle => 'Кибла на карте';

  @override
  String get mapYourLocation => 'Вы';

  @override
  String get mapKaaba => 'Кааба, Мекка';

  @override
  String get mapQiblaLine => 'Линия Киблы';

  @override
  String get mapSun => 'Солнце';

  @override
  String get mapMoon => 'Луна';

  @override
  String skyMarkerLabel(String name, int azimuth) {
    return '$name $azimuth°';
  }

  @override
  String get mapRecenter => 'Использовать моё реальное местоположение';

  @override
  String get mapZoomIn => 'Ближе';

  @override
  String get mapZoomOut => 'Дальше';

  @override
  String get mapLongPressHint =>
      'Нажмите и удерживайте любую точку карты, чтобы указать там своё местоположение.';

  @override
  String get mapHowTitle => 'Как пользоваться картой';

  @override
  String get mapHowStep1 =>
      'Золотая линия начинается там, где вы стоите, и идёт прямо к Каабе. Молитва совершается лицом вдоль этой линии.';

  @override
  String get mapHowStep2 =>
      'Найдите рядом с собой то, что линия пересекает: дорогу, высокое здание, холм, мост. Встаньте лицом к нему — и вы стоите лицом к Кибле.';

  @override
  String get mapHowStep3 =>
      'Приблизьте карту, чтобы увидеть, с какой стороны здания проходит линия, и отдалите, чтобы убедиться, что линия действительно заканчивается в Мекке.';

  @override
  String mapHowSunAbove(
    int azimuth,
    String direction,
    int offset,
    String side,
  ) {
    return 'Солнце сейчас на $azimuth° (примерно $direction). Кибла в $offset° $side от солнца: встаньте лицом к солнцу и повернитесь на столько.';
  }

  @override
  String mapHowMoonAbove(String phase, int azimuth, int offset, String side) {
    return 'Луна ($phase) на $azimuth°. Кибла в $offset° $side от неё.';
  }

  @override
  String get mapHowSkyNone =>
      'Сейчас не видно ни солнца, ни луны; ориентируйтесь по объектам на карте.';

  @override
  String get sideLeft => 'слева';

  @override
  String get sideRight => 'справа';

  @override
  String get compassPointNorth => 'север';

  @override
  String get compassPointNortheast => 'северо-восток';

  @override
  String get compassPointEast => 'восток';

  @override
  String get compassPointSoutheast => 'юго-восток';

  @override
  String get compassPointSouth => 'юг';

  @override
  String get compassPointSouthwest => 'юго-запад';

  @override
  String get compassPointWest => 'запад';

  @override
  String get compassPointNorthwest => 'северо-запад';

  @override
  String get moonPhaseNew => 'новолуние';

  @override
  String get moonPhaseWaxingCrescent => 'растущий серп';

  @override
  String get moonPhaseFirstQuarter => 'первая четверть';

  @override
  String get moonPhaseWaxingGibbous => 'растущая луна';

  @override
  String get moonPhaseFull => 'полнолуние';

  @override
  String get moonPhaseWaningGibbous => 'убывающая луна';

  @override
  String get moonPhaseLastQuarter => 'последняя четверть';

  @override
  String get moonPhaseWaningCrescent => 'убывающий серп';

  @override
  String get mapAttribution => '© Участники OpenStreetMap';

  @override
  String get mapNeedsLocation =>
      'Укажите своё местоположение, чтобы провести линию Киблы.';

  @override
  String get supportButton => 'Напишите нам';

  @override
  String get supportTitle => 'Напишите нам';

  @override
  String get supportIntro =>
      'Направление, которое где-то выглядит неверным, ошибка, идея или просто салам. Каждое сообщение читается.';

  @override
  String get supportMessageLabel => 'Ваше сообщение';

  @override
  String get supportMessageHint => 'Что случилось и где?';

  @override
  String get supportContactLabel => 'Как с вами связаться (необязательно)';

  @override
  String get supportContactHint =>
      'Почта или что угодно, только если хотите ответ';

  @override
  String supportChallengeLabel(String question) {
    return 'Быстрая проверка: сколько будет $question?';
  }

  @override
  String get supportChallengeLoading => 'Загрузка вопроса…';

  @override
  String get supportChallengeUnavailable => 'Сейчас нет доступного вопроса.';

  @override
  String get supportAnswerHint => '=';

  @override
  String get supportNewQuestion => 'Новый вопрос';

  @override
  String get supportSend => 'Отправить';

  @override
  String get supportSending => 'Отправка…';

  @override
  String get supportSentTitle => 'Получено';

  @override
  String get supportSentBody => 'Спасибо, что написали. ДжазакаЛлаху хайран.';

  @override
  String get supportClose => 'Закрыть';

  @override
  String get supportPrivacyNote =>
      'Вместе с сообщением не отправляются ни местоположение, ни данные устройства.';

  @override
  String get supportErrorOffline =>
      'Не удалось связаться с сервером. Проверьте соединение и попробуйте снова; ваш текст сохранён.';

  @override
  String get supportErrorTooMany =>
      'Слишком много сообщений с этого соединения за последний час. Попробуйте позже.';

  @override
  String get supportErrorWrongAnswer =>
      'Ответ неверный. Попробуйте ответить на новый вопрос.';

  @override
  String get supportErrorExpired => 'Этот вопрос устарел. Попробуйте новый.';

  @override
  String get supportErrorInvalid =>
      'Сервер не смог принять это сообщение. Сократите его и попробуйте снова.';

  @override
  String get supportErrorTooShort => 'Напишите хотя бы 10 символов.';

  @override
  String get supportErrorTooLong => 'Не больше 2000 символов.';

  @override
  String get supportErrorAnswerMissing =>
      'Ответьте на быструю проверку числом.';
}

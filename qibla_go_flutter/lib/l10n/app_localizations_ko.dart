// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => 'Qibla Go';

  @override
  String get qiblaLabel => '키블라';

  @override
  String get fromTrueNorth => '진북 기준';

  @override
  String get fromMagneticNorth => '자북 기준';

  @override
  String get facingQibla => '키블라를 향하고 있습니다';

  @override
  String turnRight(int degrees) {
    return '오른쪽으로 $degrees° 돌아서세요';
  }

  @override
  String turnLeft(int degrees) {
    return '왼쪽으로 $degrees° 돌아서세요';
  }

  @override
  String get turnAround => '뒤로 돌아서세요';

  @override
  String distanceToMakkah(String distance) {
    return '메카까지 $distance km';
  }

  @override
  String get atKaabaTitle => '카바 앞에 있습니다';

  @override
  String get atKaabaBody => '카바를 바로 마주하세요. 이렇게 가까우면 방위는 의미가 없습니다.';

  @override
  String accuracyPlusMinus(int degrees) {
    return '±$degrees°';
  }

  @override
  String get accuracyUnknown => '정확도 알 수 없음';

  @override
  String get qualityGood => '좋음';

  @override
  String get qualityFair => '보통';

  @override
  String get qualityPoor => '나쁨';

  @override
  String get headingLabel => '방향';

  @override
  String bearingSummary(int bearing, int magnetic) {
    return '키블라는 진북에서 $bearing°입니다(자기 나침반에서는 $magnetic°). 어떤 나침반이나 지도에서도 유효합니다.';
  }

  @override
  String get locationSetLocation => '위치 설정';

  @override
  String get locationLocating => '위치 확인 중…';

  @override
  String get locationOriginDevice => '현재 위치';

  @override
  String get locationOriginCached => '마지막으로 확인된 위치';

  @override
  String get locationOriginManual => '직접 입력함';

  @override
  String locationAccuracyMeters(int meters) {
    return '±$meters m';
  }

  @override
  String get locationAgeJustNow => '방금';

  @override
  String locationAgeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count분 전',
    );
    return '$_temp0';
  }

  @override
  String locationAgeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count시간 전',
    );
    return '$_temp0';
  }

  @override
  String locationAgeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count일 전',
    );
    return '$_temp0';
  }

  @override
  String get locationNeededTitle => '어디에 계신가요?';

  @override
  String get locationNeededBody =>
      '키블라 방향은 서 있는 곳에 따라 달라집니다. 위치 접근을 허용하거나 좌표를 입력하세요. 위치 정보는 절대 이 기기를 벗어나지 않습니다.';

  @override
  String get locationUseMyLocation => '내 위치 사용';

  @override
  String get locationEnterCoordinates => '좌표 입력';

  @override
  String get locationLatitude => '위도';

  @override
  String get locationLongitude => '경도';

  @override
  String get locationLatitudeHint => '예: 37.5665';

  @override
  String get locationLongitudeHint => '예: 126.9780';

  @override
  String get locationInvalidLatitude => '위도는 -90에서 90 사이여야 합니다';

  @override
  String get locationInvalidLongitude => '경도는 -180에서 180 사이여야 합니다';

  @override
  String get locationSave => '이 좌표 사용';

  @override
  String get locationOpenSettings => '설정 열기';

  @override
  String get locationProblemServicesDisabled => '이 기기의 위치 서비스가 꺼져 있습니다.';

  @override
  String get locationProblemPermissionDenied => '위치 권한이 허용되지 않았습니다.';

  @override
  String get locationProblemPermissionDeniedForever =>
      '위치 권한이 차단되어 있습니다. 시스템 설정에서 허용해 주세요.';

  @override
  String get locationProblemTimeout =>
      '시간 안에 위치를 확인할 수 없었습니다. 창가나 야외에서 다시 시도해 보세요.';

  @override
  String get locationProblemUnavailable => '위치를 확인할 수 없습니다.';

  @override
  String get locationStaleNote => '저장된 위치를 사용하고 있습니다. 그 뒤로 이동했다면 새로 고치세요.';

  @override
  String get locationSheetTitle => '내 위치';

  @override
  String locationCoordinates(String latitude, String longitude) {
    return '$latitude, $longitude';
  }

  @override
  String get compassCheckingTitle => '나침반 확인 중…';

  @override
  String get compassWaitingTitle => '센서 대기 중…';

  @override
  String get compassWaitingBody => '잠시 이상 걸리면 휴대폰을 살짝 움직여 보세요.';

  @override
  String get compassStaleTitle => '나침반이 응답하지 않습니다';

  @override
  String get compassStaleBody => '측정이 멈췄습니다. 휴대폰을 조금 움직이거나 앱을 다시 시작하세요.';

  @override
  String get compassNoSensorTitle => '이 기기에는 나침반이 없습니다';

  @override
  String get compassNoSensorBody =>
      '이 기기에는 자기 센서가 없어 실시간 방향을 보여 줄 수 없습니다. 아래 방위각은 실제 나침반이나 지도와 함께 사용할 수 있습니다.';

  @override
  String get compassBrowserNoSensorTitle => '이 브라우저에는 나침반이 없습니다';

  @override
  String get compassBrowserNoSensorBody =>
      '데스크톱 브라우저에는 방향 센서가 없습니다. 휴대폰에서 Qibla Go를 열거나, 아래 방위각을 나침반이나 지도와 함께 사용하세요.';

  @override
  String get compassPermissionTitle => '모션 접근 허용';

  @override
  String get compassPermissionBody => '휴대폰의 방향을 읽으려면 브라우저 권한이 필요합니다.';

  @override
  String get compassPermissionButton => '나침반 켜기';

  @override
  String get compassPermissionDeniedBody =>
      '모션 접근이 거부되었습니다. 브라우저 설정에서 허용한 뒤 페이지를 새로 고치세요.';

  @override
  String get compassRetry => '다시 시도';

  @override
  String get compassPausedTitle => '나침반 일시 중지';

  @override
  String get issueInterferenceTitle => '자기 간섭';

  @override
  String get issueInterferenceBody =>
      '근처에 자석이나 금속이 있습니다: 노트북, 자동차, 자석이 달린 휴대폰 케이스 등. 자기장이 안정될 때까지 방향이 숨겨집니다. 조금 떨어져서 다시 시도하세요.';

  @override
  String get issueMovingFastTitle => '차량 안에 계신 것 같습니다';

  @override
  String get issueMovingFastBody =>
      '움직이는 자동차나 기차 안에서는 나침반을 믿을 수 없습니다. 멈추고 밖으로 나와 방향을 확인하세요.';

  @override
  String get issueCalibrationTitle => '나침반을 보정하세요';

  @override
  String get issueCalibrationBody => '금속에서 떨어진 곳에서 휴대폰을 8자 모양으로 몇 번 움직이세요.';

  @override
  String get issueNotFlatTitle => '휴대폰을 평평하게 들어 주세요';

  @override
  String get issueNotFlatBody => '화면을 하늘 쪽으로 향하게 하면 가장 안정적으로 측정됩니다.';

  @override
  String get issueBrowserTitle => '브라우저 나침반';

  @override
  String get issueBrowserBody =>
      '브라우저는 대략적인 방향만 제공하며 간섭을 감지하지 못합니다. 기도 전에 아래 방위각으로, 가능하면 실제 나침반으로도 확인하세요.';

  @override
  String get issueLowAccuracyTitle => '정확도 낮음';

  @override
  String get issueLowAccuracyBody => '센서가 현재 큰 오차를 보고하고 있습니다. 보정한 뒤 다시 확인하세요.';

  @override
  String get declinationExtrapolatedNote =>
      '이 앱의 지자기 모델이 만료되었습니다. 최상의 정확도를 위해 앱을 업데이트하세요.';

  @override
  String get detailsButton => '자세히';

  @override
  String get detailsTitle => '이 방향을 계산한 방법';

  @override
  String get detailsSource => '센서';

  @override
  String get detailsMagneticHeading => '자기 방위';

  @override
  String get detailsDeclination => '편각(WMM2025)';

  @override
  String get detailsTrueHeading => '진방위';

  @override
  String get detailsPlatformTrueHeading => '진방위(시스템)';

  @override
  String get detailsAccuracy => '보고된 정확도';

  @override
  String get detailsConfidence => '신뢰도';

  @override
  String get detailsPitch => '기울기';

  @override
  String get detailsField => '자기장 세기';

  @override
  String get detailsFieldExpected => '예상 자기장';

  @override
  String get detailsBearing => '키블라 방위각(진북)';

  @override
  String get detailsBearingMagnetic => '키블라 방위각(자북)';

  @override
  String get detailsDistance => '카바까지의 거리';

  @override
  String get detailsLocation => '위치';

  @override
  String get detailsKaaba => '카바';

  @override
  String get detailsMethod =>
      'WGS-84 좌표의 대권 초기 방위각. 진북은 자기 방위에 이 기기에서 계산한 WMM2025 편각을 더해 구합니다.';

  @override
  String get detailsNotAvailable => '—';

  @override
  String get detailsSimulateToggle => '나침반 시뮬레이션(디버그 빌드 전용)';

  @override
  String get detailsSimulateHeading => '시뮬레이션 방위';

  @override
  String get detailsPreviewRating => '평가 요청 미리 보기(디버그 빌드 전용)';

  @override
  String get footerFree => '영원히 무료. 광고 없음, 계정 없음.';

  @override
  String get footerIntention => '하나님의 기쁨을 구하며 만들었습니다.';

  @override
  String get cardinalN => '북';

  @override
  String get cardinalE => '동';

  @override
  String get cardinalS => '남';

  @override
  String get cardinalW => '서';

  @override
  String get introTagline => '어디에 있든 카바를 향해';

  @override
  String get introSkip => '건너뛰기';

  @override
  String get desktopPromptTitle => '웹에서는 지도로';

  @override
  String get desktopPromptBody =>
      '실시간 나침반은 모션 센서를 사용할 수 있는 휴대폰 앱에 있습니다. 웹에서는 Qibla Go가 대신 지도에 방향을 표시하고, 태양과 달로 방향 잡기를 도와줍니다.';

  @override
  String get desktopPromptContinue => '지도로 계속';

  @override
  String get navCompass => '나침반';

  @override
  String get navMap => '지도';

  @override
  String get mapTitle => '지도 위의 키블라';

  @override
  String get mapYourLocation => '나';

  @override
  String get mapKaaba => '카바, 메카';

  @override
  String get mapQiblaLine => '키블라 선';

  @override
  String get mapSun => '태양';

  @override
  String get mapMoon => '달';

  @override
  String skyMarkerLabel(String name, int azimuth) {
    return '$name $azimuth°';
  }

  @override
  String get mapRecenter => '실제 내 위치 사용';

  @override
  String get mapZoomIn => '확대';

  @override
  String get mapZoomOut => '축소';

  @override
  String get mapLongPressHint => '지도의 아무 곳이나 길게 누르면 그곳이 내 위치로 설정됩니다.';

  @override
  String get mapHowTitle => '이 지도 사용법';

  @override
  String get mapHowStep1 => '금색 선은 내 위치에서 시작해 카바까지 곧게 이어집니다. 기도는 이 선을 따라 향합니다.';

  @override
  String get mapHowStep2 =>
      '근처에서 선이 지나가는 것을 찾으세요: 도로, 높은 건물, 언덕, 다리. 그것을 마주보고 서면 키블라를 향하게 됩니다.';

  @override
  String get mapHowStep3 =>
      '확대해서 선이 건물의 어느 쪽을 지나는지 확인하고, 축소해서 선이 정말 메카에서 끝나는지 확인하세요.';

  @override
  String mapHowSunAbove(
    int azimuth,
    String direction,
    int offset,
    String side,
  ) {
    return '태양은 지금 $azimuth°(대략 $direction)에 있습니다. 키블라는 태양의 $side쪽 $offset°입니다. 태양을 마주 서서 그만큼 돌아서세요.';
  }

  @override
  String mapHowMoonAbove(String phase, int azimuth, int offset, String side) {
    return '달($phase)은 $azimuth°에 있습니다. 키블라는 달의 $side쪽 $offset°입니다.';
  }

  @override
  String get mapHowSkyNone => '지금은 태양도 달도 보이지 않습니다. 지도의 지형지물을 이용하세요.';

  @override
  String get sideLeft => '왼';

  @override
  String get sideRight => '오른';

  @override
  String get compassPointNorth => '북';

  @override
  String get compassPointNortheast => '북동';

  @override
  String get compassPointEast => '동';

  @override
  String get compassPointSoutheast => '남동';

  @override
  String get compassPointSouth => '남';

  @override
  String get compassPointSouthwest => '남서';

  @override
  String get compassPointWest => '서';

  @override
  String get compassPointNorthwest => '북서';

  @override
  String get moonPhaseNew => '삭';

  @override
  String get moonPhaseWaxingCrescent => '초승달';

  @override
  String get moonPhaseFirstQuarter => '상현달';

  @override
  String get moonPhaseWaxingGibbous => '차오르는 달';

  @override
  String get moonPhaseFull => '보름달';

  @override
  String get moonPhaseWaningGibbous => '기우는 달';

  @override
  String get moonPhaseLastQuarter => '하현달';

  @override
  String get moonPhaseWaningCrescent => '그믐달';

  @override
  String get mapAttribution => '© OpenStreetMap 기여자';

  @override
  String get mapNeedsLocation => '키블라 선을 그리려면 위치를 설정하세요.';

  @override
  String get supportButton => '의견 보내기';

  @override
  String get supportTitle => '의견 보내기';

  @override
  String get supportIntro =>
      '어딘가 잘못 보이는 방향, 버그, 아이디어, 또는 그냥 살람 한마디. 모든 메시지를 읽습니다.';

  @override
  String get supportMessageLabel => '메시지';

  @override
  String get supportMessageHint => '무슨 일이 있었고, 어디에서였나요?';

  @override
  String get supportContactLabel => '연락 방법(선택)';

  @override
  String get supportContactHint => '답장을 원할 때만 이메일 등을 적어 주세요';

  @override
  String supportChallengeLabel(String question) {
    return '간단한 확인: $question은(는) 얼마인가요?';
  }

  @override
  String get supportChallengeLoading => '문제를 가져오는 중…';

  @override
  String get supportChallengeUnavailable => '지금은 문제를 가져올 수 없습니다.';

  @override
  String get supportAnswerHint => '=';

  @override
  String get supportNewQuestion => '다른 문제';

  @override
  String get supportSend => '보내기';

  @override
  String get supportSending => '보내는 중…';

  @override
  String get supportSentTitle => '받았습니다';

  @override
  String get supportSentBody => '글 남겨 주셔서 감사합니다. 자자칼라후 카이란.';

  @override
  String get supportClose => '닫기';

  @override
  String get supportPrivacyNote => '메시지에 위치나 기기 정보는 포함되지 않습니다.';

  @override
  String get supportErrorOffline =>
      '서버에 연결할 수 없습니다. 연결을 확인하고 다시 시도하세요. 작성한 글은 유지됩니다.';

  @override
  String get supportErrorTooMany =>
      '지난 한 시간 동안 이 연결에서 보낸 메시지가 너무 많습니다. 나중에 다시 시도해 주세요.';

  @override
  String get supportErrorWrongAnswer => '답이 맞지 않았습니다. 새 문제로 다시 시도해 주세요.';

  @override
  String get supportErrorExpired => '그 문제는 만료되었습니다. 새 문제로 시도해 주세요.';

  @override
  String get supportErrorInvalid => '서버가 이 메시지를 받을 수 없었습니다. 줄여서 다시 시도해 주세요.';

  @override
  String get supportErrorTooShort => '10자 이상 적어 주세요.';

  @override
  String get supportErrorTooLong => '2000자 이내로 적어 주세요.';

  @override
  String get supportErrorAnswerMissing => '간단한 확인에 숫자로 답해 주세요.';

  @override
  String get ratingTitle => 'Qibla Go가 마음에 드시나요?';

  @override
  String get ratingBodyGooglePlay =>
      'Qibla Go는 무료이며 광고가 없습니다. Google Play에 남겨 주신 평점은 다른 분들이 이 앱을 찾고 신뢰하는 데 도움이 됩니다.';

  @override
  String get ratingBodyAppStore =>
      'Qibla Go는 무료이며 광고가 없습니다. App Store에 남겨 주신 평점은 다른 분들이 이 앱을 찾고 신뢰하는 데 도움이 됩니다.';

  @override
  String get ratingRate => 'Qibla Go 평가하기';

  @override
  String get ratingNotNow => '나중에';

  @override
  String get ratingFootnote => '한 번만 묻습니다. 거절하시면 다시 묻지 않습니다.';

  @override
  String get ratingOpenFailed => '스토어를 열 수 없습니다. 나중에 다시 시도해 주세요.';

  @override
  String get ratingStoreLinkGooglePlay => 'Google Play에서 평가하기';

  @override
  String get ratingStoreLinkAppStore => 'App Store에서 평가하기';
}

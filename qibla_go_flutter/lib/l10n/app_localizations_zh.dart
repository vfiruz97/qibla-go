// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'Qibla Go';

  @override
  String get qiblaLabel => '朝向';

  @override
  String get fromTrueNorth => '自真北';

  @override
  String get fromMagneticNorth => '自磁北';

  @override
  String get facingQibla => '您正面向朝向（克尔白方向）';

  @override
  String turnRight(int degrees) {
    return '向右转 $degrees°';
  }

  @override
  String turnLeft(int degrees) {
    return '向左转 $degrees°';
  }

  @override
  String get turnAround => '转身';

  @override
  String distanceToMakkah(String distance) {
    return '距麦加 $distance 公里';
  }

  @override
  String get atKaabaTitle => '您就在克尔白旁';

  @override
  String get atKaabaBody => '直接面向它即可；这么近的距离，方位已无意义。';

  @override
  String accuracyPlusMinus(int degrees) {
    return '±$degrees°';
  }

  @override
  String get accuracyUnknown => '精度未知';

  @override
  String get qualityGood => '良好';

  @override
  String get qualityFair => '一般';

  @override
  String get qualityPoor => '较差';

  @override
  String get headingLabel => '航向';

  @override
  String bearingSummary(int bearing, int magnetic) {
    return '朝向位于真北 $bearing°（磁罗盘上为 $magnetic°）。适用于任何罗盘或地图。';
  }

  @override
  String get locationSetLocation => '设置位置';

  @override
  String get locationLocating => '正在定位…';

  @override
  String get locationOriginDevice => '当前位置';

  @override
  String get locationOriginCached => '上次已知位置';

  @override
  String get locationOriginManual => '手动输入';

  @override
  String locationAccuracyMeters(int meters) {
    return '±$meters 米';
  }

  @override
  String get locationAgeJustNow => '刚刚';

  @override
  String locationAgeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 分钟前',
    );
    return '$_temp0';
  }

  @override
  String locationAgeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 小时前',
    );
    return '$_temp0';
  }

  @override
  String locationAgeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天前',
    );
    return '$_temp0';
  }

  @override
  String get locationNeededTitle => '您在哪里？';

  @override
  String get locationNeededBody => '朝向取决于您所在的位置。请允许位置访问，或输入您的坐标。您的位置永远不会离开此设备。';

  @override
  String get locationUseMyLocation => '使用我的位置';

  @override
  String get locationEnterCoordinates => '输入坐标';

  @override
  String get locationLatitude => '纬度';

  @override
  String get locationLongitude => '经度';

  @override
  String get locationLatitudeHint => '例如 39.9042';

  @override
  String get locationLongitudeHint => '例如 116.4074';

  @override
  String get locationInvalidLatitude => '纬度必须在 -90 到 90 之间';

  @override
  String get locationInvalidLongitude => '经度必须在 -180 到 180 之间';

  @override
  String get locationSave => '使用这些坐标';

  @override
  String get locationOpenSettings => '打开设置';

  @override
  String get locationProblemServicesDisabled => '此设备的定位服务已关闭。';

  @override
  String get locationProblemPermissionDenied => '未授予位置权限。';

  @override
  String get locationProblemPermissionDeniedForever => '位置权限已被禁止。请在系统设置中允许。';

  @override
  String get locationProblemTimeout => '未能及时获取位置。请到窗边或户外再试。';

  @override
  String get locationProblemUnavailable => '无法确定您的位置。';

  @override
  String get locationStaleNote => '正在使用已保存的位置。如果您此后移动过，请刷新。';

  @override
  String get locationSheetTitle => '您的位置';

  @override
  String locationCoordinates(String latitude, String longitude) {
    return '$latitude, $longitude';
  }

  @override
  String get compassCheckingTitle => '正在检查罗盘…';

  @override
  String get compassWaitingTitle => '正在等待传感器…';

  @override
  String get compassWaitingBody => '如果等待超过片刻，请轻轻移动手机。';

  @override
  String get compassStaleTitle => '罗盘停止响应';

  @override
  String get compassStaleBody => '读数已暂停。请稍微移动手机，或重新启动应用。';

  @override
  String get compassNoSensorTitle => '此设备没有罗盘';

  @override
  String get compassNoSensorBody =>
      '此设备没有磁力计，因此无法显示实时方向。下方的方位角仍可配合任何实体罗盘或地图使用。';

  @override
  String get compassBrowserNoSensorTitle => '此浏览器没有罗盘';

  @override
  String get compassBrowserNoSensorBody =>
      '桌面浏览器没有方向传感器。请在手机上打开 Qibla Go，或将下方的方位角配合罗盘或地图使用。';

  @override
  String get compassPermissionTitle => '允许访问运动传感器';

  @override
  String get compassPermissionBody => '浏览器需要权限才能读取手机的朝向。';

  @override
  String get compassPermissionButton => '启用罗盘';

  @override
  String get compassPermissionDeniedBody => '运动传感器访问被拒绝。请在浏览器设置中允许并重新加载页面。';

  @override
  String get compassRetry => '重试';

  @override
  String get compassPausedTitle => '罗盘已暂停';

  @override
  String get issueInterferenceTitle => '磁干扰';

  @override
  String get issueInterferenceBody =>
      '附近有磁性或金属物体：笔记本电脑、汽车、带磁铁的手机壳。在磁场恢复正常之前方向将被隐藏。请走远一些再试。';

  @override
  String get issueMovingFastTitle => '您似乎在车辆中';

  @override
  String get issueMovingFastBody => '在行驶的汽车或火车中，罗盘不可信。请停下并到车外确认方向。';

  @override
  String get issueCalibrationTitle => '校准您的罗盘';

  @override
  String get issueCalibrationBody => '远离金属，将手机在空中画几次“8”字。';

  @override
  String get issueNotFlatTitle => '请将手机持平';

  @override
  String get issueNotFlatBody => '屏幕朝向天空，读数最稳定。';

  @override
  String get issueBrowserTitle => '浏览器罗盘';

  @override
  String get issueBrowserBody =>
      '浏览器只能给出粗略的航向，且无法检测干扰。礼拜前请用下方的方位角确认，可能的话再用实体罗盘核对。';

  @override
  String get issueLowAccuracyTitle => '精度较低';

  @override
  String get issueLowAccuracyBody => '传感器当前报告的误差较大。请先校准，再重新检查。';

  @override
  String get declinationExtrapolatedNote => '本应用的地磁模型已过期。请更新应用以获得最佳精度。';

  @override
  String get detailsButton => '详情';

  @override
  String get detailsTitle => '此方向的计算方式';

  @override
  String get detailsSource => '传感器';

  @override
  String get detailsMagneticHeading => '磁航向';

  @override
  String get detailsDeclination => '磁偏角（WMM2025）';

  @override
  String get detailsTrueHeading => '真航向';

  @override
  String get detailsPlatformTrueHeading => '真航向（系统）';

  @override
  String get detailsAccuracy => '报告精度';

  @override
  String get detailsConfidence => '置信度';

  @override
  String get detailsPitch => '倾斜';

  @override
  String get detailsField => '磁场强度';

  @override
  String get detailsFieldExpected => '预期磁场';

  @override
  String get detailsBearing => '朝向方位角（真北）';

  @override
  String get detailsBearingMagnetic => '朝向方位角（磁北）';

  @override
  String get detailsDistance => '距克尔白的距离';

  @override
  String get detailsLocation => '位置';

  @override
  String get detailsKaaba => '克尔白';

  @override
  String get detailsMethod =>
      '基于 WGS-84 坐标的大圆初始方位角；真北由磁航向加上在本设备上计算的 WMM2025 磁偏角得出。';

  @override
  String get detailsNotAvailable => '—';

  @override
  String get detailsSimulateToggle => '模拟罗盘（仅限调试版本）';

  @override
  String get detailsSimulateHeading => '模拟航向';

  @override
  String get footerFree => '永久免费。无广告，无账户。';

  @override
  String get footerIntention => '为求真主的喜悦而作。';

  @override
  String get cardinalN => '北';

  @override
  String get cardinalE => '东';

  @override
  String get cardinalS => '南';

  @override
  String get cardinalW => '西';

  @override
  String get introTagline => '无论身在何处，面向克尔白';

  @override
  String get introSkip => '跳过';

  @override
  String get desktopPromptTitle => '网页版：地图';

  @override
  String get desktopPromptBody =>
      '实时罗盘在手机应用中，那里可以使用运动传感器。在网页上，Qibla Go 改为在地图上显示方向，并借助太阳和月亮帮助您辨别方位。';

  @override
  String get desktopPromptContinue => '继续前往地图';

  @override
  String get navCompass => '罗盘';

  @override
  String get navMap => '地图';

  @override
  String get mapTitle => '地图上的朝向';

  @override
  String get mapYourLocation => '您';

  @override
  String get mapKaaba => '克尔白，麦加';

  @override
  String get mapQiblaLine => '朝向线';

  @override
  String get mapSun => '太阳';

  @override
  String get mapMoon => '月亮';

  @override
  String skyMarkerLabel(String name, int azimuth) {
    return '$name $azimuth°';
  }

  @override
  String get mapRecenter => '使用我的真实位置';

  @override
  String get mapZoomIn => '放大';

  @override
  String get mapZoomOut => '缩小';

  @override
  String get mapLongPressHint => '长按地图上的任意位置，即可将您的位置设在那里。';

  @override
  String get mapHowTitle => '如何使用此地图';

  @override
  String get mapHowStep1 => '金色线条从您所在的位置出发，笔直通向克尔白。礼拜时沿此线方向而立。';

  @override
  String get mapHowStep2 => '在您附近找一个线条穿过的参照物：道路、高楼、山丘、桥梁。面向它站立，您就面向了朝向。';

  @override
  String get mapHowStep3 => '放大以查看线条从建筑的哪一侧经过，缩小以确认线条确实止于麦加。';

  @override
  String mapHowSunAbove(
    int azimuth,
    String direction,
    int offset,
    String side,
  ) {
    return '太阳现在位于 $azimuth°（约为$direction）。朝向在太阳$side侧 $offset°：先面向太阳，再转过这个角度。';
  }

  @override
  String mapHowMoonAbove(String phase, int azimuth, int offset, String side) {
    return '月亮（$phase）位于 $azimuth°。朝向在月亮$side侧 $offset°。';
  }

  @override
  String get mapHowSkyNone => '现在太阳和月亮都不在天上；请借助地图上的地标。';

  @override
  String get sideLeft => '左';

  @override
  String get sideRight => '右';

  @override
  String get compassPointNorth => '北';

  @override
  String get compassPointNortheast => '东北';

  @override
  String get compassPointEast => '东';

  @override
  String get compassPointSoutheast => '东南';

  @override
  String get compassPointSouth => '南';

  @override
  String get compassPointSouthwest => '西南';

  @override
  String get compassPointWest => '西';

  @override
  String get compassPointNorthwest => '西北';

  @override
  String get moonPhaseNew => '新月';

  @override
  String get moonPhaseWaxingCrescent => '娥眉月';

  @override
  String get moonPhaseFirstQuarter => '上弦月';

  @override
  String get moonPhaseWaxingGibbous => '盈凸月';

  @override
  String get moonPhaseFull => '满月';

  @override
  String get moonPhaseWaningGibbous => '亏凸月';

  @override
  String get moonPhaseLastQuarter => '下弦月';

  @override
  String get moonPhaseWaningCrescent => '残月';

  @override
  String get mapAttribution => '© OpenStreetMap 贡献者';

  @override
  String get mapNeedsLocation => '设置您的位置以绘制朝向线。';

  @override
  String get supportButton => '写信给我们';

  @override
  String get supportTitle => '写信给我们';

  @override
  String get supportIntro => '某处看起来不对的方向、一个错误、一个想法，或只是一声色兰。每一条消息都会被阅读。';

  @override
  String get supportMessageLabel => '您的消息';

  @override
  String get supportMessageHint => '发生了什么，在哪里？';

  @override
  String get supportContactLabel => '联系方式（可选）';

  @override
  String get supportContactHint => '电子邮件或任何方式，仅在您希望收到回复时填写';

  @override
  String supportChallengeLabel(String question) {
    return '快速验证：$question 等于多少？';
  }

  @override
  String get supportChallengeLoading => '正在获取问题…';

  @override
  String get supportChallengeUnavailable => '目前没有可用的问题。';

  @override
  String get supportAnswerHint => '=';

  @override
  String get supportNewQuestion => '换一题';

  @override
  String get supportSend => '发送';

  @override
  String get supportSending => '正在发送…';

  @override
  String get supportSentTitle => '已收到';

  @override
  String get supportSentBody => '感谢您的来信。愿真主以善回报您。';

  @override
  String get supportClose => '关闭';

  @override
  String get supportPrivacyNote => '您的消息不会附带任何位置或设备数据。';

  @override
  String get supportErrorOffline => '无法连接服务器。请检查网络后重试；您的文字已保留。';

  @override
  String get supportErrorTooMany => '过去一小时内此连接发送的消息过多。请稍后再试。';

  @override
  String get supportErrorWrongAnswer => '答案不正确。请尝试新的问题。';

  @override
  String get supportErrorExpired => '该问题已过期。请尝试新的问题。';

  @override
  String get supportErrorInvalid => '服务器无法接受此消息。请缩短后重试。';

  @override
  String get supportErrorTooShort => '请至少输入 10 个字符。';

  @override
  String get supportErrorTooLong => '请控制在 2000 个字符以内。';

  @override
  String get supportErrorAnswerMissing => '请用数字回答快速验证。';
}

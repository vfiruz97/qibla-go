// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'Qibla Go';

  @override
  String get qiblaLabel => 'キブラ';

  @override
  String get fromTrueNorth => '真北から';

  @override
  String get fromMagneticNorth => '磁北から';

  @override
  String get facingQibla => 'キブラの方向を向いています';

  @override
  String turnRight(int degrees) {
    return '右へ $degrees° 回ってください';
  }

  @override
  String turnLeft(int degrees) {
    return '左へ $degrees° 回ってください';
  }

  @override
  String get turnAround => '後ろを向いてください';

  @override
  String distanceToMakkah(String distance) {
    return 'マッカまで $distance km';
  }

  @override
  String get atKaabaTitle => 'カアバのそばにいます';

  @override
  String get atKaabaBody => 'そのまま正面を向いてください。これほど近くでは方位に意味がありません。';

  @override
  String accuracyPlusMinus(int degrees) {
    return '±$degrees°';
  }

  @override
  String get accuracyUnknown => '精度不明';

  @override
  String get qualityGood => '良好';

  @override
  String get qualityFair => '普通';

  @override
  String get qualityPoor => '不良';

  @override
  String get headingLabel => '方位';

  @override
  String bearingSummary(int bearing, int magnetic) {
    return 'キブラは真北から $bearing°（磁気コンパスでは $magnetic°）です。どのコンパスや地図でも使えます。';
  }

  @override
  String get locationSetLocation => '位置を設定';

  @override
  String get locationLocating => '位置を取得中…';

  @override
  String get locationOriginDevice => '現在の位置';

  @override
  String get locationOriginCached => '最後に取得した位置';

  @override
  String get locationOriginManual => '手動で入力';

  @override
  String locationAccuracyMeters(int meters) {
    return '±$meters m';
  }

  @override
  String get locationAgeJustNow => 'たった今';

  @override
  String locationAgeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 分前',
    );
    return '$_temp0';
  }

  @override
  String locationAgeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 時間前',
    );
    return '$_temp0';
  }

  @override
  String locationAgeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 日前',
    );
    return '$_temp0';
  }

  @override
  String get locationNeededTitle => 'どこにいますか？';

  @override
  String get locationNeededBody =>
      'キブラの方向は今いる場所によって決まります。位置情報へのアクセスを許可するか、座標を入力してください。位置情報がこの端末の外に出ることはありません。';

  @override
  String get locationUseMyLocation => '現在地を使う';

  @override
  String get locationEnterCoordinates => '座標を入力';

  @override
  String get locationLatitude => '緯度';

  @override
  String get locationLongitude => '経度';

  @override
  String get locationLatitudeHint => '例：35.6762';

  @override
  String get locationLongitudeHint => '例：139.6503';

  @override
  String get locationInvalidLatitude => '緯度は -90 から 90 の間で入力してください';

  @override
  String get locationInvalidLongitude => '経度は -180 から 180 の間で入力してください';

  @override
  String get locationSave => 'この座標を使う';

  @override
  String get locationOpenSettings => '設定を開く';

  @override
  String get locationProblemServicesDisabled => 'この端末の位置情報サービスがオフになっています。';

  @override
  String get locationProblemPermissionDenied => '位置情報の許可が得られませんでした。';

  @override
  String get locationProblemPermissionDeniedForever =>
      '位置情報へのアクセスがブロックされています。システム設定で許可してください。';

  @override
  String get locationProblemTimeout => '時間内に位置を取得できませんでした。窓際や屋外でお試しください。';

  @override
  String get locationProblemUnavailable => '位置を特定できませんでした。';

  @override
  String get locationStaleNote => '保存された位置を使っています。移動した場合は更新してください。';

  @override
  String get locationSheetTitle => 'あなたの位置';

  @override
  String locationCoordinates(String latitude, String longitude) {
    return '$latitude, $longitude';
  }

  @override
  String get compassCheckingTitle => 'コンパスを確認中…';

  @override
  String get compassWaitingTitle => 'センサーを待っています…';

  @override
  String get compassWaitingBody => 'しばらく変わらない場合は、端末をゆっくり動かしてください。';

  @override
  String get compassStaleTitle => 'コンパスが応答しません';

  @override
  String get compassStaleBody => '計測が止まりました。端末を少し動かすか、アプリを再起動してください。';

  @override
  String get compassNoSensorTitle => 'この端末にはコンパスがありません';

  @override
  String get compassNoSensorBody =>
      'この端末には磁気センサーがないため、リアルタイムの方向を表示できません。下の方位角は、実物のコンパスや地図と合わせて使えます。';

  @override
  String get compassBrowserNoSensorTitle => 'このブラウザにはコンパスがありません';

  @override
  String get compassBrowserNoSensorBody =>
      'パソコンのブラウザには方向センサーがありません。スマートフォンで Qibla Go を開くか、下の方位角をコンパスや地図と合わせて使ってください。';

  @override
  String get compassPermissionTitle => 'モーションへのアクセスを許可';

  @override
  String get compassPermissionBody => '端末の向きを読み取るには、ブラウザの許可が必要です。';

  @override
  String get compassPermissionButton => 'コンパスを有効にする';

  @override
  String get compassPermissionDeniedBody =>
      'モーションへのアクセスが拒否されました。ブラウザの設定で許可して、ページを再読み込みしてください。';

  @override
  String get compassRetry => '再試行';

  @override
  String get compassPausedTitle => 'コンパスを一時停止中';

  @override
  String get issueInterferenceTitle => '磁気の干渉';

  @override
  String get issueInterferenceBody =>
      '近くに磁気や金属のものがあります：ノートパソコン、車、磁石付きのスマホケースなど。磁場が落ち着くまで方向は表示されません。離れてからもう一度お試しください。';

  @override
  String get issueMovingFastTitle => '乗り物の中にいるようです';

  @override
  String get issueMovingFastBody =>
      '走行中の車や電車の中ではコンパスは信頼できません。停まって外に出てから方向を確認してください。';

  @override
  String get issueCalibrationTitle => 'コンパスを調整してください';

  @override
  String get issueCalibrationBody => '金属から離れて、端末を8の字に数回動かしてください。';

  @override
  String get issueNotFlatTitle => '端末を水平に持ってください';

  @override
  String get issueNotFlatBody => '画面を空に向けると、最も安定して計測できます。';

  @override
  String get issueBrowserTitle => 'ブラウザのコンパス';

  @override
  String get issueBrowserBody =>
      'ブラウザの方位はおおまかで、干渉を検出できません。礼拝の前に、下の方位角と、できれば実物のコンパスで確認してください。';

  @override
  String get issueLowAccuracyTitle => '精度が低い';

  @override
  String get issueLowAccuracyBody =>
      'センサーが現在大きな誤差を報告しています。調整してから、もう一度確認してください。';

  @override
  String get declinationExtrapolatedNote =>
      'このアプリの地磁気モデルの有効期限が切れています。最良の精度のためにアプリを更新してください。';

  @override
  String get detailsButton => '詳細';

  @override
  String get detailsTitle => 'この方向の求め方';

  @override
  String get detailsSource => 'センサー';

  @override
  String get detailsMagneticHeading => '磁方位';

  @override
  String get detailsDeclination => '偏角（WMM2025）';

  @override
  String get detailsTrueHeading => '真方位';

  @override
  String get detailsPlatformTrueHeading => '真方位（システム）';

  @override
  String get detailsAccuracy => '報告された精度';

  @override
  String get detailsConfidence => '信頼度';

  @override
  String get detailsPitch => '傾き';

  @override
  String get detailsField => '磁場の強さ';

  @override
  String get detailsFieldExpected => '想定される磁場';

  @override
  String get detailsBearing => 'キブラの方位角（真北）';

  @override
  String get detailsBearingMagnetic => 'キブラの方位角（磁北）';

  @override
  String get detailsDistance => 'カアバまでの距離';

  @override
  String get detailsLocation => '位置';

  @override
  String get detailsKaaba => 'カアバ';

  @override
  String get detailsMethod =>
      'WGS-84 座標上の大圏初期方位角。真北は磁方位に、この端末で計算した WMM2025 の偏角を加えて求めます。';

  @override
  String get detailsNotAvailable => '—';

  @override
  String get detailsSimulateToggle => 'コンパスをシミュレート（デバッグビルドのみ）';

  @override
  String get detailsSimulateHeading => 'シミュレートした方位';

  @override
  String get footerFree => 'ずっと無料。広告なし、アカウント不要。';

  @override
  String get footerIntention => '神の御喜びを求めて作りました。';

  @override
  String get cardinalN => '北';

  @override
  String get cardinalE => '東';

  @override
  String get cardinalS => '南';

  @override
  String get cardinalW => '西';

  @override
  String get introTagline => 'どこにいても、カアバの方へ';

  @override
  String get introSkip => 'スキップ';

  @override
  String get desktopPromptTitle => 'ウェブでは地図';

  @override
  String get desktopPromptBody =>
      'リアルタイムのコンパスは、モーションセンサーを使えるスマートフォンアプリにあります。ウェブ版の Qibla Go は代わりに地図上で方向を示し、太陽と月で向きをつかむ手助けをします。';

  @override
  String get desktopPromptContinue => '地図へ進む';

  @override
  String get navCompass => 'コンパス';

  @override
  String get navMap => '地図';

  @override
  String get mapTitle => '地図で見るキブラ';

  @override
  String get mapYourLocation => 'あなた';

  @override
  String get mapKaaba => 'カアバ、マッカ';

  @override
  String get mapQiblaLine => 'キブラの線';

  @override
  String get mapSun => '太陽';

  @override
  String get mapMoon => '月';

  @override
  String skyMarkerLabel(String name, int azimuth) {
    return '$name $azimuth°';
  }

  @override
  String get mapRecenter => '実際の現在地を使う';

  @override
  String get mapZoomIn => '拡大';

  @override
  String get mapZoomOut => '縮小';

  @override
  String get mapLongPressHint => '地図上の好きな場所を長押しすると、そこを自分の位置に設定できます。';

  @override
  String get mapHowTitle => 'この地図の使い方';

  @override
  String get mapHowStep1 =>
      '金色の線はあなたの位置から始まり、カアバまでまっすぐ伸びています。礼拝はこの線の方向に向かって行います。';

  @override
  String get mapHowStep2 =>
      '近くで線が通っているものを探します：道路、高い建物、丘、橋など。それに正面を向けば、キブラを向いています。';

  @override
  String get mapHowStep3 =>
      '拡大して線が建物のどちら側を通るかを確かめ、縮小して線が本当にマッカで終わることを確かめてください。';

  @override
  String mapHowSunAbove(
    int azimuth,
    String direction,
    int offset,
    String side,
  ) {
    return '太陽は今 $azimuth°（およそ$direction）にあります。キブラは太陽の$side $offset° です。太陽に正面を向けてから、その分だけ回ってください。';
  }

  @override
  String mapHowMoonAbove(String phase, int azimuth, int offset, String side) {
    return '月（$phase）は $azimuth° にあります。キブラは月の$side $offset° です。';
  }

  @override
  String get mapHowSkyNone => '今は太陽も月も出ていません。地図上の目印を使ってください。';

  @override
  String get sideLeft => '左';

  @override
  String get sideRight => '右';

  @override
  String get compassPointNorth => '北';

  @override
  String get compassPointNortheast => '北東';

  @override
  String get compassPointEast => '東';

  @override
  String get compassPointSoutheast => '南東';

  @override
  String get compassPointSouth => '南';

  @override
  String get compassPointSouthwest => '南西';

  @override
  String get compassPointWest => '西';

  @override
  String get compassPointNorthwest => '北西';

  @override
  String get moonPhaseNew => '新月';

  @override
  String get moonPhaseWaxingCrescent => '三日月';

  @override
  String get moonPhaseFirstQuarter => '上弦の月';

  @override
  String get moonPhaseWaxingGibbous => '十三夜月';

  @override
  String get moonPhaseFull => '満月';

  @override
  String get moonPhaseWaningGibbous => '寝待月';

  @override
  String get moonPhaseLastQuarter => '下弦の月';

  @override
  String get moonPhaseWaningCrescent => '有明月';

  @override
  String get mapAttribution => '© OpenStreetMap 貢献者';

  @override
  String get mapNeedsLocation => 'キブラの線を描くには、位置を設定してください。';

  @override
  String get supportButton => 'ご意見を送る';

  @override
  String get supportTitle => 'ご意見を送る';

  @override
  String get supportIntro =>
      'どこかで方向が間違って見える、不具合がある、アイデアがある、あるいはただのサラーム。すべてのメッセージを読んでいます。';

  @override
  String get supportMessageLabel => 'メッセージ';

  @override
  String get supportMessageHint => '何が起きましたか？ どこで？';

  @override
  String get supportContactLabel => '連絡先（任意）';

  @override
  String get supportContactHint => 'メールアドレスなど、返信を希望する場合のみ';

  @override
  String supportChallengeLabel(String question) {
    return '簡単な確認：$question はいくつですか？';
  }

  @override
  String get supportChallengeLoading => '問題を取得中…';

  @override
  String get supportChallengeUnavailable => '現在、問題を取得できません。';

  @override
  String get supportAnswerHint => '=';

  @override
  String get supportNewQuestion => '別の問題';

  @override
  String get supportSend => '送信';

  @override
  String get supportSending => '送信中…';

  @override
  String get supportSentTitle => '受け取りました';

  @override
  String get supportSentBody => 'お便りをありがとうございます。ジャザーカッラーフ・ハイラン。';

  @override
  String get supportClose => '閉じる';

  @override
  String get supportPrivacyNote => 'メッセージに位置情報や端末の情報は添付されません。';

  @override
  String get supportErrorOffline =>
      'サーバーに接続できませんでした。接続を確認してもう一度お試しください。入力した文章は残っています。';

  @override
  String get supportErrorTooMany => 'この接続からの送信が直近1時間で多すぎます。しばらくしてからお試しください。';

  @override
  String get supportErrorWrongAnswer => '答えが正しくありませんでした。新しい問題でお試しください。';

  @override
  String get supportErrorExpired => 'その問題は期限切れです。新しい問題でお試しください。';

  @override
  String get supportErrorInvalid =>
      'サーバーがこのメッセージを受け付けられませんでした。短くしてもう一度お試しください。';

  @override
  String get supportErrorTooShort => '10 文字以上入力してください。';

  @override
  String get supportErrorTooLong => '2000 文字以内にしてください。';

  @override
  String get supportErrorAnswerMissing => '簡単な確認に数字で答えてください。';
}

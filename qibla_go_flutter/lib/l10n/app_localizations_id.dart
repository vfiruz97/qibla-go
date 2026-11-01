// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'Qibla Go';

  @override
  String get qiblaLabel => 'KIBLAT';

  @override
  String get fromTrueNorth => 'dari utara sejati';

  @override
  String get fromMagneticNorth => 'dari utara magnetis';

  @override
  String get facingQibla => 'Anda menghadap kiblat';

  @override
  String turnRight(int degrees) {
    return 'Putar ke kanan $degrees°';
  }

  @override
  String turnLeft(int degrees) {
    return 'Putar ke kiri $degrees°';
  }

  @override
  String get turnAround => 'Berbalik';

  @override
  String distanceToMakkah(String distance) {
    return '$distance km ke Makkah';
  }

  @override
  String get atKaabaTitle => 'Anda berada di Ka\'bah';

  @override
  String get atKaabaBody =>
      'Hadapi langsung ke arahnya; sedekat ini, arah tidak lagi berarti.';

  @override
  String accuracyPlusMinus(int degrees) {
    return '±$degrees°';
  }

  @override
  String get accuracyUnknown => 'Akurasi tidak diketahui';

  @override
  String get qualityGood => 'Baik';

  @override
  String get qualityFair => 'Sedang';

  @override
  String get qualityPoor => 'Buruk';

  @override
  String get headingLabel => 'Arah hadap';

  @override
  String bearingSummary(int bearing, int magnetic) {
    return 'Kiblat berada $bearing° dari utara sejati ($magnetic° pada kompas magnetis). Berlaku untuk kompas atau peta apa pun.';
  }

  @override
  String get locationSetLocation => 'Atur lokasi';

  @override
  String get locationLocating => 'Mencari lokasi…';

  @override
  String get locationOriginDevice => 'Lokasi saat ini';

  @override
  String get locationOriginCached => 'Lokasi terakhir yang diketahui';

  @override
  String get locationOriginManual => 'Dimasukkan manual';

  @override
  String locationAccuracyMeters(int meters) {
    return '±$meters m';
  }

  @override
  String get locationAgeJustNow => 'baru saja';

  @override
  String locationAgeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count menit lalu',
    );
    return '$_temp0';
  }

  @override
  String locationAgeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jam lalu',
    );
    return '$_temp0';
  }

  @override
  String locationAgeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hari lalu',
    );
    return '$_temp0';
  }

  @override
  String get locationNeededTitle => 'Di mana Anda?';

  @override
  String get locationNeededBody =>
      'Arah kiblat bergantung pada tempat Anda berdiri. Izinkan akses lokasi, atau masukkan koordinat Anda. Lokasi Anda tidak pernah keluar dari perangkat ini.';

  @override
  String get locationUseMyLocation => 'Gunakan lokasi saya';

  @override
  String get locationEnterCoordinates => 'Masukkan koordinat';

  @override
  String get locationLatitude => 'Lintang';

  @override
  String get locationLongitude => 'Bujur';

  @override
  String get locationLatitudeHint => 'mis. -6,2088';

  @override
  String get locationLongitudeHint => 'mis. 106,8456';

  @override
  String get locationInvalidLatitude => 'Lintang harus antara -90 dan 90';

  @override
  String get locationInvalidLongitude => 'Bujur harus antara -180 dan 180';

  @override
  String get locationSave => 'Gunakan koordinat ini';

  @override
  String get locationOpenSettings => 'Buka pengaturan';

  @override
  String get locationProblemServicesDisabled =>
      'Layanan lokasi dimatikan di perangkat ini.';

  @override
  String get locationProblemPermissionDenied => 'Izin lokasi tidak diberikan.';

  @override
  String get locationProblemPermissionDeniedForever =>
      'Izin lokasi diblokir. Izinkan di pengaturan sistem.';

  @override
  String get locationProblemTimeout =>
      'Posisi tidak didapat tepat waktu. Coba di dekat jendela atau di luar ruangan.';

  @override
  String get locationProblemUnavailable =>
      'Posisi Anda tidak dapat ditentukan.';

  @override
  String get locationStaleNote =>
      'Menggunakan posisi tersimpan. Jika Anda sudah berpindah, segarkan.';

  @override
  String get locationSheetTitle => 'Lokasi Anda';

  @override
  String locationCoordinates(String latitude, String longitude) {
    return '$latitude, $longitude';
  }

  @override
  String get compassCheckingTitle => 'Memeriksa kompas…';

  @override
  String get compassWaitingTitle => 'Menunggu sensor…';

  @override
  String get compassWaitingBody =>
      'Gerakkan ponsel perlahan jika ini memakan waktu lebih dari sesaat.';

  @override
  String get compassStaleTitle => 'Kompas berhenti merespons';

  @override
  String get compassStaleBody =>
      'Pembacaan terhenti. Gerakkan ponsel sedikit, atau mulai ulang aplikasi.';

  @override
  String get compassNoSensorTitle => 'Tidak ada kompas di perangkat ini';

  @override
  String get compassNoSensorBody =>
      'Perangkat ini tidak memiliki magnetometer, sehingga tidak dapat menampilkan arah langsung. Sudut di bawah tetap berlaku dengan kompas fisik atau peta apa pun.';

  @override
  String get compassBrowserNoSensorTitle => 'Tidak ada kompas di peramban ini';

  @override
  String get compassBrowserNoSensorBody =>
      'Peramban desktop tidak memiliki sensor orientasi. Buka Qibla Go di ponsel, atau gunakan sudut di bawah dengan kompas atau peta.';

  @override
  String get compassPermissionTitle => 'Izinkan akses gerakan';

  @override
  String get compassPermissionBody =>
      'Peramban Anda memerlukan izin untuk membaca orientasi ponsel.';

  @override
  String get compassPermissionButton => 'Aktifkan kompas';

  @override
  String get compassPermissionDeniedBody =>
      'Akses gerakan ditolak. Izinkan di pengaturan peramban lalu muat ulang halaman.';

  @override
  String get compassRetry => 'Coba lagi';

  @override
  String get compassPausedTitle => 'Kompas dijeda';

  @override
  String get issueInterferenceTitle => 'Gangguan magnetis';

  @override
  String get issueInterferenceBody =>
      'Ada benda magnetis atau logam di dekat Anda: laptop, mobil, casing ponsel bermagnet. Arah disembunyikan sampai medannya bersih. Menjauhlah dan coba lagi.';

  @override
  String get issueMovingFastTitle => 'Anda tampaknya berada di kendaraan';

  @override
  String get issueMovingFastBody =>
      'Kompas tidak dapat dipercaya di dalam mobil atau kereta yang bergerak. Berhenti dan keluarlah untuk memeriksa arah.';

  @override
  String get issueCalibrationTitle => 'Kalibrasi kompas Anda';

  @override
  String get issueCalibrationBody =>
      'Gerakkan ponsel membentuk angka delapan beberapa kali, jauh dari logam.';

  @override
  String get issueNotFlatTitle => 'Pegang ponsel mendatar';

  @override
  String get issueNotFlatBody =>
      'Arahkan layar ke langit untuk pembacaan paling stabil.';

  @override
  String get issueBrowserTitle => 'Kompas peramban';

  @override
  String get issueBrowserBody =>
      'Peramban memberi arah kasar dan tidak dapat mendeteksi gangguan. Sebelum salat, pastikan dengan sudut di bawah dan kompas sungguhan jika bisa.';

  @override
  String get issueLowAccuracyTitle => 'Akurasi rendah';

  @override
  String get issueLowAccuracyBody =>
      'Sensor melaporkan galat besar saat ini. Kalibrasi, lalu periksa lagi.';

  @override
  String get declinationExtrapolatedNote =>
      'Model magnetis aplikasi ini sudah kedaluwarsa. Perbarui aplikasi untuk akurasi terbaik.';

  @override
  String get detailsButton => 'Rincian';

  @override
  String get detailsTitle => 'Cara arah ini dihitung';

  @override
  String get detailsSource => 'Sensor';

  @override
  String get detailsMagneticHeading => 'Arah magnetis';

  @override
  String get detailsDeclination => 'Deklinasi (WMM2025)';

  @override
  String get detailsTrueHeading => 'Arah sejati';

  @override
  String get detailsPlatformTrueHeading => 'Arah sejati (sistem)';

  @override
  String get detailsAccuracy => 'Akurasi yang dilaporkan';

  @override
  String get detailsConfidence => 'Keyakinan';

  @override
  String get detailsPitch => 'Kemiringan';

  @override
  String get detailsField => 'Kekuatan medan';

  @override
  String get detailsFieldExpected => 'Medan yang diharapkan';

  @override
  String get detailsBearing => 'Sudut kiblat (sejati)';

  @override
  String get detailsBearingMagnetic => 'Sudut kiblat (magnetis)';

  @override
  String get detailsDistance => 'Jarak ke Ka\'bah';

  @override
  String get detailsLocation => 'Posisi';

  @override
  String get detailsKaaba => 'Ka\'bah';

  @override
  String get detailsMethod =>
      'Sudut awal lingkaran besar pada koordinat WGS-84; utara sejati dari arah magnetis ditambah deklinasi WMM2025 yang dihitung di perangkat ini.';

  @override
  String get detailsNotAvailable => '—';

  @override
  String get detailsSimulateToggle => 'Simulasikan kompas (hanya build debug)';

  @override
  String get detailsSimulateHeading => 'Arah simulasi';

  @override
  String get footerFree => 'Gratis, selamanya. Tanpa iklan, tanpa akun.';

  @override
  String get footerIntention => 'Dibuat demi keridaan Allah.';

  @override
  String get cardinalN => 'U';

  @override
  String get cardinalE => 'T';

  @override
  String get cardinalS => 'S';

  @override
  String get cardinalW => 'B';

  @override
  String get introTagline => 'Menghadap Ka\'bah, di mana pun Anda berada';

  @override
  String get introSkip => 'Lewati';

  @override
  String get desktopPromptTitle => 'Di web, peta';

  @override
  String get desktopPromptBody =>
      'Kompas langsung ada di aplikasi ponsel, yang dapat memakai sensor gerak. Di web, Qibla Go menampilkan arah di peta, dengan matahari dan bulan untuk membantu Anda berorientasi.';

  @override
  String get desktopPromptContinue => 'Lanjut ke peta';

  @override
  String get navCompass => 'Kompas';

  @override
  String get navMap => 'Peta';

  @override
  String get mapTitle => 'Kiblat di peta';

  @override
  String get mapYourLocation => 'Anda';

  @override
  String get mapKaaba => 'Ka\'bah, Makkah';

  @override
  String get mapQiblaLine => 'Garis kiblat';

  @override
  String get mapSun => 'Matahari';

  @override
  String get mapMoon => 'Bulan';

  @override
  String skyMarkerLabel(String name, int azimuth) {
    return '$name $azimuth°';
  }

  @override
  String get mapRecenter => 'Gunakan lokasi asli saya';

  @override
  String get mapZoomIn => 'Perbesar';

  @override
  String get mapZoomOut => 'Perkecil';

  @override
  String get mapLongPressHint =>
      'Tekan lama di mana saja pada peta untuk menetapkan lokasi Anda di sana.';

  @override
  String get mapHowTitle => 'Cara menggunakan peta ini';

  @override
  String get mapHowStep1 =>
      'Garis emas berawal dari tempat Anda dan lurus menuju Ka\'bah. Salat menghadap sepanjang garis ini.';

  @override
  String get mapHowStep2 =>
      'Cari sesuatu di dekat Anda yang dilintasi garis: jalan, bangunan tinggi, bukit, jembatan. Berdirilah menghadapnya, maka Anda menghadap kiblat.';

  @override
  String get mapHowStep3 =>
      'Perbesar untuk melihat sisi bangunan mana yang dilewati garis, dan perkecil untuk melihat bahwa garis benar-benar berakhir di Makkah.';

  @override
  String mapHowSunAbove(
    int azimuth,
    String direction,
    int offset,
    String side,
  ) {
    return 'Matahari sekarang di $azimuth° (sekitar $direction). Kiblat berada $offset° di $side matahari: berdirilah menghadap matahari, lalu berputar sebesar itu.';
  }

  @override
  String mapHowMoonAbove(String phase, int azimuth, int offset, String side) {
    return 'Bulan ($phase) berada di $azimuth°. Kiblat berada $offset° di $side bulan.';
  }

  @override
  String get mapHowSkyNone =>
      'Matahari maupun bulan tidak tampak saat ini; gunakan penanda di peta.';

  @override
  String get sideLeft => 'kiri';

  @override
  String get sideRight => 'kanan';

  @override
  String get compassPointNorth => 'utara';

  @override
  String get compassPointNortheast => 'timur laut';

  @override
  String get compassPointEast => 'timur';

  @override
  String get compassPointSoutheast => 'tenggara';

  @override
  String get compassPointSouth => 'selatan';

  @override
  String get compassPointSouthwest => 'barat daya';

  @override
  String get compassPointWest => 'barat';

  @override
  String get compassPointNorthwest => 'barat laut';

  @override
  String get moonPhaseNew => 'bulan baru';

  @override
  String get moonPhaseWaxingCrescent => 'sabit awal';

  @override
  String get moonPhaseFirstQuarter => 'kuartir pertama';

  @override
  String get moonPhaseWaxingGibbous => 'cembung awal';

  @override
  String get moonPhaseFull => 'bulan purnama';

  @override
  String get moonPhaseWaningGibbous => 'cembung akhir';

  @override
  String get moonPhaseLastQuarter => 'kuartir akhir';

  @override
  String get moonPhaseWaningCrescent => 'sabit akhir';

  @override
  String get mapAttribution => '© Kontributor OpenStreetMap';

  @override
  String get mapNeedsLocation =>
      'Atur lokasi Anda untuk menggambar garis kiblat.';

  @override
  String get supportButton => 'Tulis kepada kami';

  @override
  String get supportTitle => 'Tulis kepada kami';

  @override
  String get supportIntro =>
      'Arah yang tampak salah di suatu tempat, kesalahan, ide, atau sekadar salam. Setiap pesan dibaca.';

  @override
  String get supportMessageLabel => 'Pesan Anda';

  @override
  String get supportMessageHint => 'Apa yang terjadi, dan di mana?';

  @override
  String get supportContactLabel => 'Cara menghubungi Anda (opsional)';

  @override
  String get supportContactHint =>
      'Email atau apa pun, hanya jika Anda ingin balasan';

  @override
  String supportChallengeLabel(String question) {
    return 'Cek singkat: berapa $question?';
  }

  @override
  String get supportChallengeLoading => 'Mengambil pertanyaan…';

  @override
  String get supportChallengeUnavailable =>
      'Tidak ada pertanyaan tersedia saat ini.';

  @override
  String get supportAnswerHint => '=';

  @override
  String get supportNewQuestion => 'Pertanyaan baru';

  @override
  String get supportSend => 'Kirim';

  @override
  String get supportSending => 'Mengirim…';

  @override
  String get supportSentTitle => 'Diterima';

  @override
  String get supportSentBody =>
      'Terima kasih telah menulis. Jazakallahu khairan.';

  @override
  String get supportClose => 'Tutup';

  @override
  String get supportPrivacyNote =>
      'Tidak ada data lokasi atau perangkat yang dikirim bersama pesan Anda.';

  @override
  String get supportErrorOffline =>
      'Server tidak dapat dihubungi. Periksa koneksi Anda dan coba lagi; teks Anda tetap tersimpan.';

  @override
  String get supportErrorTooMany =>
      'Terlalu banyak pesan dari koneksi ini dalam satu jam terakhir. Silakan coba lagi nanti.';

  @override
  String get supportErrorWrongAnswer =>
      'Jawaban itu tidak benar. Silakan coba pertanyaan yang baru.';

  @override
  String get supportErrorExpired =>
      'Pertanyaan itu sudah kedaluwarsa. Silakan coba yang baru.';

  @override
  String get supportErrorInvalid =>
      'Server tidak dapat menerima pesan ini. Persingkat lalu coba lagi.';

  @override
  String get supportErrorTooShort => 'Tulis minimal 10 karakter.';

  @override
  String get supportErrorTooLong => 'Jaga di bawah 2000 karakter.';

  @override
  String get supportErrorAnswerMissing => 'Jawab cek singkat dengan angka.';
}

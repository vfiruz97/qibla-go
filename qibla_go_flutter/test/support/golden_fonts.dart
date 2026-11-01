import 'dart:io';

import 'package:flutter/services.dart';
import 'package:qibla_go_flutter/app/theme/app_theme.dart';

/// Loads the bundled fonts and the Material icon font so goldens render the
/// real type instead of the test framework's Ahem boxes.
Future<void> loadGoldenFonts() async {
  Future<void> load(String family, String file) async {
    final bytes = File('assets/fonts/$file').readAsBytesSync();
    final loader = FontLoader(family)
      ..addFont(Future.value(ByteData.view(bytes.buffer)));
    await loader.load();
  }

  await load(AppFonts.display, 'Marcellus-Regular.ttf');
  await load(AppFonts.body, 'Manrope-Variable.ttf');

  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  final icons = File(
    '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
  if (flutterRoot != null && icons.existsSync()) {
    final bytes = icons.readAsBytesSync();
    final loader = FontLoader('MaterialIcons')
      ..addFont(Future.value(ByteData.view(bytes.buffer)));
    await loader.load();
  }
}

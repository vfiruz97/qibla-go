import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../features/intro/presentation/intro_gate.dart';
import '../l10n/app_localizations.dart';
import '../l10n/locale_resolution.dart';
import '../l10n/tajik_material_localizations.dart';
import 'router.dart';
import 'theme/app_theme.dart';
import 'theme/qibla_palette.dart';
import 'theme/script_theme.dart';

class QiblaGoApp extends StatefulWidget {
  const QiblaGoApp({super.key, this.playIntro = true});

  /// Tests and the driver pass false to skip the opening animation.
  final bool playIntro;

  @override
  State<QiblaGoApp> createState() => _QiblaGoAppState();
}

class _QiblaGoAppState extends State<QiblaGoApp> {
  /// On the web the browser can hand the Flutter view keyboard focus before
  /// the first layout (headless Chrome and Lighthouse always do). Flutter
  /// then looks for the first focusable widget by reading geometry that
  /// does not exist yet and logs "RenderBox was not laid out". So the first
  /// web frame draws nothing focusable; the app follows one frame later,
  /// behind the HTML splash. Phones start the app at once.
  late bool _ready = !kIsWeb;

  @override
  void initState() {
    super.initState();
    if (!_ready) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _ready = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return ColoredBox(color: QiblaPalette.night.background);
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context).appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.dark,
        localizationsDelegates: const [
          ...tajikLocalizationsDelegates,
          ...AppLocalizations.localizationsDelegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        // The user's system or browser language list, in their order; English
        // when none of it is supported. See resolveLocale.
        localeListResolutionCallback: resolveLocale,
        routerConfig: appRouter,
        builder: (context, child) => ScriptTheme(
          child: IntroGate(
            playIntro: widget.playIntro,
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

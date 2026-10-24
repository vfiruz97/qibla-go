import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../features/intro/presentation/intro_gate.dart';
import '../l10n/app_localizations.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class QiblaGoApp extends StatelessWidget {
  const QiblaGoApp({super.key, this.playIntro = true});

  /// Tests and the driver pass false to skip the opening animation.
  final bool playIntro;

  @override
  Widget build(BuildContext context) {
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
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: appRouter,
        builder: (context, child) => IntroGate(
          playIntro: playIntro,
          onShowMap: () => appRouter.go(AppRoutes.map),
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}

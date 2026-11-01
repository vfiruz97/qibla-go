import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'script_typography.dart';

/// Re-themes the app for the script of the resolved locale. `MaterialApp`
/// builds its theme before it knows the locale, so this sits in `builder`,
/// below `Localizations`, and swaps the type for Cyrillic, Arabic and East
/// Asian languages. Latin-script languages keep the theme as built.
class ScriptTheme extends StatelessWidget {
  const ScriptTheme({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    if (ScriptTypography.forLocale(locale).group == ScriptGroup.latin) {
      return child;
    }
    return Theme(
      data: AppTheme.of(
        brightness: Theme.of(context).brightness,
        locale: locale,
      ),
      child: child,
    );
  }
}

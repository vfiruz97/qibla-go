import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_go_flutter/app/theme/app_theme.dart';
import 'package:qibla_go_flutter/features/intro/presentation/intro_overlay.dart';
import 'package:qibla_go_flutter/l10n/app_localizations.dart';

void main() {
  testWidgets(
    'Given the overlay above the navigator, then its text has a Material ancestor',
    (tester) async {
      // No Scaffold on purpose: this is how the app's builder mounts it.
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: IntroOverlay(onDone: () {}),
        ),
      );
      await tester.pump(const Duration(milliseconds: 1500));

      final wordmark = find.text('Qibla Go');
      expect(wordmark, findsOneWidget);
      expect(
        find.ancestor(of: wordmark, matching: find.byType(Material)),
        findsWidgets,
        reason: 'without Material, Text renders the yellow double underline',
      );
      await tester.pump(const Duration(seconds: 6)); // let timers finish
    },
  );
}

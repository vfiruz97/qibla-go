import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_go_flutter/app/theme/app_theme.dart';
import 'package:qibla_go_flutter/features/support/application/support_api.dart';
import 'package:qibla_go_flutter/features/support/presentation/support_sheet.dart';
import 'package:qibla_go_flutter/l10n/app_localizations.dart';

import '../../support/fake_support_api.dart';

void main() {
  late FakeSupportApi api;

  setUp(() => api = FakeSupportApi());

  Future<void> openSheet(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [supportApiProvider.overrideWithValue(api)],
        child: MaterialApp(
          theme: AppTheme.dark(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => SupportSheet.show(context),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('Given the sheet, when the sum is right then thanks are shown', (
    tester,
  ) async {
    await openSheet(tester);
    expect(find.textContaining('7 + 5'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('support-message')),
      'The line near the big mosque looks a few degrees off.',
    );
    await tester.enterText(find.byKey(const ValueKey('support-answer')), '12');
    await tester.tap(find.byKey(const ValueKey('support-send')));
    await tester.pumpAndSettle();

    expect(find.text('Received'), findsOneWidget);
    expect(api.submits, hasLength(1));
  });

  testWidgets('Given a short message, when sent then nothing goes out', (
    tester,
  ) async {
    await openSheet(tester);
    await tester.enterText(
      find.byKey(const ValueKey('support-message')),
      'hi',
    );
    await tester.enterText(find.byKey(const ValueKey('support-answer')), '12');
    await tester.tap(find.byKey(const ValueKey('support-send')));
    await tester.pumpAndSettle();

    expect(find.text('Please write at least 10 characters.'), findsOneWidget);
    expect(api.submits, isEmpty);
  });

  testWidgets('Given a wrong sum, when sent then a new question appears', (
    tester,
  ) async {
    await openSheet(tester);
    await tester.enterText(
      find.byKey(const ValueKey('support-message')),
      'A message that is long enough to pass.',
    );
    await tester.enterText(find.byKey(const ValueKey('support-answer')), '99');
    await tester.tap(find.byKey(const ValueKey('support-send')));
    await tester.pumpAndSettle();

    expect(find.textContaining('not right'), findsOneWidget);
    expect(api.issued, 2);
    final answerField = tester.widget<TextField>(
      find.byKey(const ValueKey('support-answer')),
    );
    expect(answerField.controller!.text, isEmpty);
  });
}

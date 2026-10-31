import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_go_client/qibla_go_client.dart';
import 'package:qibla_go_flutter/features/support/application/support_api.dart';
import 'package:qibla_go_flutter/features/support/application/support_controller.dart';
import 'package:qibla_go_flutter/features/support/domain/support_form.dart';

import '../../support/fake_support_api.dart';

void main() {
  late FakeSupportApi api;
  late ProviderContainer container;

  setUp(() {
    api = FakeSupportApi();
    container = ProviderContainer(
      overrides: [supportApiProvider.overrideWithValue(api)],
    );
    addTearDown(container.dispose);
  });

  Future<void> pump() => Future<void>.delayed(Duration.zero);

  SupportFormState state() => container.read(supportControllerProvider);
  SupportController notifier() =>
      container.read(supportControllerProvider.notifier);

  test('Given the sheet opens, then a question is fetched', () async {
    final sub = container.listen(supportControllerProvider, (_, _) {});
    addTearDown(sub.close);
    expect(state().phase, SupportPhase.loadingChallenge);
    await pump();
    expect(state().phase, SupportPhase.ready);
    expect(state().question, '7 + 5');
    expect(state().canSend, isTrue);
  });

  test('Given a right answer, when sent then the phase is sent', () async {
    final sub = container.listen(supportControllerProvider, (_, _) {});
    addTearDown(sub.close);
    await pump();
    await notifier().send(
      message: '  A real message of some length.  ',
      contact: '  ',
      answer: 12,
    );
    expect(state().phase, SupportPhase.sent);
    expect(api.submits.single.message, 'A real message of some length.');
    expect(api.submits.single.contact, isNull);
    expect(api.submits.single.platform, isNotEmpty);
  });

  test(
    'Given a wrong answer, when sent then a new question comes with the reason',
    () async {
      final sub = container.listen(supportControllerProvider, (_, _) {});
      addTearDown(sub.close);
      await pump();
      final firstId = state().challengeId;
      await notifier().send(
        message: 'A real message of some length.',
        contact: '',
        answer: 11,
      );
      expect(state().phase, SupportPhase.ready);
      expect(state().failure, SupportFailure.wrongAnswer);
      expect(state().challengeId, isNot(firstId));
      expect(state().canSend, isTrue);
    },
  );

  test(
    'Given no connection, when sent then offline is reported and a retry is possible',
    () async {
      final sub = container.listen(supportControllerProvider, (_, _) {});
      addTearDown(sub.close);
      await pump();
      api.offline = true;
      await notifier().send(
        message: 'A real message of some length.',
        contact: '',
        answer: 12,
      );
      expect(state().failure, SupportFailure.offline);
      expect(state().phase, SupportPhase.ready);

      api.offline = false;
      await notifier().loadChallenge();
      expect(state().canSend, isTrue);
      await notifier().send(
        message: 'A real message of some length.',
        contact: '',
        answer: 12,
      );
      expect(state().phase, SupportPhase.sent);
    },
  );

  test(
    'Given the server is rate limiting, then sending is not possible',
    () async {
      api.challengesAvailable = false;
      final sub = container.listen(supportControllerProvider, (_, _) {});
      addTearDown(sub.close);
      await pump();
      expect(state().failure, SupportFailure.tooManyRequests);
      expect(state().canSend, isFalse);
    },
  );

  test(
    'Given the server says too many requests on submit, then no question remains',
    () async {
      api.onCorrect = SupportSubmitResult.tooManyRequests;
      final sub = container.listen(supportControllerProvider, (_, _) {});
      addTearDown(sub.close);
      await pump();
      await notifier().send(
        message: 'A real message of some length.',
        contact: '',
        answer: 12,
      );
      expect(state().failure, SupportFailure.tooManyRequests);
      expect(state().canSend, isFalse);
    },
  );

  group('local checks', () {
    test('message bounds', () {
      expect(checkMessage('short'), SupportInputProblem.tooShort);
      expect(checkMessage('x' * 2001), SupportInputProblem.tooLong);
      expect(checkMessage('  long enough text  '), isNull);
    });

    test('answer parsing', () {
      expect(parseAnswer(' 12 '), 12);
      expect(parseAnswer('-3'), -3);
      expect(parseAnswer('twelve'), isNull);
      expect(parseAnswer(''), isNull);
    });
  });
}

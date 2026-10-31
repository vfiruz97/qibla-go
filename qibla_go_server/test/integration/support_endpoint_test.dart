import 'package:qibla_go_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

int _solve(String question) {
  final parts = question.split(' ');
  final a = int.parse(parts[0]);
  final b = int.parse(parts[2]);
  return parts[1] == '+' ? a + b : a - b;
}

void main() {
  withServerpod('Given Support endpoint', (sessionBuilder, endpoints) {
    final session = sessionBuilder.build();

    test(
      'when a challenge is requested then it has a question and a future expiry',
      () async {
        final c = (await endpoints.support.challenge(sessionBuilder))!;
        expect(c.id, hasLength(24));
        expect(c.question, matches(RegExp(r'^\d+ [+−] \d+$')));
        expect(c.expiresAt.isAfter(DateTime.now().toUtc()), isTrue);
      },
    );

    test(
      'when the answer is right then the message is stored without extras',
      () async {
        final c = (await endpoints.support.challenge(sessionBuilder))!;
        final result = await endpoints.support.submit(
          sessionBuilder,
          challengeId: c.id,
          answer: _solve(c.question),
          message: '  The line looks off by a few degrees near my mosque.  ',
          contact: '  ',
          platform: 'android',
        );
        expect(result, SupportSubmitResult.accepted);

        final rows = await SupportMessage.db.find(session);
        expect(rows, hasLength(1));
        expect(
          rows.single.message,
          'The line looks off by a few degrees near my mosque.',
        );
        expect(rows.single.contact, isNull);
        expect(rows.single.platform, 'android');
        expect(rows.single.handledAt, isNull);
      },
    );

    test(
      'when the answer is wrong then nothing is stored and the challenge is spent',
      () async {
        final c = (await endpoints.support.challenge(sessionBuilder))!;
        final wrong = await endpoints.support.submit(
          sessionBuilder,
          challengeId: c.id,
          answer: _solve(c.question) + 1,
          message: 'A perfectly fine message body.',
        );
        expect(wrong, SupportSubmitResult.wrongAnswer);
        final retry = await endpoints.support.submit(
          sessionBuilder,
          challengeId: c.id,
          answer: _solve(c.question),
          message: 'A perfectly fine message body.',
        );
        expect(retry, SupportSubmitResult.challengeExpired);
        expect(await SupportMessage.db.find(session), isEmpty);
      },
    );

    test(
      'when the message is too short then it is rejected after consuming the challenge',
      () async {
        final c = (await endpoints.support.challenge(sessionBuilder))!;
        final result = await endpoints.support.submit(
          sessionBuilder,
          challengeId: c.id,
          answer: _solve(c.question),
          message: 'hi',
        );
        expect(result, SupportSubmitResult.messageInvalid);
        expect(await SupportMessage.db.find(session), isEmpty);
      },
    );
  });
}

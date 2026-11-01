import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_go_flutter/core/text/digits.dart';
import 'package:qibla_go_flutter/features/support/domain/support_form.dart';

void main() {
  test('Arabic-Indic, Persian and fullwidth digits become ASCII', () {
    expect(toAsciiDigits('٣٨٫٥٥٩٨'), '38.5598');
    expect(toAsciiDigits('۶۸٫۷۸۷۰'), '68.7870');
    expect(toAsciiDigits('−۱۲'), '-12');
    expect(toAsciiDigits('１２３．５'), '123.5');
    expect(toAsciiDigits('１２３－'), '123-');
  });

  test('ASCII and other text pass through unchanged', () {
    expect(toAsciiDigits('38.5598'), '38.5598');
    expect(toAsciiDigits('-90,5 abc ٬ x'), '-90,5 abc , x');
    expect(toAsciiDigits(''), '');
  });

  test('the support check accepts an answer typed on a Persian keyboard', () {
    expect(parseAnswer('۱۲'), 12);
    expect(parseAnswer(' ٤٢ '), 42);
    expect(parseAnswer('abc'), isNull);
  });
}

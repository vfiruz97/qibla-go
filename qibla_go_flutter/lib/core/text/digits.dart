/// Maps digits and number punctuation from other scripts to ASCII so that
/// `int.parse` and `double.parse` accept what a Persian, Arabic, Chinese or
/// Japanese keyboard types. Everything else passes through unchanged.
String toAsciiDigits(String input) {
  final out = StringBuffer();
  for (final rune in input.runes) {
    if (rune >= 0x0660 && rune <= 0x0669) {
      out.writeCharCode(0x30 + rune - 0x0660); // Arabic-Indic ٠..٩
    } else if (rune >= 0x06F0 && rune <= 0x06F9) {
      out.writeCharCode(0x30 + rune - 0x06F0); // Extended Arabic-Indic ۰..۹
    } else if (rune >= 0xFF10 && rune <= 0xFF19) {
      out.writeCharCode(0x30 + rune - 0xFF10); // Fullwidth ０..９
    } else {
      switch (rune) {
        case 0x066B: // Arabic decimal separator ٫
        case 0xFF0E: // Fullwidth full stop ．
          out.write('.');
        case 0x066C: // Arabic thousands separator ٬
          out.write(',');
        case 0x2212: // Minus sign −
        case 0xFF0D: // Fullwidth hyphen-minus －
          out.write('-');
        default:
          out.writeCharCode(rune);
      }
    }
  }
  return out.toString();
}

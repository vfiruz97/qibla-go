import 'package:flutter/material.dart';

import 'qibla_palette.dart';

/// Font families bundled in `assets/fonts`.
abstract final class AppFonts {
  /// Roman inscriptional capitals for the wordmark and the big numerals.
  static const display = 'Marcellus';

  /// Clean geometric sans for everything that must be read quickly.
  static const body = 'Manrope';
}

/// Builds the Material theme from a [QiblaPalette].
abstract final class AppTheme {
  static ThemeData light() => _build(QiblaPalette.day, Brightness.light);

  static ThemeData dark() => _build(QiblaPalette.night, Brightness.dark);

  static ThemeData _build(QiblaPalette p, Brightness brightness) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: p.gold,
      onPrimary: p.background,
      secondary: p.goldDim,
      onSecondary: p.ink,
      error: p.danger,
      onError: p.background,
      surface: p.surface,
      onSurface: p.ink,
      surfaceContainerHighest: p.surfaceRaised,
      onSurfaceVariant: p.inkMuted,
      outline: p.inkFaint,
    );

    final text = _textTheme(p);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.background,
      canvasColor: p.background,
      fontFamily: AppFonts.body,
      textTheme: text,
      extensions: [p],
      splashFactory: InkSparkle.splashFactory,
      dividerColor: p.inkFaint.withValues(alpha: 0.4),
      iconTheme: IconThemeData(color: p.inkMuted, size: 22),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: p.inkFaint,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.gold,
          foregroundColor: p.background,
          textStyle: text.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: const StadiumBorder(),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.ink,
          side: BorderSide(color: p.inkFaint),
          textStyle: text.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: const StadiumBorder(),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.gold,
          textStyle: text.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surfaceRaised,
        labelStyle: text.bodyMedium?.copyWith(color: p.inkMuted),
        hintStyle: text.bodyMedium?.copyWith(color: p.inkFaint),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: p.inkFaint),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: p.inkFaint.withValues(alpha: 0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: p.gold, width: 1.5),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: p.surfaceRaised,
        contentTextStyle: text.bodyMedium?.copyWith(color: p.ink),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static TextTheme _textTheme(QiblaPalette p) {
    TextStyle display(double size, {double? spacing, double? height}) =>
        TextStyle(
          fontFamily: AppFonts.display,
          fontSize: size,
          color: p.ink,
          letterSpacing: spacing,
          height: height ?? 1.05,
          fontFeatures: const [FontFeature.tabularFigures()],
        );
    TextStyle body(
      double size, {
      FontWeight weight = FontWeight.w500,
      double? spacing,
      Color? color,
      double? height,
    }) => TextStyle(
      fontFamily: AppFonts.body,
      fontSize: size,
      fontWeight: weight,
      color: color ?? p.ink,
      letterSpacing: spacing,
      height: height ?? 1.35,
    );

    return TextTheme(
      displayLarge: display(72, spacing: -1),
      displayMedium: display(52, spacing: -0.5),
      displaySmall: display(36),
      headlineMedium: display(28),
      headlineSmall: display(22, spacing: 0.5),
      titleLarge: body(20, weight: FontWeight.w600),
      titleMedium: body(16, weight: FontWeight.w600),
      titleSmall: body(14, weight: FontWeight.w600),
      bodyLarge: body(16, color: p.ink),
      bodyMedium: body(14, color: p.inkMuted),
      bodySmall: body(12, color: p.inkMuted),
      labelLarge: body(14, weight: FontWeight.w700, spacing: 0.3),
      labelMedium: body(
        12,
        weight: FontWeight.w700,
        spacing: 1.6,
        color: p.inkMuted,
      ),
      labelSmall: body(
        10.5,
        weight: FontWeight.w700,
        spacing: 1.8,
        color: p.inkFaint,
      ),
    );
  }
}

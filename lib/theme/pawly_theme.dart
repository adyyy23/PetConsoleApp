import 'pawly_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pawly_colors.dart';

class PawlyTheme {
  PawlyTheme._();
  static ThemeData get lightTheme => _build(Brightness.light);
  static ThemeData get darkTheme => _build(Brightness.dark);

  static ThemeData forPalette(PawlyPalette palette, Brightness brightness) =>
      _build(brightness, palette);

  static ThemeData _build(Brightness brightness,
      [PawlyPalette palette = PawlyPalette.monochrome]) {
    final dark = brightness == Brightness.dark;
    final canvas = dark ? const Color(0xFF121212) : PawlyColors.background;
    final surface = dark ? const Color(0xFF1E1E1E) : PawlyColors.surface;
    final ink = dark ? const Color(0xFFF5F5F5) : PawlyColors.charcoal;
    final accent = dark ? palette.darkAccent : palette.lightAccent;
    final border = dark ? const Color(0xFF414141) : PawlyColors.border;
    final scheme = (dark ? const ColorScheme.dark() : const ColorScheme.light())
        .copyWith(
            primary: accent,
            secondary: accent,
            tertiary: accent,
            onSecondary: dark ? canvas : Colors.white,
            onTertiary: dark ? canvas : Colors.white,
            secondaryContainer:
                dark ? palette.darkContainer : palette.lightContainer,
            tertiaryContainer:
                dark ? palette.darkContainer : palette.lightContainer,
            onSecondaryContainer: ink,
            onTertiaryContainer: ink,
            surfaceTint: Colors.transparent,
            surfaceContainerHighest:
                dark ? const Color(0xFF2B2B2B) : const Color(0xFFF2F2F2),
            onSurfaceVariant:
                dark ? const Color(0xFFCCCCCC) : const Color(0xFF626262),
            outline: border,
            outlineVariant: border,
            onPrimary: dark ? canvas : Colors.white,
            surface: surface,
            onSurface: ink,
            primaryContainer:
                dark ? palette.darkContainer : palette.lightContainer,
            onPrimaryContainer:
                dark ? const Color(0xFFF5F5F5) : const Color(0xFF171717),
            error: dark ? const Color(0xFFFF9B94) : PawlyColors.error);
    final base = ThemeData(
        useMaterial3: true, brightness: brightness, colorScheme: scheme);
    OutlineInputBorder inputBorder(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: color));
    return base.copyWith(
      scaffoldBackgroundColor: canvas,
      textTheme: base.textTheme.apply(bodyColor: ink, displayColor: ink),
      appBarTheme: AppBarTheme(
          backgroundColor: canvas,
          foregroundColor: ink,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          systemOverlayStyle:
              dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          titleTextStyle:
              TextStyle(color: ink, fontSize: 20, fontWeight: FontWeight.w700)),
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: surface,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
          showDragHandle: true),
      dialogTheme: DialogTheme(
          backgroundColor: surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
      inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: inputBorder(border),
          enabledBorder: inputBorder(border),
          focusedBorder: inputBorder(accent),
          errorBorder: inputBorder(scheme.error),
          focusedErrorBorder: inputBorder(scheme.error)),
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
      chipTheme: base.chipTheme.copyWith(
          side: BorderSide(color: border),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
      navigationBarTheme: NavigationBarThemeData(
          backgroundColor: surface,
          elevation: 0,
          indicatorColor: dark ? palette.darkContainer : palette.lightContainer,
          height: 72,
          labelTextStyle:
              WidgetStateProperty.all(TextStyle(color: ink, fontSize: 12))),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
      }),
    );
  }
}

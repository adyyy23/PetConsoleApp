import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pawly_colors.dart';
import 'pawly_typography.dart';
import 'app_tokens.dart';

class PawlyTheme {
  PawlyTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: PawlyColors.background,
      primaryColor: PawlyColors.black,
      colorScheme: const ColorScheme.light(
        primary: PawlyColors.black,
        onPrimary: Colors.white,
        secondary: PawlyColors.charcoal,
        onSecondary: Colors.white,
        surface: PawlyColors.surface,
        onSurface: PawlyColors.black,
        error: PawlyColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: false,
        titleTextStyle: PawlyTypography.titleLarge,
        iconTheme: IconThemeData(color: PawlyColors.black, size: 20),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: PawlyColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      cardTheme: CardTheme(
        color: PawlyColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppTokens.rMd,
          side: const BorderSide(color: PawlyColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PawlyColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: AppTokens.rSm,
          borderSide: const BorderSide(color: PawlyColors.border, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppTokens.rSm,
          borderSide: const BorderSide(color: PawlyColors.border, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppTokens.rSm,
          borderSide: const BorderSide(color: PawlyColors.black, width: 1.2),
        ),
        hintStyle: const TextStyle(fontSize: 14, color: PawlyColors.tertiary),
        labelStyle: const TextStyle(fontSize: 13, color: PawlyColors.secondary),
      ),
      dividerTheme: const DividerThemeData(
        color: PawlyColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}

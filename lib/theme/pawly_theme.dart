import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pawly_colors.dart';
import 'pawly_typography.dart';

class PawlyTheme {
  PawlyTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: PawlyColors.creamBg,
      primaryColor: PawlyColors.forest,
      colorScheme: const ColorScheme.light(
        primary: PawlyColors.forest,
        onPrimary: Colors.white,
        secondary: PawlyColors.clay,
        onSecondary: Colors.white,
        surface: PawlyColors.surface,
        onSurface: PawlyColors.espresso,
        error: PawlyColors.rose,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: false,
        titleTextStyle: PawlyTypography.titleLarge,
        iconTheme: IconThemeData(color: PawlyColors.espresso),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: PawlyColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      cardTheme: CardTheme(
        color: PawlyColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: PawlyColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: PawlyColors.borderLight,
        thickness: 1,
        space: 24,
      ),
    );
  }
}

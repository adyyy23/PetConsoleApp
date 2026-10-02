import 'package:flutter/material.dart';

class PawlyColors {
  PawlyColors._();

  // Backgrounds & Surfaces (Warm Cream Foundation)
  static const Color creamBg = Color(0xFFFAF7F2);
  static const Color background = creamBg;
  static const Color warmWhite = Color(0xFFFCFAF7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceWarm = Color(0xFFF5EFE6);
  static const Color surfaceMuted = Color(0xFFEBE4DA);

  // Typography
  static const Color espresso = Color(0xFF1E1A18);
  static const Color deepEspresso = espresso;
  static const Color textPrimary = espresso;
  static const Color charcoal = Color(0xFF2C2623);
  static const Color warmGrey = Color(0xFF6B635B);
  static const Color textSecondary = warmGrey;
  static const Color mutedGrey = Color(0xFF948C84);
  static const Color textMuted = mutedGrey;
  static const Color border = Color(0xFFE5DDD3);
  static const Color borderLight = Color(0xFFEFE9E1);

  // Brand Accents
  // Forest & Soft Sage
  static const Color forest = Color(0xFF2D5742);
  static const Color forestLight = Color(0xFFE9F2ED);
  static const Color forestBorder = Color(0xFFC6DEC0);
  static const Color softSage = Color(0xFFDCE8DF);
  static const Color sageLight = forestLight;
  static const Color sageBg = Color(0xFFEEF4F0);

  // Terracotta / Warm Clay
  static const Color clay = Color(0xFFC0593B);
  static const Color warmClay = clay;
  static const Color terracotta = clay;
  static const Color clayLight = Color(0xFFFBEFEB);
  static const Color terracottaLight = clayLight;
  static const Color clayBorder = Color(0xFFF4D4C7);
  static const Color terracottaBorder = clayBorder;

  // Butter Yellow & Honey / Amber
  static const Color butterYellow = Color(0xFFF6E7B4);
  static const Color butterBg = Color(0xFFFDF8E8);
  static const Color honey = Color(0xFFB57722);
  static const Color warmHoney = honey;
  static const Color honeyLight = Color(0xFFFDF5E9);
  static const Color honeyBorder = Color(0xFFF8E3C0);

  // Powder Blue & Slate
  static const Color powderBlue = Color(0xFFD9E6ED);
  static const Color powderBlueBg = Color(0xFFEFF6F9);
  static const Color slate = Color(0xFF486E85);
  static const Color slateLight = Color(0xFFEFF5F8);

  // Alert / Rose
  static const Color rose = Color(0xFFB83A3A);
  static const Color alertRose = rose;
  static const Color roseLight = Color(0xFFFDF0F0);

  // Carefully balanced translucent tones (NO excessive glassmorphism)
  static const Color frostedWhite = Color(0xD9FFFFFF); // ~85% opacity
  static const Color frostedWarmWhite = Color(0xE6FCFAF7); // ~90% opacity
  static const Color frostedEspresso = Color(0xB31E1A18); // ~70% opacity
  static const Color frostedBorder = Color(0x66FFFFFF); // 40% white border
  static const Color frostedBorderDark = Color(0x1F1E1A18); // subtle 12% espresso border
}

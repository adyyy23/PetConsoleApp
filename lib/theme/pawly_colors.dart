import 'package:flutter/material.dart';

class PawlyColors {
  PawlyColors._();

  // Foundation & Neutrals (Editorial Black & White with Warm Neutrals)
  static const Color black = Color(0xFF111111);
  static const Color pureBlack = Color(0xFF000000);
  static const Color charcoal = Color(0xFF222222);
  static const Color darkGrey = Color(0xFF383838);
  static const Color midGrey = Color(0xFF6E6E6E);
  static const Color warmGrey = Color(0xFF76726D);
  static const Color lightGrey = Color(0xFFE8E5DF);
  static const Color softGrey = Color(0xFFF3F1EC);
  static const Color offWhite = Color(0xFFFAF9F6);
  static const Color warmWhite = Color(0xFFF6F5F1);
  static const Color white = Color(0xFFFFFFFF);

  // Backgrounds & Surfaces
  static const Color background = offWhite;
  static const Color creamBg = offWhite;
  static const Color surface = white;
  static const Color surfaceWarm = softGrey;
  static const Color surfaceMuted = lightGrey;

  // Typography
  static const Color textPrimary = black;
  static const Color textSecondary = midGrey;
  static const Color textMuted = Color(0xFF98948E);
  static const Color espresso = black;
  static const Color deepEspresso = black;
  static const Color mutedGrey = textMuted;

  // Borders & Dividers (Very subtle neutral borders)
  static const Color border = Color(0xFFE6E3DC);
  static const Color borderLight = Color(0xFFEFECE5);
  static const Color borderDark = Color(0xFF2E2E2E);

  // Primary Action Accent (Strictly Editorial Black / Charcoal - NO GREEN)
  static const Color primary = black;
  static const Color primarySubtle = softGrey;
  static const Color secondary = charcoal;

  // Subtle Status Tones (Restrained, low-saturation)
  static const Color alert = Color(0xFFB33927);
  static const Color alertLight = Color(0xFFFAF0EE);
  static const Color tagBg = softGrey;
  static const Color tagText = charcoal;

  // Backwards compatibility aliases mapped strictly to neutral palette (Zero green)
  static const Color forest = black;
  static const Color forestLight = softGrey;
  static const Color forestBorder = border;
  static const Color softSage = lightGrey;
  static const Color sageLight = softGrey;
  static const Color sageBg = offWhite;

  static const Color clay = charcoal;
  static const Color warmClay = charcoal;
  static const Color terracotta = charcoal;
  static const Color clayLight = softGrey;
  static const Color terracottaLight = softGrey;
  static const Color clayBorder = border;
  static const Color terracottaBorder = border;

  static const Color butterYellow = softGrey;
  static const Color butterBg = offWhite;
  static const Color honey = charcoal;
  static const Color warmHoney = charcoal;
  static const Color honeyLight = softGrey;
  static const Color honeyBorder = border;

  static const Color powderBlue = lightGrey;
  static const Color powderBlueBg = offWhite;
  static const Color slate = charcoal;
  static const Color slateLight = softGrey;

  static const Color rose = alert;
  static const Color alertRose = alert;
  static const Color roseLight = alertLight;

  // Scrim & Controlled Overlays
  static const Color frostedWhite = Color(0xF2FFFFFF);
  static const Color frostedWarmWhite = Color(0xF2FAF9F6);
  static const Color frostedEspresso = Color(0xD9000000);
  static const Color frostedBorder = Color(0x33FFFFFF);
  static const Color frostedBorderDark = Color(0x22000000);
}

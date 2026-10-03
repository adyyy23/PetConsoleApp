import 'package:flutter/material.dart';

class PawlyColors {
  PawlyColors._();

  /// Semantic surfaces adapt to the current theme. Photo overlays stay fixed.
  static Color resolve(BuildContext context, Color light) {
    if (light == primary) return Theme.of(context).colorScheme.primary;
    if (Theme.of(context).brightness != Brightness.dark) return light;

    if (light == black) return const Color(0xFFE5E5E5);
    if (light == charcoal) return const Color(0xFFF5F5F5);
    if (light == secondary) return const Color(0xFFCCCCCC);
    if (light == tertiary) return const Color(0xFFA6A6A6);
    if (light == background) return const Color(0xFF121212);
    if (light == surface) return const Color(0xFF1E1E1E);
    if (light == surfaceWarm) return const Color(0xFF2B2B2B);
    if (light == border) return const Color(0xFF414141);
    if (light == borderDark) return const Color(0xFF666666);
    if (light == alertLight) return const Color(0xFF462525);
    if (light == error) return const Color(0xFFFF9B94);
    return light;
  }

  // ── Core palette ────────────────────────────────────────────────────────────
  static const Color black = Color(0xFF171717);
  static const Color charcoal = Color(0xFF262626);
  static const Color secondary = Color(0xFF626262);
  static const Color tertiary = Color(0xFF757575);
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceWarm = Color(0xFFF2F2F2);
  static const Color border = Color(0xFFE2E2E2);
  static const Color borderDark = Color(0xFFD0D0D0);

  // Overlays (for surfaces over photography — NEVER for text)
  static const Color overlayDark = Color(0xB3111111); // 70% black
  static const Color overlayLight = Color(0xDEFFFFFF); // 87% white

  // Semantic
  static const Color neutralAccent = Color(0xFFE5E5E5);
  static const Color ink = black;
  static const Color primary = Color(0xFF171717);
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF333333);

  // Alert / safety (used by emergency screens)
  static const Color alert = Color(0xFFD32F2F);
  static const Color alertLight = Color(0xFFFDE8E8);

  // ── Backward-compat aliases ─────────────────────────────────────────────────
  // Old screens referenced these names; map them to the new palette.
  static const Color pureBlack = black;
  static const Color darkGrey = charcoal;
  static const Color midGrey = secondary;
  static const Color warmGrey = secondary;
  static const Color lightGrey = border;
  static const Color softGrey = surfaceWarm;
  static const Color offWhite = background;
  static const Color warmWhite = surfaceWarm;
  static const Color white = surface;
  static const Color creamBg = background;
  static const Color surfaceMuted = border;
  static const Color borderLight = border;
  static const Color textPrimary = black;
  static const Color textSecondary = secondary;
  static const Color textMuted = tertiary;
  static const Color espresso = black;
  static const Color deepEspresso = black;
  static const Color mutedGrey = tertiary;

  // alertRose → map to error/alert for lost-pet screens
  static const Color alertRose = alert;
  // warmHoney → a neutral accent (emergency)
  static const Color warmHoney = Color(0xFF626262);
}

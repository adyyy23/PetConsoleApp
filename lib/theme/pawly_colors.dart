import 'package:flutter/material.dart';

class PawlyColors {
  PawlyColors._();

  // ── Core palette ────────────────────────────────────────────────────────────
  static const Color black      = Color(0xFF111111);
  static const Color charcoal   = Color(0xFF2C2A27);
  static const Color secondary  = Color(0xFF6F6A63);
  static const Color tertiary   = Color(0xFF9C9690);
  static const Color background = Color(0xFFF7F4EF);
  static const Color surface    = Color(0xFFFFFFFF);
  static const Color surfaceWarm= Color(0xFFF0EDE8);
  static const Color border     = Color(0xFFEAE6DF);
  static const Color borderDark = Color(0xFFD5D0C8);

  // Overlays (for surfaces over photography — NEVER for text)
  static const Color overlayDark  = Color(0xB3111111); // 70% black
  static const Color overlayLight = Color(0xDEFFFFFF); // 87% white

  // Semantic
  static const Color primary = black;
  static const Color error   = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);

  // Alert / safety (used by emergency screens)
  static const Color alert      = Color(0xFFD32F2F);
  static const Color alertLight = Color(0xFFFDE8E8);

  // ── Backward-compat aliases ─────────────────────────────────────────────────
  // Old screens referenced these names; map them to the new palette.
  static const Color pureBlack     = black;
  static const Color darkGrey      = charcoal;
  static const Color midGrey       = secondary;
  static const Color warmGrey      = secondary;
  static const Color lightGrey     = border;
  static const Color softGrey      = surfaceWarm;
  static const Color offWhite      = background;
  static const Color warmWhite     = surfaceWarm;
  static const Color white         = surface;
  static const Color creamBg       = background;
  static const Color surfaceMuted  = border;
  static const Color borderLight   = border;
  static const Color textPrimary   = black;
  static const Color textSecondary = secondary;
  static const Color textMuted     = tertiary;
  static const Color espresso      = black;
  static const Color deepEspresso  = black;
  static const Color mutedGrey     = tertiary;

  // alertRose → map to error/alert for lost-pet screens
  static const Color alertRose     = alert;
  // warmHoney → a warm neutral accent (emergency)
  static const Color warmHoney     = Color(0xFFB07D3E);
}

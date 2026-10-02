import 'package:flutter/material.dart';

class PawlyTypography {
  PawlyTypography._();

  // ── Display ─────────────────────────────────────────────────────────────────
  static const TextStyle display = TextStyle(
    fontSize: 36, fontWeight: FontWeight.w800,
    height: 1.1, letterSpacing: -1.0, color: Color(0xFF111111),
  );
  static const TextStyle displayMedium = TextStyle(
    fontSize: 30, fontWeight: FontWeight.w700,
    height: 1.15, letterSpacing: -0.5, color: Color(0xFF111111),
  );

  // ── Page title (28px) ───────────────────────────────────────────────────────
  static const TextStyle pageTitle = TextStyle(
    fontSize: 28, fontWeight: FontWeight.w700,
    height: 1.2, letterSpacing: -0.3, color: Color(0xFF111111),
  );

  // ── Section heading (20px) ──────────────────────────────────────────────────
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20, fontWeight: FontWeight.w700,
    height: 1.25, color: Color(0xFF111111),
  );

  // ── Card title (16px) ───────────────────────────────────────────────────────
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600,
    height: 1.3, color: Color(0xFF111111),
  );

  // ── Body ─────────────────────────────────────────────────────────────────────
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w400,
    height: 1.5, color: Color(0xFF2C2A27),
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400,
    height: 1.5, color: Color(0xFF6F6A63),
  );

  // ── Secondary / caption ──────────────────────────────────────────────────────
  static const TextStyle secondary = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w400,
    height: 1.4, color: Color(0xFF6F6A63),
  );
  static const TextStyle caption = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w500,
    height: 1.4, color: Color(0xFF9C9690),
  );
  static const TextStyle eyebrow = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w600,
    letterSpacing: 0.8, color: Color(0xFF9C9690),
  );

  // ── Titles ────────────────────────────────────────────────────────────────────
  static const TextStyle titleLarge = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w600,
    height: 1.3, color: Color(0xFF111111),
  );
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600,
    height: 1.3, color: Color(0xFF111111),
  );
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600,
    height: 1.3, color: Color(0xFF111111),
  );

  // ── Backward-compat aliases ───────────────────────────────────────────────────
  /// Was used by auth/care/add screens as PawlyTypography.labelLarge
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600,
    height: 1.3, color: Color(0xFF111111),
  );
  /// Was used by emergency screens
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w600,
    height: 1.3, color: Color(0xFF6F6A63),
  );
  /// Was used by some screens as headlineSmall
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 22, fontWeight: FontWeight.w700,
    height: 1.2, letterSpacing: -0.2, color: Color(0xFF111111),
  );
  /// Was used by some screens as headlineLarge
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 30, fontWeight: FontWeight.w700,
    height: 1.15, letterSpacing: -0.5, color: Color(0xFF111111),
  );
}

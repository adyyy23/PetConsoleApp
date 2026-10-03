import 'package:flutter/material.dart';
import 'pawly_colors.dart';

class PawlyTypography {
  PawlyTypography._();

  static TextStyle resolve(
          BuildContext context, TextStyle style) =>
      style.copyWith(
          color: style.color == null
              ? null
              : PawlyColors.resolve(context, style.color!));

  // ── Display ─────────────────────────────────────────────────────────────────
  static const TextStyle display = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    height: 1.1,
    letterSpacing: -1.0,
    color: PawlyColors.charcoal,
  );
  static const TextStyle displayMedium = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -0.5,
    color: PawlyColors.charcoal,
  );

  // ── Page title (28px) ───────────────────────────────────────────────────────
  static const TextStyle pageTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.3,
    color: PawlyColors.charcoal,
  );

  // ── Section heading (20px) ──────────────────────────────────────────────────
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: PawlyColors.charcoal,
  );

  // ── Card title (16px) ───────────────────────────────────────────────────────
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: PawlyColors.charcoal,
  );

  // ── Body ─────────────────────────────────────────────────────────────────────
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: PawlyColors.charcoal,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: PawlyColors.secondary,
  );

  // ── Secondary / caption ──────────────────────────────────────────────────────
  static const TextStyle secondary = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: PawlyColors.secondary,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: PawlyColors.tertiary,
  );
  static const TextStyle eyebrow = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    color: PawlyColors.tertiary,
  );

  // ── Titles ────────────────────────────────────────────────────────────────────
  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: PawlyColors.charcoal,
  );
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: PawlyColors.charcoal,
  );
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: PawlyColors.charcoal,
  );

  // ── Backward-compat aliases ───────────────────────────────────────────────────
  /// Was used by auth/care/add screens as PawlyTypography.labelLarge
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: PawlyColors.charcoal,
  );

  /// Was used by emergency screens
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: PawlyColors.secondary,
  );

  /// Was used by some screens as headlineSmall
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.2,
    color: PawlyColors.charcoal,
  );

  /// Was used by some screens as headlineLarge
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -0.5,
    color: PawlyColors.charcoal,
  );
}

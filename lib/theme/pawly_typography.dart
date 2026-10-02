import 'package:flutter/material.dart';
import 'pawly_colors.dart';

class PawlyTypography {
  PawlyTypography._();

  // Display / Hero (e.g. Pet Name Hero, Major editorial banners)
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
    color: PawlyColors.black,
    height: 1.15,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    color: PawlyColors.black,
    height: 1.2,
  );

  static const TextStyle headlineLarge = displayLarge;
  static const TextStyle headlineMedium = displayMedium;
  static const TextStyle headlineSmall = titleLarge;

  // Page Title (e.g. Care Agenda, Mochi's Growth, Universal Search)
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: PawlyColors.black,
  );

  // Section Heading (e.g. Today's Care, Daily Observations, Vitals)
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: PawlyColors.black,
  );

  // Card Heading / Subheading
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.1,
    color: PawlyColors.black,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: PawlyColors.charcoal,
    height: 1.45,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: PawlyColors.warmGrey,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: PawlyColors.warmGrey,
    height: 1.35,
  );

  // Metadata / Caption / Label
  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: PawlyColors.textMuted,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: PawlyColors.black,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    color: PawlyColors.textMuted,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    color: PawlyColors.textMuted,
  );

  static const TextStyle eyebrow = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    color: PawlyColors.textSecondary,
  );
}

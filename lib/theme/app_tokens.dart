import 'package:flutter/material.dart';

/// Centralized border radius design tokens (strictly 4px – 12px for regular UI).
class AppRadius {
  AppRadius._();

  /// 4px: micro indicators, tiny badges
  static const double xs = 4.0;

  /// 6px: small buttons, input fields, control chips
  static const double sm = 6.0;

  /// 8px: standard cards, list containers, tiles
  static const double md = 8.0;

  /// 10px: large photo cards, featured hero containers
  static const double lg = 10.0;

  /// 12px: bottom sheets, modal dialogs (maximum allowable)
  static const double xl = 12.0;

  /// 999px: pill shape (reserved strictly for small filter chips and status tags)
  static const double pill = 999.0;

  static BorderRadius get rXs => BorderRadius.circular(xs);
  static BorderRadius get rSm => BorderRadius.circular(sm);
  static BorderRadius get rMd => BorderRadius.circular(md);
  static BorderRadius get rLg => BorderRadius.circular(lg);
  static BorderRadius get rXl => BorderRadius.circular(xl);
  static BorderRadius get rPill => BorderRadius.circular(pill);
}

/// Standardized spacing grid tokens.
class AppSpacing {
  AppSpacing._();

  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s12 = 12.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;
  static const double s32 = 32.0;
  static const double s40 = 40.0;
  static const double s48 = 48.0;
}

import 'package:flutter/material.dart';

class AppTokens {
  static const double r6 = 6.0;
  static const double r10 = 10.0;
  static const double r14 = 14.0;
  static const double r18 = 18.0; // DEFAULT card
  static const double r24 = 24.0; // large photo
  static const double pill = 999.0;

  // Short const alias numbers (usable in const expressions)
  static const double xs = 6.0;
  static const double sm = 10.0;
  static const double md = 14.0;
  static const double lg = 18.0;
  static const double xl = 24.0;

  // Named BorderRadius shortcuts
  static BorderRadius rXs = BorderRadius.circular(6);
  static BorderRadius rSm = BorderRadius.circular(10);
  static BorderRadius rMd = BorderRadius.circular(14);
  static BorderRadius rLg = BorderRadius.circular(18);
  static BorderRadius rXl = BorderRadius.circular(24);
  static BorderRadius rPill = BorderRadius.circular(999);
}

/// Backward-compatible alias — older screens reference AppRadius.*
class AppRadius {
  static const double xs = 6.0;
  static const double sm = 10.0;
  static const double md = 14.0;
  static const double lg = 18.0;
  static const double xl = 24.0;
  static const double pill = 999.0;

  static BorderRadius rXs = BorderRadius.circular(6);
  static BorderRadius rSm = BorderRadius.circular(10);
  static BorderRadius rMd = BorderRadius.circular(14);
  static BorderRadius rLg = BorderRadius.circular(18);
  static BorderRadius rXl = BorderRadius.circular(24);
  static BorderRadius rPill = BorderRadius.circular(999);
}

import 'package:flutter/material.dart';

/// User-selectable accents. Monochrome is the default; appearance is independent.
enum PawlyPalette {
  monochrome('Black & white', Color(0xFF171717), Color(0xFFE5E5E5),
      Color(0xFFEEEEEE), Color(0xFF333333)),
  lavender('Lavender', Color(0xFF6651A3), Color(0xFFD1BFF5), Color(0xFFECE5F8),
      Color(0xFF3A304D)),
  ocean('Ocean blue', Color(0xFF285D8C), Color(0xFFA8CFF4), Color(0xFFE6F0FA),
      Color(0xFF263B4D)),
  rose('Rose', Color(0xFF994A66), Color(0xFFF2B9CE), Color(0xFFF8E8EE),
      Color(0xFF4B2C39));

  const PawlyPalette(this.label, this.lightAccent, this.darkAccent,
      this.lightContainer, this.darkContainer);
  final String label;
  final Color lightAccent;
  final Color darkAccent;
  final Color lightContainer;
  final Color darkContainer;
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SaasTheme {
  // Brand Colors
  static const Color primary = Color(0xFF006AFF); // Electric Blue
  static const Color background = Color(0xFFF8F9FB); // Soft Studio Gray
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textBody = Color(0xFF1E293B); // Slate 800
  static const Color textMuted = Color(0xFF64748B); // Slate 500
  static const Color border = Color(0xFFE2E8F0); // Slate 200

  // Layout Constants
  static const double bentoRadius = 16.0;
  static const double sidebarWidth = 240.0;
  static const double topBarHeight = 56.0;

  // Elevation
  static List<BoxShadow> get subtleShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.03),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.02),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  static TextTheme get textTheme => TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: 42,
      fontWeight: FontWeight.w800,
      height: 1.1,
      letterSpacing: -1.0,
      color: textBody,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.2,
      color: textBody,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: textBody,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.6,
      color: textBody,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: textMuted,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.0,
      color: primary,
    ),
  );

  static ThemeData get theme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: background,
    primaryColor: primary,
    textTheme: textTheme,
    dividerTheme: const DividerThemeData(color: border, thickness: 1),
  );
}

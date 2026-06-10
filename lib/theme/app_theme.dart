import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ── Paleta ──────────────────────────────────────────────────────────
  static const Color pink = Color(0xFFFFAECF);
  static const Color softPink = Color(0xFFFFD6E8);
  static const Color palePink = Color(0xFFFFF0F6);
  static const Color lightBlue = Color(0xFFAEDFF7);
  static const Color paleBlue = Color(0xFFEAF5FF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkBrown = Color(0xFF3D2B1F);
  static const Color mediumBrown = Color(0xFF7A5C4F);
  static const Color lightBrown = Color(0xFFB89890);
  static const Color darkBg = Color(0xFF1A1A2E);

  static const Color whatsappGreen = Color(0xFF25D366);

  // ── TextTheme con Bree Serif ─────────────────────────────────────────
  static TextTheme get _textTheme {
    return GoogleFonts.breeSerifTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.w400, // Bree Serif es inherentemente bold
          color: darkBrown,
          height: 1.05,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w400,
          color: darkBrown,
          height: 1.1,
        ),
        headlineLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: darkBrown,
          height: 1.2,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: darkBrown,
          height: 1.3,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: darkBrown,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          color: mediumBrown,
          height: 1.7,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: mediumBrown,
          height: 1.6,
        ),
        bodySmall: TextStyle(
          fontSize: 13,
          color: lightBrown,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: darkBrown,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: white,
      colorScheme: const ColorScheme.light(
        primary: pink,
        secondary: lightBlue,
        surface: white,
        onPrimary: darkBrown,
        onSecondary: darkBrown,
        onSurface: darkBrown,
      ),
      textTheme: _textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: pink,
          foregroundColor: darkBrown,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.breeSerif(
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: lightBlue, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: lightBlue, width: 2),
        ),
        hintStyle: const TextStyle(color: lightBrown),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    );
  }
}

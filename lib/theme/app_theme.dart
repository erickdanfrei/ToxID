import 'package:flutter/material.dart';

/// Tema visual oficial do ToxID.
/// Atende ao RNF04: Dark Mode de alto contraste (verde-musgo e preto profundo)
/// projetado para máxima legibilidade mesmo sob luz solar intensa no campo.
class AppTheme {
  // Paleta de Cores
  static const Color darkBackground = Color(0xFF0B1900);
  static const Color surfaceColor = Color(0xFF243323);
  static const Color surfaceHighlight = Color(0xFF1E2E23);
  static const Color cardColor = Color(0xFF405630);

  static const Color primaryGreen = Color(0xFFA5C583);
  static const Color lightGreen = Color(0xFF48C774);
  static const Color mutedGreen = Color(0xFF274230);
  static const Color callGreen = Color(0xFF506C36);

  static const Color emergencyRed = Color(0xFF791F0A);
  static const Color alertRed = Color(0xFFFF5252);
  static const Color warningOrange = Color(0xFFE67E22);
  static const Color cautionYellow = Color(0xFFF1C40F);

  static const Color textLight = Color(0xFFF1F5F2);
  static const Color textMuted = Color(0xFFA3B8A8);
  static const Color borderColor = Color(0xFF283D2D);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: primaryGreen,
      colorScheme: const ColorScheme.dark(
        primary: primaryGreen,
        secondary: lightGreen,
        surface: surfaceColor,
        background: darkBackground,
        error: emergencyRed,
        onPrimary: Colors.white,
        onSurface: textLight,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textLight,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: primaryGreen),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderColor, width: 1),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkBackground,
        selectedItemColor: primaryGreen,
        unselectedItemColor: textMuted,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        hintStyle: const TextStyle(color: textMuted),
        labelStyle: const TextStyle(color: textLight),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
      ),
    );
  }
}

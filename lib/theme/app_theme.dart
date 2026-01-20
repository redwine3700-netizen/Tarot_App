import 'package:flutter/material.dart';

class AppTheme {
  // Paleta femenina pastel (oscuro + rosé/lavanda)
  static const Color bg = Color(0xFF0E0A1A);        // fondo general
  static const Color surface = Color(0xFF1A1230);   // cards
  static const Color surface2 = Color(0xFF241A3E);  // cards más claras
  static const Color rose = Color(0xFFFFB3D9);      // acento principal (pastel)
  static const Color lavender = Color(0xFFCBB6FF);  // acento secundario (pastel)
  static const Color outline = Color(0x66FFD1EA);   // borde suave (con alpha)
  static const Color text = Color(0xFFF5F2FF);      // texto principal

  static ThemeData dark() {
    final scheme = const ColorScheme.dark(
      primary: rose,
      secondary: lavender,
      background: bg,
      surface: surface,
      outline: outline,
      onPrimary: Color(0xFF1A1230),
      onSecondary: Color(0xFF1A1230),
      onBackground: text,
      onSurface: text,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,

      // Tipografías base
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: text, fontSize: 14),
        titleLarge: TextStyle(color: text, fontWeight: FontWeight.w700),
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: text,
        elevation: 0,
      ),

      // Cards
      cardTheme: CardThemeData(
        color: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),

      // Botones (coherentes)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: rose.withOpacity(0.18),
          foregroundColor: text,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          side: BorderSide(color: rose.withOpacity(0.35)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lavender,
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface2.withOpacity(0.35),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: outline.withOpacity(0.6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: outline.withOpacity(0.45)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: rose.withOpacity(0.7), width: 1.4),
        ),
      ),
    );
  }
}

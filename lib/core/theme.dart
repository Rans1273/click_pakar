// lib/core/theme.dart
import 'package:flutter/material.dart';

class AppThemes {
  // Aksen utama: hijau lime
  static const _limeSeed = Colors.lime;

  /// Tema Terang: putih krem, aksen lime
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _limeSeed,
      brightness: Brightness.light,
    ),
    // Gantikan 'background' yang deprecated dengan scaffoldBackgroundColor
    scaffoldBackgroundColor: const Color(0xFFFFF9F0), // putih agak krem
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    // Gunakan CardThemeData (bukan CardTheme)
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
    ),
  );

  /// Tema Gelap: hitam doff, aksen lime
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _limeSeed,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121416), // hitam doff
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: const Color(0xFF1A1D20),
      surfaceTintColor: const Color(0xFF1A1D20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
    ),
  );
}

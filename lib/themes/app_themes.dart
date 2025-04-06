import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Colors.white,
      secondary: Color(0xFF0A192F),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: GoogleFonts.audiowide(
        color: Color(0xFF0A192F),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xFF0A192F),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF0A192F),
      secondary: Color(0xFF64FFDA),
      surface: Color(0xFF172A45),
    ),
    scaffoldBackgroundColor: const Color(0xFF0A192F),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF0A192F),
      titleTextStyle: GoogleFonts.audiowide(
        color: Color(0xFF64FFDA),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF172A45),
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

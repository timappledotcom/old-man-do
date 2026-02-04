import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color slate = Color(0xFF2F4F4F); // Dark Slate Gray
  static const Color olive = Color(0xFF556B2F); // Dark Olive Green
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightSlate = Color(0xFF708090);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: olive,
      scaffoldBackgroundColor: Colors.grey[200],
      colorScheme: ColorScheme.light(
        primary: olive,
        secondary: slate,
        surface: white,
      ),
      textTheme: GoogleFonts.robotoTextTheme().copyWith(
        displayLarge: GoogleFonts.oswald(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: black,
        ),
        displayMedium: GoogleFonts.oswald(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: black,
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 18,
          color: black,
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: slate,
        titleTextStyle: GoogleFonts.blackOpsOne(
          fontSize: 24,
          color: white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: olive,
          foregroundColor: white,
          textStyle: GoogleFonts.oswald(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4), // Military boxy look
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: olive,
      scaffoldBackgroundColor: Color(0xFF121212),
      colorScheme: ColorScheme.dark(
        primary: olive,
        secondary: slate,
        surface: Color(0xFF1E1E1E),
      ),
      textTheme: GoogleFonts.robotoTextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
         titleTextStyle: GoogleFonts.blackOpsOne(
          fontSize: 24,
          color: olive,
        ),
      ),
       elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: olive,
          foregroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

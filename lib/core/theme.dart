import 'package:flutter/material.dart';

abstract final class Brand {
  static const yellow = Color(0xFFFEB500);
  static const muted = Color(0xFFABABAB);
  static const panel = Color(0xFF161616);
  static const radius = BorderRadius.all(Radius.circular(10));
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    fontFamily: 'Poppins',
    colorScheme: const ColorScheme.dark(
      primary: yellow,
      onPrimary: Colors.black,
      surface: Colors.black,
      onSurface: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 14, height: 1.5),
      bodySmall: TextStyle(fontSize: 12, height: 1.5),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: yellow,
        foregroundColor: Colors.black,
        minimumSize: const Size(0, 56),
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: yellow,
        textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: yellow,
      contentTextStyle: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
      behavior: SnackBarBehavior.floating,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF444444)),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF444444)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: yellow),
      ),
      labelStyle: TextStyle(color: yellow, fontSize: 14),
      hintStyle: TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
      errorMaxLines: 2,
    ),
  );
}

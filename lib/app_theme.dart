import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    primaryColor: const Color(0xFFFFFFF),
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2E2E2E),
      ),
      bodyMedium: TextStyle(
        fontSize: 12,
        height: 1.6,
        color: Color(0xFF4A4A4A),
      ),
    ),
  );
}

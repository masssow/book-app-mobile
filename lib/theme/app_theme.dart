// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {

  
static const Color background = Color.fromRGBO(13, 31, 28, 1);
  static const Color gold = Color(0xFFE6C66A);
  static const Color darkGold = Color.fromRGBO(185, 151, 91, 1);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color accentGreen = Colors.green;
  static const Color accentGreenLight = Colors.greenAccent;


  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(seedColor: gold, primary: gold),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: darkGold,
        elevation: 0,
        iconTheme: IconThemeData(color: darkGold),
        titleTextStyle: TextStyle(
          color: darkGold,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
        bodyMedium: TextStyle(color: Colors.white70),
        titleLarge: TextStyle(
          color: darkGold,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

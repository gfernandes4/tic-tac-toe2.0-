import 'package:flutter/material.dart';

class AppTheme {
  static const Color xColor = Colors.blue;
  static const Color oColor = Colors.red;
  static const Color neutralColor = Colors.grey;
  static const Color forcedBorderColor = Colors.yellow;

  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.grey,
        primary: Colors.grey[900]!,
        onPrimary: Colors.grey[200]!,
        surface: Colors.blue[400]!,
        onSurface: Colors.black87,
        brightness: Brightness.light,
      ),
      cardColor: Colors.grey[50],
      scaffoldBackgroundColor: Colors.grey[50],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue[400]!, // Cor fixa para o AppBar
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.grey[200],
          foregroundColor: Colors.black54,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.grey,
        primary: Colors.grey[50]!,
        onPrimary: Colors.grey[900]!,
        surface: Colors.blue[800]!,
        onSurface: Colors.white,
        brightness: Brightness.dark,
      ),
      cardColor: Colors.grey[800],
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue[800], // Cor fixa para o AppBar
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.grey[800],
          foregroundColor: Colors.white,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static const BoxDecoration cellDecoration = BoxDecoration(
    border: Border.fromBorderSide(BorderSide(color: Colors.grey)),
    borderRadius: BorderRadius.all(Radius.circular(8)),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 2,
        offset: Offset(1, 1),
      ),
    ],
  );

  static const BoxDecoration boardCellDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 4,
        offset: Offset(2, 2),
      ),
    ],
  );

  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration pulseDuration = Duration(milliseconds: 500);
}
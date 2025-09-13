import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.pink,
  scaffoldBackgroundColor: Colors.pink.shade50,

  // Apply Poppins globally
  fontFamily: 'Poppins',

  // AppBar Theme
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.pink.shade300,
    foregroundColor: Colors.white,
    titleTextStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  ),

  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    labelStyle: TextStyle(
      color: Colors.pink.shade400,
      fontFamily: 'Poppins',
    ),
    hintStyle: TextStyle(
      color: Colors.pink.shade200,
      fontFamily: 'Poppins',
    ),
  ),

  // Elevated Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      backgroundColor: Colors.pink.shade400,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
      shadowColor: Colors.pink.shade200,
      elevation: 5,
    ),
  ),

  // SnackBar Theme
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.pink.shade400,
    contentTextStyle: const TextStyle(
      color: Colors.white,
      fontFamily: 'Poppins',
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    behavior: SnackBarBehavior.floating,
  ),

  // Dialog Theme
  dialogTheme: DialogThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    backgroundColor: Colors.white,
    titleTextStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.pink,
      fontFamily: 'Poppins',
    ),
    contentTextStyle: const TextStyle(
      fontSize: 16,
      fontFamily: 'Poppins',
    ),
  ),

  // Text Theme (applies globally to all Text widgets)
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontFamily: 'Poppins'),
    headlineMedium: TextStyle(fontFamily: 'Poppins'),
    headlineSmall: TextStyle(fontFamily: 'Poppins'),
    
    bodyLarge: TextStyle(fontFamily: 'Poppins'),
    bodyMedium: TextStyle(fontFamily: 'Poppins'),
    bodySmall: TextStyle(fontFamily: 'Poppins'),

    titleLarge: TextStyle(fontFamily: 'Poppins'),
    titleMedium: TextStyle(fontFamily: 'Poppins'),
    titleSmall: TextStyle(fontFamily: 'Poppins'),
  ),
);

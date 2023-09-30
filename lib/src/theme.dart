import 'package:flutter/material.dart';

class TAppTheme {
  static const Color primaryColor = Color(0xFF1287c3);
  static const Color accentColor = Color(0xFFFFC107);
  static const Color errorColor = Color(0xFFCC0000);

  ///Light theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(
      secondary: accentColor,
    ),
    appBarTheme: const AppBarTheme(
      color: Color(0xff184a45),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0)),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0))),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.orange))),
  );

  ///Dark theme

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      color: Color(0xff184a45),
    ),
    scaffoldBackgroundColor: Colors.black,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none),
      filled: true,
      fillColor: Colors.grey.withOpacity(0.1),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0)),
        shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        overlayColor: MaterialStateProperty.all<Color>(Colors.black26),
      ),
    ),
  );
}

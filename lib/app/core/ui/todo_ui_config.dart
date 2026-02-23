import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TodoUiConfig {
  static final Color _primaryColor = Color(0xff5C77CE);
  static final Color _primaryColorLight = Color(0xffABC8F7);
  TodoUiConfig._();

  static ThemeData get theme => ThemeData(
    textTheme: GoogleFonts.mandaliTextTheme(),
    primaryColor: _primaryColor,
    primaryColorLight: _primaryColorLight,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        textStyle: TextStyle(fontWeight: FontWeight.w500),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primaryColor,
        textStyle: TextStyle(fontWeight: FontWeight.w500),
      ),
    ),
  );

  static Color get getPrimaryColor => _primaryColor;
  static Color get getPrimaryLightColor => _primaryColorLight;
}

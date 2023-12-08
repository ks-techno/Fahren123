import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData light({Color color = const Color(0xFF00CCFE)}) => ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: color,
      primaryColorLight: Colors.black,
      primaryColorDark: Colors.white,
      secondaryHeaderColor: const Color(0xFF00CCFE),
      disabledColor: const Color(0x20000000),
      backgroundColor: const Color(0x09000000),
      errorColor: const Color(0xFFE84D4F),
      brightness: Brightness.light,
      hintColor:  Colors.black26,
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      cardColor: Colors.white,
      colorScheme: ColorScheme.light(primary: color, secondary: const Color(0xFF7CED93)),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(primary: color)),
    );

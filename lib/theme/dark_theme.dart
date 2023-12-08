import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData dark({Color color = const Color(0xFF54b46b)}) => ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: color,
      secondaryHeaderColor: const Color(0xFF009f67),
      disabledColor: const Color(0xffa2a7ad),
      backgroundColor: const Color(0xFF343636),
      errorColor: const Color(0xFFdd3135),
      brightness: Brightness.dark,
      hintColor: const Color(0xFFbebebe),
      cardColor: Colors.black,
      colorScheme: ColorScheme.dark(primary: color, secondary: color),
      textButtonTheme:
          TextButtonThemeData(style: TextButton.styleFrom(primary: color)),
    );

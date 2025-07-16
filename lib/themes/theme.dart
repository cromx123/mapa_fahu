import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: const Color(0xFF00A499), // azul USACH
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF00A499),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFE77500), // naranjo USACH
    foregroundColor: Colors.white,
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF00A499), // azul para iconos principales
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: Color(0xFF00A499),
    textColor: Color(0xFF394049), // gris oscuro para legibilidad
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Color(0xFF394049)),
    bodyMedium: TextStyle(color: Color(0xFF394049)),
    bodySmall: TextStyle(color: Color(0xFF757575)), // gris claro
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStatePropertyAll(Color(0xFFE77500)), // naranjo
    trackColor: MaterialStatePropertyAll(Color(0xFFE77500).withOpacity(0.4)),
  ),
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: const Color(0xFF00A499), // azul USACH
  scaffoldBackgroundColor: const Color(0xFF121212), // fondo dark
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF00A499),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFE77500),
    foregroundColor: Colors.white,
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF00A499),
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: Color(0xFF00A499),
    textColor: Colors.white,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
    bodySmall: TextStyle(color: Colors.white54),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStatePropertyAll(Color(0xFFE77500)),
    trackColor: MaterialStatePropertyAll(Color(0xFFE77500).withOpacity(0.4)),
  ),
);
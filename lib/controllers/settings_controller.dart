// maps_fahu/lib/controllers/settings_controller.dart
import 'package:flutter/material.dart';

class SettingsController extends ChangeNotifier {
  Locale _locale = const Locale('es');
  String _unit = 'metros'; // o 'millas'
  ThemeMode _themeMode = ThemeMode.system;

  // Getter para locale
  Locale get locale => _locale;

  // Setter para locale
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  // Getter para unidad
  String get unit => _unit;

  // Setter para unidad
  void setUnit(String unit) {
    _unit = unit;
    notifyListeners();
  }

  // Getter para tema
  ThemeMode get themeMode => _themeMode;

  // Setter para tema
  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}

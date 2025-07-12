import 'package:flutter/material.dart';

class SettingsController extends ChangeNotifier {
  Locale _locale = const Locale('es');
  String _unit = 'metros'; // o 'millas'

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
}

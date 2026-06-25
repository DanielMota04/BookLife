import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;

  void setMode(ThemeMode newMode) {
    if (newMode == _mode) return;
    _mode = newMode;
    notifyListeners();
  }
}
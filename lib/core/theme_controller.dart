// ==================== lib/core/theme_controller.dart ====================
import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;
  ThemeMode get mode => _mode;

  void toggle() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // singleton sederhana
  static final ThemeController instance = ThemeController._();
  ThemeController._();
}
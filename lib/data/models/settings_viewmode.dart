import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsViewModel extends ChangeNotifier {
  final Box<bool> _settingsBox = Hive.box<bool>('settings');

  // 🔐 BIOMETRIC
  bool get biometricEnabled =>
      _settingsBox.get('biometric') ?? false;

  void toggleBiometric(bool value) {
    _settingsBox.put('biometric', value);
    notifyListeners();
  }

  // 🌙 DARK MODE
  bool get darkMode =>
      _settingsBox.get('darkMode') ?? true;

  void toggleDarkMode(bool value) {
    _settingsBox.put('darkMode', value);
    notifyListeners();
  }
}

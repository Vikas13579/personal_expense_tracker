import 'package:flutter/material.dart';

import '../../service/biometric_service.dart';

class AuthViewModel extends ChangeNotifier {
  final BiometricService _biometricService = BiometricService();

  bool _authenticated = false;
  bool get isAuthenticated => _authenticated;

  Future<void> authenticateWithBiometric() async {
    final canAuth = await _biometricService.canAuthenticate();
    if (!canAuth) return;

    final success = await _biometricService.authenticate();
    _authenticated = success;
    notifyListeners();
  }

  void logout() {
    _authenticated = false;
    notifyListeners();
  }
}

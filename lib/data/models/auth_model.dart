import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class AuthViewModel extends ChangeNotifier {
  final Box<Map> _usersBox = Hive.box<Map>('users');
  final Box<String> _sessionBox = Hive.box<String>('session');

  bool get isLoggedIn => _sessionBox.containsKey('email');

  String get userName {
    final email = _sessionBox.get('email');
    if (email == null) return '';
    return _usersBox.get(email)?['name'] ?? '';
  }

  /// 🔹 SIGN UP WITH VALIDATION
  String? signup({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return "All fields are required";
    }

    if (password.length < 6) {
      return "Password must be at least 6 characters";
    }

    if (password != confirmPassword) {
      return "Passwords do not match";
    }

    if (_usersBox.containsKey(email)) {
      return "Email already registered";
    }

    _usersBox.put(email, {
      'name': name,
      'password': password,
    });

    _sessionBox.put('email', email);
    notifyListeners();
    return null; // success
  }

  /// 🔹 LOGIN WITH VALIDATION
  String? login({
    required String email,
    required String password,
  }) {
    if (email.isEmpty || password.isEmpty) {
      return "Email & password required";
    }

    final user = _usersBox.get(email);
    if (user == null) {
      return "User not found";
    }

    if (user['password'] != password) {
      return "Invalid password";
    }

    _sessionBox.put('email', email);
    notifyListeners();
    return null; // success
  }

  void logout() {
    _sessionBox.clear();
    notifyListeners();
  }
}

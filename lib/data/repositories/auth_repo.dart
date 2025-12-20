import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

class AuthRepository {
  final Box<UserModel> _box =
  Hive.box<UserModel>('users');

  bool register(UserModel user) {
    if (_box.containsKey(user.email)) {
      return false; // already exists
    }
    _box.put(user.email, user);
    return true;
  }

  UserModel? login(String email, String password) {
    final user = _box.get(email);
    if (user != null && user.password == password) {
      return user;
    }
    return null;
  }
}

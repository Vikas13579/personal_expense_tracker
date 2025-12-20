import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/user_model.dart';

class SessionManager {
  static final _box = Hive.box('session');

  static void saveUser(UserModel user) {
    _box.put('user', user);
  }

  static UserModel? get user =>
      _box.get('user');

  static bool get isLoggedIn =>
      _box.containsKey('user');

  static void logout() {
    _box.clear();
  }
}

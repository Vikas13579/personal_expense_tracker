import 'package:hive_flutter/hive_flutter.dart';

class AppLockService {
  final Box<bool> _box = Hive.box<bool>('meta');

  static const _key = 'biometric_enabled';

  bool isEnabled() {
    return _box.get(_key, defaultValue: false) ?? false;
  }

  void setEnabled(bool value) {
    _box.put(_key, value);
  }
}

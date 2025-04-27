// lib/services/auth_storage_service.dart
import 'package:hive_flutter/hive_flutter.dart';

class AuthStorageService {
  static const String _authBoxName = 'authBox';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userEmailKey = 'userEmail';

  static Future<Box> _getBox() async {
    return await Hive.openBox(_authBoxName);
  }

  static Future<void> saveLoginSession(String email) async {
    final box = await _getBox();
    await box.put(_isLoggedInKey, true);
    await box.put(_userEmailKey, email);
  }

  static Future<void> clearSession() async {
    final box = await _getBox();
    await box.delete(_isLoggedInKey);
    await box.delete(_userEmailKey);
  }

  static Future<bool> isLoggedIn() async {
    final box = await _getBox();
    return box.get(_isLoggedInKey, defaultValue: false);
  }

  static Future<String?> getUserEmail() async {
    final box = await _getBox();
    return box.get(_userEmailKey);
  }
}

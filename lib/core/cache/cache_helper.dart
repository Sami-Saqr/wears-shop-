import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await _preferences!.setString(key, value);
    if (value is int) return await _preferences!.setInt(key, value);
    if (value is bool) return await _preferences!.setBool(key, value);
    if (value is double) return await _preferences!.setDouble(key, value);
    return false;
  }

  static dynamic getData({required String key}) {
    return _preferences?.get(key);
  }

  static String? getString({required String key}) {
    return _preferences?.getString(key);
  }

  static bool? getBool({required String key}) {
    return _preferences?.getBool(key);
  }

  static int? getInt({required String key}) {
    return _preferences?.getInt(key);
  }

  static Future<bool> removeData({required String key}) async {
    return await _preferences!.remove(key);
  }

  static Future<bool> clearAll() async {
    return await _preferences!.clear();
  }

  // Auth specific helpers
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  static Future<bool> saveToken(String token) async {
    return await saveData(key: _tokenKey, value: token);
  }

  static String? getToken() {
    return getString(key: _tokenKey);
  }

  static Future<bool> removeToken() async {
    return await removeData(key: _tokenKey);
  }

  static bool isLoggedIn() {
    return getToken() != null && getToken()!.isNotEmpty;
  }
}

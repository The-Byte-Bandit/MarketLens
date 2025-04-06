import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _themeKey = 'theme_preference';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // Theme preferences
  bool get isDarkMode => _prefs.getBool(_themeKey) ?? false;
  Future<void> setDarkMode(bool value) async =>
      await _prefs.setBool(_themeKey, value);

  // User data
  String? get userName => _prefs.getString(_userNameKey);
  Future<void> setUserName(String value) async =>
      await _prefs.setString(_userNameKey, value);

  String? get userEmail => _prefs.getString(_userEmailKey);
  Future<void> setUserEmail(String value) async =>
      await _prefs.setString(_userEmailKey, value);
}

import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsRepository {
  Future<bool> isDarkMode();
  Future<void> setDarkMode(bool value);
}

class SettingsRepositoryImpl implements SettingsRepository {
  static const _darkModeKey = 'dark_mode';
  final SharedPreferences prefs;

  SettingsRepositoryImpl(this.prefs);

  @override
  Future<bool> isDarkMode() async {
    return prefs.getBool(_darkModeKey) ?? false;
  }

  @override
  Future<void> setDarkMode(bool value) async {
    await prefs.setBool(_darkModeKey, value);
  }
}

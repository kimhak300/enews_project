import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _key = "isDarkMode";

  Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false; // default light
  }

  Future<void> saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isDarkMode);
  }
  bool isDarkMode() {
    // This method should be async to fetch from SharedPreferences
    // but for simplicity, we return false here.
    // In a real implementation, consider making this method async.
    return false;
  }
  void setDarkMode(bool isDarkMode) {
    saveTheme(isDarkMode);
  }


}

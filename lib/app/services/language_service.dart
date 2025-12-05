import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _key = "isKhmer";

  /// Load saved language (default = false → English)
  Future<bool> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  /// Save language (true = Khmer, false = English)
  Future<void> saveLanguage(bool isKhmer) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isKhmer);
  }
}
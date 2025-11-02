import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';


class LanguageController extends GetxController {
  final _box = GetStorage();
  final _key = 'isKhmer';

  // Observable for current language state
  final RxBool isKhmer = false.obs;

  // Get saved language on init
  @override
  void onInit() {
    super.onInit();
    isKhmer.value = _loadCurrentLanguage();
    _updateLocale();
  }

  // Load saved language preference
  bool _loadCurrentLanguage() {
    return _box.read(_key) ?? false;
  }

  // Save language preference
  Future<void> _saveLanguage(bool isKh) async {
    await _box.write(_key, isKh);
  }

  // Update app locale based on selection
  void _updateLocale() {
    Get.updateLocale(
      isKhmer.value ? const Locale('km', 'KH') : const Locale('en', 'US')
    );
  }

  // Toggle language
  void toggleLanguage() {
    isKhmer.value = !isKhmer.value;
    _saveLanguage(isKhmer.value);
    _updateLocale();
  }

  // Change to specific language
  void changeLanguage(bool toKhmer) {
    isKhmer.value = toKhmer;
    _saveLanguage(toKhmer);
    _updateLocale();
  }
}
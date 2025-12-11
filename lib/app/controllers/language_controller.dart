import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/services/language_service.dart';

class LanguageController extends GetxController {

  final LanguageService _service = Get.find<LanguageService>();

  RxBool isKhmer = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadLanguage();
  }

  /// Load saved language asynchronously
  Future<void> _loadLanguage() async {
    isKhmer.value = await _service.loadLanguage();
    updateLocale();
  }

  /// Update app language
  void updateLocale() {
    Get.updateLocale(
      isKhmer.value ? const Locale('km', 'KH') : const Locale('en', 'US'),
    );
  }

  /// Toggle between Khmer <-> English
  void toggleLanguage() {
    isKhmer.value = !isKhmer.value;
    _service.saveLanguage(isKhmer.value);
    updateLocale();
  }

  /// Change language directly
  void changeLanguage(bool kh) {
    isKhmer.value = kh;
    _service.saveLanguage(kh);
    updateLocale();
  }
}
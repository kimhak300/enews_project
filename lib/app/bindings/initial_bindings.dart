import 'package:get/get.dart';
import 'package:newshub/app/services/api_service.dart';
import 'package:newshub/app/services/storage_service.dart';
import 'package:newshub/app/services/theme_service.dart';
import 'package:newshub/app/services/language_service.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Core Services
    Get.put<StorageService>(StorageService(), permanent: true);
    Get.put<ApiService>(ApiService(), permanent: true);
    Get.put<ThemeService>(ThemeService(), permanent: true);
    Get.put<LanguageService>(LanguageService(), permanent: true);
  }
}

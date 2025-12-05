import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:newshub/app/bindings/initial_bindings.dart';
import 'package:newshub/app/controllers/language_controller.dart';
import 'package:newshub/app/controllers/ratio_controller.dart';
import 'package:newshub/app/controllers/theme_controller.dart';
import 'package:newshub/app/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'core/localization/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  await GetStorage.init();
  await SharedPreferences.getInstance();

  /// Put controllers
  Get.put(ThemeController());
  Get.put(RatioController());
  Get.put(LanguageController());

  runApp(ENewsApp());
}

class ENewsApp extends StatelessWidget {
  ENewsApp({super.key});

  final ThemeController themeController = Get.find();
  final LanguageController languageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'E-News',

          /// Language
          translations: AppTranslation(),
          locale: languageController.isKhmer.value
              ? const Locale('km', 'KH')
              : const Locale('en', 'US'),
          fallbackLocale: const Locale('en', 'US'),

          /// Theme
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeController.themeMode.value,

          /// Route
          initialRoute: Routes.SPLASH,
          initialBinding: InitialBindings(),
          getPages: AppPages.pages,
        );
      },
    );
  }
}
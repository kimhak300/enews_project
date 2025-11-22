import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:newshub/app/controllers/language_controller.dart';
import 'package:newshub/app/controllers/ratio_controller.dart';
import 'package:newshub/app/controllers/theme_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'core/bindings/initial_bindings.dart';
import 'core/localization/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await GetStorage.init();
  
  Get.put(ThemeController(), permanent: true);
  Get.put(RatioController());
  Get.put(LanguageController(), permanent: true);

  runApp(ENewsApp());
}

class ENewsApp extends StatelessWidget {
  ENewsApp({super.key});
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return Obx(() => GetMaterialApp(
          title: 'ENews',
          debugShowCheckedModeBanner: false,
          translations: AppTranslations(),
          locale: Get.find<LanguageController>().isKhmer.value
              ? const Locale('km', 'KH')
              : const Locale('en', 'US'),
          fallbackLocale: const Locale('en', 'US'),
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeController.themeMode.value,
          initialBinding: InitialBindings(),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          defaultTransition: Transition.cupertino,
        ));
      },
    );
}
}

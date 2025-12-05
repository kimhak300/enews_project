import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newshub/app/controllers/id_controller.dart';
import 'package:newshub/app/controllers/language_controller.dart';
import 'package:newshub/app/controllers/ratio_controller.dart';
import 'package:newshub/app/controllers/theme_controller.dart';
import 'package:newshub/sqflite_db/db_helper.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'core/localization/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Delete all Data in Database
  // final dbPath = join(await getDatabasesPath(), 'e_new_app.db');
  // await deleteDatabase(dbPath);

  /// Local Database
  await DBHelper.initDb();
  await SharedPreferences.getInstance();

  /// Put controllers
  Get.put(IdController());
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
        return Obx(() => GetMaterialApp(
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
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        ));
      },
    );
  }
}
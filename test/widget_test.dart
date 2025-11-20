// This is a basic Flutter widget test for eNews app.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newshub/app/controllers/language_controller.dart';
import 'package:newshub/app/controllers/ratio_controller.dart';
import 'package:newshub/app/controllers/theme_controller.dart';
import 'package:newshub/main.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    PathProviderPlatform.instance = _FakePathProviderPlatform();
    await GetStorage.init();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('eNews app smoke test', (WidgetTester tester) async {
    Get.put(ThemeController());
    Get.put(RatioController());
    Get.put(LanguageController());
    // Build our app and trigger a frame.
    await tester.pumpWidget(ENewsApp());

    // Verify that splash screen shows
    expect(find.text('eNews'), findsOneWidget);
  });
}

class _FakePathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return Directory.systemTemp.path;
  }
}


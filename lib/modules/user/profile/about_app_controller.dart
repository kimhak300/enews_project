import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutAppController extends GetxController {
  final appName = 'ENews'.obs;
  final version = '1.0.0'.obs;
  final buildNumber = '1'.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadAppInfo();
  }

  Future<void> loadAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appName.value = packageInfo.appName;
      version.value = packageInfo.version;
      buildNumber.value = packageInfo.buildNumber;
    } catch (e) {
      print('Error loading app info: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

import 'package:get/get.dart';
import 'package:newshub/modules/p2_dashboard/dashboard_controller.dart';
// import 'package:newshub/core/controllers/theme_controller.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/api_service.dart';
import '../../data/local/storage_service.dart';
import '../../data/local/cache_manager.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/article_repository.dart';
import '../../data/repositories/notification_repository.dart';
import '../controllers/language_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut<StorageService>(() => StorageService(), fenix: true);
    Get.lazyPut<CacheManager>(() => CacheManager(), fenix: true);
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);

    // Repositories
    Get.lazyPut<AuthRepository>(() => AuthRepository(), fenix: true);
    Get.lazyPut<ArticleRepository>(() => ArticleRepository(), fenix: true);
    Get.lazyPut<NotificationRepository>(() => NotificationRepository(),
        fenix: true);
    // Language controller (app-wide)
    Get.put(LanguageController(), permanent: true);
    Get.put(DashboardController(), permanent: true);

    // Theme controller (app-wide)
    // Get.put(ThemeController(), permanent: true);
  }
}

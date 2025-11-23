import 'package:get/get.dart';
import 'package:newshub/app/controllers/id_controller.dart';
import 'package:newshub/app/routes/app_routes.dart';
import 'package:newshub/app/widget/blur_loading_widget.dart';
import 'package:newshub/sqflite_db/controller/article_controller.dart';
import 'package:newshub/sqflite_db/controller/follow_controller.dart';
import 'package:newshub/sqflite_db/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/auth_service.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;

  final AuthService _service = AuthService();

  /// Login method
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    error.value = '';

    try {
      // Call service to get user
      final user = await _service.login(email, password);

      if (user == null) {
        error.value = 'Invalid email or password';
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', user.userId ?? 0);
        await prefs.setString('name', user.name);
        await prefs.setString('email', user.email);

        BlurLoadingWidget.show();
        await Future.delayed(const Duration(seconds: 2));
        BlurLoadingWidget.hide();

        Get.offNamed(Routes.BOTTOM_NAV);

        // ✅ Update IdController immediately
        final idController = Get.find<IdController>();
        idController.currentUserId.value = user.userId ?? 0;

        // Optional: clear dependent controllers
        final articleController = Get.find<ArticleController>();
        final followController = Get.find<FollowController>();

        articleController.articles.clear();
        articleController.fetchArticles();

        followController.followingAuthors.clear();
        followController.loadAllFollowStatus();
      }

      return user;
    } catch (e) {
      error.value = 'Login failed: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Register method
  Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    error.value = '';

    try {
      // Check if email already exists
      final exists = await _service.getUserByEmail(email);
      if (exists != null) {
        error.value = 'Email already exists';
        return null;
      }

      // Create new user
      final newUser = UserModel(
        userId: null,
        name: name,
        email: email,
        password: password,
        createdAt: '',
        updatedAt: '',
      );
      await _service.insertUser(newUser);

      print("-"*100);
      print(newUser.userId);
      print("-"*100);

      // Save user info to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', newUser.userId ?? 0);
      await prefs.setString('name', newUser.name);
      await prefs.setString('email', newUser.email);

      BlurLoadingWidget.show();
      await Future.delayed(const Duration(seconds: 2));
      BlurLoadingWidget.hide();

      // Navigate to BottomNav page
      Get.offAllNamed(Routes.LOGIN);

      return newUser;
    } catch (e) {
      error.value = 'Registration failed: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Check if user is already logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('userId');
  }

  /// Logout user
  Future<void> logout() async {
    try {
      BlurLoadingWidget.show();
      await Future.delayed(const Duration(seconds: 2));

      // Clear shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Reset controllers
      final idController = Get.find<IdController>();
      final articleController = Get.find<ArticleController>();
      final followController = Get.find<FollowController>();

      idController.currentUserId.value = 0;
      articleController.articles.clear();
      followController.followingAuthors.clear();
      // followController.isFollowing.value = false;

      // Navigate to login screen
      Get.offAllNamed(Routes.LOGIN);

      BlurLoadingWidget.hide();
    } catch (e) {
      print("Logout error: $e");
    }
  }

}
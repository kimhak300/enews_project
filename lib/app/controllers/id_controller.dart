import 'package:get/get.dart';
import 'package:newshub/sqflite_db/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IdController extends GetxController {
  /// Current logged-in user info
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  /// All IDs you might need globally
  RxInt currentUserId = 0.obs;

  /// Following authors (author IDs)
  RxList<int> followingAuthors = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
  }

  /// Load user info from SharedPreferences
  Future<void> loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('userId') ?? 0;
    final name = prefs.getString('name') ?? '';
    final email = prefs.getString('email') ?? '';

    currentUser.value = UserModel(
      userId: id,
      name: name,
      email: email,
      password: '',
      createdAt: '',
      updatedAt: '',
    );

    currentUserId.value = id;
  }

  /// Save current user to SharedPreferences
  Future<void> saveCurrentUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', user.userId ?? 0);
    await prefs.setString('name', user.name);
    await prefs.setString('email', user.email);

    currentUser.value = user;
    currentUserId.value = user.userId ?? 0;
  }

  /// Clear user (logout)
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    currentUser.value = null;
    currentUserId.value = 0;
    followingAuthors.clear();
  }
}
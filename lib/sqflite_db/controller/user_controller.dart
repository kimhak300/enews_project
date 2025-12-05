import 'package:get/get.dart';
import 'package:newshub/sqflite_db/model/user_model.dart';
import 'package:newshub/sqflite_db/service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  final UserService _service = UserService();

  /// Logged-in user
  var currentUser = Rxn<UserModel>();

  /// Cache of all loaded users (authorId → UserModel)
  var userMap = <int, UserModel>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
  }

  /// Load the currently logged-in user from SharedPreferences
  Future<void> loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("userId");

    if (userId != null) {
      final user = await _service.getUserById(userId);
      if (user != null) {
        currentUser.value = user;
      }
    }
  }

  /// Load user profile by ID (for news authors)
  Future<UserModel?> loadUserById(int userId) async {
    // Return cached if exists
    if (userMap.containsKey(userId)) {
      return userMap[userId];
    }

    // Load from database
    final user = await _service.getUserById(userId);

    // Cache it
    if (user != null) {
      userMap[userId] = user;
    }

    return user;
  }

  /// Update current logged user
  Future<void> updateCurrentUser(UserModel user) async {
    await _service.updateUser(user);
    currentUser.value = user;

    // Also update cache
    if (user.userId != null) {
      userMap[user.userId!] = user;
    }
  }

  /// Delete logged-in user account
  Future<void> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("userId");

    if (userId != null) {
      await _service.deleteUser(userId);
      await prefs.clear();

      currentUser.value = null;
      userMap.remove(userId);
    }
  }
}
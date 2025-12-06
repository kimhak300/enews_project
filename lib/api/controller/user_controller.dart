import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:newshub/api/model/user_model.dart';
import 'package:newshub/api/service/user_service.dart';

class UserController extends GetxController {
  final UserService _service = UserService();

  var users = <UserModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  // Load all users
  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      users.value = await _service.getUsers();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Convert image → Base64
  Future<String?> convertImageToBase64(File? imageFile) async {
    if (imageFile == null) return null;
    final bytes = await imageFile.readAsBytes();
    return "data:image/png;base64,${base64Encode(bytes)}";
  }

  Future<void> createUser({
    required String displayName,
    required String email,
    required String password,
    required String role,
    required bool isActive,
    File? avatarFile,
  }) async {
    try {
      isLoading.value = true;
      final avatarBase64 = await convertImageToBase64(avatarFile);

      await _service.createUser(
        displayName: displayName,
        email: email,
        password: password,
        role: role,
        isActive: isActive,
        avatarBase64: avatarBase64,
      );

      Get.back();
      fetchUsers();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser({
    required int id,
    required String displayName,
    required String email,
    required String role,
    required bool isActive,
    File? avatarFile,
  }) async {
    try {
      isLoading.value = true;
      final avatarBase64 = await convertImageToBase64(avatarFile);

      await _service.updateUser(
        id: id,
        displayName: displayName,
        email: email,
        role: role,
        isActive: isActive,
        avatarBase64: avatarBase64,
      );

      Get.back();
      fetchUsers();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await _service.deleteUser(id);
      fetchUsers();
    } catch (e) {
      print(e);
    }
  }
}
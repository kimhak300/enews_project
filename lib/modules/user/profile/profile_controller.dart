import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newshub/app/constants/app_constant.dart';
import 'package:newshub/app/services/storage_service.dart';
import 'dart:convert';

class ProfileController extends GetxController {
  // Reactive state
  final isEditing = false.obs;
  final userName = 'User Name'.obs;
  final userEmail = 'user@example.com'.obs;
  final userRole = 'user'.obs;
  final Rxn<File> profileImage = Rxn<File>();
  final Rxn<String> avatarPath = Rxn<String>();

  // Text controllers
  late TextEditingController nameController;
  late TextEditingController emailController;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: userName.value);
    emailController = TextEditingController(text: userEmail.value);
    // Load persisted user info into reactive fields
    loadFromStorage();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  void enableEditing() {
    isEditing.value = true;
    nameController.text = userName.value;
    emailController.text = userEmail.value;
  }

  void cancelEditing() {
    isEditing.value = false;
    nameController.text = userName.value;
    emailController.text = userEmail.value;
  }

  void saveProfile() {
    userName.value = nameController.text;
    userEmail.value = emailController.text;
    isEditing.value = false;
    Get.snackbar('Success', 'Profile updated successfully',
        snackPosition: SnackPosition.TOP);
  }

  void showImageSourceDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
        avatarPath.value = pickedFile.path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image',
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> loadFromStorage() async {
    try {
      final storage = StorageService.to;
      final raw = await storage.read<String>(AppConstants.USER_INFO_KEY);
      if (raw != null) {
        final Map<String, dynamic> map = jsonDecode(raw) as Map<String, dynamic>;
        final name = (map['display_name'] ?? map['full_name'] ?? map['name']) as String?;
        final email = map['email'] as String?;
        final avatar = map['avatar_url'] as String?;
        // Some backends store role under 'primary_role' or 'role'
        final role = (map['primary_role'] ?? map['role'] ?? map['primaryRole']) as String?;
        if (name != null && name.isNotEmpty) userName.value = name;
        if (email != null && email.isNotEmpty) userEmail.value = email;
        if (avatar != null && avatar.isNotEmpty) avatarPath.value = avatar;
        if (role != null && role.isNotEmpty) userRole.value = role.toString().toLowerCase();
      }
    } catch (_) {
      // ignore
    }
  }

  void goToBookmarks() => Get.toNamed('/bookmark');
  void goToNotifications() => Get.toNamed('/notifications');
  void goToSettings() => Get.toNamed('/settings');
  void goToAbout() => Get.toNamed('/about');

  void logout() {
    Get.dialog(
      AlertDialog(
        title: Text('logout'.tr),
        content: Text('logout_confirm'.tr),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          TextButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed('/login');
            },
            child: Text('logout'.tr),
          ),
        ],
      ),
    );
  }
}
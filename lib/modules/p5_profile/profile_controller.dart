import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../app/routes/app_pages.dart';
import '../../app/services/storage_service.dart';

class ProfileController extends GetxController {
  final userName = 'kim hak'.obs;
  final userEmail = 'kimhak029@gmail.com'.obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  final Rx<String?> profileImagePath = Rx<String?>(null);
  final StorageService _storage = StorageService();
  final ImagePicker _picker = ImagePicker();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final isEditing = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProfileData();
    nameController.text = userName.value;
    emailController.text = userEmail.value;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  void _loadProfileData() {
    // Load saved profile data
    userName.value = _storage.read('profile_name') ?? 'kim hak';
    userEmail.value = _storage.read('profile_email') ?? 'kimhak029@gmail.com';
    profileImagePath.value = _storage.read('profile_image_path');

    if (profileImagePath.value != null) {
      profileImage.value = File(profileImagePath.value!);
    }
  }

  // void _loadProfileData(dynamic textColor, color) {
  //   // Load saved profile data
  //   userName.value = _storage.read('profile_name') ?? 'kim hak';
  //   userEmail.value = _storage.read('profile_email') ?? 'kimhak029@gmail.com';
  //   profileImagePath.value = _storage.read('profile_image_path');

  //   // Load font color (save as int)
  //   int? savedColor = _storage.read('font_color');
  //   textColor.value = savedColor != null ? Color(savedColor) : Colors.black;

  //   if (profileImagePath.value != null) {
  //     profileImage.value = File(profileImagePath.value!);
  //   }
  // }

  Future<void> pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        profileImage.value = File(image.path);
        profileImagePath.value = image.path;
        // Save the image path
        _storage.write('profile_image_path', image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> takeProfilePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        profileImage.value = File(image.path);
        profileImagePath.value = image.path;
        // Save the image path
        _storage.write('profile_image_path', image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to take photo: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void showImageSourceDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose Profile Photo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Get.back();
                takeProfilePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                pickProfileImage();
              },
            ),
            if (profileImage.value != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Get.back();
                  removeProfileImage();
                },
              ),
          ],
        ),
      ),
    );
  }

  void removeProfileImage() {
    profileImage.value = null;
    profileImagePath.value = null;
    _storage.remove('profile_image_path');
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
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Name cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (emailController.text.trim().isEmpty ||
        !GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        'Error',
        'Please enter a valid email',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Save the updated values
    userName.value = nameController.text.trim();
    userEmail.value = emailController.text.trim();

    // Save to storage
    _storage.write('profile_name', userName.value);
    _storage.write('profile_email', userEmail.value);

    isEditing.value = false;

    Get.snackbar(
      'Success',
      'Profile updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void goToSettings() {
    Get.toNamed(Routes.SETTINGS);
  }

  void goToBookmarks() {
    Get.toNamed(Routes.BOOKMARK);
  }

  void goToNotifications() {
    Get.toNamed(Routes.NOTIFICATIONS);
  }

  void goToAbout() {
    Get.toNamed(Routes.ABOUT);
  }

  void logout() {
    Get.defaultDialog(
      title: 'Logout'.tr,
      middleText: 'Are you sure you want to logout?'.tr,
      textCancel: 'Cancel'.tr,
      textConfirm: 'Logout'.tr,
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        Get.offAllNamed(Routes.LOGIN);
      },
    );
  }
}

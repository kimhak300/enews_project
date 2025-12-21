import 'package:get/get.dart';
import 'package:newshub/modules/auth/services/auth_service.dart';
import 'package:newshub/app/routes/app_routes.dart';

class PrivacySettingsController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final isLoading = false.obs;

  // Privacy toggles
  final showProfilePicture = true.obs;
  final showEmail = true.obs;
  final showPhone = false.obs;
  final allowTagging = true.obs;
  final showOnlineStatus = true.obs;
  final allowMessaging = true.obs;
  
  // Notification preferences
  final pushNotifications = true.obs;
  final emailNotifications = false.obs;
  
  // Data & Privacy
  final dataCollection = true.obs;
  final personalization = true.obs;

  void toggleShowProfilePicture(bool value) {
    showProfilePicture.value = value;
    _saveSettings();
  }

  void toggleShowEmail(bool value) {
    showEmail.value = value;
    _saveSettings();
  }

  void toggleShowPhone(bool value) {
    showPhone.value = value;
    _saveSettings();
  }


  void toggleShowOnlineStatus(bool value) {
    showOnlineStatus.value = value;
    _saveSettings();
  }

  // void togglePushNotifications(bool value) {
  //   pushNotifications.value = value;
  //   _saveSettings();
  // }

  // void toggleEmailNotifications(bool value) {
  //   emailNotifications.value = value;
  //   _saveSettings();
  // }

  void toggleDataCollection(bool value) {
    dataCollection.value = value;
    _saveSettings();
  }

  void togglePersonalization(bool value) {
    personalization.value = value;
    _saveSettings();
  }

  void _saveSettings() {
    print('Privacy settings saved');
  }

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      isLoading.value = true;
      
      final result = await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );

      if (result['success']) {
        Get.back(); // Close dialog
        Get.snackbar(
          'success'.tr,
          result['message'],
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'error'.tr,
          result['message'],
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Failed to change password: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete account
  Future<void> deleteAccount({
    required String password,
  }) async {
    try {
      isLoading.value = true;
      
      final result = await _authService.deleteAccount(
        password: password,
      );

      if (result['success']) {
        Get.back(); // Close dialog
        Get.snackbar(
          'success'.tr,
          result['message'],
          snackPosition: SnackPosition.TOP,
        );
        
        // Navigate to login after a delay
        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.snackbar(
          'error'.tr,
          result['message'],
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Failed to delete account: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

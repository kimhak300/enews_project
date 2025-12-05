import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/app/widget/app_layout_widget.dart';
import 'package:newshub/app/widget/item_widget.dart';
import 'package:newshub/app/widget/title_widget.dart';
import 'package:newshub/modules/auth/controllers/auth_controller.dart';
import 'package:newshub/modules/p5_profile/widget/logout_dialog.dart';
import 'package:newshub/modules/p5_profile/widget/profile_widget.dart';
import 'package:newshub/sqflite_db/controller/user_controller.dart';
import '../controller/profile_controller.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final UserController userController = Get.put(UserController());
  final AuthController authController = Get.put(AuthController());
  final ProfileController profileCtrl = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return AppLayoutWidget(
      title: "profile".tr,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _profileHeader(),
              SizedBox(height: AppSpacing.paddingXXL),
              _settingsList(),
            ],
          ),
        ),
      ),
    );
  }

  /// PROFILE HEADER UI
  Widget _profileHeader() {
    return Obx(() {
      final user = userController.currentUser.value;

      if (user == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final imageUrl = (user.profileImage == null || user.profileImage!.isEmpty)
          ? "https://i.pravatar.cc/150?img=3"
          : user.profileImage!;

      return ProfileWidget(
        imageUrl: imageUrl,
        title: user.name,
        description: user.email,
      );
    });
  }

  /// SETTINGS LIST UI
  Widget _settingsList() {
    return Column(
      children: [
        // ---------------- Account Settings ----------------
        TitleWidget(title: "Account Settings"),
        ItemWidget(
          icon: Icons.password,
          title: "Change Password",
          // onRightTap: profileCtrl.goToEditProfile,
        ),
        ItemWidget(
          icon: Icons.bookmark,
          title: 'my_bookmarks'.tr,
          onRightTap: profileCtrl.goToBookmarks,
        ),

        SizedBox(height: AppSpacing.paddingL),

        // ---------------- App Preferences ----------------
        TitleWidget(title: "App Preferences".tr),
        ItemWidget(
          icon: Icons.settings,
          title: 'setting'.tr,
          onRightTap: profileCtrl.goToSettings,
        ),

        SizedBox(height: AppSpacing.paddingL),

        // ---------------- Help ----------------
        TitleWidget(title: "Help & Support".tr),
        ItemWidget(
          icon: Icons.info_outline,
          title: 'about_help'.tr,
          onRightTap: profileCtrl.goToAbout,
        ),

        SizedBox(height: AppSpacing.paddingL),

        // ---------------- Logout ----------------
        ItemWidget(
          iconColor: Colors.red,
          icon: Icons.logout,
          title: 'logout'.tr,
          onTap: () {
            Get.dialog(
              LogoutDialog(
                title: "Logout",
                message: "Are you sure you want to log out?",
                confirmText: "Yes",
                cancelText: "Cancel",
                onConfirm: () {
                  authController.logout();
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
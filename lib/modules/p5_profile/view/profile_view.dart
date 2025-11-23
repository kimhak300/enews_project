import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/app/widget/app_layout_widget.dart';
import 'package:newshub/app/widget/item_widget.dart';
import 'package:newshub/app/widget/title_widget.dart';
import 'package:newshub/modules/auth/controllers/auth_controller.dart';
import 'package:newshub/modules/p5_profile/widget/logout_dialog.dart';
import 'package:newshub/modules/p5_profile/widget/profile_widget.dart';
import '../controller/profile_controller.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {

    return AppLayoutWidget(
        title: "profile".tr,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _profile(context),
                SizedBox(height: AppSpacing.paddingXXL),
                _settingList(context),
              ],
            ),
          ),
        )
    );
  }

  Widget _profile(BuildContext context){
    return ProfileWidget(
      imageUrl: "https://i.pravatar.cc/150?img=3",
      title: "John Doe",
      description: "Flutter Developer",
    );
  }

  Widget _settingList(BuildContext context){
    final ctrl = Get.put(ProfileController());

    return Column(
      children: [
        TitleWidget(title: "Account Settings"),
        ItemWidget(
          icon: Icons.edit,
          title: 'edit_profile'.tr,
          onRightTap: ctrl.goToBookmarks,
        ),
        ItemWidget(
          icon: Icons.bookmark,
          title: 'my_bookmarks'.tr,
          onRightTap: ctrl.goToBookmarks,
        ),
        SizedBox(height: AppSpacing.paddingL),
        TitleWidget(title: 'App Preferences'.tr),
        ItemWidget(
          icon: Icons.notifications,
          title: 'notification'.tr,
          onRightTap: ctrl.goToNotifications,
        ),
        ItemWidget(
          icon: Icons.settings,
          title: 'setting'.tr,
          onRightTap: ctrl.goToSettings,
        ),
        SizedBox(height: AppSpacing.paddingL),
        TitleWidget(title: 'Help & Support'.tr),
        ItemWidget(
          icon: Icons.info_outline,
          title: 'about_help'.tr,
          onRightTap: ctrl.goToAbout,
        ),
        SizedBox(height: AppSpacing.paddingL),
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
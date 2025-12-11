import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/routes/app_routes.dart';
import 'package:newshub/modules/auth/controllers/register_controller.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    final RegisterController controller = Get.find<RegisterController>();
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('register'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text('create_account'.tr,
                  style: text.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onBackground)),
              const SizedBox(height: 20),

              TextField(
                controller: controller.fullNameController,
                cursorColor: theme.colorScheme.primary,
                style: TextStyle(color: theme.colorScheme.onBackground),
                decoration: InputDecoration(
                  labelText: 'name'.tr,
                  labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                  hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.primary)),
                  filled: true,
                  fillColor: theme.inputDecorationTheme.fillColor ?? theme.colorScheme.surface,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: controller.emailController,
                cursorColor: theme.colorScheme.primary,
                style: TextStyle(color: theme.colorScheme.onBackground),
                decoration: InputDecoration(
                  labelText: 'email'.tr,
                  labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                  hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.primary)),
                  filled: true,
                  fillColor: theme.inputDecorationTheme.fillColor ?? theme.colorScheme.surface,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              TextField(
                controller: controller.passwordController,
                cursorColor: theme.colorScheme.primary,
                style: TextStyle(color: theme.colorScheme.onBackground),
                decoration: InputDecoration(
                  labelText: 'password'.tr,
                  labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                  hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.primary)),
                  filled: true,
                  fillColor: theme.inputDecorationTheme.fillColor ?? theme.colorScheme.surface,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),

              TextField(
                controller: controller.confirmPasswordController,
                cursorColor: theme.colorScheme.primary,
                style: TextStyle(color: theme.colorScheme.onBackground),
                decoration: InputDecoration(
                  labelText: 'confirm_password'.tr,
                  labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                  hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.primary)),
                  filled: true,
                  fillColor: theme.inputDecorationTheme.fillColor ?? theme.colorScheme.surface,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),

              TextField(
                controller: controller.phoneController,
                cursorColor: theme.colorScheme.primary,
                style: TextStyle(color: theme.colorScheme.onBackground),
                decoration: InputDecoration(
                  labelText: 'phone'.tr,
                  labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                  hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.primary)),
                  filled: true,
                  fillColor: theme.inputDecorationTheme.fillColor ?? theme.colorScheme.surface,
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.register,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                    child: controller.isLoading.value
                      ? CircularProgressIndicator(color: theme.colorScheme.onPrimary)
                      : Text('register'.tr,
                      style: text.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold
                      )),
                ),
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('or_continue_with'.tr),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.g_mobiledata),
                      label: Text('sign_up_with'.tr),
                      onPressed: controller.loginWithGoogle,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.facebook),
                      label: Text('sign_up_with'.tr),
                      onPressed: controller.loginWithFacebook,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('already_have_account'.tr + ' '),
                  TextButton(
                    onPressed: () => Get.offAllNamed(Routes.LOGIN),
                    child: Text('sign_in'.tr),
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/routes/app_routes.dart';
import 'package:newshub/modules/auth/controllers/auth_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'login'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onBackground),
                ),
                const SizedBox(height: 16),
                Text(
                  'sign_in_to_continue'.tr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onBackground.withOpacity(0.8)),
                ),
                const SizedBox(height: 32),

                // Email
                TextField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
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
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: controller.passwordController,
                  obscureText: true,
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
                ),
                const SizedBox(height: 24),

                // Login Button
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: controller.isLoading.value ? null : controller.login,
                    child: controller.isLoading.value
                          ? CircularProgressIndicator(color: theme.colorScheme.onPrimary)
                          : Text(
                        'login'.tr,
                        style: text.titleMedium?.copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold),
                      ),
                  ),
                )),
                const SizedBox(height: 16),
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
                        label: Text('continue_with'.tr),
                        onPressed: controller.loginWithGoogle,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.facebook),
                        label: Text('continue_with'.tr),
                        onPressed: controller.loginWithFacebook,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('dont_have_account'.tr + ' '),
                    TextButton(
                      onPressed: () => Get.toNamed(Routes.REGISTER),
                      child: Text('register'.tr),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
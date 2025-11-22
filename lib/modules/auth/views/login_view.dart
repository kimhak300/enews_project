import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  late final LoginController controller;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = Get.find<LoginController>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.paddingXXL),
              _title(),
              SizedBox(height: AppSpacing.paddingXXL),
              _form(),
              SizedBox(height: AppSpacing.paddingS),
              _forgotPassword(),
              SizedBox(height: AppSpacing.paddingXXL),
              _signInButton(),
              SizedBox(height: AppSpacing.paddingS),
              _registerButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'wellcome_back'.tr,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold
          ),
        ),
        Text(
          'sign_in_to_continue'.tr,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6)
          ),
        ),
      ],
    );
  }

  Widget _form(){
    final theme = Theme.of(context);

    return Column(
      children: [
        // Email
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'email'.tr,
            hintText: 'your@email.com'.tr,
            prefixIcon: Icon(Icons.email_outlined, color: theme.colorScheme.onSurface.withOpacity(0.6)),
          ),
        ),
        SizedBox(height: AppSpacing.paddingS),
        Obx(() => TextField(
          controller: _passwordController,
          obscureText: controller.obscurePassword.value,
          decoration: InputDecoration(
            labelText: 'password'.tr,
            hintText: '••••••••',
            prefixIcon: Icon(Icons.lock_outline, color: theme.colorScheme.onSurface.withOpacity(0.6)),
            suffixIcon: IconButton(
              icon: Icon(controller.obscurePassword.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
          ),
        )),
      ],
    );
  }

  Widget _forgotPassword(){
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: (){
          controller.goToForgotPassword;
        },
        child: Text(
          'forgot_password'.tr,
          style: textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }

  Widget _signInButton(){
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Obx(() => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () => controller.login(
            email: _emailController.text,
            password: _passwordController.text,
          ),
          child: controller.isLoading.value ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(theme.colorScheme.onPrimary),
            ),
          ) : Text(
            'sign_in'.tr,
            style: textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ));
  }

  Widget _registerButton(){
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'dont_have_account'.tr,
            style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onBackground.withOpacity(0.6)),
          ),
          GestureDetector(
            onTap: controller.goToRegister,
            child: Text(
              'register'.tr,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      );
  }
}
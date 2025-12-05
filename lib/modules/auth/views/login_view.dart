import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/app/routes/app_routes.dart';
import 'package:newshub/modules/auth/controllers/auth_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final AuthController authController = Get.put(AuthController());

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

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
              _signInButton(context, theme, textTheme),
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
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        SizedBox(height: AppSpacing.paddingS),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'password'.tr,
            hintText: '••••••••',
            prefixIcon: Icon(Icons.lock_outline),
          ),
        ),
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
          // controller.goToForgotPassword;
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

  Widget _signInButton(BuildContext context, ThemeData theme, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (){
          authController.login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
        },
        child: Text('Sign In',
          style: textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
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
          SizedBox(width: AppSpacing.paddingXS),
          GestureDetector(
            onTap: (){
              Get.toNamed(Routes.REGISTER);
            },
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
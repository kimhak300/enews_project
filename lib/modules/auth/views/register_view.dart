import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/app/constants/app_widget_size.dart';
import 'package:newshub/app/widget/app_layout_widget.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final AuthController controller = Get.put(AuthController());

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppLayoutWidget(
        title: "Register",
        leftWidget: GestureDetector(
          onTap: (){
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios, size: AppWidgetSize.iconSmall),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.paddingXXL),
                _title(context),
                SizedBox(height: AppSpacing.paddingXXL),
                _form(),
                SizedBox(height: AppSpacing.paddingXXL),
                _registerButton(context),
              ],
            ),
          ),
        )
    );
  }
  
  Widget _title(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Register",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text("Please create new account!",
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ],
    );
  }

  Widget _form(){
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        SizedBox(height: AppSpacing.paddingS),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        SizedBox(height: AppSpacing.paddingS),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock_outline),
          ),
        ),
      ],
    );
  }

  Widget _registerButton(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (){

        },
        child: Text('Register',
          style: textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
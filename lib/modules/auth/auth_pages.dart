import 'package:get/get.dart';
import 'package:newshub/app/routes/app_routes.dart';
import 'package:newshub/modules/auth/auth_binding.dart';
import 'package:newshub/modules/auth/views/forgot_password_view.dart';
import 'package:newshub/modules/auth/views/login_view.dart';
import 'package:newshub/modules/auth/views/register_view.dart';
import 'package:newshub/modules/auth/views/splash_view.dart';

class AuthPages {

  static final pages = [
    GetPage(
        name: Routes.SPLASH,
        page: () => SplashView(),
        binding: AuthBinding()
    ),
    GetPage(
        name: Routes.LOGIN,
        page: () => LoginView(),
        binding: AuthBinding()
    ),
    GetPage(
        name: Routes.REGISTER,
        page: () => RegisterView(),
        binding: AuthBinding()
    ),
    GetPage(
        name: Routes.FORGOT_PASSWORD,
        page: () => ForgotPasswordView(),
        binding: AuthBinding()
    ),
  ];
}
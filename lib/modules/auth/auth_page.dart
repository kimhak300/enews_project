import 'package:get/get.dart';
import 'package:newshub/modules/auth/auth_binding.dart';
import 'package:newshub/modules/auth/views/login_view.dart';
class AuthPage {
  static final routes = <GetPage>[
    GetPage(
      name: '/login',
      page: () => LoginView(),
      binding: AuthBinding()
    ),
  ];
}

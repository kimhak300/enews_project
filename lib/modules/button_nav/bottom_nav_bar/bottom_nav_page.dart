import 'package:get/get.dart';
import 'package:newshub/modules/button_nav/bottom_nav_bar/bottom_nav_view.dart';
import 'package:newshub/modules/button_nav/bottom_nav_bar/bottom_nav_binding.dart';

class BottomNavPage {
  static final routes = <GetPage>[
    GetPage(
        name: '/bottomNav',
        page: () => BottomNavView(),
        binding: BottomNavBinding()
    ),
  ];
}

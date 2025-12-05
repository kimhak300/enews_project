import 'package:get/get.dart';
import 'package:newshub/modules/user/bookmark/bookmark_view.dart';
import 'package:newshub/modules/user/home/home_view.dart';
import 'package:newshub/modules/user/profile/profile_view.dart';
import 'package:newshub/modules/user/search/search_view.dart';

class UserController extends GetxController {

  var currentIndex = 0.obs;

  final pages = [
    HomeView(),
    BookmarkView(),
    SearchView(),
    ProfileView()
  ];

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
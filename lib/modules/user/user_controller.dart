import 'package:get/get.dart';
import 'package:newshub/modules/user/home/home_view.dart';
import 'package:newshub/modules/user/video/video_view.dart';
import 'package:newshub/modules/user/hotnews/hotnews_view.dart';
import 'package:newshub/modules/user/profile/profile_view.dart';

class UserController extends GetxController {

  var currentIndex = 0.obs;

  final pages = [
    const HomeView(),
    const VideoView(),
    const HotNewsView(),
    const ProfileView()
  ];

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
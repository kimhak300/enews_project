import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/modules/p1_home/home_view.dart';
import 'package:newshub/modules/p2_dashboard/dashboard_screen/dashboard_view.dart';

class BottomNavController extends GetxController {
  // Current selected index
  var selectedIndex = 0.obs;

  // Screens for each tab
  final List<Widget> screens = [
    HomeView(),
    DashboardView(),
    Text(""),
    Text(""),
  ];

  // Titles for AppBar
  final List<String> titles = [
    'Home',
    'Search',
    'Cart',
    'Profile',
  ];

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}
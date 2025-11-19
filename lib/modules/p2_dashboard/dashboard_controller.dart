import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/models/post_model.dart';

class DashboardController extends GetxController {
  static DashboardController get to => Get.find();
  
  final RxBool isLoading = false.obs;
  final String baseUrl = 'http://10.0.2.2:3000'; // Android emulator localhost
  
  // Posts list
  final RxList<Post> posts = <Post>[].obs;

  // Dashboard metrics
  final RxInt views = 1200000.obs;
  final RxDouble viewsChange = 12.5.obs;
  final RxInt visits = 890000.obs;
  final RxDouble visitsChange = 9.8.obs;
  final RxInt newUsers = 5600.obs;
  final RxDouble newUsersChange = (-2.1).obs;
  final RxInt activeUsers = 125000.obs;
  final RxDouble activeUsersChange = 5.3.obs;

  // Chart data
  final RxList<double> chartData = [45.0, 52.0, 38.0, 65.0, 48.0, 58.0, 54.0].obs;
  final RxList<String> chartLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'].obs;
  
  // Device traffic data
  final RxMap<String, double> deviceTraffic = {
    'Linux': 45.0,
    'Mac': 65.0,
    'iOS': 80.0,
    'Windows': 100.0,
    'Android': 78.0,
    'Other': 35.0,
  }.obs;

  // Date filter
  final List<String> rangeOptions = const [
    'Last 7 Days',
    'Last 30 Days',
    'This Month',
    'Custom Range',
  ];

  final RxString selectedRangeLabel = 'Last 7 Days'.obs;
  final Rxn<DateTimeRange> customRange = Rxn<DateTimeRange>();

  // Audience age groups (percent values)
  final RxList<Map<String, dynamic>> audienceAgeGroups = <Map<String, dynamic>>[
    {'label': '18-24', 'value': 35},
    {'label': '25-34', 'value': 45},
    {'label': '35-44', 'value': 15},
    {'label': '45+', 'value': 5},
  ].obs;

  // Active user trends (daily values)
  final RxList<Map<String, dynamic>> activeUserTrends = <Map<String, dynamic>>[
    {'label': '9', 'value': 12.0},
    {'label': '10', 'value': 14.0},
    {'label': '11', 'value': 18.0},
    {'label': '12', 'value': 24.0},
    {'label': '13', 'value': 28.0},
    {'label': '14', 'value': 32.0},
    {'label': '15', 'value': 40.0},
  ].obs;

  @override
  void onInit() {
    super.onInit();
    if (!Get.testMode) {
      loadDashboardData();
    }
    // Load saved posts from local storage
    _loadSavedPosts();
    // Persist posts whenever they change
    ever(posts, (_) {
      _savePosts();
    });
  }

  Future<void> loadDashboardData() async {
    if (Get.testMode) {
      return;
    }
    try {
      isLoading.value = true;
      
      // Simulate loading dashboard data
      // In production, you would fetch from your API
      await Future.delayed(Duration(seconds: 1));
      
      // You can add real API calls here
      // final response = await http.get(Uri.parse('$baseUrl/dashboard'));
      
      print('Dashboard data loaded');
      
    } catch (e) {
      print('Error loading dashboard: $e');
      Get.snackbar(
        'error'.tr,
        'Failed to load dashboard data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void refreshDashboard() {
    loadDashboardData();
  }

  // Persistence: save/load posts to shared preferences
  static const String _kPostsKey = 'dashboard_saved_posts_v1';

  Future<void> _savePosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = posts.map((p) => p.toJson()).toList();
      final encoded = jsonEncode(list);
      await prefs.setString(_kPostsKey, encoded);
      // debug print for persistence
      // print('Saved ${posts.length} posts to SharedPreferences');
    } catch (e) {
      print('Error saving posts: $e');
    }
  }

  /// Public wrapper to trigger immediate save (useful after explicit changes)
  Future<void> savePosts() async {
    await _savePosts();
  }

  Future<void> _loadSavedPosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = prefs.getString(_kPostsKey);
      if (encoded != null && encoded.isNotEmpty) {
        final List decoded = jsonDecode(encoded) as List;
        final loaded = decoded.map((e) => Post.fromJson(e)).toList();
        posts.assignAll(loaded);
        // print('Loaded ${posts.length} saved posts');
      }
    } catch (e) {
      print('Error loading saved posts: $e');
    }
  }

  void setPredefinedRange(String label) {
    selectedRangeLabel.value = label;
    customRange.value = null;
  }

  void updateCustomRange(DateTimeRange range) {
    customRange.value = range;
    selectedRangeLabel.value = 'Custom Range';
  }

  String getChangeIcon(double change) {
    return change >= 0 ? '↗' : '↘';
  }

  bool isPositiveChange(double change) {
    return change >= 0;
  }
}

import 'dart:convert';

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
  final RxInt views = 7265.obs;
  final RxDouble viewsChange = 11.01.obs;
  final RxInt visits = 3671.obs;
  final RxDouble visitsChange = (-0.03).obs;
  final RxInt newUsers = 256.obs;
  final RxDouble newUsersChange = 15.03.obs;
  final RxInt activeUsers = 2318.obs;
  final RxDouble activeUsersChange = 6.08.obs;

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

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
    // Load saved posts from local storage
    _loadSavedPosts();
    // Persist posts whenever they change
    ever(posts, (_) {
      _savePosts();
    });
  }

  Future<void> loadDashboardData() async {
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

  String getChangeIcon(double change) {
    return change >= 0 ? '↗' : '↘';
  }

  bool isPositiveChange(double change) {
    return change >= 0;
  }
}

import 'package:get/get.dart';

class DashboardController extends GetxController {
  static DashboardController get to => Get.find();
  
  final RxBool isLoading = false.obs;
  final String baseUrl = 'http://10.0.2.2:3000'; // Android emulator localhost

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

  String getChangeIcon(double change) {
    return change >= 0 ? '↗' : '↘';
  }

  bool isPositiveChange(double change) {
    return change >= 0;
  }
}

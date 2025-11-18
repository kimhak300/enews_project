import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  DashboardController get ctrl => Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    'home'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // Overview Title
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                'overview'.tr,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            // Metrics Cards
            Expanded(
              child: Obx(() {
                if (ctrl.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // First Row - Views and Visits
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            title: 'views'.tr,
                            value: ctrl.views.value.toString(),
                            change: ctrl.viewsChange.value,
                            isHighlighted: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricCard(
                            title: 'visits'.tr,
                            value: ctrl.visits.value.toString(),
                            change: ctrl.visitsChange.value,
                            isHighlighted: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Second Row - New Users and Active Users
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            title: 'new_users'.tr,
                            value: ctrl.newUsers.value.toString(),
                            change: ctrl.newUsersChange.value,
                            isHighlighted: false,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricCard(
                            title: 'active_users'.tr,
                            value: ctrl.activeUsers.value.toStringAsFixed(0),
                            change: ctrl.activeUsersChange.value,
                            isHighlighted: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Tabs Section
                    // _buildTabSection(),
                    const SizedBox(height: 24),
                    // Device Traffic
                    _buildDeviceTraffic(),
                    const SizedBox(height: 48),
                    // Chart
                    _buildChart(),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required double change,
    required bool isHighlighted,
  }) {
    final isPositive = ctrl.isPositiveChange(change);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.blue : Colors.grey.shade500, 
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value.contains('.')
                ? double.parse(value).toStringAsFixed(0)
                : value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}%',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildTabSection() {
  //   return Row(
  //     children: [
  //       Text('create_post'.tr,
  //           style: const TextStyle(
  //              fontWeight: FontWeight.bold)),

  //     ],
  //   );
  // }

  Widget _buildChart() {
    return SizedBox(
      
      height: 150,
      child: CustomPaint(
        painter: SimpleLineChartPainter(ctrl.chartData),
        child: Container(),
      ),
    );
  }

  Widget _buildDeviceTraffic() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'device_traffic'.tr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: ctrl.deviceTraffic.entries.map((entry) {
              final isWindows = entry.key == 'Windows';
              return Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isWindows)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '243K',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 22),
                    const SizedBox(height: 4),
                    Container(
                      width: 40,
                      height: entry.value,
                      decoration: BoxDecoration(
                        color: isWindows ? Colors.blue : Colors.grey[300],
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.key,
                      style: const TextStyle(fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // _buildCategoriesSection removed per request. Categories/CRUD moved to CategoryView.

}

// _CategoryViewHost removed — category UI deleted

// Simple line chart painter
class SimpleLineChartPainter extends CustomPainter {
  final List<double> data;

  SimpleLineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final stepX = size.width / (data.length - 1);
    final maxValue = data.reduce((a, b) => a > b ? a : b);

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - (data[i] / maxValue) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Draw dots
      canvas.drawCircle(Offset(x, y), 3, Paint()..color = Colors.purple);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

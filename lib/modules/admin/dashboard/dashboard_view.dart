import 'package:flutter/material.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/app/constants/app_widget_size.dart';
import 'package:newshub/app/widget/title_widget.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleWidget(title: 'Platform Stats'),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _statCard(context, 'Users', 1250, Icons.people, Colors.blueAccent),
                _statCard(context,'Articles', 345, Icons.article, Colors.orangeAccent),
                _statCard(context,'Comments', 789, Icons.comment, Colors.greenAccent),
                _statCard(
                    context, 'Reactions', 1520, Icons.thumb_up, Colors.purpleAccent),
              ],
            ),
            SizedBox(height: AppSpacing.paddingXL),
            TitleWidget(title: 'Quick Actions'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _actionButton(Icons.check_circle, 'Approve Article', Colors.blueAccent),
                _actionButton(Icons.bar_chart, 'View Reports', Colors.orangeAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Statistic Card Widget
  Widget _statCard(BuildContext context, String title, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: AppWidgetSize.iconSM),
          ),
          SizedBox(height: AppSpacing.paddingS),
          Text(
            count.toString(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge
          ),
        ],
      )
    );
  }

  // Quick Action Button Widget
  Widget _actionButton(IconData icon, String title, Color color) {
    return Expanded(
      child: Card(
        color: color,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.paddingL),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // User Activity Chart
            _sectionTitle('User Activity (Last 7 Days)'),
            const SizedBox(height: 8),
            _lineChart(),
            const SizedBox(height: 24),

            // Article Views
            _sectionTitle('Article Views'),
            const SizedBox(height: 8),
            _barChart(),
            const SizedBox(height: 24),

            // Trending Articles
            _sectionTitle('Trending Articles'),
            const SizedBox(height: 8),
            _trendingArticles(),
            const SizedBox(height: 24),

            // Engagement Stats by Category
            _sectionTitle('Engagement by Category'),
            const SizedBox(height: 8),
            _pieChart(),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  // Line chart for User Activity
  Widget _lineChart() {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  return Text(days[value.toInt() % 7]);
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 10),
                FlSpot(1, 12),
                FlSpot(2, 8),
                FlSpot(3, 14),
                FlSpot(4, 16),
                FlSpot(5, 10),
                FlSpot(6, 18),
              ],
              isCurved: true,
              barWidth: 3,
              dotData: FlDotData(show: true),
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }

  // Bar chart for Article Views
  Widget _barChart() {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 20,
          barGroups: [
            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 10, color: Colors.green)]),
            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 14, color: Colors.green)]),
            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 8, color: Colors.green)]),
            BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 16, color: Colors.green)]),
            BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 12, color: Colors.green)]),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const articles = ['Art1', 'Art2', 'Art3', 'Art4', 'Art5'];
                  return Text(articles[value.toInt() % 5]);
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
        ),
      ),
    );
  }

  // Trending Articles List
  Widget _trendingArticles() {
    final trending = [
      {'title': 'Flutter Widgets', 'views': 120},
      {'title': 'Dart Tips', 'views': 100},
      {'title': 'UI Design', 'views': 80},
    ];
    return Column(
      children: trending.map((item) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(item['title'].toString()),
            trailing: Text('${item['views']} views'),
          ),
        );
      }).toList(),
    );
  }

  // Pie chart for Engagement by Category
  Widget _pieChart() {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 40,
              color: Colors.blueAccent,
              title: 'Tech',
              radius: 50,
              titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            PieChartSectionData(
              value: 30,
              color: Colors.orangeAccent,
              title: 'Design',
              radius: 50,
              titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            PieChartSectionData(
              value: 20,
              color: Colors.greenAccent,
              title: 'Education',
              radius: 50,
              titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            PieChartSectionData(
              value: 10,
              color: Colors.purpleAccent,
              title: 'Other',
              radius: 50,
              titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
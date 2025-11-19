import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  DashboardController get ctrl => Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildDateFilter(context),
                if (ctrl.customRange.value != null &&
                    ctrl.selectedRangeLabel.value == 'Custom Range')
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: _buildCustomRangeCard(context),
                  ),
                const SizedBox(height: 28),
                _sectionTitle(context, 'Overview'),
                const SizedBox(height: 16),
                _buildOverviewGrid(context),
                const SizedBox(height: 28),
                _sectionTitle(context, 'Audience'),
                const SizedBox(height: 16),
                _buildAudienceCard(context),
                const SizedBox(height: 28),
                _sectionTitle(context, 'Active User Trends'),
                const SizedBox(height: 16),
                _buildActiveUsersCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final titleColor = theme.textTheme.titleLarge?.color ?? theme.colorScheme.onBackground;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analytics Overview',
                style: theme.textTheme.titleLarge?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ) ??
                    TextStyle(
                      color: titleColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              // const SizedBox(height: 8),
              // Text(
              //   'Monitor growth and engagement across your channels',
              //   style: TextStyle(
              //     color: Colors.white.withOpacity(0.65),
              //     fontSize: 14,
              //   ),
              // ),
            ],
          ),
        ),
        // Container(
        //   decoration: BoxDecoration(
        //     color: const Color(0xFF111B2E),
        //     borderRadius: BorderRadius.circular(16),
        //     border: Border.all(color: const Color(0xFF1E2942)),
        //   ),
        //   child: IconButton(
        //     onPressed: ctrl.refreshDashboard,
        //     icon: const Icon(Icons.refresh, color: Colors.white),
        //     tooltip: 'Refresh',
        //   ),
        // ),
      ],
    );
  }

  Widget _buildDateFilter(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: _cardDecoration(context),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: theme.cardColor,
                value: ctrl.selectedRangeLabel.value,
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: onSurface.withOpacity(0.6),
                ),
                style: theme.textTheme.bodyMedium?.copyWith(color: onSurface),
                onChanged: (value) {
                  if (value == null) return;
                  _handleRangeSelection(context, value);
                },
                items: ctrl.rangeOptions
                    .map(
                      (option) => DropdownMenuItem<String>(
                        value: option,
                        child: Text(
                          option,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: onSurface,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          TextButton.icon(
            onPressed: () => _handleRangeSelection(context, 'Custom Range'),
            style: TextButton.styleFrom(
              backgroundColor: isDark
                  ? theme.colorScheme.secondaryContainer.withOpacity(0.35)
                  : theme.colorScheme.secondaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(
              Icons.date_range,
              color: theme.colorScheme.onSecondaryContainer,
              size: 18,
            ),
            label: Text(
              'Custom',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomRangeCard(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final range = ctrl.customRange.value;
    if (range == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer.withOpacity(
                theme.brightness == Brightness.dark ? 0.4 : 0.9,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.calendar_today,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Custom Range',
                  style: TextStyle(
                    color: onSurface.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatDate(range.start)}  •  ${_formatDate(range.end)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                        color: onSurface,
                        fontWeight: FontWeight.w600,
                      ) ??
                      TextStyle(
                        color: onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => ctrl.setPredefinedRange(ctrl.rangeOptions.first),
            icon: Icon(
              Icons.close,
              color: onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewGrid(BuildContext context) {
    final items = [
      _MetricCardData(
        label: 'Total Views',
        value: ctrl.views.value,
        change: ctrl.viewsChange.value,
      ),
      _MetricCardData(
        label: 'Visits',
        value: ctrl.visits.value,
        change: ctrl.visitsChange.value,
      ),
      _MetricCardData(
        label: 'New Users',
        value: ctrl.newUsers.value,
        change: ctrl.newUsersChange.value,
      ),
      _MetricCardData(
        label: 'Active Users',
        value: ctrl.activeUsers.value,
        change: ctrl.activeUsersChange.value,
      ),
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return _MetricCard(
          data: item,
          formattedValue: _formatLargeNumber(item.value),
        );
      },
    );
  }

  Widget _buildAudienceCard(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Age group distribution',
            style: TextStyle(
              color: onSurface.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Top audience segments',
            style: theme.textTheme.titleMedium?.copyWith(
                  color: onSurface,
                  fontWeight: FontWeight.w600,
                ) ??
                TextStyle(
                  color: onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 20),
          Column(
            children: ctrl.audienceAgeGroups.map((group) {
              final int value = group['value'] as int;
              final String label = group['label'] as String;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _AudienceBar(label: label, value: value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveUsersCard(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final values = ctrl.activeUserTrends
        .map((point) => (point['value'] as num).toDouble())
        .toList();
    final labels =
        ctrl.activeUserTrends.map((point) => point['label'].toString()).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily active users',
            style: TextStyle(
              color: onSurface.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${_formatLargeNumber(ctrl.activeUsers.value)} active right now',
                  style: theme.textTheme.titleMedium?.copyWith(
                        color: onSurface,
                        fontWeight: FontWeight.w600,
                      ) ??
                      TextStyle(
                        color: onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer.withOpacity(
                    theme.brightness == Brightness.dark ? 0.35 : 0.9,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      ctrl.isPositiveChange(ctrl.activeUsersChange.value)
                          ? Icons.trending_up
                          : Icons.trending_down,
                      color: theme.colorScheme.onSecondaryContainer,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${ctrl.activeUsersChange.value >= 0 ? '+' : ''}${ctrl.activeUsersChange.value.toStringAsFixed(1)}%',
                      style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            width: double.infinity,
            child: CustomPaint(
              painter: _TrendLineChartPainter(
                values,
                lineColor: theme.colorScheme.secondary,
                fillColor: theme.colorScheme.secondary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: labels
                .map(
                  (label) => Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: onSurface.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }

  Future<void> _handleRangeSelection(
      BuildContext context, String option) async {
    final theme = Theme.of(context);
    if (option == 'Custom Range') {
      final now = DateTime.now();
      final initialRange = ctrl.customRange.value ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 6)),
            end: now,
          );
      final picked = await showDateRangePicker(
        context: context,
        initialDateRange: initialRange,
        firstDate: DateTime(now.year - 5),
        lastDate: DateTime(now.year + 1),
        builder: (context, child) {
          return Theme(
            data: theme.copyWith(
              colorScheme: theme.colorScheme.copyWith(
                surface: theme.colorScheme.surface,
                onSurface: theme.colorScheme.onSurface,
              ),
              dialogBackgroundColor: theme.dialogBackgroundColor,
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
      );
      if (picked != null) {
        ctrl.updateCustomRange(picked);
      }
    } else {
      ctrl.setPredefinedRange(option);
    }
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('MMM d, yyyy');
    return formatter.format(date);
  }

  String _formatLargeNumber(num value) {
    final formatter =
        NumberFormat.compact(locale: Get.locale?.toLanguageTag() ?? 'en');
    return formatter.format(value);
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    final color = theme.textTheme.titleLarge?.color ?? theme.colorScheme.onBackground;
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ) ??
          TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
    );
  }

  BoxDecoration _cardDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.cardColor;
    final borderColor = theme.dividerColor.withOpacity(0.3);
    final shadowColor = theme.shadowColor.withOpacity(
      theme.brightness == Brightness.dark ? 0.45 : 0.15,
    );
    return BoxDecoration(
      color: baseColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: borderColor,
      ),
      boxShadow: [
        BoxShadow(
          color: shadowColor,
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}

class _MetricCardData {
  final String label;
  final num value;
  final double change;

  const _MetricCardData({
    required this.label,
    required this.value,
    required this.change,
  });
}

class _MetricCard extends StatelessWidget {
  final _MetricCardData data;
  final String formattedValue;

  const _MetricCard({
    required this.data,
    required this.formattedValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final positiveColor = theme.colorScheme.secondary;
    final negativeColor = theme.colorScheme.error;
    final borderColor = theme.dividerColor.withOpacity(0.3);
    final isPositive = data.change >= 0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.label,
            style: TextStyle(
              color: onSurface.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                formattedValue,
                style: theme.textTheme.headlineMedium?.copyWith(
                      color: onSurface,
                      fontWeight: FontWeight.w700,
                    ) ??
                    TextStyle(
                      color: onSurface,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: isPositive ? positiveColor : negativeColor,
              ),
              const SizedBox(width: 6),
              Text(
                '${isPositive ? '+' : ''}${data.change.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: isPositive ? positiveColor : negativeColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'vs last period',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: onSurface.withOpacity(0.55),
                    fontSize: 12,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class _AudienceBar extends StatelessWidget {
  final String label;
  final int value;

  const _AudienceBar({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                      color: onSurface,
                      fontSize: 14,
                    ) ??
                    TextStyle(color: onSurface, fontSize: 14),
              ),
            ),
            Text(
              '$value%',
              style: theme.textTheme.bodyMedium?.copyWith(
                    color: onSurface,
                    fontWeight: FontWeight.w600,
                  ) ??
                  TextStyle(color: onSurface, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth * (value / 100);
            return Stack(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: onSurface.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                Container(
                  height: 6,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: LinearGradient(
                      colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _TrendLineChartPainter extends CustomPainter {
  final List<double> values;
  final Color lineColor;
  final Color fillColor;

  _TrendLineChartPainter(
    this.values, {
    required this.lineColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) {
      return;
    }

    final maxValue = values.reduce(math.max);
    final minValue = values.reduce(math.min);
    final range = (maxValue - minValue).abs() < 0.001 ? 1.0 : maxValue - minValue;
    final stepX = size.width / (values.length - 1);

    final path = Path();
    for (int i = 0; i < values.length; i++) {
      final x = stepX * i;
      final normalized = (values[i] - minValue) / range;
      final y = size.height - normalized * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final gradient = LinearGradient(
      colors: [fillColor.withOpacity(0.35), Colors.transparent],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = gradient.createShader(
          Rect.fromLTWH(0, 0, size.width, size.height),
        )
        ..style = PaintingStyle.fill,
    );

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < values.length; i++) {
      final x = stepX * i;
      final normalized = (values[i] - minValue) / range;
      final y = size.height - normalized * size.height;
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendLineChartPainter oldDelegate) {
    if (oldDelegate.values.length != values.length) {
      return true;
    }
    for (int i = 0; i < values.length; i++) {
      if (oldDelegate.values[i] != values[i]) {
        return true;
      }
    }
    return oldDelegate.lineColor != lineColor || oldDelegate.fillColor != fillColor;
  }
}

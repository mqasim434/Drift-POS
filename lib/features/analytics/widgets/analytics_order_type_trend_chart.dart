import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/analytics_models.dart';

class AnalyticsOrderTypeTrendChart extends StatelessWidget {
  const AnalyticsOrderTypeTrendChart({
    super.key,
    required this.data,
  });

  final List<WeeklyOrderTypeStats> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty || data.every((week) => week.total == 0)) {
      return const _EmptyChart(message: 'No order type data in this period');
    }

    final maxY = data
            .map((week) => week.total.toDouble())
            .fold<double>(0, (max, value) => value > max ? value : max) *
        1.2;

    return SizedBox(
      height: 260,
      child: BarChart(
        BarChartData(
          maxY: maxY <= 0 ? 10 : maxY,
          groupsSpace: AppSizes.md,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: AppColors.border.withValues(alpha: 0.6),
              strokeWidth: 1,
              dashArray: [4, 6],
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  if (value == 0 || value % 1 != 0) {
                    return const SizedBox.shrink();
                  }
                  return Text('${value.toInt()}', style: AppTextStyles.caption);
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= data.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: AppSizes.xs),
                    child: Text(
                      DateFormat('d MMM').format(data[index].weekStart),
                      style: AppTextStyles.caption,
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < data.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: data[i].dineInCount.toDouble(),
                    color: AppColors.dineIn,
                    width: 14,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                  BarChartRodData(
                    fromY: data[i].dineInCount.toDouble(),
                    toY: (data[i].dineInCount + data[i].takeawayCount).toDouble(),
                    color: AppColors.takeaway,
                    width: 14,
                  ),
                  BarChartRodData(
                    fromY: (data[i].dineInCount + data[i].takeawayCount).toDouble(),
                    toY: data[i].total.toDouble(),
                    color: AppColors.delivery,
                    width: 14,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyChart extends StatelessWidget {
  const _EmptyChart({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Center(child: Text(message, style: AppTextStyles.bodySmall)),
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/analytics_models.dart';
import '../../../core/utils/currency_formatter.dart';

class AnalyticsRevenueLineChart extends StatelessWidget {
  const AnalyticsRevenueLineChart({
    super.key,
    required this.data,
    required this.dayCount,
  });

  final List<DailyAnalyticsSummary> data;
  final int dayCount;

  @override
  Widget build(BuildContext context) {
    if (data.every((day) => day.revenueInPaisa == 0)) {
      return const _EmptyChart(message: 'No revenue in this period');
    }

    final spots = [
      for (var i = 0; i < data.length; i++)
        FlSpot(
          i.toDouble(),
          CurrencyFormatter.paisaToRupees(data[i].revenueInPaisa),
        ),
    ];

    final maxY = spots
            .map((spot) => spot.y)
            .fold<double>(0, (max, value) => value > max ? value : max) *
        1.2;

    final labelStep = dayCount <= 14 ? 2 : dayCount <= 45 ? 5 : 10;

    return SizedBox(
      height: 260,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY <= 0 ? 100 : maxY,
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
                reservedSize: 44,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const SizedBox.shrink();
                  return Text(_compactAmount(value), style: AppTextStyles.caption);
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 ||
                      index >= data.length ||
                      index % labelStep != 0) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: AppSizes.xs),
                    child: Text(
                      DateFormat('d MMM').format(data[index].date),
                      style: AppTextStyles.caption,
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => AppColors.surfaceElevated,
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  final index = spot.x.toInt();
                  final summary = data[index];
                  return LineTooltipItem(
                    '${DateFormat('d MMM').format(summary.date)}\n${CurrencyFormatter.format(summary.revenueInPaisa)}',
                    AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.accent,
              barWidth: 3,
              dotData: FlDotData(
                show: data.length <= 31,
                getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                  radius: 3,
                  color: AppColors.accent,
                  strokeWidth: 0,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.accent.withValues(alpha: 0.28),
                    AppColors.accent.withValues(alpha: 0.02),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _compactAmount(double rupees) {
    if (rupees >= 1000) return '${(rupees / 1000).toStringAsFixed(0)}k';
    return rupees.toStringAsFixed(0);
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

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/dashboard_stats.dart';

class OrderTypesChart extends StatelessWidget {
  const OrderTypesChart({
    super.key,
    required this.stats,
  });

  final DashboardStats stats;

  @override
  Widget build(BuildContext context) {
    if (stats.totalOrders == 0) {
      return const _EmptyChart(message: 'No orders yet today');
    }

    final segments = [
      _Segment('Dine In', stats.dineInCount, AppColors.dineIn),
      _Segment('Take Away', stats.takeawayCount, AppColors.takeaway),
      _Segment('Delivery', stats.deliveryCount, AppColors.delivery),
    ];

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 48,
                  sections: [
                    for (final segment in segments)
                      if (segment.count > 0)
                        PieChartSectionData(
                          value: segment.count.toDouble(),
                          color: segment.color,
                          radius: 52,
                          showTitle: false,
                        ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${stats.totalOrders}', style: AppTextStyles.display.copyWith(fontSize: 28)),
                  Text('total orders', style: AppTextStyles.caption),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.lg),
        for (final segment in segments)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.sm),
            child: _LegendBar(
              label: segment.label,
              count: segment.count,
              total: stats.totalOrders,
              color: segment.color,
            ),
          ),
      ],
    );
  }
}

class _Segment {
  const _Segment(this.label, this.count, this.color);

  final String label;
  final int count;
  final Color color;
}

class _LegendBar extends StatelessWidget {
  const _LegendBar({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  final String label;
  final int count;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final fraction = total == 0 ? 0.0 : count / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: AppTextStyles.bodySmall)),
            Text('$count', style: AppTextStyles.subtitle),
            const SizedBox(width: AppSizes.sm),
            Text(
              '${(fraction * 100).round()}%',
              style: AppTextStyles.caption.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 6,
            backgroundColor: AppColors.border,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _EmptyChart extends StatelessWidget {
  const _EmptyChart({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.donut_large_rounded,
              size: 40,
              color: AppColors.textMuted.withValues(alpha: 0.6),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(message, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}

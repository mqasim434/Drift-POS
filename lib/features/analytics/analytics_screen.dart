import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../shared/widgets/page_header.dart';
import '../dashboard/widgets/dashboard_panel.dart';
import 'providers/analytics_provider.dart';
import 'widgets/analytics_order_type_trend_chart.dart';
import 'widgets/analytics_range_selector.dart';
import 'widgets/analytics_revenue_line_chart.dart';
import 'widgets/analytics_summary_table.dart';
import 'widgets/analytics_top_products_charts.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(analyticsDataProvider);
    final range = ref.watch(analyticsRangeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Analytics',
          actions: const [AnalyticsRangeSelector()],
        ),
        Expanded(
          child: dataAsync.when(
            data: (snapshot) {
              return RefreshIndicator(
                color: AppColors.accent,
                onRefresh: () async => ref.invalidate(analyticsDataProvider),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Historical performance',
                        style: AppTextStyles.headline.copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        '${range.label} · ${range.dayCount} days',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: AppSizes.lg),
                      DashboardPanel(
                        title: 'Revenue over time',
                        subtitle: 'Daily totals for the selected period',
                        child: AnalyticsRevenueLineChart(
                          data: snapshot.dailySummaries,
                          dayCount: range.dayCount,
                        ),
                      ),
                      const SizedBox(height: AppSizes.lg),
                      DashboardPanel(
                        title: 'Top products',
                        subtitle: 'Best performers by quantity and revenue',
                        child: AnalyticsTopProductsCharts(
                          byQuantity: snapshot.topByQuantity,
                          byRevenue: snapshot.topByRevenue,
                        ),
                      ),
                      const SizedBox(height: AppSizes.lg),
                      DashboardPanel(
                        title: 'Order type trend',
                        subtitle: 'Weekly channel mix',
                        child: AnalyticsOrderTypeTrendChart(
                          data: snapshot.weeklyTrend,
                        ),
                      ),
                      const SizedBox(height: AppSizes.lg),
                      DashboardPanel(
                        title: 'Daily summary',
                        subtitle: 'Orders, revenue, and channel breakdown',
                        padding: const EdgeInsets.fromLTRB(
                          AppSizes.lg,
                          AppSizes.sm,
                          AppSizes.lg,
                          AppSizes.lg,
                        ),
                        child: AnalyticsSummaryTable(
                          rows: snapshot.dailySummaries,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: Text('Loading analytics...')),
            error: (error, _) => Center(
              child: Text(
                error.toString(),
                style: const TextStyle(color: AppColors.danger),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

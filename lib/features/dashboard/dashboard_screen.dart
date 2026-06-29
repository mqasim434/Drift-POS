import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../shared/widgets/page_header.dart';
import 'providers/dashboard_provider.dart';
import 'widgets/dashboard_panel.dart';
import 'widgets/hourly_revenue_chart.dart';
import 'widgets/order_types_chart.dart';
import 'widgets/recent_orders_table.dart';
import 'widgets/top_products_list.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final todayLabel = DateFormat('EEE, d MMM yyyy').format(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Dashboard',
          actions: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSizes.xs),
                  Text(todayLabel, style: AppTextStyles.caption),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Refresh',
              onPressed: () =>
                  ref.read(dashboardStatsProvider.notifier).refresh(),
              icon: const Icon(Icons.refresh_rounded),
            ),
          ],
        ),
        Expanded(
          child: statsAsync.when(
            data: (stats) {
              final avgOrderInPaisa = stats.totalOrders == 0
                  ? 0
                  : (stats.revenueInPaisa / stats.totalOrders).round();

              return RefreshIndicator(
                onRefresh: () =>
                    ref.read(dashboardStatsProvider.notifier).refresh(),
                color: AppColors.accent,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Today at a glance',
                        style: AppTextStyles.headline.copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        'Live snapshot of sales, channels, and recent activity.',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: AppSizes.lg),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final wide = constraints.maxWidth >= AppSizes.breakpointMd;

                          if (wide) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: DashboardHeroCard(
                                    revenueLabel: CurrencyFormatter.format(
                                      stats.revenueInPaisa,
                                    ),
                                    orderCount: stats.totalOrders,
                                    itemsSold: stats.itemsSold,
                                  ),
                                ),
                                const SizedBox(width: AppSizes.md),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      DashboardMetricTile(
                                        label: 'Average order value',
                                        value: CurrencyFormatter.format(
                                          avgOrderInPaisa,
                                        ),
                                        icon: Icons.trending_up_rounded,
                                        accentColor: AppColors.success,
                                      ),
                                      const SizedBox(height: AppSizes.sm),
                                      DashboardMetricTile(
                                        label: 'Completed orders',
                                        value: '${stats.totalOrders}',
                                        icon: Icons.receipt_long_outlined,
                                        accentColor: AppColors.info,
                                      ),
                                      const SizedBox(height: AppSizes.sm),
                                      DashboardMetricTile(
                                        label: 'Items sold',
                                        value: '${stats.itemsSold}',
                                        icon: Icons.inventory_2_outlined,
                                        accentColor: AppColors.warning,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }

                          return Column(
                            children: [
                              DashboardHeroCard(
                                revenueLabel: CurrencyFormatter.format(
                                  stats.revenueInPaisa,
                                ),
                                orderCount: stats.totalOrders,
                                itemsSold: stats.itemsSold,
                              ),
                              const SizedBox(height: AppSizes.md),
                              DashboardMetricTile(
                                label: 'Average order value',
                                value: CurrencyFormatter.format(avgOrderInPaisa),
                                icon: Icons.trending_up_rounded,
                                accentColor: AppColors.success,
                              ),
                              const SizedBox(height: AppSizes.sm),
                              Row(
                                children: [
                                  Expanded(
                                    child: DashboardMetricTile(
                                      label: 'Orders',
                                      value: '${stats.totalOrders}',
                                      icon: Icons.receipt_long_outlined,
                                      accentColor: AppColors.info,
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.sm),
                                  Expanded(
                                    child: DashboardMetricTile(
                                      label: 'Items sold',
                                      value: '${stats.itemsSold}',
                                      icon: Icons.inventory_2_outlined,
                                      accentColor: AppColors.warning,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: AppSizes.lg),
                      DashboardChannelStrip(
                        dineIn: stats.dineInCount,
                        takeaway: stats.takeawayCount,
                        delivery: stats.deliveryCount,
                      ),
                      const SizedBox(height: AppSizes.lg),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final wide = constraints.maxWidth >= AppSizes.breakpointMd;

                          final charts = wide
                              ? IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: DashboardPanel(
                                          title: 'Revenue flow',
                                          subtitle: 'Hourly performance today',
                                          child: HourlyRevenueChart(
                                            data: stats.hourlyRevenue,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: AppSizes.md),
                                      Expanded(
                                        flex: 2,
                                        child: DashboardPanel(
                                          title: 'Order mix',
                                          subtitle: 'Split by channel',
                                          child: OrderTypesChart(stats: stats),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  children: [
                                    DashboardPanel(
                                      title: 'Revenue flow',
                                      subtitle: 'Hourly performance today',
                                      child: HourlyRevenueChart(
                                        data: stats.hourlyRevenue,
                                      ),
                                    ),
                                    const SizedBox(height: AppSizes.md),
                                    DashboardPanel(
                                      title: 'Order mix',
                                      subtitle: 'Split by channel',
                                      child: OrderTypesChart(stats: stats),
                                    ),
                                  ],
                                );

                          final lists = wide
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: DashboardPanel(
                                        title: 'Top performers',
                                        subtitle: 'Best sellers today',
                                        child: TopProductsList(
                                          products: stats.topProducts,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppSizes.md),
                                    Expanded(
                                      child: DashboardPanel(
                                        title: 'Latest orders',
                                        subtitle: 'Tap to open orders',
                                        child: RecentOrdersTable(
                                          orders: stats.recentOrders,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    DashboardPanel(
                                      title: 'Top performers',
                                      subtitle: 'Best sellers today',
                                      child: TopProductsList(
                                        products: stats.topProducts,
                                      ),
                                    ),
                                    const SizedBox(height: AppSizes.md),
                                    DashboardPanel(
                                      title: 'Latest orders',
                                      subtitle: 'Tap to open orders',
                                      child: RecentOrdersTable(
                                        orders: stats.recentOrders,
                                      ),
                                    ),
                                  ],
                                );

                          return Column(
                            children: [
                              charts,
                              const SizedBox(height: AppSizes.lg),
                              lists,
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: Text('Loading dashboard...')),
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

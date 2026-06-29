import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../shared/layouts/feature_scaffold.dart';
import '../../shared/widgets/empty_state.dart';
import 'providers/orders_provider.dart';
import 'widgets/orders_filter_bar.dart';
import 'widgets/orders_stats_row.dart';
import 'widgets/orders_table_view.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(filteredOrdersProvider);

    return FeatureScaffold(
      title: 'Orders',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const OrdersFilterBar(),
          const OrdersStatsRow(),
          const SizedBox(height: AppSizes.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.lg,
                0,
                AppSizes.lg,
                AppSizes.lg,
              ),
              child: ordersAsync.when(
                data: (orders) {
                  if (orders.isEmpty) {
                    return const EmptyState(
                      message: 'No orders for this period',
                      icon: Icons.receipt_long_outlined,
                    );
                  }

                  return OrdersTableView(orders: orders);
                },
                loading: () => const Center(child: Text('Loading orders...')),
                error: (error, _) => Center(
                  child: Text(
                    error.toString(),
                    style: const TextStyle(color: AppColors.danger),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../shared/layouts/feature_scaffold.dart';
import '../../shared/widgets/empty_state.dart';
import 'providers/orders_provider.dart';
import 'widgets/order_detail_panel.dart';
import 'widgets/orders_filter_bar.dart';
import 'widgets/orders_stats_row.dart';
import 'widgets/orders_table_view.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(filteredOrdersProvider);
    final selectedOrderId = ref.watch(selectedOrderIdProvider);

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

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final useSplitView =
                          constraints.maxWidth >= AppSizes.breakpointMd;

                      if (!useSplitView && selectedOrderId != null) {
                        return OrderDetailPanel(
                          onClose: () => ref
                              .read(selectedOrderIdProvider.notifier)
                              .state = null,
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 6,
                            child: OrdersTableView(
                              orders: orders,
                              selectedOrderId: selectedOrderId,
                              onSelect: (id) => ref
                                  .read(selectedOrderIdProvider.notifier)
                                  .state = id,
                            ),
                          ),
                          if (useSplitView)
                            Expanded(
                              flex: 4,
                              child: OrderDetailPanel(
                                onClose: () => ref
                                    .read(selectedOrderIdProvider.notifier)
                                    .state = null,
                              ),
                            ),
                        ],
                      );
                    },
                  );
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

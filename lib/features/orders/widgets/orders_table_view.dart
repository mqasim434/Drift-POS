import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/order_models.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import 'order_type_badge.dart';

class OrdersTableView extends ConsumerWidget {
  const OrdersTableView({
    super.key,
    required this.orders,
    required this.selectedOrderId,
    required this.onSelect,
  });

  final List<OrderSummary> orders;
  final int? selectedOrderId;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
            color: AppColors.surfaceElevated,
            child: Row(
              children: [
                SizedBox(width: 140, child: Text('Order #', style: AppTextStyles.label)),
                SizedBox(width: 80, child: Text('Time', style: AppTextStyles.label)),
                SizedBox(width: 110, child: Text('Type', style: AppTextStyles.label)),
                SizedBox(width: 60, child: Text('Items', style: AppTextStyles.label)),
                Expanded(child: Text('Total', style: AppTextStyles.label)),
                SizedBox(width: 80, child: Text('Actions', style: AppTextStyles.label)),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: orders.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: AppColors.border),
              itemBuilder: (context, index) {
                final summary = orders[index];
                final order = summary.order;
                final isSelected = selectedOrderId == order.id;

                return Material(
                  color: isSelected ? AppColors.accentBg : Colors.transparent,
                  child: InkWell(
                    onTap: () => onSelect(order.id),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.md,
                        vertical: AppSizes.sm,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 140,
                            child: Text(
                              order.orderNumber,
                              style: AppTextStyles.body,
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: Text(
                              DateFormatter.formatTime24(order.createdAt),
                              style: AppTextStyles.bodySmall,
                            ),
                          ),
                          SizedBox(
                            width: 110,
                            child: OrderTypeBadge(
                              orderType: order.orderType,
                              isCancelled: summary.isCancelled,
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            child: Text(
                              '${summary.itemCount}',
                              style: AppTextStyles.body,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              CurrencyFormatter.format(order.totalInPaisa),
                              style: AppTextStyles.price,
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: IconButton(
                              tooltip: 'View details',
                              onPressed: () => onSelect(order.id),
                              icon: Icon(
                                Icons.chevron_right,
                                color: isSelected
                                    ? AppColors.accent
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

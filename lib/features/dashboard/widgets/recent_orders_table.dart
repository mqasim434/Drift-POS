import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/database/app_database.dart';
import '../../../core/navigation/nav_item.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../orders/widgets/order_status_badge.dart';
import '../../orders/widgets/order_type_badge.dart';

class RecentOrdersTable extends StatelessWidget {
  const RecentOrdersTable({
    super.key,
    required this.orders,
  });

  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.xl),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 36,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: AppSizes.sm),
            Text('No orders yet today', style: AppTextStyles.bodySmall),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < orders.length; i++)
          Padding(
            padding: EdgeInsets.only(
              bottom: i == orders.length - 1 ? 0 : AppSizes.sm,
            ),
            child: _RecentOrderTile(order: orders[i]),
          ),
      ],
    );
  }
}

class _RecentOrderTile extends StatelessWidget {
  const _RecentOrderTile({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceElevated.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => context.go(NavItem.orders.route),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.accentBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.receipt_outlined,
                  color: AppColors.accent,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.orderNumber,
                      style: AppTextStyles.body,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Row(
                      children: [
                        Text(
                          DateFormatter.formatTime24(order.createdAt),
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(width: AppSizes.sm),
                        OrderTypeBadge(orderType: order.orderType),
                        const SizedBox(width: AppSizes.xs),
                        OrderStatusBadge(orderStatus: order.orderStatus),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                CurrencyFormatter.format(order.totalInPaisa),
                style: AppTextStyles.subtitle,
              ),
              const SizedBox(width: AppSizes.xs),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

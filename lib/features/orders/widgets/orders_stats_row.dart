import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../providers/orders_provider.dart';

class OrdersStatsRow extends ConsumerWidget {
  const OrdersStatsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(ordersStatsProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Wrap(
        spacing: AppSizes.lg,
        runSpacing: AppSizes.sm,
        children: [
          _StatItem(
            label: 'Orders',
            value: '${stats.totalOrders}',
          ),
          _StatItem(
            label: 'Revenue',
            value: CurrencyFormatter.format(stats.revenueInPaisa),
          ),
          _StatItem(
            label: 'Dine In',
            value: '${stats.dineInCount}',
          ),
          _StatItem(
            label: 'Take Away',
            value: '${stats.takeawayCount}',
          ),
          _StatItem(
            label: 'Delivery',
            value: '${stats.deliveryCount}',
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ', style: AppTextStyles.bodySmall),
        Text(value, style: AppTextStyles.subtitle),
      ],
    );
  }
}
